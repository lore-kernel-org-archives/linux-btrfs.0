Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qc0-f170.google.com ([209.85.216.170]:35843 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752512AbbCEWEU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 5 Mar 2015 17:04:20 -0500
Received: by qcxn11 with SMTP id n11so24245810qcx.3
        for <linux-btrfs@vger.kernel.org>; Thu, 05 Mar 2015 14:04:19 -0800 (PST)
Received: from mail-qc0-f171.google.com (mail-qc0-f171.google.com. [209.85.216.171])
        by mx.google.com with ESMTPSA id f131sm3402006qka.40.2015.03.05.14.04.18
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 05 Mar 2015 14:04:18 -0800 (PST)
From: Sandy McArthur Jr <sandy@mcarthur.org>
Received: by qcxr5 with SMTP id r5so46323377qcx.10
        for <linux-btrfs@vger.kernel.org>; Thu, 05 Mar 2015 14:04:18 -0800 (PST)
MIME-Version: 1.0
Date: Thu, 5 Mar 2015 17:04:18 -0500
Message-ID: <CAPs0BiibA5CmL8QOyUR67oLG_3Za+KfPT16eTo75u-L_z1k4VQ@mail.gmail.com>
Subject: Occasional read error on idle USB attached disk
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I have a btrfs filesystem that gets read errors that appear to only
happen after a disk has been idle a while. I don't know if the error
output below is BTRFS, USB, both or other related. I suspect it's
timing related. If I should take this error report somewhere else,
please point me in the right direction.

I have a large RAID1 btrfs filesystem (>13TB) that provides
archive/backup space that is housed in a multi-drive USB enclosures
comprising of WD Red drives. I noticed errors in dmesg, so I'd run a
`btrfs scrub` and for two days it'd report zero errors. Within hours
of the scrub completing I'd start seeing "csum failed ino" or other
errors again. Not wanting to run a btrfs scrub 24/7 as it impacts load
and available I/O I thought of a crude workaround...

My workaround is every minute cron runs the unfortunate script below
which is my hack to create some minimal random activity and this has
had the effect of eliminating btrfs errors in dmesg since I installed
it ~5 days ago.

#!/bin/bash
for dev in /dev/disk/by-path/*-usb-*
do
 dd "if=$dev" skip=$RANDOM of=/dev/null bs=1k count=1 conv=noerror
 sleep 1
done

Also: I have used `idle3ctl -d` on every WD drive to configure them
not to idle spin down.

I'd like to eliminate the need for script above but I don't know what
to look into for more insight.


Below are examples of errors in dmesg output that I believe to be from
after an idle time.

[Thu Feb 26 21:14:53 2015] sd 6:0:0:6: [sdh]
[Thu Feb 26 21:14:53 2015] Result: hostbyte=0x00 driverbyte=0x08
[Thu Feb 26 21:14:53 2015] sd 6:0:0:6: [sdh]
[Thu Feb 26 21:14:53 2015] Sense Key : 0x5 [current]
[Thu Feb 26 21:14:53 2015] sd 6:0:0:6: [sdh]
[Thu Feb 26 21:14:53 2015] ASC=0x21 ASCQ=0x0
[Thu Feb 26 21:14:53 2015] sd 6:0:0:6: [sdh] CDB:
[Thu Feb 26 21:14:53 2015] cdb[0]=0x88: 88 00 00 00 00 01 62 a6 b2 10
00 00 00 08 00 00
[Thu Feb 26 21:14:53 2015] blk_update_request: critical target error,
dev sdh, sector 5950059024
[Thu Feb 26 21:14:53 2015] BTRFS: bdev /dev/sdh1 errs: wr 0, rd 1,
flush 0, corrupt 0, gen 0
[Thu Feb 26 21:14:53 2015] BTRFS: read error corrected: ino 1 off
44992282501120 (dev /dev/sdh1 sector 5950056976)

[Thu Feb 26 22:45:22 2015] __readpage_endio_check: 18 callbacks suppressed
[Thu Feb 26 22:45:22 2015] BTRFS info (device sdj1): csum failed ino
6367 off 950272 csum 1607841533 expected csum 1974928297
[Thu Feb 26 22:45:55 2015] BTRFS info (device sdj1): csum failed ino
6367 off 950272 csum 3541269260 expected csum 1974928297
[Thu Feb 26 22:45:55 2015] BTRFS: read error corrected: ino 6367 off
950272 (dev /dev/sdn1 sector 5100129584)

[Thu Feb 26 23:03:27 2015] __readpage_endio_check: 19 callbacks suppressed
[Thu Feb 26 23:03:27 2015] BTRFS info (device sdj1): csum failed ino
59095 off 262144 csum 343380379 expected csum 1424044590
[Thu Feb 26 23:03:27 2015] BTRFS info (device sdj1): csum failed ino
59095 off 315392 csum 1424678262 expected csum 2679854845
[Thu Feb 26 23:03:27 2015] BTRFS info (device sdj1): csum failed ino
59095 off 266240 csum 2640353180 expected csum 3029459156
[Thu Feb 26 23:03:27 2015] BTRFS info (device sdj1): csum failed ino
59095 off 319488 csum 2451256998 expected csum 2468347880
[Thu Feb 26 23:03:27 2015] BTRFS info (device sdj1): csum failed ino
59095 off 270336 csum 345966290 expected csum 2742069942
[Thu Feb 26 23:03:27 2015] BTRFS info (device sdj1): csum failed ino
59095 off 323584 csum 3197427733 expected csum 85045692
[Thu Feb 26 23:03:27 2015] BTRFS info (device sdj1): csum failed ino
59095 off 274432 csum 471582907 expected csum 2556165357
[Thu Feb 26 23:03:27 2015] BTRFS info (device sdj1): csum failed ino
59095 off 327680 csum 2709949441 expected csum 2084817183
[Thu Feb 26 23:03:27 2015] BTRFS info (device sdj1): csum failed ino
59095 off 278528 csum 1074665437 expected csum 3742172546
[Thu Feb 26 23:03:27 2015] BTRFS info (device sdj1): csum failed ino
59095 off 331776 csum 960121098 expected csum 1047166743

[Sat Feb 28 22:37:27 2015] BTRFS (device sdj1): bad tree block start
16702985684700295141 44148565934080
[Sat Feb 28 22:38:28 2015] BTRFS (device sdj1): bad tree block start
18405645867681351400 44148565934080
[Sat Feb 28 22:47:37 2015] BTRFS (device sdj1): bad tree block start
9667861177667953406 37828540731392
[Sat Feb 28 22:48:29 2015] BTRFS (device sdj1): bad tree block start
13145213771949975882 37828540731392
[Sat Feb 28 23:07:42 2015] BTRFS (device sdj1): bad tree block start
3229042711727727555 37828408807424
[Sat Feb 28 23:08:43 2015] BTRFS (device sdj1): bad tree block start
10868841450782383314 37828408807424
[Sat Feb 28 23:17:45 2015] BTRFS (device sdj1): bad tree block start
7898245970193992494 38304904036352
[Sat Feb 28 23:18:46 2015] BTRFS (device sdj1): bad tree block start
11326950486664265401 38304904036352
[Sat Feb 28 23:47:49 2015] BTRFS (device sdj1): bad tree block start
8268695429503799068 44148995371008
[Sat Feb 28 23:47:49 2015] BTRFS: read error corrected: ino 1 off
44148995371008 (dev /dev/sdl1 sector 1641660376)

# btrfs --version
Btrfs v3.18.2

# uname -a
Linux mcplex 3.18.4-gentoo #1 SMP Wed Jan 28 22:25:43 EST 2015 x86_64
Intel(R) Core(TM) i7-2600S CPU @ 2.80GHz GenuineIntel GNU/Linux

-- 
Sandy McArthur, Jr.

"No nation could preserve its freedom in the midst of continual warfare."
- Letters and Other Writings of James Madison (1865), Vol. IV, p. 491
