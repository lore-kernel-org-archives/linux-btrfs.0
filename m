Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f47.google.com ([74.125.82.47]:38097 "EHLO
	mail-wm0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753199AbcGFIH2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 Jul 2016 04:07:28 -0400
Received: by mail-wm0-f47.google.com with SMTP id r201so181863267wme.1
        for <linux-btrfs@vger.kernel.org>; Wed, 06 Jul 2016 01:07:27 -0700 (PDT)
Subject: Re: Unable to mount degraded RAID5
To: Chris Murphy <lists@colorremedies.com>
References: <cc4fd464-271c-6b32-263c-ae91c19b8712@gmail.com>
 <CAJCQCtQoCtbt5NrggHPp+WrwUKbJ0nah4s6nJ0mPnKsGQ5i63Q@mail.gmail.com>
 <95f58623-95a4-b5d2-fa3a-bfb957840a31@gmail.com>
 <CAJCQCtSczHoBYyKB1DTyqGngdvC+BHtnXeZiG=1QHWkAWFO6EA@mail.gmail.com>
 <dc944146-50ce-b2fd-189c-a2c9f5a957c3@gmail.com>
 <CAJCQCtTPXY7=9vi9Ai2VrCEHzsEj_J0gurAVH5JGLJYmKmUpPw@mail.gmail.com>
 <577B2E1D.5070808@gmail.com>
 <CAJCQCtSW+3eA-amrGgQAds1F8sYPDPgTB9x49RjWnaq=vSePgw@mail.gmail.com>
 <b9647ec5-fe9b-4bfe-97d1-329f47dbf7b0@gmail.com>
 <CAJCQCtRPhn0i0MkPn1QFr0wqovwQkuEdZ=eWtRZ0QR3O5z5T+w@mail.gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: =?UTF-8?B?VG9tw6HFoSBIcmRpbmE=?= <thomas.rkh@gmail.com>
Message-ID: <04874cd6-b043-2743-8e6e-f0ebd61400ed@gmail.com>
Date: Wed, 6 Jul 2016 10:07:23 +0200
MIME-Version: 1.0
In-Reply-To: <CAJCQCtRPhn0i0MkPn1QFr0wqovwQkuEdZ=eWtRZ0QR3O5z5T+w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Now with 3 disks:

sudo btrfs check /dev/sda
parent transid verify failed on 7008807157760 wanted 70175 found 70133
parent transid verify failed on 7008807157760 wanted 70175 found 70133
checksum verify failed on 7008807157760 found F192848C wanted 1571393A
checksum verify failed on 7008807157760 found F192848C wanted 1571393A
bytenr mismatch, want=7008807157760, have=65536
Checking filesystem on /dev/sda
UUID: 2dab74bb-fc73-4c47-a413-a55840f6f71e
checking extents
parent transid verify failed on 7009468874752 wanted 70180 found 70133
parent transid verify failed on 7009468874752 wanted 70180 found 70133
checksum verify failed on 7009468874752 found 2B10421A wanted CFF3FFAC
checksum verify failed on 7009468874752 found 2B10421A wanted CFF3FFAC
bytenr mismatch, want=7009468874752, have=65536
parent transid verify failed on 7008859045888 wanted 70175 found 70133
parent transid verify failed on 7008859045888 wanted 70175 found 70133
checksum verify failed on 7008859045888 found 7313A127 wanted 97F01C91
checksum verify failed on 7008859045888 found 7313A127 wanted 97F01C91
bytenr mismatch, want=7008859045888, have=65536
parent transid verify failed on 7008899547136 wanted 70175 found 70133
parent transid verify failed on 7008899547136 wanted 70175 found 70133
checksum verify failed on 7008899547136 found 2B6F9045 wanted CF8C2DF3
parent transid verify failed on 7008899547136 wanted 70175 found 70133
Ignoring transid failure
leaf parent key incorrect 7008899547136
bad block 7008899547136
Errors found in extent allocation tree or chunk allocation
parent transid verify failed on 7009074167808 wanted 70175 found 70133
parent transid verify failed on 7009074167808 wanted 70175 found 70133
checksum verify failed on 7009074167808 found FDA6D1F0 wanted 19456C46
checksum verify failed on 7009074167808 found FDA6D1F0 wanted 19456C46
bytenr mismatch, want=7009074167808, have=65536


sudo btrfs-debug-tree -d /dev/sdc
http://sebsauvage.net/paste/?d690b2c9d130008d#cni3fnKUZ7Y/oaXm+nsOw0afoWDFXNl26eC+vbJmcRA=
 

sudo btrfs-find-root /dev/sdc
parent transid verify failed on 7008807157760 wanted 70175 found 70133
parent transid verify failed on 7008807157760 wanted 70175 found 70133
Superblock thinks the generation is 70182
Superblock thinks the level is 1
Found tree root at 6062830010368 gen 70182 level 1
Well block 6062434418688(gen: 70181 level: 1) seems good, but
generation/level doesn't match, want gen: 70182 level: 1
Well block 6062497202176(gen: 69186 level: 0) seems good, but
generation/level doesn't match, want gen: 70182 level: 1
Well block 6062470332416(gen: 69186 level: 0) seems good, but
generation/level doesn't match, want gen: 70182 level: 1


sudo smartctl -l scterc /dev/sda
smartctl 6.5 2016-01-24 r4214 [x86_64-linux-4.4.0-24-generic] (local build)
Copyright (C) 2002-16, Bruce Allen, Christian Franke, www.smartmontools.org

SCT Error Recovery Control:
           Read: Disabled
          Write: Disabled


sudo smartctl -l scterc /dev/sdb
smartctl 6.5 2016-01-24 r4214 [x86_64-linux-4.4.0-24-generic] (local build)
Copyright (C) 2002-16, Bruce Allen, Christian Franke, www.smartmontools.org

SCT Error Recovery Control:
           Read:     70 (7.0 seconds)
          Write:     70 (7.0 seconds)


sudo smartctl -l scterc /dev/sdc
smartctl 6.5 2016-01-24 r4214 [x86_64-linux-4.4.0-24-generic] (local build)
Copyright (C) 2002-16, Bruce Allen, Christian Franke, www.smartmontools.org

SCT Error Recovery Control:
           Read: Disabled
          Write: Disabled


sudo smartcl -a /dev/sdx
http://sebsauvage.net/paste/?aab1d282ceb1e1cf#auxFRkK5GCW8j1gR7mwgzR1z92Qn9oqtc6EEC2C6sEE=


cat /sys/block/sda/device/timeout
30


cat /sys/block/sdb/device/timeout
30


cat /sys/block/sdc/device/timeout
30

Thank you
Tomas

------------------------------------------------------------------------

 *From:* Chris Murphy
 *Sent:*  Wednesday, July 06, 2016 1:19AM
 *To:* Tomáš Hrdina
*Cc:* Chris Murphy, Btrfs Btrfs
 *Subject:* Re: Unable to mount degraded RAID5

btrfs check


---
Tato zpráva byla zkontrolována na viry programem Avast Antivirus.
https://www.avast.com/antivirus

