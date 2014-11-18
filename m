Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fw12a-leta.wadns.net ([41.185.62.175]:21865 "EHLO
	fw12a.wadns.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751038AbaKRH35 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 18 Nov 2014 02:29:57 -0500
Received: from lnxwebr01.cpt.wa.co.za ([41.185.8.51])
	by fw12a.wadns.net with esmtp (Exim 4.80)
	(envelope-from <brendan@swiftspirit.co.za>)
	id 1XqdEU-0004gQ-7S
	for linux-btrfs@vger.kernel.org; Tue, 18 Nov 2014 09:29:53 +0200
Received: from [196.220.32.228] (port=40374 helo=[10.4.64.103])
	by lnxwebr01.cpt.wa.co.za with esmtpsa (TLSv1:DHE-RSA-CAMELLIA256-SHA:256)
	(Exim 4.82)
	(envelope-from <brendan@swiftspirit.co.za>)
	id 1Xqd1m-0016CW-Rf
	for linux-btrfs@vger.kernel.org; Tue, 18 Nov 2014 09:16:42 +0200
Message-ID: <546AF572.2020101@swiftspirit.co.za>
Date: Tue, 18 Nov 2014 09:29:54 +0200
From: Brendan Hide <brendan@swiftspirit.co.za>
MIME-Version: 1.0
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: scrub implies failing drive - smartctl blissfully unaware
References: <E1XqYMg-0000YI-8y@watricky.valid.co.za>
In-Reply-To: <E1XqYMg-0000YI-8y@watricky.valid.co.za>
Content-Type: multipart/mixed;
 boundary="------------030106020006070600040903"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a multi-part message in MIME format.
--------------030106020006070600040903
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hey, guys

See further below extracted output from a daily scrub showing csum 
errors on sdb, part of a raid1 btrfs. Looking back, it has been getting 
errors like this for a few days now.

The disk is patently unreliable but smartctl's output implies there are 
no issues. Is this somehow standard faire for S.M.A.R.T. output?

Here are (I think) the important bits of the smartctl output for 
$(smartctl -a /dev/sdb) (the full results are attached):
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE UPDATED  
WHEN_FAILED RAW_VALUE
   1 Raw_Read_Error_Rate     0x000f   100   253   006    Pre-fail 
Always       -       0
   5 Reallocated_Sector_Ct   0x0033   100   100   036    Pre-fail 
Always       -       1
   7 Seek_Error_Rate         0x000f   086   060   030    Pre-fail 
Always       -       440801014
197 Current_Pending_Sector  0x0012   100   100   000    Old_age 
Always       -       0
198 Offline_Uncorrectable   0x0010   100   100   000    Old_age 
Offline      -       0
199 UDMA_CRC_Error_Count    0x003e   200   200   000    Old_age 
Always       -       0
200 Multi_Zone_Error_Rate   0x0000   100   253   000    Old_age 
Offline      -       0
202 Data_Address_Mark_Errs  0x0032   100   253   000    Old_age 
Always       -       0



-------- Original Message --------
Subject: 	Cron <root@watricky> /usr/local/sbin/btrfs-scrub-all
Date: 	Tue, 18 Nov 2014 04:19:12 +0200
From: 	(Cron Daemon) <root@watricky>
To: 	brendan@watricky



WARNING: errors detected during scrubbing, corrected.
[snip]
scrub device /dev/sdb2 (id 2) done
	scrub started at Tue Nov 18 03:22:58 2014 and finished after 2682 seconds
	total bytes scrubbed: 189.49GiB with 5420 errors
	error details: read=5 csum=5415
	corrected errors: 5420, uncorrectable errors: 0, unverified errors: 164
[snip]


--------------030106020006070600040903
Content-Type: text/plain; charset=windows-1252;
 name="sdbres[1].txt"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="sdbres[1].txt"

c21hcnRjdGwgNi4zIDIwMTQtMDctMjYgcjM5NzYgW3g4Nl82NC1saW51eC0zLjE3LjItMS1B
UkNIXSAobG9jYWwgYnVpbGQpCkNvcHlyaWdodCAoQykgMjAwMi0xNCwgQnJ1Y2UgQWxsZW4s
IENocmlzdGlhbiBGcmFua2UsIHd3dy5zbWFydG1vbnRvb2xzLm9yZwoKPT09IFNUQVJUIE9G
IElORk9STUFUSU9OIFNFQ1RJT04gPT09Ck1vZGVsIEZhbWlseTogICAgIFNlYWdhdGUgQmFy
cmFjdWRhIDcyMDAuMTAKRGV2aWNlIE1vZGVsOiAgICAgU1QzMjUwNDEwQVMKU2VyaWFsIE51
bWJlcjogICAgNlJZRjVOUDcKRmlybXdhcmUgVmVyc2lvbjogNC5BQUEKVXNlciBDYXBhY2l0
eTogICAgMjUwLDA1OSwzNTAsMDE2IGJ5dGVzIFsyNTAgR0JdClNlY3RvciBTaXplOiAgICAg
IDUxMiBieXRlcyBsb2dpY2FsL3BoeXNpY2FsCkRldmljZSBpczogICAgICAgIEluIHNtYXJ0
Y3RsIGRhdGFiYXNlIFtmb3IgZGV0YWlscyB1c2U6IC1QIHNob3ddCkFUQSBWZXJzaW9uIGlz
OiAgIEFUQS9BVEFQSS03IChtaW5vciByZXZpc2lvbiBub3QgaW5kaWNhdGVkKQpMb2NhbCBU
aW1lIGlzOiAgICBUdWUgTm92IDE4IDA5OjE2OjAzIDIwMTQgU0FTVApTTUFSVCBzdXBwb3J0
IGlzOiBBdmFpbGFibGUgLSBkZXZpY2UgaGFzIFNNQVJUIGNhcGFiaWxpdHkuClNNQVJUIHN1
cHBvcnQgaXM6IEVuYWJsZWQKCj09PSBTVEFSVCBPRiBSRUFEIFNNQVJUIERBVEEgU0VDVElP
TiA9PT0KU01BUlQgb3ZlcmFsbC1oZWFsdGggc2VsZi1hc3Nlc3NtZW50IHRlc3QgcmVzdWx0
OiBQQVNTRUQKU2VlIHZlbmRvci1zcGVjaWZpYyBBdHRyaWJ1dGUgbGlzdCBmb3IgbWFyZ2lu
YWwgQXR0cmlidXRlcy4KCkdlbmVyYWwgU01BUlQgVmFsdWVzOgpPZmZsaW5lIGRhdGEgY29s
bGVjdGlvbiBzdGF0dXM6ICAoMHg4MikJT2ZmbGluZSBkYXRhIGNvbGxlY3Rpb24gYWN0aXZp
dHkKCQkJCQl3YXMgY29tcGxldGVkIHdpdGhvdXQgZXJyb3IuCgkJCQkJQXV0byBPZmZsaW5l
IERhdGEgQ29sbGVjdGlvbjogRW5hYmxlZC4KU2VsZi10ZXN0IGV4ZWN1dGlvbiBzdGF0dXM6
ICAgICAgKCAgIDApCVRoZSBwcmV2aW91cyBzZWxmLXRlc3Qgcm91dGluZSBjb21wbGV0ZWQK
CQkJCQl3aXRob3V0IGVycm9yIG9yIG5vIHNlbGYtdGVzdCBoYXMgZXZlciAKCQkJCQliZWVu
IHJ1bi4KVG90YWwgdGltZSB0byBjb21wbGV0ZSBPZmZsaW5lIApkYXRhIGNvbGxlY3Rpb246
IAkJKCAgNDMwKSBzZWNvbmRzLgpPZmZsaW5lIGRhdGEgY29sbGVjdGlvbgpjYXBhYmlsaXRp
ZXM6IAkJCSAoMHg1YikgU01BUlQgZXhlY3V0ZSBPZmZsaW5lIGltbWVkaWF0ZS4KCQkJCQlB
dXRvIE9mZmxpbmUgZGF0YSBjb2xsZWN0aW9uIG9uL29mZiBzdXBwb3J0LgoJCQkJCVN1c3Bl
bmQgT2ZmbGluZSBjb2xsZWN0aW9uIHVwb24gbmV3CgkJCQkJY29tbWFuZC4KCQkJCQlPZmZs
aW5lIHN1cmZhY2Ugc2NhbiBzdXBwb3J0ZWQuCgkJCQkJU2VsZi10ZXN0IHN1cHBvcnRlZC4K
CQkJCQlObyBDb252ZXlhbmNlIFNlbGYtdGVzdCBzdXBwb3J0ZWQuCgkJCQkJU2VsZWN0aXZl
IFNlbGYtdGVzdCBzdXBwb3J0ZWQuClNNQVJUIGNhcGFiaWxpdGllczogICAgICAgICAgICAo
MHgwMDAzKQlTYXZlcyBTTUFSVCBkYXRhIGJlZm9yZSBlbnRlcmluZwoJCQkJCXBvd2VyLXNh
dmluZyBtb2RlLgoJCQkJCVN1cHBvcnRzIFNNQVJUIGF1dG8gc2F2ZSB0aW1lci4KRXJyb3Ig
bG9nZ2luZyBjYXBhYmlsaXR5OiAgICAgICAgKDB4MDEpCUVycm9yIGxvZ2dpbmcgc3VwcG9y
dGVkLgoJCQkJCUdlbmVyYWwgUHVycG9zZSBMb2dnaW5nIHN1cHBvcnRlZC4KU2hvcnQgc2Vs
Zi10ZXN0IHJvdXRpbmUgCnJlY29tbWVuZGVkIHBvbGxpbmcgdGltZTogCSAoICAgMSkgbWlu
dXRlcy4KRXh0ZW5kZWQgc2VsZi10ZXN0IHJvdXRpbmUKcmVjb21tZW5kZWQgcG9sbGluZyB0
aW1lOiAJICggIDY0KSBtaW51dGVzLgpTQ1QgY2FwYWJpbGl0aWVzOiAJICAgICAgICgweDAw
MDEpCVNDVCBTdGF0dXMgc3VwcG9ydGVkLgoKU01BUlQgQXR0cmlidXRlcyBEYXRhIFN0cnVj
dHVyZSByZXZpc2lvbiBudW1iZXI6IDEwClZlbmRvciBTcGVjaWZpYyBTTUFSVCBBdHRyaWJ1
dGVzIHdpdGggVGhyZXNob2xkczoKSUQjIEFUVFJJQlVURV9OQU1FICAgICAgICAgIEZMQUcg
ICAgIFZBTFVFIFdPUlNUIFRIUkVTSCBUWVBFICAgICAgVVBEQVRFRCAgV0hFTl9GQUlMRUQg
UkFXX1ZBTFVFCiAgMSBSYXdfUmVhZF9FcnJvcl9SYXRlICAgICAweDAwMGYgICAxMDAgICAy
NTMgICAwMDYgICAgUHJlLWZhaWwgIEFsd2F5cyAgICAgICAtICAgICAgIDAKICAzIFNwaW5f
VXBfVGltZSAgICAgICAgICAgIDB4MDAwMyAgIDA5OSAgIDA5NyAgIDAwMCAgICBQcmUtZmFp
bCAgQWx3YXlzICAgICAgIC0gICAgICAgMAogIDQgU3RhcnRfU3RvcF9Db3VudCAgICAgICAg
MHgwMDMyICAgMTAwICAgMTAwICAgMDIwICAgIE9sZF9hZ2UgICBBbHdheXMgICAgICAgLSAg
ICAgICA2OAogIDUgUmVhbGxvY2F0ZWRfU2VjdG9yX0N0ICAgMHgwMDMzICAgMTAwICAgMTAw
ICAgMDM2ICAgIFByZS1mYWlsICBBbHdheXMgICAgICAgLSAgICAgICAxCiAgNyBTZWVrX0Vy
cm9yX1JhdGUgICAgICAgICAweDAwMGYgICAwODYgICAwNjAgICAwMzAgICAgUHJlLWZhaWwg
IEFsd2F5cyAgICAgICAtICAgICAgIDQ0MDgwMTA1NwogIDkgUG93ZXJfT25fSG91cnMgICAg
ICAgICAgMHgwMDMyICAgMDQ0ICAgMDQ0ICAgMDAwICAgIE9sZF9hZ2UgICBBbHdheXMgICAg
ICAgLSAgICAgICA0OTEwNgogMTAgU3Bpbl9SZXRyeV9Db3VudCAgICAgICAgMHgwMDEzICAg
MTAwICAgMTAwICAgMDk3ICAgIFByZS1mYWlsICBBbHdheXMgICAgICAgLSAgICAgICAwCiAx
MiBQb3dlcl9DeWNsZV9Db3VudCAgICAgICAweDAwMzIgICAxMDAgICAxMDAgICAwMjAgICAg
T2xkX2FnZSAgIEFsd2F5cyAgICAgICAtICAgICAgIDg5CjE4NyBSZXBvcnRlZF9VbmNvcnJl
Y3QgICAgICAweDAwMzIgICAxMDAgICAxMDAgICAwMDAgICAgT2xkX2FnZSAgIEFsd2F5cyAg
ICAgICAtICAgICAgIDAKMTg5IEhpZ2hfRmx5X1dyaXRlcyAgICAgICAgIDB4MDAzYSAgIDA5
OCAgIDA5OCAgIDAwMCAgICBPbGRfYWdlICAgQWx3YXlzICAgICAgIC0gICAgICAgMgoxOTAg
QWlyZmxvd19UZW1wZXJhdHVyZV9DZWwgMHgwMDIyICAgMDYwICAgMDMwICAgMDQ1ICAgIE9s
ZF9hZ2UgICBBbHdheXMgICBJbl90aGVfcGFzdCA0MCAoTWluL01heCAyMy83MCAjMjUpCjE5
NCBUZW1wZXJhdHVyZV9DZWxzaXVzICAgICAweDAwMjIgICAwNDAgICAwNzAgICAwMDAgICAg
T2xkX2FnZSAgIEFsd2F5cyAgICAgICAtICAgICAgIDQwICgwIDIzIDAgMCAwKQoxOTUgSGFy
ZHdhcmVfRUNDX1JlY292ZXJlZCAgMHgwMDFhICAgMDY5ICAgMDU1ICAgMDAwICAgIE9sZF9h
Z2UgICBBbHdheXMgICAgICAgLSAgICAgICAxMjY2MzIwNTEKMTk3IEN1cnJlbnRfUGVuZGlu
Z19TZWN0b3IgIDB4MDAxMiAgIDEwMCAgIDEwMCAgIDAwMCAgICBPbGRfYWdlICAgQWx3YXlz
ICAgICAgIC0gICAgICAgMAoxOTggT2ZmbGluZV9VbmNvcnJlY3RhYmxlICAgMHgwMDEwICAg
MTAwICAgMTAwICAgMDAwICAgIE9sZF9hZ2UgICBPZmZsaW5lICAgICAgLSAgICAgICAwCjE5
OSBVRE1BX0NSQ19FcnJvcl9Db3VudCAgICAweDAwM2UgICAyMDAgICAyMDAgICAwMDAgICAg
T2xkX2FnZSAgIEFsd2F5cyAgICAgICAtICAgICAgIDAKMjAwIE11bHRpX1pvbmVfRXJyb3Jf
UmF0ZSAgIDB4MDAwMCAgIDEwMCAgIDI1MyAgIDAwMCAgICBPbGRfYWdlICAgT2ZmbGluZSAg
ICAgIC0gICAgICAgMAoyMDIgRGF0YV9BZGRyZXNzX01hcmtfRXJycyAgMHgwMDMyICAgMTAw
ICAgMjUzICAgMDAwICAgIE9sZF9hZ2UgICBBbHdheXMgICAgICAgLSAgICAgICAwCgpTTUFS
VCBFcnJvciBMb2cgVmVyc2lvbjogMQpObyBFcnJvcnMgTG9nZ2VkCgpTTUFSVCBTZWxmLXRl
c3QgbG9nIHN0cnVjdHVyZSByZXZpc2lvbiBudW1iZXIgMQpOdW0gIFRlc3RfRGVzY3JpcHRp
b24gICAgU3RhdHVzICAgICAgICAgICAgICAgICAgUmVtYWluaW5nICBMaWZlVGltZShob3Vy
cykgIExCQV9vZl9maXJzdF9lcnJvcgojIDEgIEV4dGVuZGVkIG9mZmxpbmUgICAgQ29tcGxl
dGVkIHdpdGhvdXQgZXJyb3IgICAgICAgMDAlICAgICAzNzU5OCAgICAgICAgIC0KClNNQVJU
IFNlbGVjdGl2ZSBzZWxmLXRlc3QgbG9nIGRhdGEgc3RydWN0dXJlIHJldmlzaW9uIG51bWJl
ciAxCiBTUEFOICBNSU5fTEJBICBNQVhfTEJBICBDVVJSRU5UX1RFU1RfU1RBVFVTCiAgICAx
ICAgICAgICAwICAgICAgICAwICBOb3RfdGVzdGluZwogICAgMiAgICAgICAgMCAgICAgICAg
MCAgTm90X3Rlc3RpbmcKICAgIDMgICAgICAgIDAgICAgICAgIDAgIE5vdF90ZXN0aW5nCiAg
ICA0ICAgICAgICAwICAgICAgICAwICBOb3RfdGVzdGluZwogICAgNSAgICAgICAgMCAgICAg
ICAgMCAgTm90X3Rlc3RpbmcKU2VsZWN0aXZlIHNlbGYtdGVzdCBmbGFncyAoMHgwKToKICBB
ZnRlciBzY2FubmluZyBzZWxlY3RlZCBzcGFucywgZG8gTk9UIHJlYWQtc2NhbiByZW1haW5k
ZXIgb2YgZGlzay4KSWYgU2VsZWN0aXZlIHNlbGYtdGVzdCBpcyBwZW5kaW5nIG9uIHBvd2Vy
LXVwLCByZXN1bWUgYWZ0ZXIgMCBtaW51dGUgZGVsYXkuCgo=
--------------030106020006070600040903--
