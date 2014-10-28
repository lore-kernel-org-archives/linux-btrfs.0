Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.miceliux.com ([81.4.104.92]:58216 "EHLO mx2.miceliux.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750873AbaJ1Pyb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 28 Oct 2014 11:54:31 -0400
Received: from localhost (localhost [127.0.0.1])
	by mx2.miceliux.com (Postfix) with ESMTP id C29821B6BE3
	for <linux-btrfs@vger.kernel.org>; Tue, 28 Oct 2014 16:54:21 +0100 (CET)
Received: from mx2.miceliux.com ([127.0.0.1])
	by localhost (mx2.miceliux.com [127.0.0.1]) (amavisd-new, port 10028)
	with ESMTP id rXKw6vL_oiLU for <linux-btrfs@vger.kernel.org>;
	Tue, 28 Oct 2014 16:54:20 +0100 (CET)
Received: from miceliux.com (unknown [IPv6:2a00:dcc0:dead:a8bb::1])
	(using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: juan.orti@miceliux.com)
	by mx2.miceliux.com (Postfix) with ESMTPSA id 2179C1B6BDE
	for <linux-btrfs@vger.kernel.org>; Tue, 28 Oct 2014 16:54:20 +0100 (CET)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Tue, 28 Oct 2014 16:54:19 +0100
From: Juan Orti <juan.orti@miceliux.com>
To: linux-btrfs@vger.kernel.org
Subject: Unable to fixup (regular) error in RAID1 fs
Message-ID: <a3d3305c6149a1aa5e2b3f29d76fff93@miceliux.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I'm seeing these errors in a RAID1 fs:

[ 3565.073223] BTRFS: bdev /dev/sdb2 errs: wr 0, rd 0, flush 0, corrupt 
30, gen 0
[ 3565.073472] BTRFS: unable to fixup (regular) error at logical 
460632743936 on dev /dev/sdb2
[ 3566.605419] BTRFS: checksum error at logical 461883383808 on dev 
/dev/sdb2, sector 600109712, root 2500, inode 1436631, offset 
6134886400, length 4096, links 1 (path: 
juan/.local/share/gnome-boxes/images/boxes-unknown)
[ 3566.605429] BTRFS: bdev /dev/sdb2 errs: wr 0, rd 0, flush 0, corrupt 
31, gen 0
[ 3566.629207] BTRFS: unable to fixup (regular) error at logical 
461883383808 on dev /dev/sdb2
[ 3569.459460] BTRFS: bdev /dev/sdb2 errs: wr 0, rd 0, flush 0, corrupt 
32, gen 0
[ 3569.478667] BTRFS: unable to fixup (regular) error at logical 
462282203136 on dev /dev/sdb2
[ 3569.479163] BTRFS: bdev /dev/sdb2 errs: wr 0, rd 0, flush 0, corrupt 
33, gen 0
[ 3569.479531] BTRFS: unable to fixup (regular) error at logical 
462282207232 on dev /dev/sdb2
[ 3569.479970] BTRFS: bdev /dev/sdb2 errs: wr 0, rd 0, flush 0, corrupt 
34, gen 0
[ 3569.480102] BTRFS: unable to fixup (regular) error at logical 
462282211328 on dev /dev/sdb2
[ 3569.494522] BTRFS: bdev /dev/sdb2 errs: wr 0, rd 0, flush 0, corrupt 
35, gen 0
[ 3569.494709] BTRFS: unable to fixup (regular) error at logical 
462282215424 on dev /dev/sdb2
[ 3569.495148] BTRFS: bdev /dev/sdb2 errs: wr 0, rd 0, flush 0, corrupt 
36, gen 0
[ 3713.075962] BTRFS: checksum error at logical 483011874816 on dev 
/dev/sdb2, sector 628793384, root 2500, inode 1436631, offset 
3997003776, length 4096, links 1 (path: 
juan/.local/share/gnome-boxes/images/boxes-unknown)
[ 3713.075987] BTRFS: bdev /dev/sdb2 errs: wr 0, rd 0, flush 0, corrupt 
37, gen 0
[ 3713.086292] BTRFS: unable to fixup (regular) error at logical 
483011874816 on dev /dev/sdb2
[ 3713.092577] BTRFS: checksum error at logical 483011948544 on dev 
/dev/sdb2, sector 628793528, root 2500, inode 1436631, offset 
4059963392, length 4096, links 1 (path: 
juan/.local/share/gnome-boxes/images/boxes-unknown)
[ 3713.092584] BTRFS: bdev /dev/sdb2 errs: wr 0, rd 0, flush 0, corrupt 
38, gen 0
[ 3713.093035] BTRFS: unable to fixup (regular) error at logical 
483011948544 on dev /dev/sdb2

Why can't it fix the errors? a bad device? smartctl says the disk is ok. 
I'm currently running a full scrub to see if it finds more errors. What 
should I do?

Versions used:
kernel-3.16.6-200.fc20.x86_64
btrfs-progs-3.16.2-1.fc20.x86_64

Full dmesg: http://ur1.ca/ikxxl

# btrfs fi show
Label: 'fedora_xenon'  uuid: f1c013ff-9bd4-48fe-828e-d0b7b9d91af1
         Total devices 1 FS bytes used 13.85GiB
         devid    1 size 103.22GiB used 17.04GiB path /dev/sda4

Label: 'btrfs_raid1'  uuid: 7721c28b-8ae6-432d-bfe1-0f98fb4043e0
         Total devices 3 FS bytes used 1.50TiB
         devid    1 size 1.81TiB used 1.08TiB path /dev/sdb2
         devid    2 size 1.81TiB used 1.08TiB path /dev/sdc2
         devid    3 size 1.81TiB used 1.08TiB path /dev/sdd2

# btrfs fi df /mnt/btrfs_raid1/
Data, RAID1: total=1.60TiB, used=1.49TiB
System, RAID1: total=32.00MiB, used=256.00KiB
Metadata, RAID1: total=10.00GiB, used=5.75GiB
GlobalReserve, single: total=512.00MiB, used=0.00

# btrfs fi df /mnt/btrfs_ssd/
Data, single: total=15.01GiB, used=13.13GiB
System, single: total=32.00MiB, used=16.00KiB
Metadata, single: total=2.00GiB, used=739.86MiB
GlobalReserve, single: total=256.00MiB, used=0.00

-- 
Juan Orti
https://miceliux.com

