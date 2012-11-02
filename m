Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:48646 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932906Ab2KBKO5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 2 Nov 2012 06:14:57 -0400
Received: by mail-ee0-f46.google.com with SMTP id b15so1719880eek.19
        for <linux-btrfs@vger.kernel.org>; Fri, 02 Nov 2012 03:14:56 -0700 (PDT)
From: Goffredo Baroncelli <kreijack@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Hugo Mills <hugo@carfax.org.uk>,
        Michael =?utf-8?q?Kj=C3=B6rling?= <michael@kjorling.se>,
        Martin Steigerwald <Martin@lichtvoll.de>, cwillu <cwillu@cwillu.com>,
        Chris Murphy <lists@colorremedies.com>
Subject: [PATCH][BTRFS-PROGS] Enhance btrfs fi df
Date: Fri,  2 Nov 2012 11:15:31 +0100
Message-Id: <1351851339-19150-1-git-send-email-kreijack@inwind.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi all, on the basis of the discussion in the thread 
'[RFC] New attempt to a better "btrfs fi df"', I prepared the following
set of patches.
These patches update the btrfs fi df command and add two new commands:
- btrfs filesystem disk-usage <path>
- btrfs device disk-usage <path>

The command "btrfs filesystem df" now shows only the disk usage/available.

$ btrfs filesystem df /mnt/btrfs1/
Disk size:		 109.00GB
Disk allocated:		   5.90GB
Disk unallocated:	 103.10GB
Used:			 284.00KB
Free (Estimated):	  63.00GB	(Max: 106.51GB, min: 54.96GB)
Data to disk ratio:	     58 %

This was the "Summary" section of the my first attempt to enhance this
command.
The "Free (Estimated)" try to give an estimation of the free space
on the basis of the chunks usage.

The other two commands show the relation between the chunks and the disks.

$ sudo ./btrfs filesystem disk-usage /mnt/btrfs1/
Data,Single: Size:8.00MB, Used:0.00
   /dev/vdb	    8.00MB

Data,RAID0: Size:921.75MB, Used:256.00KB
   /dev/vdb	  307.25MB
   /dev/vdc	  307.25MB
   /dev/vdd	  307.25MB

Metadata,Single: Size:8.00MB, Used:0.00
   /dev/vdb	    8.00MB

Metadata,RAID1: Size:2.45GB, Used:24.00KB
   /dev/vdb	    1.45GB
   /dev/vdc	    1.00GB
   /dev/vdd	  460.94MB
   /dev/vdi	    2.00GB

System,Single: Size:4.00MB, Used:0.00
   /dev/vdb	    4.00MB

System,RAID1: Size:40.00MB, Used:4.00KB
   /dev/vdc	   40.00MB
   /dev/vdd	   40.00MB

Unallocated:
   /dev/vdb	    1.23GB
   /dev/vdc	    1.66GB
   /dev/vdd	    2.21GB
   /dev/vdi	   98.00GB

or in tabular format

$ sudo ./btrfs filesystem disk-usage -t /mnt/btrfs1/
         Data   Data     Metadata Metadata System System             
         Single RAID0    Single   RAID1    Single RAID1   Unallocated
                                                                     
/dev/vdb 8.00MB 307.25MB   8.00MB   1.45GB 4.00MB       -      1.23GB
/dev/vdc      - 307.25MB        -   1.00GB      - 40.00MB      1.66GB
/dev/vdd      - 307.25MB        - 460.94MB      - 40.00MB      2.21GB
/dev/vdi      -        -        -   2.00GB      -       -     98.00GB
         ====== ======== ======== ======== ====== ======= ===========
Total    8.00MB 921.75MB   8.00MB   2.45GB 4.00MB 40.00MB    103.10GB
Used       0.00 256.00KB     0.00  24.00KB   0.00  4.00KB


These are the most complete output, where it is possible to know which
disk a chunk uses and the usage of every chunk.

Finally the last command show which chunks a disk hosts:

$ sudo ./btrfs device disk-usage /mnt/btrfs1/
/dev/vdb	    3.00GB
   Data,Single:              8.00MB
   Data,RAID0:             307.25MB
   Metadata,Single:          8.00MB
   Metadata,RAID1:           1.45GB
   System,Single:            4.00MB
   Unallocated:              1.23GB

/dev/vdc	    3.00GB
   Data,RAID0:             307.25MB
   Metadata,RAID1:           1.00GB
   System,RAID1:            40.00MB
   Unallocated:              1.66GB

/dev/vdd	    3.00GB
   Data,RAID0:             307.25MB
   Metadata,RAID1:         460.94MB
   System,RAID1:            40.00MB
   Unallocated:              2.21GB

/dev/vdi	  100.00GB
   Metadata,RAID1:           2.00GB
   Unallocated:             98.00GB

More or less are the same information above, only grouped by disk.
Unfortunately I don't have any information on the chunk usage per disk basis.

Comments are welcome.
The code is pullable from
        http://cassiopea.homelinux.net/git/btrfs-progs-unstable.git
branch
        info-cmd

--
gpg @keyserver.linux.it: Goffredo Baroncelli (kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5

