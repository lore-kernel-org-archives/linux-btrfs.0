Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f45.google.com ([74.125.82.45]:36824 "EHLO
	mail-wm0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751181AbcDLKZG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Apr 2016 06:25:06 -0400
Received: by mail-wm0-f45.google.com with SMTP id v188so120898008wme.1
        for <linux-btrfs@vger.kernel.org>; Tue, 12 Apr 2016 03:25:01 -0700 (PDT)
Received: from [134.171.70.22] ([134.171.70.22])
        by smtp.googlemail.com with ESMTPSA id q62sm22155782wmg.12.2016.04.12.03.24.59
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1/SSLv3 cipher=OTHER);
        Tue, 12 Apr 2016 03:24:59 -0700 (PDT)
To: linux-btrfs@vger.kernel.org
From: Julian Taylor <jtaylor.debian@googlemail.com>
Subject: enospace regression in 4.4
Message-ID: <570CCCFB.5000104@googlemail.com>
Date: Tue, 12 Apr 2016 12:24:59 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

hi,
I have a system with two filesystems which are both affected by the
notorious enospace bug when there is plenty of unallocated space
available. The system is a raid0 on two 900 GiB disks and an iscsi
single/dup 1.4TiB.
To deal with the problem I use a cronjob that uses fallocate to give me
an advance notice on the issue so I can apply the only workaround that
works for me, which is shrink the fs to the minimum and grow it again.
This has worked fine for a couple of month.

I now updated from 4.2 to 4.4.6 and it appears my cronjob actually
triggers an immediate enospc in the balance after removing the
fallocated file and the shrink/resize workaround does not work anymore.
it is mounted with enospc_debug but that just says "2 enospc in
balance". Nothing else useful in the log.

I had to revert back to 4.2 to get the system running again so it is
currently not available for more testing, but I may be able to do more
tests if required in future.

The cronjob does this once a day:

#!/bin/bash
sync

check() {
  date
  mnt=$1
  time btrfs fi balance start -mlimit=2 $mnt
  btrfs fi balance start -dusage=5 $mnt
  sync
  freespace=$(df -B1 $mnt | tail -n 1 | awk '{print $4 -
50*1024*1024*1024}')
  fallocate -l $freespace $mnt/falloc
  /usr/sbin/filefrag $mnt/falloc
  rm -f $mnt/falloc
  btrfs fi balance start -dusage=0 $mnt

  time btrfs fi balance start -mlimit=2 $mnt
  time btrfs fi balance start -dlimit=10 $mnt
  date
}

check /data
check /data/nas


btrfs info:


 ~ $ btrfs --version
btrfs-progs v4.4
sagan5 ~ $ sudo btrfs fi show
Label: none  uuid: e4aef349-7a56-4287-93b1-79233e016aae
	Total devices 2 FS bytes used 898.18GiB
	devid    1 size 880.00GiB used 473.03GiB path /dev/mapper/data-linear1
	devid    2 size 880.00GiB used 473.03GiB path /dev/mapper/data-linear2

Label: none  uuid: 14040f9b-53c8-46cf-be6b-35de746c3153
	Total devices 1 FS bytes used 557.19GiB
	devid    1 size 1.36TiB used 585.95GiB path /dev/sdd

 ~ $ sudo btrfs fi df /data
Data, RAID0: total=938.00GiB, used=895.09GiB
System, RAID1: total=32.00MiB, used=112.00KiB
Metadata, RAID1: total=4.00GiB, used=3.10GiB
GlobalReserve, single: total=512.00MiB, used=0.00B
sagan5 ~ $ sudo btrfs fi usage /data
Overall:
    Device size:		   1.72TiB
    Device allocated:		 946.06GiB
    Device unallocated:		 813.94GiB
    Device missing:		     0.00B
    Used:			 901.27GiB
    Free (estimated):		 856.85GiB	(min: 449.88GiB)
    Data ratio:			      1.00
    Metadata ratio:		      2.00
    Global reserve:		 512.00MiB	(used: 0.00B)

Data,RAID0: Size:938.00GiB, Used:895.09GiB
   /dev/dm-1	 469.00GiB
   /dev/mapper/data-linear1	 469.00GiB

Metadata,RAID1: Size:4.00GiB, Used:3.09GiB
   /dev/dm-1	   4.00GiB
   /dev/mapper/data-linear1	   4.00GiB

System,RAID1: Size:32.00MiB, Used:112.00KiB
   /dev/dm-1	  32.00MiB
   /dev/mapper/data-linear1	  32.00MiB

Unallocated:
   /dev/dm-1	 406.97GiB
   /dev/mapper/data-linear1	 406.97GiB
