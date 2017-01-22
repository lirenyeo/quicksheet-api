module GoogleDrive
  class Worksheet
    def num_rows_at(col)
      reload_cells unless @cells
      @num_rows = @input_values.select { |(_r, _c), v| !v.empty? && _c == col }.map { |(r, _c), _v| r }.max || 0
    end
  end
end