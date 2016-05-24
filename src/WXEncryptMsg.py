#!/usr/bin/env python
# -*- coding: utf-8 -*-

import WXBizMsgCryptTool
import sys
if __name__ == "__main__":   

   sReqTimeStamp = sys.argv[1]
   sReqNonce = sys.argv[2]
   sRespData = sys.argv[3]

   wxcpt = generateWXCpt()

   ret,sEncryptMsg = wxcpt.EncryptMsg(sRespData, sReqNonce, sReqTimeStamp)
   if( ret != 0 ):
      print -1
      sys.exit(1)
   print sEncryptMsg
