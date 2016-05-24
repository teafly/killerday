#!/usr/bin/env python
# -*- coding: utf-8 -*-

from WXBizMsgCrypt import WXBizMsgCrypt
import sys
if __name__ == "__main__":   

   sCorpID = "wx60f0179a53a30de9"

   sReqMsgSig = sys.argv[1]
   sReqTimeStamp = sys.argv[2]
   sReqNonce = sys.argv[3]
   sReqData = sys.argv[4]

   ret,sMsg=wxcpt.DecryptMsg(sReqData, sReqMsgSig, sReqTimeStamp, sReqNonce)
   if( ret != 0 ):
      print -1
      sys.exit(1)
   print sMsg