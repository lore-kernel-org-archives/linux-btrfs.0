Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yh0-f50.google.com ([209.85.213.50]:53743 "EHLO
	mail-yh0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751273Ab3LRCKN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 Dec 2013 21:10:13 -0500
Received: by mail-yh0-f50.google.com with SMTP id b6so5057554yha.23
        for <linux-btrfs@vger.kernel.org>; Tue, 17 Dec 2013 18:10:12 -0800 (PST)
Received: from vfr.localnet (adsl-74-190-214-178.asm.bellsouth.net. [74.190.214.178])
        by mx.google.com with ESMTPSA id w8sm28105642yhg.8.2013.12.17.18.03.42
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 17 Dec 2013 18:03:42 -0800 (PST)
From: "Garry T. Williams" <gtwilliams@gmail.com>
To: linux-btrfs@vger.kernel.org
Subject: Btrfs RAID1 File System Grew Something Extra
Date: Tue, 17 Dec 2013 21:03:41 -0500
Message-ID: <1617587.38j2eTuIdt@vfr>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I have been using btrfs for my /home partition on my home machine for
a few years now.  I created the file system RAID1 using two disk
partitions.  Recently I noticed btrfs fi df shows extra Data, System,
and Metadata allocations.  And btrfs fi show indicates extra
allocations on one of my disk drives accounting for the 20 MiB
allocation in the df display.

I'm confused.  What does this mean?

    garry@vfr$ sudo btrfs subvolume list /home
    garry@vfr$ sudo btrfs filesystem df /home
    Data, RAID1: total=32.00GiB, used=21.01GiB
--> Data, single: total=8.00MiB, used=0.00
    System, RAID1: total=8.00MiB, used=12.00KiB
--> System, single: total=4.00MiB, used=0.00
    Metadata, RAID1: total=15.00GiB, used=424.60MiB
--> Metadata, single: total=8.00MiB, used=0.00
    garry@vfr$ sudo btrfs filesystem show /home
    Label: none  uuid: 6c3aeff6-9a50-4481-a175-7b98980eb638
	    Total devices 2 FS bytes used 21.43GiB
-->         devid    1 size 373.76GiB used 47.03GiB path /dev/sda4
	    devid    2 size 373.76GiB used 47.01GiB path /dev/sdb4

    Btrfs v3.12
    garry@vfr$

If it matters, I create a snapshot each night and run a rsync backup
to another drive and then delete the snapshot.

garry@vfr$ uname -r
3.11.10-200.fc19.x86_64
garry@vfr$ rpm -q btrfs-progs
btrfs-progs-3.12-1.fc19.x86_64

-- 
Garry T. Williams

