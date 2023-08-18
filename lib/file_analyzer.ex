defmodule FileAnalyzer do
  defmodule TextFileInfo do
    defstruct word_count: nil, line_count: nil, char_count: nil

    def set_text_info(%TextFileInfo{} = info, contents) do
      info
      |> set_character_count(contents)
      |> set_word_count(contents)
      |> set_line_count(contents)
    end

    defp set_character_count(%TextFileInfo{} = info, contents),
      do: Map.put(info, :char_count, String.length(contents))

    defp set_word_count(%TextFileInfo{} = info, contents),
      do: Map.put(info, :word_count, (Regex.scan(~r/\s+/, contents) |> length) + 1)

    defp set_line_count(%TextFileInfo{} = info, contents),
      do: Map.put(info, :line_count, (Regex.scan(~r/\r?\n/, contents) |> length) + 1)

    defimpl String.Chars do
      def to_string(%TextFileInfo{} = info) do
        """
        Text info:
              Character count: #{info.char_count}
              Word count: #{info.word_count}
              Line count: #{info.line_count}
        """
      end
    end
  end

  defmodule FileInfo do
    defstruct path: "",
              contents: nil,
              name: "",
              extension: "",
              type: nil,
              size: "",
              text_info: %TextFileInfo{}

    defimpl String.Chars do
      def to_string(%FileInfo{} = info) do
        """
        File Info:
            Name: #{info.name}
            Extension: #{info.extension}
            Size: #{info.size}
            Type: #{Atom.to_string(info.type)}
            #{if info.type == :binary, do: "", else: info.text_info}
        """
      end
    end
  end

  def analyze(path) do
    %FileInfo{path: String.trim(path)}
    |> set_file_content
    |> set_file_type
    |> set_file_extension
    |> set_file_name
    |> set_file_size
    |> set_text_info
    |> IO.puts()
  end

  defp set_file_content(%FileInfo{path: path} = info),
    do: Map.put(info, :contents, File.read!(path))

  defp set_file_type(%FileInfo{contents: contents} = info),
    do: Map.put(info, :type, get_file_type(contents))

  defp set_file_extension(%FileInfo{path: path} = info),
    do: Map.put(info, :extension, Path.extname(path))

  defp set_file_name(%FileInfo{path: path, extension: ext} = info),
    do: Map.put(info, :name, Path.split(path) |> List.last() |> String.replace(ext, ""))

  defp set_file_size(%FileInfo{contents: contents} = info),
    do: Map.put(info, :size, byte_size(contents) |> format_size_in_kb)

  defp set_text_info(%FileInfo{type: :binary} = info), do: info

  defp set_text_info(%FileInfo{contents: contents, text_info: text_info} = info),
    do: Map.put(info, :text_info, TextFileInfo.set_text_info(text_info, contents))

  # checks for null byte
  defp get_file_type(contents),
    do: if(String.contains?(contents, <<0>>), do: :binary, else: :text)

  defp format_size_in_kb(bytes), do: "#{(bytes / 1024) |> Float.round(1)} kb"
end
