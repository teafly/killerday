#!/usr/bin/env python
# -*- coding: utf-8 -*-

import WXBizMsgCryptTool
import sys
if __name__ == "__main__":   

   sVerifyMsgSig = sys.argv[1]
   sVerifyTimeStamp = sys.argv[2]
   sVerifyNonce = sys.argv[3]
   sVerifyEchoStr = sys.argv[4]

   wxcpt = generateWXCpt()

   ret,sEchoStr = wxcpt.VerifyURL(sVerifyMsgSig, sVerifyTimeStamp,sVerifyNonce,sVerifyEchoStr)
   if(ret != 0):
      print -1
      sys.exit(1)
   print sEchoStr