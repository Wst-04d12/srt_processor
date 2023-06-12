# srt_processor
A simple srt subtitle parser implemented by Lua  
  
  The main function `process_srt` can be modified to suit other scenarios, it basically works as a SRT parser and returns the parsed table.  
  The program now works as an example, to strip the text from the SRT and save them into a new TXT file, this is built for convert the SRT to an pure-text passage for the not-video viewers.
  The potential usages are unlimited by anything else but your imagination, the rest part of the returns from the `process_srt` are used in the scenarios that your SRT not begins with the index `1` and still needed to be processed furtherly. That makes you can know the index range, for example from 100 to 200, of your incomplete SRT file.
  
  Granted the usage for `D_yinGG` on `space.bilibili.com/184448192`, and thanks to his work on testing and debugging.
