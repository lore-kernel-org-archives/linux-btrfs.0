Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f179.google.com ([209.85.213.179]:44887 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751001AbaJRBrq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 17 Oct 2014 21:47:46 -0400
Received: by mail-ig0-f179.google.com with SMTP id h18so1884254igc.0
        for <linux-btrfs@vger.kernel.org>; Fri, 17 Oct 2014 18:47:45 -0700 (PDT)
MIME-Version: 1.0
From: "Vincent." <fensoft@gmail.com>
Date: Sat, 18 Oct 2014 03:47:05 +0200
Message-ID: <CAMhgxDMxRNviq5iayuziqUiQXGzSP5cZV2qxnch-3wWLZvwNAA@mail.gmail.com>
Subject: raid10 drive replacement
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi !

I have a faulty drive in my raid10 and want it to be replaced.
Working drive are xvd[bef] and replacement drive is xvdc.

When I mount my drive in RW:
#mount -odegraded /dev/xvdb /tank
#dmesg -c
[ 6207.294513] btrfs: device fsid 728ef4d8-928c-435c-b707-f71c459e1520
devid 1 transid 551398 /dev/xvdb
[ 6207.327357] btrfs: allowing degraded mounts
[ 6207.477041] btrfs: bdev (null) errs: wr 15211054, rd 3038899, flush
0, corrupt 0, gen 0
[ 6219.703606] Btrfs: too many missing devices, writeable mount is not allowed
[ 6219.785929] btrfs: open_ctree failed

When I mount my drive in RO:
#mount -odegraded,ro /dev/xvdb /tank
#btrfs filesystem show
Label: none  uuid: 728ef4d8-928c-435c-b707-f71c459e1520
Total devices 4 FS bytes used 4.70TiB
devid    1 size 2.73TiB used 2.73TiB path /dev/xvdb
devid    2 size 2.73TiB used 2.73TiB path
devid    3 size 2.73TiB used 2.73TiB path /dev/xvde
devid    4 size 2.73TiB used 2.73TiB path /dev/xvdf

Btrfs v3.12

Of course, because my mount is in RO, i can't add device and do a balance:
#btrfs device add /dev/xvdc /tank
ERROR: error adding the device '/dev/xvdc' - Read-only file system

Neither a "replace without disk":
#btrfs replace start -Br 2 /dev/xvdc /tank
ERROR: ioctl(DEV_REPLACE_START) failed on "/tank": Read-only file
system, no error

FYI I'm on ubuntu 14.04 with btrfs 3.12

Any idea ?
Thanks !
--
fensoft
