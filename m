Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:49305 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750815AbdEFKdW (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 6 May 2017 06:33:22 -0400
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id 9626520AC3
        for <linux-btrfs@vger.kernel.org>; Sat,  6 May 2017 06:33:21 -0400 (EDT)
Received: from [192.168.1.63] (cm-171-100-83-117.revip10.asianet.co.th [171.100.83.117])
        by mail.messagingengine.com (Postfix) with ESMTPA id C04E27E98D
        for <linux-btrfs@vger.kernel.org>; Sat,  6 May 2017 06:33:20 -0400 (EDT)
To: linux-btrfs@vger.kernel.org
From: Tom Hale <tom@hale.ee>
Subject: "Corrected" errors persist after scrubbing
Message-ID: <92b9b7cd-5b54-775f-95c1-4788b2d3ea67@hale.ee>
Date: Sat, 6 May 2017 17:33:17 +0700
MIME-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------6401CCCDE64345D770715A41"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a multi-part message in MIME format.
--------------6401CCCDE64345D770715A41
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit

Below (and also attached because of formatting) is an example of `btrfs
scrub` incorrectly reporting that errors have been corrected.

In this example, /dev/md127 is the device created by running:
mdadm --build /dev/md0 --level=faulty --raid-devices=1 /dev/loop0

The filesystem is RAID1.

# mdadm --grow /dev/md0 --layout=rp400
layout for /dev/md0 set to 12803
# btrfs scrub start -Bd /mnt/tmp
scrub device /dev/md127 (id 1) done
        scrub started at Fri May  5 19:23:54 2017 and finished after
00:00:01
        total bytes scrubbed: 200.47MiB with 8 errors
        error details: read=8
        corrected errors: 8, uncorrectable errors: 0, unverified errors: 248
scrub device /dev/loop1 (id 2) done
        scrub started at Fri May  5 19:23:54 2017 and finished after
00:00:01
        total bytes scrubbed: 200.47MiB with 0 errors
WARNING: errors detected during scrubbing, corrected
# ### But the errors haven't really been corrected, they're still there:
# mdadm --grow /dev/md0 --layout=clear # Stop producing additional errors
layout for /dev/md0 set to 31
# btrfs scrub start -Bd /mnt/tmp
scrub device /dev/md127 (id 1) done
        scrub started at Fri May  5 19:24:24 2017 and finished after
00:00:00
        total bytes scrubbed: 200.47MiB with 8 errors
        error details: read=8
        corrected errors: 8, uncorrectable errors: 0, unverified errors: 248
scrub device /dev/loop1 (id 2) done
        scrub started at Fri May  5 19:24:24 2017 and finished after
00:00:00
        total bytes scrubbed: 200.47MiB with 0 errors
WARNING: errors detected during scrubbing, corrected
#

Since scrub is checking for read issues, I expect that it would read any
corrections before asserting that they have indeed been corrected.

I understand that HDDs have a pool of non-LBA-addressable sectors set
aside to mask bad physical sectors, but this pool size is fixed by the
manufacturer (who makes money from sales of new drives).

However, I don't believe it is sufficient to blindly trust that the
underlying  HDD still has spare reallocatable sectors or that the
hardware will always correctly write data, given the verification and
fixing intention of scrub.

At a minimum, shouldn't these 8 "corrected errors" be listed as
"uncorrectable errors" to inform the sysadmin that data integrity has
degraded (e.g. in this RAID1 example the data is no longer duplicated)?

Ideally, I would hope that the blocks with uncorrectable errors are
marked as bad and fresh blocks are used to maintain integrity.

-- 
Regards,

Tom Hale

--------------6401CCCDE64345D770715A41
Content-Type: text/plain; charset=UTF-8;
 name="btrfs-scrub"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="btrfs-scrub"

IyBtZGFkbSAtLWdyb3cgL2Rldi9tZDAgLS1sYXlvdXQ9cnA0MDAKbGF5b3V0IGZvciAvZGV2
L21kMCBzZXQgdG8gMTI4MDMKIyBidHJmcyBzY3J1YiBzdGFydCAtQmQgL21udC90bXAKc2Ny
dWIgZGV2aWNlIC9kZXYvbWQxMjcgKGlkIDEpIGRvbmUKICAgICAgICBzY3J1YiBzdGFydGVk
IGF0IEZyaSBNYXkgIDUgMTk6MjM6NTQgMjAxNyBhbmQgZmluaXNoZWQgYWZ0ZXIgMDA6MDA6
MDEKICAgICAgICB0b3RhbCBieXRlcyBzY3J1YmJlZDogMjAwLjQ3TWlCIHdpdGggOCBlcnJv
cnMKICAgICAgICBlcnJvciBkZXRhaWxzOiByZWFkPTgKICAgICAgICBjb3JyZWN0ZWQgZXJy
b3JzOiA4LCB1bmNvcnJlY3RhYmxlIGVycm9yczogMCwgdW52ZXJpZmllZCBlcnJvcnM6IDI0
OApzY3J1YiBkZXZpY2UgL2Rldi9sb29wMSAoaWQgMikgZG9uZQogICAgICAgIHNjcnViIHN0
YXJ0ZWQgYXQgRnJpIE1heSAgNSAxOToyMzo1NCAyMDE3IGFuZCBmaW5pc2hlZCBhZnRlciAw
MDowMDowMQogICAgICAgIHRvdGFsIGJ5dGVzIHNjcnViYmVkOiAyMDAuNDdNaUIgd2l0aCAw
IGVycm9ycwpXQVJOSU5HOiBlcnJvcnMgZGV0ZWN0ZWQgZHVyaW5nIHNjcnViYmluZywgY29y
cmVjdGVkCiMgIyMjIEJ1dCB0aGUgZXJyb3JzIGhhdmVuJ3QgcmVhbGx5IGJlZW4gY29ycmVj
dGVkLCB0aGV5J3JlIHN0aWxsIHRoZXJlOgojIG1kYWRtIC0tZ3JvdyAvZGV2L21kMCAtLWxh
eW91dD1jbGVhciAjIFN0b3AgcHJvZHVjaW5nIGFkZGl0aW9uYWwgZXJyb3JzCmxheW91dCBm
b3IgL2Rldi9tZDAgc2V0IHRvIDMxCiMgYnRyZnMgc2NydWIgc3RhcnQgLUJkIC9tbnQvdG1w
CnNjcnViIGRldmljZSAvZGV2L21kMTI3IChpZCAxKSBkb25lCiAgICAgICAgc2NydWIgc3Rh
cnRlZCBhdCBGcmkgTWF5ICA1IDE5OjI0OjI0IDIwMTcgYW5kIGZpbmlzaGVkIGFmdGVyIDAw
OjAwOjAwCiAgICAgICAgdG90YWwgYnl0ZXMgc2NydWJiZWQ6IDIwMC40N01pQiB3aXRoIDgg
ZXJyb3JzCiAgICAgICAgZXJyb3IgZGV0YWlsczogcmVhZD04CiAgICAgICAgY29ycmVjdGVk
IGVycm9yczogOCwgdW5jb3JyZWN0YWJsZSBlcnJvcnM6IDAsIHVudmVyaWZpZWQgZXJyb3Jz
OiAyNDgKc2NydWIgZGV2aWNlIC9kZXYvbG9vcDEgKGlkIDIpIGRvbmUKICAgICAgICBzY3J1
YiBzdGFydGVkIGF0IEZyaSBNYXkgIDUgMTk6MjQ6MjQgMjAxNyBhbmQgZmluaXNoZWQgYWZ0
ZXIgMDA6MDA6MDAKICAgICAgICB0b3RhbCBieXRlcyBzY3J1YmJlZDogMjAwLjQ3TWlCIHdp
dGggMCBlcnJvcnMKV0FSTklORzogZXJyb3JzIGRldGVjdGVkIGR1cmluZyBzY3J1YmJpbmcs
IGNvcnJlY3RlZAojCg==
--------------6401CCCDE64345D770715A41--
