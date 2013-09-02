Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qc0-f177.google.com ([209.85.216.177]:40217 "EHLO
	mail-qc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932194Ab3IBVrY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 2 Sep 2013 17:47:24 -0400
Received: by mail-qc0-f177.google.com with SMTP id a11so171680qcx.22
        for <linux-btrfs@vger.kernel.org>; Mon, 02 Sep 2013 14:47:24 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 2 Sep 2013 23:41:12 +0200
Message-ID: <CAD+_0YrG2ju47suCSRKta+bONwUPcjTpv1y=11rkVNqVtHHwiQ@mail.gmail.com>
Subject: Recovering from csum errors
From: Rain Maker <rainmaker52@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello list,

I was greeted by the following errors in my syslog:
Sep  2 23:06:08 laptop kernel: [ 7340.809551] btrfs: checksum error at
logical 271008116736 on dev /dev/dm-0, sector 540863448, root 442,
inode 1508, offset 10128658432, length 4096, links 1 (path:
Werkstation/Windows 8 x64-cl1.vmdk)
Sep  2 23:06:08 laptop kernel: [ 7340.809562] btrfs: bdev /dev/dm-0
errs: wr 0, rd 0, flush 0, corrupt 1, gen 0
Sep  2 23:06:08 laptop kernel: [ 7340.809565] btrfs: unable to fixup
(regular) error at logical 271008116736 on dev /dev/dm-0
Sep  2 23:06:08 laptop kernel: [ 7340.814266] btrfs: checksum error at
logical 271008120832 on dev /dev/dm-0, sector 540863456, root 442,
inode 1508, offset 10128662528, length 4096, links 1 (path:
Werkstation/Windows 8 x64-cl1.vmdk)
Sep  2 23:06:08 laptop kernel: [ 7340.814278] btrfs: bdev /dev/dm-0
errs: wr 0, rd 0, flush 0, corrupt 2, gen 0
Sep  2 23:06:08 laptop kernel: [ 7340.814283] btrfs: unable to fixup
(regular) error at logical 271008120832 on dev /dev/dm-0
Sep  2 23:06:08 laptop kernel: [ 7340.815205] btrfs: checksum error at
logical 271008124928 on dev /dev/dm-0, sector 540863464, root 442,
inode 1508, offset 10128666624, length 4096, links 1 (path:
Werkstation/Windows 8 x64-cl1.vmdk)
Sep  2 23:06:08 laptop kernel: [ 7340.815212] btrfs: bdev /dev/dm-0
errs: wr 0, rd 0, flush 0, corrupt 3, gen 0
Sep  2 23:06:08 laptop kernel: [ 7340.815214] btrfs: unable to fixup
(regular) error at logical 271008124928 on dev /dev/dm-0
Sep  2 23:06:08 laptop kernel: [ 7340.816107] btrfs: checksum error at
logical 271008129024 on dev /dev/dm-0, sector 540863472, root 442,
inode 1508, offset 10128670720, length 4096, links 1 (path:
Werkstation/Windows 8 x64-cl1.vmdk)
Sep  2 23:06:08 laptop kernel: [ 7340.816111] btrfs: bdev /dev/dm-0
errs: wr 0, rd 0, flush 0, corrupt 4, gen 0
Sep  2 23:06:08 laptop kernel: [ 7340.816113] btrfs: unable to fixup
(regular) error at logical 271008129024 on dev /dev/dm-0
Sep  2 23:06:08 laptop kernel: [ 7340.816882] btrfs: checksum error at
logical 271008133120 on dev /dev/dm-0, sector 540863480, root 442,
inode 1508, offset 10128674816, length 4096, links 1 (path:
Werkstation/Windows 8 x64-cl1.vmdk)
Sep  2 23:06:08 laptop kernel: [ 7340.816887] btrfs: bdev /dev/dm-0
errs: wr 0, rd 0, flush 0, corrupt 5, gen 0
Sep  2 23:06:08 laptop kernel: [ 7340.816889] btrfs: unable to fixup
(regular) error at logical 271008133120 on dev /dev/dm-0
Sep  2 23:06:08 laptop kernel: [ 7340.817672] btrfs: bdev /dev/dm-0
errs: wr 0, rd 0, flush 0, corrupt 6, gen 0
Sep  2 23:06:08 laptop kernel: [ 7340.817676] btrfs: unable to fixup
(regular) error at logical 271008137216 on dev /dev/dm-0

So, I ran a full scrub, and, luckily, it only found 6 csum errors
(these 6). The damage therefore seems to be contained in "just" 1
file.

Now, I removed the offending file. But is there something else I
should have done to recover the data in this file? Can it be
recovered?

I'm running 3.11-rc7. It is a single disk btrfs filesystem. I have
several subvolumes defined, one of which for VMWare Workstation (on
which the corruption took place).

I checked the SMART values, they all seem OK. The harddisks in this
machine are less then a month old. I replaced them after seeing
similar messages on the "old" disks.

Is the only logical explanation for this some kind of hardware failure
(SATA controller, power supply...), or could there be something more
to this?

Sincerely,
Roel Brook
