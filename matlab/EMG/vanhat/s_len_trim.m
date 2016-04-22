function len = s_len_trim ( s )

%% S_LEN_TRIM returns the length of string to the last nonblank.
%
%  Modified:
%
%    28 April 2003
%
%  Author:
%
%    John Burkardt
%
%  Parameters:
%
%    Input, character string S, a string to be measured.
%
%    Output, integer LEN, the length of the string to the last nonblank.
%
  full_length = length ( s );

  for ( i = full_length : -1 : 1 )
    if ( s(i) ~= ' ' )
      len = i;
      return
    end
  end

  len = 0;