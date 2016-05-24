#!/usr/bin/env python
# -*- coding: utf-8 -*-

import WXBizMsgCryptTool
import sys
if __name__ == "__main__":   

   sReqMsgSig = sys.argv[1]
   sReqTimeStamp = sys.argv[2]
   sReqNonce = sys.argv[3]
   sReqData = sys.argv[4]

   wxcpt = generateWXCpt()

   ret,sMsg=wxcpt.DecryptMsg(sReqData, sReqMsgSig, sReqTimeStamp, sReqNonce)
   if( ret != 0 ):
      print -1
      sys.exit(1)
   print sMsg