Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from nm24-vm5.bullet.mail.ird.yahoo.com ([212.82.109.196]:33653 "HELO
	nm24-vm5.bullet.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751319Ab3CJMQ2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 10 Mar 2013 08:16:28 -0400
From: Goffredo Baroncelli <goffredo.baroncelli@yahoo.com>
To: linux-btrfs@vger.kernel.org
Cc: Hugo Mills <hugo@carfax.org.uk>,
        Michael =?utf-8?q?Kj=C3=B6rling?= <michael@kjorling.se>,
        Martin Steigerwald <Martin@lichtvoll.de>, cwillu <cwillu@cwillu.com>,
        Chris Murphy <lists@colorremedies.com>, David Sterba <dsterba@suse.cz>,
        Zach Brown <zab@zabbo.net>
Subject: [PATCH V3][BTRFS-PROGS] Enhance btrfs fi df with raid5/6 support
Date: Sun, 10 Mar 2013 13:17:31 +0100
Message-Id: <1362917859-18824-1-git-send-email-goffredo.baroncelli@yahoo.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi all, 

This is the third attempt of my patches related to show how the data
are stored in a btrfs filesystem. I rebased all the patches on the latest
mason git. I tried to address the Zach concern abou the using of
the string_list_add() in the df_pretty_sizes(): string_list_add() is
removed from the df_pretty_sizes() and I created the new function 
sla_pretty_sizes() which calls df_pretty_sizes() and string_list_add().

Unfortunately I noticed a regression which passed all the reviews until now:
the command btrfs fi df previous didn't require the root capability,
now with my patches it is required, because I need to know some info
about the chunks so I need to use the "BTRFS_IOC_TREE_SEARCH".

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
        http://cassiopea.homelinux.net/git/btrfs-progs-unstable.git
branch
        df-du-raid56

BR
G.Baroncelli

[1] http://permalink.gmane.org/gmane.comp.file-systems.btrfs/21071

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



