#!/usr/bin/env python
# -*- coding: utf-8 -*-

from WXBizMsgCrypt import WXBizMsgCrypt
import sys
if __name__ == "__main__":   

   sCorpID = "wx60f0179a53a30de9"

   sToken = sys.argv[1]
   sEncodingAESKey = sys.argv[2]
   sVerifyMsgSig = sys.argv[3]
   sVerifyTimeStamp = sys.argv[4]
   sVerifyNonce = sys.argv[5]
   sVerifyEchoStr = sys.argv[6]

   wxcpt=WXBizMsgCrypt(sToken,sEncodingAESKey,sCorpID)

   ret,sEchoStr = wxcpt.VerifyURL(sVerifyMsgSig, sVerifyTimeStamp,sVerifyNonce,sVerifyEchoStr)
   if(ret != 0):
      print -1
      sys.exit(1)
   print sEchoStr