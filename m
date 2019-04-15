Return-Path: <SRS0=I+S+=SR=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EAD5C10F0E
	for <linux-btrfs@archiver.kernel.org>; Mon, 15 Apr 2019 20:02:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0DD3020854
	for <linux-btrfs@archiver.kernel.org>; Mon, 15 Apr 2019 20:02:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729159AbfDOUCG (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 15 Apr 2019 16:02:06 -0400
Received: from atl4mhfb04.myregisteredsite.com ([209.17.115.120]:38504 "EHLO
        atl4mhfb04.myregisteredsite.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728548AbfDOUCF (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 15 Apr 2019 16:02:05 -0400
X-Greylist: delayed 376 seconds by postgrey-1.27 at vger.kernel.org; Mon, 15 Apr 2019 16:02:03 EDT
Received: from atl4mhob13.registeredsite.com (atl4mhob13.registeredsite.com [209.17.115.51])
        by atl4mhfb04.myregisteredsite.com (8.14.4/8.14.4) with ESMTP id x3FJtlA2014092
        for <linux-btrfs@vger.kernel.org>; Mon, 15 Apr 2019 15:55:47 -0400
Received: from mailpod.hostingplatform.com (atl4qobmail01pod1.registeredsite.com [10.30.71.113])
        by atl4mhob13.registeredsite.com (8.14.4/8.14.4) with ESMTP id x3FJtjBL005595
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-btrfs@vger.kernel.org>; Mon, 15 Apr 2019 15:55:45 -0400
Received: (qmail 11593 invoked by uid 0); 15 Apr 2019 19:55:45 -0000
X-TCPREMOTEIP: 47.208.152.107
X-Authenticated-UID: george@chinilu.com
Received: from unknown (HELO localhost.localdomain) (george@chinilu.com@47.208.152.107)
  by 0 with ESMTPA; 15 Apr 2019 19:55:44 -0000
Reply-To: george@chinilu.com
To:     linux-btrfs@vger.kernel.org
From:   George Mitchell <george@chinilu.com>
Subject: btrfs mount fail after adding new drive to raid1 array
Message-ID: <eb0caa5e-3d35-495c-7420-1c39056f9ec4@chinilu.com>
Date:   Mon, 15 Apr 2019 12:55:44 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------F8F1F31727DF6213E91BFE0C"
Content-Language: en-US
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is a multi-part message in MIME format.
--------------F8F1F31727DF6213E91BFE0C
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit

After adding a new drive to a btrfs raid1 array I cannot remount it.  
One thing that went wrong for me after having successfully done this 
many times before over the last five years is that in this case I failed 
to format the partition as btrfs and just left it unformatted assuming 
the btrfs command would format it or give me a warning.  But I am not 
sure that is what caused the problem.

So far I have tried physically disconnecting the added drive and trying 
to mount read only but that has been unsuccessful.

I could forge ahead attempting to recover but I prefer to gather any 
advice or suggestions I can get before making some foolish mistake.  I 
appreciate any comments you might have.

Here is what I am seeing:

+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


[root@localhost ghmitch]# btrfs filesystem show
Label: 'COMMON'  uuid: 4b0983d7-8d85-463d-85c1-c20aa3b4fa3b
         Total devices 7 FS bytes used 473.83GiB
         devid    1 size 385.78GiB used 96.00GiB path /dev/sde4
         devid    4 size 385.78GiB used 84.00GiB path /dev/sdc4
         devid    5 size 385.78GiB used 85.00GiB path /dev/sdd4
         devid    6 size 385.76GiB used 109.03GiB path /dev/sdf4
         devid    7 size 385.76GiB used 110.00GiB path /dev/sdg4
         devid    8 size 781.12GiB used 480.03GiB path /dev/sdb4
         devid    9 size 458.98GiB used 0.00B path /dev/sda4

[root@localhost ghmitch]# btrfs check /dev/sda4
Checking filesystem on /dev/sda4
UUID: 4b0983d7-8d85-463d-85c1-c20aa3b4fa3b
checking extents
WARNING: unaligned total_bytes detected for devid 4, have 414224777728 
should be aligned to 4096
WARNING: this is OK for older kernel, but may cause kernel warning for 
newer kernels
WARNING: this can be fixed by 'btrfs rescue fix-device-size'
WARNING: unaligned total_bytes detected for devid 5, have 414224777728 
should be aligned to 4096
WARNING: this is OK for older kernel, but may cause kernel warning for 
newer kernels
WARNING: this can be fixed by 'btrfs rescue fix-device-size'
ERROR: super total bytes 3402637811712 smaller than real device(s) size 
3402637812736
ERROR: mounting this fs may fail for newer kernels
ERROR: this can be fixed by 'btrfs rescue fix-device-size'
checking free space cache
checking fs roots
checking csums
checking root refs
found 508766167040 bytes used, error(s) found
total csum bytes: 495196304
total tree bytes: 1548525568
total fs tree bytes: 891138048
total extent tree bytes: 111878144
btree space waste bytes: 305303118
file data blocks allocated: 1035580137472
  referenced 506530619392
[root@localhost ghmitch]# btrfs check /dev/sdb4
Checking filesystem on /dev/sdb4
UUID: 4b0983d7-8d85-463d-85c1-c20aa3b4fa3b
checking extents
WARNING: unaligned total_bytes detected for devid 4, have 414224777728 
should be aligned to 4096
WARNING: this is OK for older kernel, but may cause kernel warning for 
newer kernels
WARNING: this can be fixed by 'btrfs rescue fix-device-size'
WARNING: unaligned total_bytes detected for devid 5, have 414224777728 
should be aligned to 4096
WARNING: this is OK for older kernel, but may cause kernel warning for 
newer kernels
WARNING: this can be fixed by 'btrfs rescue fix-device-size'
ERROR: super total bytes 3402637811712 smaller than real device(s) size 
3402637812736
ERROR: mounting this fs may fail for newer kernels
ERROR: this can be fixed by 'btrfs rescue fix-device-size'
checking free space cache
checking fs roots
checking csums
checking root refs
found 508766167040 bytes used, error(s) found
total csum bytes: 495196304
total tree bytes: 1548525568
total fs tree bytes: 891138048
total extent tree bytes: 111878144
btree space waste bytes: 305303118
file data blocks allocated: 1035580137472
  referenced 506530619392
[root@localhost ghmitch]# btrfs check /dev/sdc4
Checking filesystem on /dev/sdc4
UUID: 4b0983d7-8d85-463d-85c1-c20aa3b4fa3b
checking extents
WARNING: unaligned total_bytes detected for devid 4, have 414224777728 
should be aligned to 4096
WARNING: this is OK for older kernel, but may cause kernel warning for 
newer kernels
WARNING: this can be fixed by 'btrfs rescue fix-device-size'
WARNING: unaligned total_bytes detected for devid 5, have 414224777728 
should be aligned to 4096
WARNING: this is OK for older kernel, but may cause kernel warning for 
newer kernels
WARNING: this can be fixed by 'btrfs rescue fix-device-size'
ERROR: super total bytes 3402637811712 smaller than real device(s) size 
3402637812736
ERROR: mounting this fs may fail for newer kernels
ERROR: this can be fixed by 'btrfs rescue fix-device-size'
checking free space cache
checking fs roots
checking csums
checking root refs
found 508766167040 bytes used, error(s) found
total csum bytes: 495196304
total tree bytes: 1548525568
total fs tree bytes: 891138048
total extent tree bytes: 111878144
btree space waste bytes: 305303118
file data blocks allocated: 1035580137472
  referenced 506530619392
[root@localhost ghmitch]# btrfs check /dev/sdd4
Checking filesystem on /dev/sdd4
UUID: 4b0983d7-8d85-463d-85c1-c20aa3b4fa3b
checking extents
WARNING: unaligned total_bytes detected for devid 4, have 414224777728 
should be aligned to 4096
WARNING: this is OK for older kernel, but may cause kernel warning for 
newer kernels
WARNING: this can be fixed by 'btrfs rescue fix-device-size'
WARNING: unaligned total_bytes detected for devid 5, have 414224777728 
should be aligned to 4096
WARNING: this is OK for older kernel, but may cause kernel warning for 
newer kernels
WARNING: this can be fixed by 'btrfs rescue fix-device-size'
ERROR: super total bytes 3402637811712 smaller than real device(s) size 
3402637812736
ERROR: mounting this fs may fail for newer kernels
ERROR: this can be fixed by 'btrfs rescue fix-device-size'
checking free space cache
checking fs roots
checking csums
checking root refs
found 508766167040 bytes used, error(s) found
total csum bytes: 495196304
total tree bytes: 1548525568
total fs tree bytes: 891138048
total extent tree bytes: 111878144
btree space waste bytes: 305303118
file data blocks allocated: 1035580137472
  referenced 506530619392
[root@localhost ghmitch]# btrfs check /dev/sde4
Checking filesystem on /dev/sde4
UUID: 4b0983d7-8d85-463d-85c1-c20aa3b4fa3b
checking extents
WARNING: unaligned total_bytes detected for devid 4, have 414224777728 
should be aligned to 4096
WARNING: this is OK for older kernel, but may cause kernel warning for 
newer kernels
WARNING: this can be fixed by 'btrfs rescue fix-device-size'
WARNING: unaligned total_bytes detected for devid 5, have 414224777728 
should be aligned to 4096
WARNING: this is OK for older kernel, but may cause kernel warning for 
newer kernels
WARNING: this can be fixed by 'btrfs rescue fix-device-size'
ERROR: super total bytes 3402637811712 smaller than real device(s) size 
3402637812736
ERROR: mounting this fs may fail for newer kernels
ERROR: this can be fixed by 'btrfs rescue fix-device-size'
checking free space cache
checking fs roots
checking csums
checking root refs
found 508766167040 bytes used, error(s) found
total csum bytes: 495196304
total tree bytes: 1548525568
total fs tree bytes: 891138048
total extent tree bytes: 111878144
btree space waste bytes: 305303118
file data blocks allocated: 1035580137472
  referenced 506530619392
[root@localhost ghmitch]# btrfs check /dev/sdf4
Checking filesystem on /dev/sdf4
UUID: 4b0983d7-8d85-463d-85c1-c20aa3b4fa3b
checking extents
WARNING: unaligned total_bytes detected for devid 4, have 414224777728 
should be aligned to 4096
WARNING: this is OK for older kernel, but may cause kernel warning for 
newer kernels
WARNING: this can be fixed by 'btrfs rescue fix-device-size'
WARNING: unaligned total_bytes detected for devid 5, have 414224777728 
should be aligned to 4096
WARNING: this is OK for older kernel, but may cause kernel warning for 
newer kernels
WARNING: this can be fixed by 'btrfs rescue fix-device-size'
ERROR: super total bytes 3402637811712 smaller than real device(s) size 
3402637812736
ERROR: mounting this fs may fail for newer kernels
ERROR: this can be fixed by 'btrfs rescue fix-device-size'
checking free space cache
checking fs roots
checking csums
checking root refs
found 508766167040 bytes used, error(s) found
total csum bytes: 495196304
total tree bytes: 1548525568
total fs tree bytes: 891138048
total extent tree bytes: 111878144
btree space waste bytes: 305303118
file data blocks allocated: 1035580137472
  referenced 506530619392
[root@localhost ghmitch]# btrfs check /dev/sdg4
Checking filesystem on /dev/sdg4
UUID: 4b0983d7-8d85-463d-85c1-c20aa3b4fa3b
checking extents
WARNING: unaligned total_bytes detected for devid 4, have 414224777728 
should be aligned to 4096
WARNING: this is OK for older kernel, but may cause kernel warning for 
newer kernels
WARNING: this can be fixed by 'btrfs rescue fix-device-size'
WARNING: unaligned total_bytes detected for devid 5, have 414224777728 
should be aligned to 4096
WARNING: this is OK for older kernel, but may cause kernel warning for 
newer kernels
WARNING: this can be fixed by 'btrfs rescue fix-device-size'
ERROR: super total bytes 3402637811712 smaller than real device(s) size 
3402637812736
ERROR: mounting this fs may fail for newer kernels
ERROR: this can be fixed by 'btrfs rescue fix-device-size'
checking free space cache
checking fs roots
checking csums
checking root refs
found 508766167040 bytes used, error(s) found
total csum bytes: 495196304
total tree bytes: 1548525568
total fs tree bytes: 891138048
total extent tree bytes: 111878144
btree space waste bytes: 305303118
file data blocks allocated: 1035580137472
  referenced 506530619392
[root@localhost ghmitch]# mount LABEL=common /common
mount: can't find LABEL=common
[root@localhost ghmitch]# mount LABEL=COMMON /common
mount: wrong fs type, bad option, bad superblock on /dev/sdb4,
        missing codepage or helper program, or other error

        In some cases useful info is found in syslog - try
        dmesg | tail or so.
[root@localhost ghmitch]# mount LABEL=COMMON /common
mount: wrong fs type, bad option, bad superblock on /dev/sdb4,
        missing codepage or helper program, or other error

        In some cases useful info is found in syslog - try
        dmesg | tail or so.
[root@localhost ghmitch]#


I am attaching the output from journalctl for this.


--------------F8F1F31727DF6213E91BFE0C
Content-Type: text/plain; charset=UTF-8;
 name="btrfs_mount_fail"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="btrfs_mount_fail"

W3Jvb3RAbG9jYWxob3N0IGdobWl0Y2hdIyBidHJmcyBmaWxlc3lzdGVtIHNob3cKTGFiZWw6
ICdDT01NT04nICB1dWlkOiA0YjA5ODNkNy04ZDg1LTQ2M2QtODVjMS1jMjBhYTNiNGZhM2IK
ICAgICAgICBUb3RhbCBkZXZpY2VzIDcgRlMgYnl0ZXMgdXNlZCA0NzMuODNHaUIKICAgICAg
ICBkZXZpZCAgICAxIHNpemUgMzg1Ljc4R2lCIHVzZWQgOTYuMDBHaUIgcGF0aCAvZGV2L3Nk
ZTQKICAgICAgICBkZXZpZCAgICA0IHNpemUgMzg1Ljc4R2lCIHVzZWQgODQuMDBHaUIgcGF0
aCAvZGV2L3NkYzQKICAgICAgICBkZXZpZCAgICA1IHNpemUgMzg1Ljc4R2lCIHVzZWQgODUu
MDBHaUIgcGF0aCAvZGV2L3NkZDQKICAgICAgICBkZXZpZCAgICA2IHNpemUgMzg1Ljc2R2lC
IHVzZWQgMTA5LjAzR2lCIHBhdGggL2Rldi9zZGY0CiAgICAgICAgZGV2aWQgICAgNyBzaXpl
IDM4NS43NkdpQiB1c2VkIDExMC4wMEdpQiBwYXRoIC9kZXYvc2RnNAogICAgICAgIGRldmlk
ICAgIDggc2l6ZSA3ODEuMTJHaUIgdXNlZCA0ODAuMDNHaUIgcGF0aCAvZGV2L3NkYjQKICAg
ICAgICBkZXZpZCAgICA5IHNpemUgNDU4Ljk4R2lCIHVzZWQgMC4wMEIgcGF0aCAvZGV2L3Nk
YTQKCltyb290QGxvY2FsaG9zdCBnaG1pdGNoXSMgYnRyZnMgY2hlY2sgL2Rldi9zZGE0CkNo
ZWNraW5nIGZpbGVzeXN0ZW0gb24gL2Rldi9zZGE0ICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgIApVVUlEOiA0YjA5ODNkNy04ZDg1LTQ2M2QtODVjMS1jMjBh
YTNiNGZhM2IgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKY2hlY2tpbmcgZXh0
ZW50cyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgCldBUk5JTkc6IHVuYWxpZ25lZCB0b3RhbF9ieXRlcyBkZXRlY3RlZCBmb3Ig
ZGV2aWQgNCwgaGF2ZSA0MTQyMjQ3Nzc3Mjggc2hvdWxkIGJlIGFsaWduZWQgdG8gNDA5NiAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIApXQVJOSU5HOiB0aGlzIGlzIE9LIGZv
ciBvbGRlciBrZXJuZWwsIGJ1dCBtYXkgY2F1c2Uga2VybmVsIHdhcm5pbmcgZm9yIG5ld2Vy
IGtlcm5lbHMgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAK
V0FSTklORzogdGhpcyBjYW4gYmUgZml4ZWQgYnkgJ2J0cmZzIHJlc2N1ZSBmaXgtZGV2aWNl
LXNpemUnICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgCldBUk5JTkc6IHVuYWxpZ25lZCB0b3RhbF9ieXRlcyBk
ZXRlY3RlZCBmb3IgZGV2aWQgNSwgaGF2ZSA0MTQyMjQ3Nzc3Mjggc2hvdWxkIGJlIGFsaWdu
ZWQgdG8gNDA5NiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIApXQVJOSU5HOiB0
aGlzIGlzIE9LIGZvciBvbGRlciBrZXJuZWwsIGJ1dCBtYXkgY2F1c2Uga2VybmVsIHdhcm5p
bmcgZm9yIG5ld2VyIGtlcm5lbHMgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAKV0FSTklORzogdGhpcyBjYW4gYmUgZml4ZWQgYnkgJ2J0cmZzIHJlc2N1
ZSBmaXgtZGV2aWNlLXNpemUnICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCkVSUk9SOiBzdXBlciB0b3RhbCBi
eXRlcyAzNDAyNjM3ODExNzEyIHNtYWxsZXIgdGhhbiByZWFsIGRldmljZShzKSBzaXplIDM0
MDI2Mzc4MTI3MzYgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
IApFUlJPUjogbW91bnRpbmcgdGhpcyBmcyBtYXkgZmFpbCBmb3IgbmV3ZXIga2VybmVscyAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAKRVJST1I6IHRoaXMgY2FuIGJlIGZpeGVkIGJ5ICdi
dHJmcyByZXNjdWUgZml4LWRldmljZS1zaXplJyAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCmNoZWNraW5n
IGZyZWUgc3BhY2UgY2FjaGUgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgIApjaGVja2luZyBmcyByb290cyAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKY2hlY2tpbmcgY3N1bXMgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgCmNoZWNraW5nIHJvb3QgcmVmcyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgIApmb3VuZCA1MDg3NjYxNjcwNDAgYnl0ZXMgdXNl
ZCwgZXJyb3IocykgZm91bmQgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKdG90YWwg
Y3N1bSBieXRlczogNDk1MTk2MzA0ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgCnRvdGFsIHRyZWUgYnl0ZXM6IDE1NDg1MjU1NjgKdG90YWwgZnMg
dHJlZSBieXRlczogODkxMTM4MDQ4CnRvdGFsIGV4dGVudCB0cmVlIGJ5dGVzOiAxMTE4Nzgx
NDQKYnRyZWUgc3BhY2Ugd2FzdGUgYnl0ZXM6IDMwNTMwMzExOApmaWxlIGRhdGEgYmxvY2tz
IGFsbG9jYXRlZDogMTAzNTU4MDEzNzQ3MgogcmVmZXJlbmNlZCA1MDY1MzA2MTkzOTIKW3Jv
b3RAbG9jYWxob3N0IGdobWl0Y2hdIyBidHJmcyBjaGVjayAvZGV2L3NkYjQKQ2hlY2tpbmcg
ZmlsZXN5c3RlbSBvbiAvZGV2L3NkYjQKVVVJRDogNGIwOTgzZDctOGQ4NS00NjNkLTg1YzEt
YzIwYWEzYjRmYTNiCmNoZWNraW5nIGV4dGVudHMKV0FSTklORzogdW5hbGlnbmVkIHRvdGFs
X2J5dGVzIGRldGVjdGVkIGZvciBkZXZpZCA0LCBoYXZlIDQxNDIyNDc3NzcyOCBzaG91bGQg
YmUgYWxpZ25lZCB0byA0MDk2CldBUk5JTkc6IHRoaXMgaXMgT0sgZm9yIG9sZGVyIGtlcm5l
bCwgYnV0IG1heSBjYXVzZSBrZXJuZWwgd2FybmluZyBmb3IgbmV3ZXIga2VybmVscwpXQVJO
SU5HOiB0aGlzIGNhbiBiZSBmaXhlZCBieSAnYnRyZnMgcmVzY3VlIGZpeC1kZXZpY2Utc2l6
ZScKV0FSTklORzogdW5hbGlnbmVkIHRvdGFsX2J5dGVzIGRldGVjdGVkIGZvciBkZXZpZCA1
LCBoYXZlIDQxNDIyNDc3NzcyOCBzaG91bGQgYmUgYWxpZ25lZCB0byA0MDk2CldBUk5JTkc6
IHRoaXMgaXMgT0sgZm9yIG9sZGVyIGtlcm5lbCwgYnV0IG1heSBjYXVzZSBrZXJuZWwgd2Fy
bmluZyBmb3IgbmV3ZXIga2VybmVscwpXQVJOSU5HOiB0aGlzIGNhbiBiZSBmaXhlZCBieSAn
YnRyZnMgcmVzY3VlIGZpeC1kZXZpY2Utc2l6ZScKRVJST1I6IHN1cGVyIHRvdGFsIGJ5dGVz
IDM0MDI2Mzc4MTE3MTIgc21hbGxlciB0aGFuIHJlYWwgZGV2aWNlKHMpIHNpemUgMzQwMjYz
NzgxMjczNgpFUlJPUjogbW91bnRpbmcgdGhpcyBmcyBtYXkgZmFpbCBmb3IgbmV3ZXIga2Vy
bmVscwpFUlJPUjogdGhpcyBjYW4gYmUgZml4ZWQgYnkgJ2J0cmZzIHJlc2N1ZSBmaXgtZGV2
aWNlLXNpemUnCmNoZWNraW5nIGZyZWUgc3BhY2UgY2FjaGUKY2hlY2tpbmcgZnMgcm9vdHMK
Y2hlY2tpbmcgY3N1bXMKY2hlY2tpbmcgcm9vdCByZWZzCmZvdW5kIDUwODc2NjE2NzA0MCBi
eXRlcyB1c2VkLCBlcnJvcihzKSBmb3VuZAp0b3RhbCBjc3VtIGJ5dGVzOiA0OTUxOTYzMDQK
dG90YWwgdHJlZSBieXRlczogMTU0ODUyNTU2OAp0b3RhbCBmcyB0cmVlIGJ5dGVzOiA4OTEx
MzgwNDgKdG90YWwgZXh0ZW50IHRyZWUgYnl0ZXM6IDExMTg3ODE0NApidHJlZSBzcGFjZSB3
YXN0ZSBieXRlczogMzA1MzAzMTE4CmZpbGUgZGF0YSBibG9ja3MgYWxsb2NhdGVkOiAxMDM1
NTgwMTM3NDcyCiByZWZlcmVuY2VkIDUwNjUzMDYxOTM5Mgpbcm9vdEBsb2NhbGhvc3QgZ2ht
aXRjaF0jIGJ0cmZzIGNoZWNrIC9kZXYvc2RjNApDaGVja2luZyBmaWxlc3lzdGVtIG9uIC9k
ZXYvc2RjNApVVUlEOiA0YjA5ODNkNy04ZDg1LTQ2M2QtODVjMS1jMjBhYTNiNGZhM2IKY2hl
Y2tpbmcgZXh0ZW50cwpXQVJOSU5HOiB1bmFsaWduZWQgdG90YWxfYnl0ZXMgZGV0ZWN0ZWQg
Zm9yIGRldmlkIDQsIGhhdmUgNDE0MjI0Nzc3NzI4IHNob3VsZCBiZSBhbGlnbmVkIHRvIDQw
OTYKV0FSTklORzogdGhpcyBpcyBPSyBmb3Igb2xkZXIga2VybmVsLCBidXQgbWF5IGNhdXNl
IGtlcm5lbCB3YXJuaW5nIGZvciBuZXdlciBrZXJuZWxzCldBUk5JTkc6IHRoaXMgY2FuIGJl
IGZpeGVkIGJ5ICdidHJmcyByZXNjdWUgZml4LWRldmljZS1zaXplJwpXQVJOSU5HOiB1bmFs
aWduZWQgdG90YWxfYnl0ZXMgZGV0ZWN0ZWQgZm9yIGRldmlkIDUsIGhhdmUgNDE0MjI0Nzc3
NzI4IHNob3VsZCBiZSBhbGlnbmVkIHRvIDQwOTYKV0FSTklORzogdGhpcyBpcyBPSyBmb3Ig
b2xkZXIga2VybmVsLCBidXQgbWF5IGNhdXNlIGtlcm5lbCB3YXJuaW5nIGZvciBuZXdlciBr
ZXJuZWxzCldBUk5JTkc6IHRoaXMgY2FuIGJlIGZpeGVkIGJ5ICdidHJmcyByZXNjdWUgZml4
LWRldmljZS1zaXplJwpFUlJPUjogc3VwZXIgdG90YWwgYnl0ZXMgMzQwMjYzNzgxMTcxMiBz
bWFsbGVyIHRoYW4gcmVhbCBkZXZpY2Uocykgc2l6ZSAzNDAyNjM3ODEyNzM2CkVSUk9SOiBt
b3VudGluZyB0aGlzIGZzIG1heSBmYWlsIGZvciBuZXdlciBrZXJuZWxzCkVSUk9SOiB0aGlz
IGNhbiBiZSBmaXhlZCBieSAnYnRyZnMgcmVzY3VlIGZpeC1kZXZpY2Utc2l6ZScKY2hlY2tp
bmcgZnJlZSBzcGFjZSBjYWNoZQpjaGVja2luZyBmcyByb290cwpjaGVja2luZyBjc3Vtcwpj
aGVja2luZyByb290IHJlZnMKZm91bmQgNTA4NzY2MTY3MDQwIGJ5dGVzIHVzZWQsIGVycm9y
KHMpIGZvdW5kCnRvdGFsIGNzdW0gYnl0ZXM6IDQ5NTE5NjMwNAp0b3RhbCB0cmVlIGJ5dGVz
OiAxNTQ4NTI1NTY4CnRvdGFsIGZzIHRyZWUgYnl0ZXM6IDg5MTEzODA0OAp0b3RhbCBleHRl
bnQgdHJlZSBieXRlczogMTExODc4MTQ0CmJ0cmVlIHNwYWNlIHdhc3RlIGJ5dGVzOiAzMDUz
MDMxMTgKZmlsZSBkYXRhIGJsb2NrcyBhbGxvY2F0ZWQ6IDEwMzU1ODAxMzc0NzIKIHJlZmVy
ZW5jZWQgNTA2NTMwNjE5MzkyCltyb290QGxvY2FsaG9zdCBnaG1pdGNoXSMgYnRyZnMgY2hl
Y2sgL2Rldi9zZGQ0CkNoZWNraW5nIGZpbGVzeXN0ZW0gb24gL2Rldi9zZGQ0ClVVSUQ6IDRi
MDk4M2Q3LThkODUtNDYzZC04NWMxLWMyMGFhM2I0ZmEzYgpjaGVja2luZyBleHRlbnRzCldB
Uk5JTkc6IHVuYWxpZ25lZCB0b3RhbF9ieXRlcyBkZXRlY3RlZCBmb3IgZGV2aWQgNCwgaGF2
ZSA0MTQyMjQ3Nzc3Mjggc2hvdWxkIGJlIGFsaWduZWQgdG8gNDA5NgpXQVJOSU5HOiB0aGlz
IGlzIE9LIGZvciBvbGRlciBrZXJuZWwsIGJ1dCBtYXkgY2F1c2Uga2VybmVsIHdhcm5pbmcg
Zm9yIG5ld2VyIGtlcm5lbHMKV0FSTklORzogdGhpcyBjYW4gYmUgZml4ZWQgYnkgJ2J0cmZz
IHJlc2N1ZSBmaXgtZGV2aWNlLXNpemUnCldBUk5JTkc6IHVuYWxpZ25lZCB0b3RhbF9ieXRl
cyBkZXRlY3RlZCBmb3IgZGV2aWQgNSwgaGF2ZSA0MTQyMjQ3Nzc3Mjggc2hvdWxkIGJlIGFs
aWduZWQgdG8gNDA5NgpXQVJOSU5HOiB0aGlzIGlzIE9LIGZvciBvbGRlciBrZXJuZWwsIGJ1
dCBtYXkgY2F1c2Uga2VybmVsIHdhcm5pbmcgZm9yIG5ld2VyIGtlcm5lbHMKV0FSTklORzog
dGhpcyBjYW4gYmUgZml4ZWQgYnkgJ2J0cmZzIHJlc2N1ZSBmaXgtZGV2aWNlLXNpemUnCkVS
Uk9SOiBzdXBlciB0b3RhbCBieXRlcyAzNDAyNjM3ODExNzEyIHNtYWxsZXIgdGhhbiByZWFs
IGRldmljZShzKSBzaXplIDM0MDI2Mzc4MTI3MzYKRVJST1I6IG1vdW50aW5nIHRoaXMgZnMg
bWF5IGZhaWwgZm9yIG5ld2VyIGtlcm5lbHMKRVJST1I6IHRoaXMgY2FuIGJlIGZpeGVkIGJ5
ICdidHJmcyByZXNjdWUgZml4LWRldmljZS1zaXplJwpjaGVja2luZyBmcmVlIHNwYWNlIGNh
Y2hlCmNoZWNraW5nIGZzIHJvb3RzCmNoZWNraW5nIGNzdW1zCmNoZWNraW5nIHJvb3QgcmVm
cwpmb3VuZCA1MDg3NjYxNjcwNDAgYnl0ZXMgdXNlZCwgZXJyb3IocykgZm91bmQKdG90YWwg
Y3N1bSBieXRlczogNDk1MTk2MzA0CnRvdGFsIHRyZWUgYnl0ZXM6IDE1NDg1MjU1NjgKdG90
YWwgZnMgdHJlZSBieXRlczogODkxMTM4MDQ4CnRvdGFsIGV4dGVudCB0cmVlIGJ5dGVzOiAx
MTE4NzgxNDQKYnRyZWUgc3BhY2Ugd2FzdGUgYnl0ZXM6IDMwNTMwMzExOApmaWxlIGRhdGEg
YmxvY2tzIGFsbG9jYXRlZDogMTAzNTU4MDEzNzQ3MgogcmVmZXJlbmNlZCA1MDY1MzA2MTkz
OTIKW3Jvb3RAbG9jYWxob3N0IGdobWl0Y2hdIyBidHJmcyBjaGVjayAvZGV2L3NkZTQKQ2hl
Y2tpbmcgZmlsZXN5c3RlbSBvbiAvZGV2L3NkZTQKVVVJRDogNGIwOTgzZDctOGQ4NS00NjNk
LTg1YzEtYzIwYWEzYjRmYTNiCmNoZWNraW5nIGV4dGVudHMKV0FSTklORzogdW5hbGlnbmVk
IHRvdGFsX2J5dGVzIGRldGVjdGVkIGZvciBkZXZpZCA0LCBoYXZlIDQxNDIyNDc3NzcyOCBz
aG91bGQgYmUgYWxpZ25lZCB0byA0MDk2CldBUk5JTkc6IHRoaXMgaXMgT0sgZm9yIG9sZGVy
IGtlcm5lbCwgYnV0IG1heSBjYXVzZSBrZXJuZWwgd2FybmluZyBmb3IgbmV3ZXIga2VybmVs
cwpXQVJOSU5HOiB0aGlzIGNhbiBiZSBmaXhlZCBieSAnYnRyZnMgcmVzY3VlIGZpeC1kZXZp
Y2Utc2l6ZScKV0FSTklORzogdW5hbGlnbmVkIHRvdGFsX2J5dGVzIGRldGVjdGVkIGZvciBk
ZXZpZCA1LCBoYXZlIDQxNDIyNDc3NzcyOCBzaG91bGQgYmUgYWxpZ25lZCB0byA0MDk2CldB
Uk5JTkc6IHRoaXMgaXMgT0sgZm9yIG9sZGVyIGtlcm5lbCwgYnV0IG1heSBjYXVzZSBrZXJu
ZWwgd2FybmluZyBmb3IgbmV3ZXIga2VybmVscwpXQVJOSU5HOiB0aGlzIGNhbiBiZSBmaXhl
ZCBieSAnYnRyZnMgcmVzY3VlIGZpeC1kZXZpY2Utc2l6ZScKRVJST1I6IHN1cGVyIHRvdGFs
IGJ5dGVzIDM0MDI2Mzc4MTE3MTIgc21hbGxlciB0aGFuIHJlYWwgZGV2aWNlKHMpIHNpemUg
MzQwMjYzNzgxMjczNgpFUlJPUjogbW91bnRpbmcgdGhpcyBmcyBtYXkgZmFpbCBmb3IgbmV3
ZXIga2VybmVscwpFUlJPUjogdGhpcyBjYW4gYmUgZml4ZWQgYnkgJ2J0cmZzIHJlc2N1ZSBm
aXgtZGV2aWNlLXNpemUnCmNoZWNraW5nIGZyZWUgc3BhY2UgY2FjaGUKY2hlY2tpbmcgZnMg
cm9vdHMKY2hlY2tpbmcgY3N1bXMKY2hlY2tpbmcgcm9vdCByZWZzCmZvdW5kIDUwODc2NjE2
NzA0MCBieXRlcyB1c2VkLCBlcnJvcihzKSBmb3VuZAp0b3RhbCBjc3VtIGJ5dGVzOiA0OTUx
OTYzMDQKdG90YWwgdHJlZSBieXRlczogMTU0ODUyNTU2OAp0b3RhbCBmcyB0cmVlIGJ5dGVz
OiA4OTExMzgwNDgKdG90YWwgZXh0ZW50IHRyZWUgYnl0ZXM6IDExMTg3ODE0NApidHJlZSBz
cGFjZSB3YXN0ZSBieXRlczogMzA1MzAzMTE4CmZpbGUgZGF0YSBibG9ja3MgYWxsb2NhdGVk
OiAxMDM1NTgwMTM3NDcyCiByZWZlcmVuY2VkIDUwNjUzMDYxOTM5Mgpbcm9vdEBsb2NhbGhv
c3QgZ2htaXRjaF0jIGJ0cmZzIGNoZWNrIC9kZXYvc2RmNApDaGVja2luZyBmaWxlc3lzdGVt
IG9uIC9kZXYvc2RmNApVVUlEOiA0YjA5ODNkNy04ZDg1LTQ2M2QtODVjMS1jMjBhYTNiNGZh
M2IKY2hlY2tpbmcgZXh0ZW50cwpXQVJOSU5HOiB1bmFsaWduZWQgdG90YWxfYnl0ZXMgZGV0
ZWN0ZWQgZm9yIGRldmlkIDQsIGhhdmUgNDE0MjI0Nzc3NzI4IHNob3VsZCBiZSBhbGlnbmVk
IHRvIDQwOTYKV0FSTklORzogdGhpcyBpcyBPSyBmb3Igb2xkZXIga2VybmVsLCBidXQgbWF5
IGNhdXNlIGtlcm5lbCB3YXJuaW5nIGZvciBuZXdlciBrZXJuZWxzCldBUk5JTkc6IHRoaXMg
Y2FuIGJlIGZpeGVkIGJ5ICdidHJmcyByZXNjdWUgZml4LWRldmljZS1zaXplJwpXQVJOSU5H
OiB1bmFsaWduZWQgdG90YWxfYnl0ZXMgZGV0ZWN0ZWQgZm9yIGRldmlkIDUsIGhhdmUgNDE0
MjI0Nzc3NzI4IHNob3VsZCBiZSBhbGlnbmVkIHRvIDQwOTYKV0FSTklORzogdGhpcyBpcyBP
SyBmb3Igb2xkZXIga2VybmVsLCBidXQgbWF5IGNhdXNlIGtlcm5lbCB3YXJuaW5nIGZvciBu
ZXdlciBrZXJuZWxzCldBUk5JTkc6IHRoaXMgY2FuIGJlIGZpeGVkIGJ5ICdidHJmcyByZXNj
dWUgZml4LWRldmljZS1zaXplJwpFUlJPUjogc3VwZXIgdG90YWwgYnl0ZXMgMzQwMjYzNzgx
MTcxMiBzbWFsbGVyIHRoYW4gcmVhbCBkZXZpY2Uocykgc2l6ZSAzNDAyNjM3ODEyNzM2CkVS
Uk9SOiBtb3VudGluZyB0aGlzIGZzIG1heSBmYWlsIGZvciBuZXdlciBrZXJuZWxzCkVSUk9S
OiB0aGlzIGNhbiBiZSBmaXhlZCBieSAnYnRyZnMgcmVzY3VlIGZpeC1kZXZpY2Utc2l6ZScK
Y2hlY2tpbmcgZnJlZSBzcGFjZSBjYWNoZQpjaGVja2luZyBmcyByb290cwpjaGVja2luZyBj
c3VtcwpjaGVja2luZyByb290IHJlZnMKZm91bmQgNTA4NzY2MTY3MDQwIGJ5dGVzIHVzZWQs
IGVycm9yKHMpIGZvdW5kCnRvdGFsIGNzdW0gYnl0ZXM6IDQ5NTE5NjMwNAp0b3RhbCB0cmVl
IGJ5dGVzOiAxNTQ4NTI1NTY4CnRvdGFsIGZzIHRyZWUgYnl0ZXM6IDg5MTEzODA0OAp0b3Rh
bCBleHRlbnQgdHJlZSBieXRlczogMTExODc4MTQ0CmJ0cmVlIHNwYWNlIHdhc3RlIGJ5dGVz
OiAzMDUzMDMxMTgKZmlsZSBkYXRhIGJsb2NrcyBhbGxvY2F0ZWQ6IDEwMzU1ODAxMzc0NzIK
IHJlZmVyZW5jZWQgNTA2NTMwNjE5MzkyCltyb290QGxvY2FsaG9zdCBnaG1pdGNoXSMgYnRy
ZnMgY2hlY2sgL2Rldi9zZGc0CkNoZWNraW5nIGZpbGVzeXN0ZW0gb24gL2Rldi9zZGc0ClVV
SUQ6IDRiMDk4M2Q3LThkODUtNDYzZC04NWMxLWMyMGFhM2I0ZmEzYgpjaGVja2luZyBleHRl
bnRzCldBUk5JTkc6IHVuYWxpZ25lZCB0b3RhbF9ieXRlcyBkZXRlY3RlZCBmb3IgZGV2aWQg
NCwgaGF2ZSA0MTQyMjQ3Nzc3Mjggc2hvdWxkIGJlIGFsaWduZWQgdG8gNDA5NgpXQVJOSU5H
OiB0aGlzIGlzIE9LIGZvciBvbGRlciBrZXJuZWwsIGJ1dCBtYXkgY2F1c2Uga2VybmVsIHdh
cm5pbmcgZm9yIG5ld2VyIGtlcm5lbHMKV0FSTklORzogdGhpcyBjYW4gYmUgZml4ZWQgYnkg
J2J0cmZzIHJlc2N1ZSBmaXgtZGV2aWNlLXNpemUnCldBUk5JTkc6IHVuYWxpZ25lZCB0b3Rh
bF9ieXRlcyBkZXRlY3RlZCBmb3IgZGV2aWQgNSwgaGF2ZSA0MTQyMjQ3Nzc3Mjggc2hvdWxk
IGJlIGFsaWduZWQgdG8gNDA5NgpXQVJOSU5HOiB0aGlzIGlzIE9LIGZvciBvbGRlciBrZXJu
ZWwsIGJ1dCBtYXkgY2F1c2Uga2VybmVsIHdhcm5pbmcgZm9yIG5ld2VyIGtlcm5lbHMKV0FS
TklORzogdGhpcyBjYW4gYmUgZml4ZWQgYnkgJ2J0cmZzIHJlc2N1ZSBmaXgtZGV2aWNlLXNp
emUnCkVSUk9SOiBzdXBlciB0b3RhbCBieXRlcyAzNDAyNjM3ODExNzEyIHNtYWxsZXIgdGhh
biByZWFsIGRldmljZShzKSBzaXplIDM0MDI2Mzc4MTI3MzYKRVJST1I6IG1vdW50aW5nIHRo
aXMgZnMgbWF5IGZhaWwgZm9yIG5ld2VyIGtlcm5lbHMKRVJST1I6IHRoaXMgY2FuIGJlIGZp
eGVkIGJ5ICdidHJmcyByZXNjdWUgZml4LWRldmljZS1zaXplJwpjaGVja2luZyBmcmVlIHNw
YWNlIGNhY2hlCmNoZWNraW5nIGZzIHJvb3RzCmNoZWNraW5nIGNzdW1zCmNoZWNraW5nIHJv
b3QgcmVmcwpmb3VuZCA1MDg3NjYxNjcwNDAgYnl0ZXMgdXNlZCwgZXJyb3IocykgZm91bmQK
dG90YWwgY3N1bSBieXRlczogNDk1MTk2MzA0CnRvdGFsIHRyZWUgYnl0ZXM6IDE1NDg1MjU1
NjgKdG90YWwgZnMgdHJlZSBieXRlczogODkxMTM4MDQ4CnRvdGFsIGV4dGVudCB0cmVlIGJ5
dGVzOiAxMTE4NzgxNDQKYnRyZWUgc3BhY2Ugd2FzdGUgYnl0ZXM6IDMwNTMwMzExOApmaWxl
IGRhdGEgYmxvY2tzIGFsbG9jYXRlZDogMTAzNTU4MDEzNzQ3MgogcmVmZXJlbmNlZCA1MDY1
MzA2MTkzOTIKW3Jvb3RAbG9jYWxob3N0IGdobWl0Y2hdIyBtb3VudCBMQUJFTD1jb21tb24g
L2NvbW1vbgptb3VudDogY2FuJ3QgZmluZCBMQUJFTD1jb21tb24KW3Jvb3RAbG9jYWxob3N0
IGdobWl0Y2hdIyBtb3VudCBMQUJFTD1DT01NT04gL2NvbW1vbgptb3VudDogd3JvbmcgZnMg
dHlwZSwgYmFkIG9wdGlvbiwgYmFkIHN1cGVyYmxvY2sgb24gL2Rldi9zZGI0LAogICAgICAg
bWlzc2luZyBjb2RlcGFnZSBvciBoZWxwZXIgcHJvZ3JhbSwgb3Igb3RoZXIgZXJyb3IKCiAg
ICAgICBJbiBzb21lIGNhc2VzIHVzZWZ1bCBpbmZvIGlzIGZvdW5kIGluIHN5c2xvZyAtIHRy
eQogICAgICAgZG1lc2cgfCB0YWlsIG9yIHNvLgpbcm9vdEBsb2NhbGhvc3QgZ2htaXRjaF0j
IG1vdW50IExBQkVMPUNPTU1PTiAvY29tbW9uCm1vdW50OiB3cm9uZyBmcyB0eXBlLCBiYWQg
b3B0aW9uLCBiYWQgc3VwZXJibG9jayBvbiAvZGV2L3NkYjQsCiAgICAgICBtaXNzaW5nIGNv
ZGVwYWdlIG9yIGhlbHBlciBwcm9ncmFtLCBvciBvdGhlciBlcnJvcgoKICAgICAgIEluIHNv
bWUgY2FzZXMgdXNlZnVsIGluZm8gaXMgZm91bmQgaW4gc3lzbG9nIC0gdHJ5CiAgICAgICBk
bWVzZyB8IHRhaWwgb3Igc28uCltyb290QGxvY2FsaG9zdCBnaG1pdGNoXSMgCg==
--------------F8F1F31727DF6213E91BFE0C--
