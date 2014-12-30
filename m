Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:34768 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751340AbaL3RZ4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 30 Dec 2014 12:25:56 -0500
From: Martin Steigerwald <Martin@lichtvoll.de>
To: dsterba@suse.cz
Cc: linux-btrfs@vger.kernel.org, clm@fb.com
Subject: Re: Btrfs progs release 3.18
Date: Tue, 30 Dec 2014 18:25:50 +0100
Message-ID: <7560809.H5eVrAyh13@merkaba>
In-Reply-To: <20141230163439.GP6490@suse.cz>
References: <20141230163439.GP6490@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Dienstag, 30. Dezember 2014, 17:34:39 schrieb David Sterba:
> Hi,

Hi David,

> let me announce the release of btrfs-progs version 3.18. There are
> updates to UI and several enhancements of check/repair. About 100
> commits from 14 contributors, thank you all!
> 
> Tarballs: https://www.kernel.org/pub/linux/kernel/people/kdave/btrfs-progs/
> Git: git://git.kernel.org/pub/scm/linux/kernel/git/kdave/btrfs-progs.git
> 
> 
> Major user-visible changes:
> 
> * mkfs - skinny-metadata feature is now on by default, first introduced
>   in kernel 3.10
> 
> New subcommands:
> 
> * filesystem usage - give an overview of fs usage in a way that's more
>   comprehensible than existing 'fi df'
>   * on kernels < 3.18: requires root due to restricted ioctl FS_INFO
>   * raid 5/6 numbers may be missing due to restricte ioctl (TREE_SEARCH)
>   * that's used to calculate the numbers
> * device usage - more detailed information about per-device allocations
>   * same restrictions as for 'fi usage'

Thank you and all the contributors for this nice after christmas gift!

I like it:

merkaba:~> btrfs fi usage /home
Overall:
    Device size:                 340.00GiB
    Device allocated:            291.90GiB
    Device unallocated:           48.10GiB
    Used:                        273.15GiB
    Free (estimated):             31.64GiB      (min: 31.64GiB)
    Data ratio:                       2.00
    Metadata ratio:                   2.00
    Global reserve:              512.00MiB      (used: 0.00B)

Data,RAID1: Size:140.93GiB, Used:133.34GiB
   /dev/mapper/msata-home        140.93GiB
   /dev/mapper/sata-home         140.93GiB

Metadata,RAID1: Size:4.99GiB, Used:3.24GiB
   /dev/mapper/msata-home          4.99GiB
   /dev/mapper/sata-home           4.99GiB

System,RAID1: Size:32.00MiB, Used:48.00KiB
   /dev/mapper/msata-home         32.00MiB
   /dev/mapper/sata-home          32.00MiB

Unallocated:
   /dev/mapper/msata-home         24.05GiB
   /dev/mapper/sata-home          24.05GiB

merkaba:~> btrfs device us /home   
/dev/mapper/msata-home, ID: 1
   Device size:           170.00GiB
   Data,RAID1:            140.93GiB
   Metadata,RAID1:          4.99GiB
   System,RAID1:           32.00MiB
   Unallocated:            24.05GiB

/dev/mapper/sata-home, ID: 2
   Device size:           170.00GiB
   Data,RAID1:            140.93GiB
   Metadata,RAID1:          4.99GiB
   System,RAID1:           32.00MiB
   Unallocated:            24.05GiB

-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
