Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:32548 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750997AbaLXPcI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 24 Dec 2014 10:32:08 -0500
Received: from acsinet22.oracle.com (acsinet22.oracle.com [141.146.126.238])
	by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id sBOFW6Do006692
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Wed, 24 Dec 2014 15:32:07 GMT
Received: from userz7021.oracle.com (userz7021.oracle.com [156.151.31.85])
	by acsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id sBOFW5TQ007498
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-btrfs@vger.kernel.org>; Wed, 24 Dec 2014 15:32:06 GMT
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
	by userz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id sBOFW5ZO020290
	for <linux-btrfs@vger.kernel.org>; Wed, 24 Dec 2014 15:32:05 GMT
Message-ID: <549ADD17.60705@oracle.com>
Date: Wed, 24 Dec 2014 23:34:47 +0800
From: Anand Jain <anand.jain@oracle.com>
MIME-Version: 1.0
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: systemtap script to controlled induce of media error
Content-Type: multipart/mixed;
 boundary="------------020600090000080000000205"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a multi-part message in MIME format.
--------------020600090000080000000205
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



  A simple script which would fake media error back the upper
  level.

  First read write files and list block numbers being read/written,
  and then specify block number on which media error has to be created.
  IO will fake fail, btrfs can be tested for these error conditions.
  You won't be able to test for data consistency.

  Works on any SCSI device no need of LVM or any IO special kernel
  module.

  attached script is still a rough cut.

Thanks, Anand

--------------020600090000080000000205
Content-Type: text/plain; charset=windows-1252;
 name="induce-media-err.stap"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="induce-media-err.stap"

