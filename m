Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:46480 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753417Ab2J0Qn6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 27 Oct 2012 12:43:58 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: linux-btrfs@vger.kernel.org, "kreijack@inwind.it" <kreijack@inwind.it>
Subject: Re: [RFC] New attempt to a better "btrfs fi df"
Date: Sat, 27 Oct 2012 18:43:40 +0200
References: <50899151.1070503@inwind.it> (sfid-20121026_011035_692410_A53EF7F2)
In-Reply-To: <50899151.1070503@inwind.it>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201210271843.40540.Martin@lichtvoll.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Donnerstag, 25. Oktober 2012 schrieb Goffredo Baroncelli:
> Hi all,
> 
> this is a new attempt to improve the output of the command "btrfs fi
> df".
> 
> The previous attempt received a good reception. However there was no a
> general consensus about the wording.
> 
> Moreover I still didn't understand how btrfs was using the disks.
> A my first attempt was to develop a new command which shows how the
> disks are divided in chunks. However it still was no clear. Then I
> realised that I need to merge the two output.
> 
> Below the results. It shows how the disks is used by the different
> chunks.
> 
> The code is pullable from
>         http://cassiopea.homelinux.net/git/btrfs-progs-unstable.git
> branch
>         info-cmd
> 
> I don't publish the patched because aren't in a good shape. However I
> really like the output. The example is a filesystem based on three
> disks of 3GB.
> 
> It is clear that:
> - RAID0 uses all the disks
> - RAID1 uses two different disks
> 
> Comments are welcome.
> 
> Known bugs:
> - if a filesystem uses a disk but there is any chunk, the disk is not
> shown (solvable)
> - this command need root capability (I use the BTRFS_IOC_TREE_SEARCH
> to get the chunk info; so that is unavoidable)
> 
> 
> ghigo@emulato:~$ sudo ./btrfs fi df /mnt/btrfs1/
> [sudo] password for ghigo:
> Path: /mnt/btrfs1
> Summary:
>   Disk_size:		   9.00GB
>   Disk_allocated:	   1.83GB
>   Disk_unallocated:	   7.17GB
>   Used:			 284.00KB
>   Free_(Estimated):	   6.76GB	(Max: 8.54GB, min: 4.96GB)
>   Data_to_disk_ratio:	     75 %
> 
> Allocated_area:
>   Data,RAID0: Size:921.75MB, Used:256.00KB
>      /dev/vdc	  307.25MB
>      /dev/vdb	  307.25MB
>      /dev/vdd	  307.25MB
> 
>   Data,Single: Size:8.00MB, Used:0.00
>      /dev/vdb	    8.00MB
> 
>   System,RAID1: Size:8.00MB, Used:4.00KB
>      /dev/vdd	    8.00MB
>      /dev/vdc	    8.00MB
> 
>   System,Single: Size:4.00MB, Used:0.00
>      /dev/vdb	    4.00MB
> 
>   Metadata,RAID1: Size:460.94MB, Used:24.00KB
>      /dev/vdb	  460.94MB
>      /dev/vdd	  460.94MB
> 
>   Metadata,Single: Size:8.00MB, Used:0.00
>      /dev/vdb	    8.00MB
> 
>   Unused:
>      /dev/vdb	    2.23GB
>      /dev/vdc	    2.69GB
>      /dev/vdd	    2.24GB

Just a quick feedback:

I think this is rather long. And I find it more complicated than the older 
output.

But maybe its more the vertically oriented formatting.

How about:


ghigo@emulato:~$ sudo ./btrfs fi df /mnt/btrfs1/
=== regular output ===
[sudo] password for ghigo:
Path: /mnt/btrfs1
Summary:
  Disk_size:		   9.00GB
  Disk_allocated:	   1.83GB
  Disk_unallocated:	   7.17GB
  Used:			 284.00KB
  Free_(Estimated):	   6.76GB	(Max: 8.54GB, min: 4.96GB)
  Data_to_disk_ratio:	     75 %

Allocated_area:
  Data,RAID0: 256.00KB of 921.75MB used
  Data,Single: 0 of 8.00MB used
  System,RAID1: 4 KB of 8.00MB used
  System,Single: 0 of 4.00MB used
  Metadata,RAID1: 24KB of 460.94MB used
  Metadata,Single: 0 of 8.00MB used

^^^ possibly tabular ^^^

=== only with -d / --disks or -v? ===

/dev/vdb:
  Data, RAID 0		307.25MB
  Data,Single		8MB
  System,Single		4MB
  Metadata,RAID1	460.94MB
  Metadata,Single	8MB
  Unused			2,23GB

/dev/vdc:
  Data,RAID 0		307,25MB
  System,RAID1		8MB
  Unused			2,69GB

/dev/vdd:
  Data,RAID 0		307.25MB
  System,RAID1		8MB
  Metadata,RAID1	460.94MB
  Unused			2.24GB

(one could include the usage in single disk view as well.)



Hmmm... but that also looks quite heavy.


Possibly this could be done tabular as well, like:

                        vdb		vdc		vdd
Data, RAID 0	307,25MB	307,25MB	307,25MB
…
System,RAID1	-		8MB		8MB
…
Unused		2,23GB	2,69GB	2,24GB

I like this. But what if the filesystem has 100 disks?


Hmmm, how about:

                        vdb		vdc		vdd
Data, RAID 0	307,25MB	307,25MB	307,25MB
			vde		vdf		vdg
			307,25MB	200MB	200MB
…
			vdb		vdc		vdd
System,RAID1	-		8MB		8MB
…
			vdb		vdc		vdd
Unused		2,23GB	2,69GB	2,24GB
			vde		vdf		vdg
			2,25GB	2,8GB	2,21GB

in such a case? Then each line has to have headings with devices. As long 
as one line is enough, it only needs to be printed once at the beginning 
of the table.

So in some form a tabular matrix of devices.


Other idea might be:

Allocated_area:
  Data,RAID0: Size:921.75MB, Used:256.00KB
      /dev/vdb: 307.25MB	/dev/vdc: 307.25MB	/dev/vdd: 307.25MB

And if same possibly:

Allocated_area:
  Data,RAID0: Size:921.75MB, Used:256.00KB
      /dev/vd[bcd]: 307.25MB


Hmmm, this is all playing with the same presentation.


Possibly one can at least hide empty trees. Or have them not created at 
all at mkfs.btrfs time. There is no point in having / showing 
Metadata,Single I think as long as it is not used.


Will think about this a bit.

Anyway I am fine with starting somewhere. Improvents can be made later on 
also taking user feedback into account.

Thanks,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
