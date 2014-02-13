Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from outrelay07.libero.it ([212.52.84.111]:43902 "EHLO
	outrelay07.libero.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750839AbaBMTSI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 13 Feb 2014 14:18:08 -0500
Message-ID: <52FD1A72.5060307@libero.it>
Date: Thu, 13 Feb 2014 20:18:10 +0100
From: Goffredo Baroncelli <kreijack@libero.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: linux-btrfs <linux-btrfs@vger.kernel.org>, Josef Bacik <jbacik@fb.com>
CC: Hugo Mills <hugo@carfax.org.uk>,
        Kostia Khlebopros <kkhlebopros@netgear.com>
Subject: [PATCH][BTRFS-PROGS][v4] Enhance btrfs fi df
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi all, 

This is the 4th attempt of my patches related to show how the data
are stored in a btrfs filesystem. I rebased all the patches on the v3.13
btrfs-progs. 

These patches update the btrfs fi df command and add two new commands:
- btrfs filesystem disk-usage <path>
- btrfs device disk-usage <path>

The command "btrfs filesystem df" now shows only the disk usage/available.

$ sudo btrfs filesystem df /mnt/btrfs1/
Disk size:		 400.00GB
Disk allocated:		   8.04GB
Disk unallocated:	 391.97GB
Used:			  11.29MB
Free (Estimated):	 250.45GB	(Max: 396.99GB, min: 201.00GB)
Data to disk ratio:	     63 %

The "Free (Estimated)" tries to give an estimation of the free space
on the basis of the chunks usage. Max and min are the maximum allowable
space (if the next chunk are allocated as SINGLE) or the minimum one (
if the next chunks are allocated as DUP/RAID1/RAID10).

The other two commands show the chunks in the disks.

$ sudo btrfs filesystem disk-usage /mnt/btrfs1/
Data,Single: Size:8.00MB, Used:0.00
   /dev/vdb	    8.00MB

Data,RAID6: Size:2.00GB, Used:11.25MB
   /dev/vdb	    1.00GB
   /dev/vdc	    1.00GB
   /dev/vdd	    1.00GB
   /dev/vde	    1.00GB

Metadata,Single: Size:8.00MB, Used:0.00
   /dev/vdb	    8.00MB

Metadata,RAID5: Size:3.00GB, Used:36.00KB
   /dev/vdb	    1.00GB
   /dev/vdc	    1.00GB
   /dev/vdd	    1.00GB
   /dev/vde	    1.00GB

System,Single: Size:4.00MB, Used:0.00
   /dev/vdb	    4.00MB

System,RAID5: Size:12.00MB, Used:4.00KB
   /dev/vdb	    4.00MB
   /dev/vdc	    4.00MB
   /dev/vdd	    4.00MB
   /dev/vde	    4.00MB

Unallocated:
   /dev/vdb	   97.98GB
   /dev/vdc	   98.00GB
   /dev/vdd	   98.00GB
   /dev/vde	   98.00GB

or in tabular format

$ sudo ./btrfs filesystem disk-usage -t /mnt/btrfs1/
         Data   Data    Metadata Metadata System System             
         Single RAID6   Single   RAID5    Single RAID5   Unallocated
                                                                    
/dev/vdb 8.00MB  1.00GB   8.00MB   1.00GB 4.00MB  4.00MB     97.98GB
/dev/vdc      -  1.00GB        -   1.00GB      -  4.00MB     98.00GB
/dev/vdd      -  1.00GB        -   1.00GB      -  4.00MB     98.00GB
/dev/vde      -  1.00GB        -   1.00GB      -  4.00MB     98.00GB
         ====== ======= ======== ======== ====== ======= ===========
Total    8.00MB  2.00GB   8.00MB   3.00GB 4.00MB 12.00MB    391.97GB
Used       0.00 11.25MB     0.00  36.00KB   0.00  4.00KB            

These are the most complete output, where it is possible to know which
disk a chunk uses and the usage of every chunk.

Finally the last command shows which chunks a disk hosts:

$ sudo ./btrfs device disk-usage /mnt/btrfs1/
/dev/vdb	  100.00GB
   Data,Single:              8.00MB
   Data,RAID6:               1.00GB
   Metadata,Single:          8.00MB
   Metadata,RAID5:           1.00GB
   System,Single:            4.00MB
   System,RAID5:             4.00MB
   Unallocated:             97.98GB

/dev/vdc	  100.00GB
   Data,RAID6:               1.00GB
   Metadata,RAID5:           1.00GB
   System,RAID5:             4.00MB
   Unallocated:             98.00GB

/dev/vdd	  100.00GB
   Data,RAID6:               1.00GB
   Metadata,RAID5:           1.00GB
   System,RAID5:             4.00MB
   Unallocated:             98.00GB

/dev/vde	  100.00GB
   Data,RAID6:               1.00GB
   Metadata,RAID5:           1.00GB
   System,RAID5:             4.00MB
   Unallocated:             98.00GB

More or less are the same information above, only grouped by disk.
Unfortunately I don't have any information about the chunk usage per disk basis.

Comments are welcome.
The code is pullable from
        https://github.com/kreijack/btrfs-progs.git
branch
        dfdu

Finally I have to point out that the command btrfs fi df previous didn't require 
the root capability, now with my patches it is required, because I need 
to know some info about the chunks so I need to use the 
"BTRFS_IOC_TREE_SEARCH".

I think that there are the following possibilities:
1) accept this regresssion
2) remove the command "btrfs fi df" and leave only "btrfs fi disk-usage" and
   "btrfs dev disk-usage"
3) adding a new ioctl which could be used without root capability. Of course
   this ioctl would return only a subset of the BTRFS_IOC_TREE_SEARCH info

I think that the 3) would be the "long term" solution. I am not happy about
the 1), so as "short term solution" I think that we should go with the 2).
What do you think ?

Below the description of the patches.

--


BR
G.Baroncelli

Changelog:
v1 2013/02/18 First issue
v2 2013/02/23 Fix uncorrct "not enough memory" handling in patch #1.
              Thanks to Zac to highlight it.
v3 2013/03/10 - Rebased on the latest mason git repository
              - Small fix in the comment
              - Increase the buffer in the function df_pretty_sizes() to
		avoid buffer pverwflow (thanks to Zach to highlight it)
	      - adding the sla_pretty_sizes() function to remove the call
	        of string_list_add() from df_pretty_sizes.
v4 2014/02/13 - Rebased to v3.12
              - Replace MB/GB/TB with MiB/GiB/TiB
              - correct some small bug related to mixing same raid level
                with different disk number
              -removing the string_list_add() function




-- 
gpg @keyserver.linux.it: Goffredo Baroncelli (kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