IyEgL3Vzci9iaW4vZW52IHN0YXAKCmdsb2JhbCBpbmplY3QKZ2xvYmFsIGRldl9ibG9jawpn
bG9iYWwgZGV2X2RldmljZQpnbG9iYWwgZmFpbF9yZWFkID0gMAoKI2dsb2JhbCBkZXZfZGV2
aWNlMSA9ICJzZGUiCiNnbG9iYWwgZGV2X2RldmljZTI9ICJzZGQiCiNnbG9iYWwgZGV2X2Rl
dmljZTEgPSAic2RnIgojZ2xvYmFsIGRldl9kZXZpY2UyPSAic2RmIgojZ2xvYmFsIGRldl9k
ZXZpY2UxID0gInNkYiIKI2dsb2JhbCBkZXZfZGV2aWNlMj0gInNkYyIKCgpwcm9iZSBiZWdp
bgp7CglpbmplY3QgPSAkMQoJZGV2X2Jsb2NrID0gJDIKCWRldl9kZXZpY2UgPSBAMwoJI3By
aW50ZigiQkVHSU46ICVkICVseCAlcyAlcyAlc1xuIiwgaW5qZWN0LCBkZXZfYmxvY2ssIGRl
dl9kZXZpY2UsIGRldl9kZXZpY2UxLCBkZXZfZGV2aWNlMik7CglwcmludGYoIkJFR0lOOiAl
ZCAlbHggJXNcbiIsIGluamVjdCwgZGV2X2Jsb2NrLCBkZXZfZGV2aWNlKTsKfQoKcHJvYmUg
a2VybmVsLmZ1bmN0aW9uKCJzZF9wcmVwX2ZuIikgISwKCW1vZHVsZSgiKiIpLmZ1bmN0aW9u
KCJzZF9wcmVwX2ZuIikKewoJaWYgKCRycS0+cnFfZGlzay0+ZGlza19uYW1lICE9IE5VTEwp
CiAgICAgICAgCWRldmljZSA9IGtlcm5lbF9zdHJpbmcoJHJxLT5ycV9kaXNrLT5kaXNrX25h
bWUpCgllbHNlCgkJZGV2aWNlID0gIm5vbmUiCgoJI2lmIChkZXZpY2UgPT0gZGV2X2Rldmlj
ZTEgfHwgZGV2aWNlID09IGRldl9kZXZpY2UyKSB7CglpZiAoZGV2aWNlID09IGRldl9kZXZp
Y2UpIHsKICAgICAgICAJaWYoJHJxLT5jbWRfZmxhZ3MgJiAxKQoJCQlyZWFkX29yX3dyaXRl
ID0gInciCiAgICAgICAgCWVsc2UKCQkJcmVhZF9vcl93cml0ZSA9ICJyIgoKICAgICAgICAJ
cHJpbnRmKCIlcyAlcyAlbHhcbiIsIGRldmljZSwgcmVhZF9vcl93cml0ZSwgJHJxLT5fX3Nl
Y3RvcikKCgkJI2lmIChpbmplY3QgJiYgKGRldl9kZXZpY2UxID09IGRldmljZSB8fCBkZXZf
ZGV2aWNlMiA9PSBkZXZpY2UpICYmIGRldl9ibG9jayA9PSAkcnEtPl9fc2VjdG9yKSB7CgkJ
aWYgKGluamVjdCAmJiBkZXZfZGV2aWNlID09IGRldmljZSAmJiBkZXZfYmxvY2sgPT0gJHJx
LT5fX3NlY3RvcikgewoJCQlpZiAocmVhZF9vcl93cml0ZSA9PSAiciIpIHsKCQkJCWZhaWxf
cmVhZCA9IDEKCQkJCXByaW50ZigiVHJpZ2dlciBlbmFibGVkLi4gIik7CgkJCX0gZWxzZSBp
ZiAocmVhZF9vcl93cml0ZSA9PSAidyIgJiYgZmFpbF9yZWFkKSB7CgkJCQlmYWlsX3JlYWQg
PSAwCgkJCQlwcmludGYoIkZpeCB3cml0ZSBhcHBlYXJlZC4gVHJpZ2dlciBkaXNhYmxlZFxu
Iik7CgkJCX0KCQl9Cgl9Cn0KCnByb2JlIG1vZHVsZSgiKiIpLmZ1bmN0aW9uKCJzY3NpX2Rl
Y2lkZV9kaXNwb3NpdGlvbkBkcml2ZXJzL3Njc2kvc2NzaV9lcnJvci5jIikgISwKCWtlcm5l
bC5mdW5jdGlvbigic2NzaV9kZWNpZGVfZGlzcG9zaXRpb25AZHJpdmVycy9zY3NpL3Njc2lf
ZXJyb3IuYyIpCnsKCWlmICgkc2NtZC0+cmVxdWVzdC0+cnFfZGlzay0+ZGlza19uYW1lICE9
IE5VTEwpCgkJZGV2aWNlID0ga2VybmVsX3N0cmluZygkc2NtZC0+cmVxdWVzdC0+cnFfZGlz
ay0+ZGlza19uYW1lKQoJZWxzZQoJCWRldmljZSA9ICJub25lIgoKICAgICAgICBpZigkc2Nt
ZC0+cmVxdWVzdC0+Y21kX2ZsYWdzICYgMSkKCQlyZWFkX29yX3dyaXRlID0gInciCiAgICAg
ICAgZWxzZQoJCXJlYWRfb3Jfd3JpdGUgPSAiciIKCglibG9jayA9ICRzY21kLT5yZXF1ZXN0
LT5fX3NlY3RvcgoKCSNpZiAoKGRldmljZSA9PSBkZXZfZGV2aWNlMSB8fCBkZXZpY2UgPT0g
ZGV2X2RldmljZTIpICYmIGZhaWxfcmVhZCAmJiBibG9jayA9PSBkZXZfYmxvY2sgJiYgcmVh
ZF9vcl93cml0ZSA9PSAiciIpCglpZiAoZGV2aWNlID09IGRldl9kZXZpY2UgJiYgZmFpbF9y
ZWFkICYmIGJsb2NrID09IGRldl9ibG9jayAmJiByZWFkX29yX3dyaXRlID09ICJyIikKCXsK
CQlwcmludGYoIkZhaWxpbmcgdGhlIENEQiAuLiAiKQoJCXByaW50ZigiJXMgJXMgJWx4XG4i
LCBkZXZpY2UsIHJlYWRfb3Jfd3JpdGUsIGJsb2NrKQoJCS8qIGNyZWF0ZSBmYWtlIHN0YXR1
cyBhbmQgc2Vuc2UgZGF0YSAqLwoJCSRzY21kLT5yZXN1bHQgPSAweDAyCgkJJHNjbWQtPnNl
bnNlX2J1ZmZlclswXSA9IDB4NzAKCQkkc2NtZC0+c2Vuc2VfYnVmZmVyWzJdID0gMHgwMwoJ
CSRzY21kLT5zZW5zZV9idWZmZXJbN10gPSAweDEzCgkJJHNjbWQtPnNlbnNlX2J1ZmZlclsx
Ml0gPSAweDExCgkJJHNjbWQtPnNlbnNlX2J1ZmZlclsxM10gPSAweDA0Cgl9Cn0KCnByb2Jl
IGVuZAp7CglkZWxldGUgaW5qZWN0CglkZWxldGUgZGV2X2Jsb2NrCglkZWxldGUgZGV2X2Rl
dmljZQp9Cg==
--------------020600090000080000000205--
