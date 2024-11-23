# srt_processor
A simple srt subtitle parser implemented by Lua  
  
  The main function `parse_srt` can be modified to suit other scenarios, it basically works as a SRT parser and returns the parsed table.  
  The rest part of the returns from the `parse_srt` are used in the scenarios that your SRT not begins with the index `1` and still needed to be processed furtherly. That let you knows the index range, for example from 100 to 200, of your incomplete SRT file.
  
