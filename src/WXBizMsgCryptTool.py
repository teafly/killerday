#!/usr/bin/env python
# -*- coding: utf-8 -*-

from WXBizMsgCrypt import WXBizMsgCrypt

TOKEN = "0C72wGwIv"
AES_KEY = "1JvFzJKvPrftib6EtBQ5DyXPbrSB7fUQ6oJs36aPjNh"
CORP_ID = "wx60f0179a53a30de9"

def generateWXCpt():

   return WXBizMsgCrypt(TOKEN, AES_KEY, CORP_ID)