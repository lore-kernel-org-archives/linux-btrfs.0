Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:61532 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759716Ab2JYTkb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 25 Oct 2012 15:40:31 -0400
Received: by mail-pb0-f46.google.com with SMTP id rr4so2244964pbb.19
        for <linux-btrfs@vger.kernel.org>; Thu, 25 Oct 2012 12:40:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <50899151.1070503@inwind.it>
References: <50899151.1070503@inwind.it>
Date: Thu, 25 Oct 2012 13:40:30 -0600
Message-ID: <CAE5mzvgem05HN1QTFb6FkhHv0U=e1PTo7idPy06SR97cMbpFLg@mail.gmail.com>
Subject: Re: [RFC] New attempt to a better "btrfs fi df"
From: cwillu <cwillu@cwillu.com>
To: "kreijack@inwind.it" <kreijack@inwind.it>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> I don't publish the patched because aren't in a good shape. However I
> really like the output. The example is a filesystem based on three
> disks of 3GB.
>
> It is clear that:
> - - RAID0 uses all the disks
> - - RAID1 uses two different disks
>
> Comments are welcome.
>
> Known bugs:
> - - if a filesystem uses a disk but there is any chunk, the disk is not
> shown (solvable)
> - - this command need root capability (I use the BTRFS_IOC_TREE_SEARCH
> to get the chunk info; so that is unavoidable)
>
>
> ghigo@emulato:~$ sudo ./btrfs fi df /mnt/btrfs1/
> [sudo] password for ghigo:
> Path: /mnt/btrfs1
> Summary:
>   Disk_size:               9.00GB
>   Disk_allocated:          1.83GB
>   Disk_unallocated:        7.17GB
>   Used:                  284.00KB
>   Free_(Estimated):        6.76GB       (Max: 8.54GB, min: 4.96GB)
>   Data_to_disk_ratio:        75 %
>
> Allocated_area:
>   Data,RAID0: Size:921.75MB, Used:256.00KB
>      /dev/vdc     307.25MB
>      /dev/vdb     307.25MB
>      /dev/vdd     307.25MB
>
>   Data,Single: Size:8.00MB, Used:0.00
>      /dev/vdb       8.00MB
>
>   System,RAID1: Size:8.00MB, Used:4.00KB
>      /dev/vdd       8.00MB
>      /dev/vdc       8.00MB
>
>   System,Single: Size:4.00MB, Used:0.00
>      /dev/vdb       4.00MB
>
>   Metadata,RAID1: Size:460.94MB, Used:24.00KB
>      /dev/vdb     460.94MB
>      /dev/vdd     460.94MB
>
>   Metadata,Single: Size:8.00MB, Used:0.00
>      /dev/vdb       8.00MB
>
>   Unused:
>      /dev/vdb       2.23GB
>      /dev/vdc       2.69GB
>      /dev/vdd       2.24GB

Couple minor things, in order of personal opinion of severity:

* Devices should be listed in a consistent order; device names are
just too consistently similar

* System chunks shouldn't be listed between data and metadata; really,
they're just noise 99% of the time anyway

* I think it may be more useful to display each disk, with the
profiles in use underneath.  With a larger number of disks, that would
make it _much_ easier to tell at-a-glance what is currently on a disk
(that I may want to remove, or which I may suspect to be unreliable).

* I'd rename "Unused" to "Unallocated" for consistency with the section title

* (and I still detest the_underscores_between_all_the_words; it
doesn't make parsing significantly easier, and it's an eyesore)

* Three coats of blue paint plus a clear-coat is the One True Paint-Job.
