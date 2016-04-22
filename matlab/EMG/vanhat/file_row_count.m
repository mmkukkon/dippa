function row_num = file_row_count ( input_file_name )

%% FILE_ROW_COUNT counts the number of row records in a file.
%
%  Discussion:
%
%    It does not count lines that are blank, or that begin with a
%    comment symbol '#'.
%
%  Modified:
%
%    21 February 2004
%
%  Author:
%
%    John Burkardt
%
%  Parameters:
%
%    Input, string INPUT_FILE_NAME, the name of the input file.
%
%    Output, integer ROW_NUM, the number of rows found. 
%
  input_unit = fopen ( input_file_name );

  if ( input_unit < 0 ) 
    fprintf ( 1, '\n' );
    fprintf ( 1, 'FILE_ROW_COUNT - Error!\n' );
    fprintf ( 1, '  Could not open the file "%s".\n', input_file_name );
    error ( 'FILE_ROW_COUNT - Error!' );
    row_num = -1;
    return;
  end

  comment_num = 0;
  row_num = 0;
  record_num = 0;

  while ( 1 )

    line = fgets ( input_unit );

    if ( line == -1 )
      break;
    end

    record_num = record_num + 1;

    if ( line(1) == '#' )
      comment_num = comment_num + 1;
    elseif ( s_len_trim ( line ) == 0 )
      comment_num = comment_num + 1;
    else
      row_num = row_num + 1;
    end

  end

  fclose ( input_unit );