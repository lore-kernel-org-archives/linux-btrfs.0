Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f52.google.com ([209.85.215.52]:40289 "EHLO
        mail-lf0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751434AbeCJK1G (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 10 Mar 2018 05:27:06 -0500
Received: by mail-lf0-f52.google.com with SMTP id 37-v6so16598104lfs.7
        for <linux-btrfs@vger.kernel.org>; Sat, 10 Mar 2018 02:27:05 -0800 (PST)
Subject: Re: How to replace a failed drive in btrfs RAID 1 filesystem
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        Paul Richards <paul.richards@gmail.com>, linux-btrfs@vger.kernel.org
References: <CAMoswehA9P+JEoLmrMcWDys8t_pgNQxjvSGsk5XHhshFo+=e-Q@mail.gmail.com>
 <923562e4-7069-7541-0500-e16c302893dc@gmail.com>
From: Andrei Borzenkov <arvidjaar@gmail.com>
Message-ID: <b9c2d96c-8b06-2cf7-6d04-a70a3d41b0e3@gmail.com>
Date: Sat, 10 Mar 2018 13:27:03 +0300
MIME-Version: 1.0
In-Reply-To: <923562e4-7069-7541-0500-e16c302893dc@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

09.03.2018 19:43, Austin S. Hemmelgarn пишет:
> 
> If the answer to either one or two is no but the answer to three is yes,
> pull out the failed disk, put in a new one, mount the volume degraded,
> and use `btrfs replace` as well (you will need to specify the device ID
> for the now missing failed disk, which you can find by calling `btrfs
> filesystem show` on the volume).

I do not see it and I do not remember ever seeing device ID of missing
devices.

10:/home/bor # blkid
/dev/sda1: UUID="ce0caa57-7140-4374-8534-3443d21f3edc" TYPE="swap"
PARTUUID="d2714b67-01"
/dev/sda2: UUID="cc072e56-f671-4388-a4a0-2ffee7c98fdb"
UUID_SUB="eaeb4c78-da94-43b3-acc7-c3e963f1108d" TYPE="btrfs"
PTTYPE="dos" PARTUUID="d2714b67-02"
/dev/sdb1: UUID="e4af8f3c-8307-4397-90e3-97b90989cf5d"
UUID_SUB="f421f1e7-2bb0-4a67-a18e-cfcbd63560a8" TYPE="btrfs"
PARTUUID="875525bf-01"
10:/home/bor # mount /dev/sdb1 /mnt
mount: /mnt: wrong fs type, bad option, bad superblock on /dev/sdb1,
missing codepage or helper program, or other error.
10:/home/bor # mount -o degraded /dev/sdb1 /mnt
10:/home/bor # btrfs fi sh /mnt
Label: none  uuid: e4af8f3c-8307-4397-90e3-97b90989cf5d
	Total devices 2 FS bytes used 256.00KiB
	devid    2 size 1023.00MiB used 212.50MiB path /dev/sdb1
	*** Some devices missing

10:/home/bor # btrfs fi us /mnt
Overall:
    Device size:		   2.00GiB
    Device allocated:		 425.00MiB
    Device unallocated:		   1.58GiB
    Device missing:		1023.00MiB
    Used:			 512.00KiB
    Free (estimated):		 912.62MiB	(min: 912.62MiB)
    Data ratio:			      2.00
    Metadata ratio:		      2.00
    Global reserve:		  16.00MiB	(used: 0.00B)

Data,RAID1: Size:102.25MiB, Used:128.00KiB
   /dev/sdb1	 102.25MiB
   missing	 102.25MiB

Metadata,RAID1: Size:102.25MiB, Used:112.00KiB
   /dev/sdb1	 102.25MiB
   missing	 102.25MiB

System,RAID1: Size:8.00MiB, Used:16.00KiB
   /dev/sdb1	   8.00MiB
   missing	   8.00MiB

Unallocated:
   /dev/sdb1	 810.50MiB
   missing	 810.50MiB
10:/home/bor # rpm -q btrfsprogs
btrfsprogs-4.15-2.1.x86_64
10:/home/bor # uname -a
Linux 10 4.15.7-1-default #1 SMP PREEMPT Wed Feb 28 12:40:23 UTC 2018
(a36e160) x86_64 x86_64 x86_64 GNU/Linux
10:/home/bor #



And "missing" is not the answer because I obviously may have more than
one missing device.
