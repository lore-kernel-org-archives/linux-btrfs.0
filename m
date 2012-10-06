Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:54547 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754402Ab2JFJ5F convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 6 Oct 2012 05:57:05 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH][BTRFS-PROGS][V3] btrfs filesystem df
Date: Sat, 6 Oct 2012 11:57:03 +0200
Cc: Goffredo Baroncelli <kreijack@gmail.com>,
        Chris Mason <chris.mason@fusionio.com>,
        Hugo Mills <hugo@carfax.org.uk>, Roman Mamedov <rm@romanrm.ru>,
        =?utf-8?q?S=C3=A9bastien_Maury?= <sebastien.maury@inserm.fr>,
        Ilya Dryomov <idryomov@gmail.com>
References: <1349371679-10775-1-git-send-email-kreijack@inwind.com> (sfid-20121004_215416_819357_23AF71B8)
In-Reply-To: <1349371679-10775-1-git-send-email-kreijack@inwind.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201210061157.03992.Martin@lichtvoll.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Donnerstag, 4. Oktober 2012 schrieb Goffredo Baroncelli:
> Hi Chris,
> 
> this serie of patches updated the command "btrfs filesystem
> df". I update this command because it is not so easy to get
> the information about the disk usage from the command "fi df" and "fi show".
> This patch was the result of some discussions on the btrfs 
> mailing list. Many thanks to all the contributors.
> 
> From the man page (see 2nd patch):
> 
> [...]
> The  command  btrfs  filesystem  df is used to query the
> status of the chunks, how many space on the disk(s) are used  by
> the  chunks,  how many space are available in the chunks, and an
> estimation of the free space of the filesystem.
> [...]
> 
> $ ./btrfs filesystem df --help
> usage: btrfs filesystem disk-usage [-k] <path> [<path>..]
> 
>     Show space usage information for a mount point(s).
> 
>     -k  Set KB (1024 bytes) as unit
> 
> $ ./btrfs filesystem df /
> Path: /
> Summary:
>   Disk_size:                 72.57GB
>   Disk_allocated:            25.10GB
>   Disk_unallocated:          47.48GB
>   Logical_size:              23.06GB
>   Used:                      11.01GB
>   Free_(Estimated):          55.66GB    (Max: 59.52GB, Min: 35.78GB)
>   Data_to_disk_ratio:           92 %
> 
> Details:
>   Chunk_type  Mode     Size_(disk) Size_(logical)     Used
>   Data        Single       21.01GB      21.01GB     10.34GB
>   System      DUP          80.00MB      40.00MB      4.00KB
>   System      Single        4.00MB       4.00MB        0.00
>   Metadata    DUP           4.00GB       2.00GB    686.93MB
>   Metadata    Single        8.00MB       8.00MB        0.00

Works nicely here:

merkaba:/home/[…]> ./btrfs fi df /
Path: /
Summary:
  Disk_size:                 18.62GB
  Disk_allocated:            18.62GB
  Disk_unallocated:             0.00
  Logical_size:              16.87GB
  Used:                      12.46GB
  Free_(Estimated):           4.41GB    (Max: 4.41GB, Min: 4.41GB)
  Data_to_disk_ratio:           91 %

Details:
  Chunk_type  Mode     Size_(disk) Size_(logical)     Used
  Data        Single       15.10GB     15.10GB     11.78GB
  System      DUP          16.00MB      8.00MB      4.00KB
  System      Single        4.00MB      4.00MB        0.00
  Metadata    DUP           3.50GB      1.75GB    693.97MB
  Metadata    Single        8.00MB      8.00MB        0.00


merkaba:/home/[…]> ./btrfs fi df /mnt/amazon
Path: /mnt/amazon
Summary:
  Disk_size:                465.76GB
  Disk_allocated:           465.76GB
  Disk_unallocated:           4.00KB
  Logical_size:             455.75GB
  Used:                     368.83GB
  Free_(Estimated):          86.93GB    (Max: 86.93GB, Min: 86.93GB)
  Data_to_disk_ratio:           98 %

Details:
  Chunk_type  Mode     Size_(disk) Size_(logical)     Used
  Data        Single      445.73GB    445.73GB    368.24GB
  System      DUP          16.00MB      8.00MB     64.00KB
  System      Single        4.00MB      4.00MB        0.00
  Metadata    DUP          20.00GB     10.00GB    598.84MB
  Metadata    Single        8.00MB      8.00MB        0.00


I wonder about free size estimation minimum and maximum are the same tough.

Do you have a explaination for this?

Otherwise:

Tested-By: Martin Steigerwald <martin@lichtvoll.de>

(as of commit c3f7fa95f3aa29972b79eed71ec063b6a3019017 from your repo.)


The data to disk ratio on bigger disk is lower due to less duplicated meta
data involved, I bet. I want to recreate / anyway with 16 KiB leaf and node
size and then I think I will use single for metadata as its an SSD. The
bigger one is external eSATA harddisk.


I can test and post outputs of a few other disks including my oldest BTRFS
filesystems on a ThinkPad T23 which are at least one, possible almost 2
years old. Is there are way to tell filesystem creation date? And a 2 TiB
backup disk with three or for subvolumes and >10 snapshots of all of them
together.

> Where:
>         Disk_size                       -> sum of sizes of teh disks
>         Disk_allocated                  -> sum of chunk sizes
>         Disk_unallocated                -> Disk_size - Disk_allocated
>         Logical_size                    -> sum of logical area sizes
>         Used                            -> logical area used
>         Free_(Estimated)                -> on the basis of allocated
>                                            chunk, an estrapolation of
>                                            the free space
>         Data_to_disk_ratio              -> ration between the space occuped
>                                            by a chunk and the real space
>                                            available ( due to duplication
>                                            and/or RAID level)
>         Chunk_type                      -> kind of chunk
>         Mode                            -> allocation policy of a chunk
>         Size_(disk)                     -> area of disk(s) occuped by the
>                                            chunk (see it as raw space used)
>         Size_(logical)                  -> logical area size of the chunk
>         Used                            -> portion of the logical area
>                                            used by the filesystem
[…]
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
