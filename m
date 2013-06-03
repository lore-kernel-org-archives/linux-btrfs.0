Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f53.google.com ([209.85.160.53]:63813 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755323Ab3FCCFF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 2 Jun 2013 22:05:05 -0400
Received: by mail-pb0-f53.google.com with SMTP id un4so4912015pbc.26
        for <linux-btrfs@vger.kernel.org>; Sun, 02 Jun 2013 19:05:04 -0700 (PDT)
MIME-Version: 1.0
Date: Sun, 2 Jun 2013 21:05:03 -0500
Message-ID: <CAOMROUjkcZGC-OwkPdJvyx6KknpAeEA0jp3bkh=GF8zpS2mb9g@mail.gmail.com>
Subject: csum failed during rebalance
From: John Haller <john.h.haller@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I added a new drive to an existing RAID 0 array. Every
attempt to rebalance the array fails:
# btrfs filesystem balance /share/bd8
ERROR: error during balancing '/share/bd8' - Input/output error
# dmesg | tail
btrfs: found 1 extents
btrfs: relocating block group 10752513540096 flags 1
btrfs: found 5 extents
btrfs: found 5 extents
btrfs: relocating block group 10751439798272 flags 1
btrfs: found 1 extents
btrfs: found 1 extents
btrfs: relocating block group 10048138903552 flags 1
btrfs csum failed ino 365 off 221745152 csum 3391451932 private 3121065028
btrfs csum failed ino 365 off 221745152 csum 3391451932 private 3121065028

An earlier rebalance attempt had the same csum error on a different inode:
btrfs csum failed ino 312 off 221745152 csum 3391451932 private 3121065028
btrfs csum failed ino 312 off 221745152 csum 3391451932 private 3121065028

Every rebalance attempt fails the same way, but with a different inum.

Here is the array:
# btrfs filesystem show
Label: 'bd8'  uuid: b39f475f-3ebf-40ea-b088-4ce7f4d4d8f4
        Total devices 4 FS bytes used 7.37TB
        devid    4 size 3.64TB used 52.00GB path /dev/sde
        devid    1 size 3.64TB used 3.32TB path /dev/sdf1
        devid    3 size 3.64TB used 2.92TB path /dev/sdc
        devid    2 size 3.64TB used 2.97TB path /dev/sdb

While I didn't finish the scrub, no errors were found:
# btrfs scrub status -d /share/bd8
scrub status for b39f475f-3ebf-40ea-b088-4ce7f4d4d8f4
scrub device /dev/sdf1 (id 1) status
        scrub resumed at Sun Jun  2 20:29:06 2013, running for 10360 seconds
        total bytes scrubbed: 845.53GB with 0 errors
scrub device /dev/sdb (id 2) status
        scrub resumed at Sun Jun  2 20:29:06 2013, running for 10360 seconds
        total bytes scrubbed: 869.38GB with 0 errors
scrub device /dev/sdc (id 3) status
        scrub resumed at Sun Jun  2 20:29:06 2013, running for 10360 seconds
        total bytes scrubbed: 706.04GB with 0 errors
scrub device /dev/sde (id 4) history
        scrub started at Sun Jun  2 12:48:36 2013 and finished after 0 seconds
        total bytes scrubbed: 0.00 with 0 errors

Mount options:
/dev/sdf1 on /share/bd8 type btrfs (rw,flushoncommit)

Kernel 3.9.4

John
