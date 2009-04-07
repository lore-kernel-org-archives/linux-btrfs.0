From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Problem with renaming devices
Date: Tue, 07 Apr 2009 07:35:56 -0400
Message-ID: <1239104156.17426.26.camel@think.oraclecorp.com>
References: <20090406174135.GC27111@vlad.carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-btrfs@vger.kernel.org
To: Hugo Mills <hugo-lkml@carfax.org.uk>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090406174135.GC27111@vlad.carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 2009-04-06 at 18:41 +0100, Hugo Mills wrote:
> There seems to be some issue over changing the names of the device
> that a btrfs filesystem lives on:
> 
> # lvcreate scratch -n fstest -L 2G
>   Logical volume "fstest" created
> # mkfs -t btrfs /dev/scratch/fstest
> 
> WARNING! - Btrfs v0.18-ge3b0f66 IS EXPERIMENTAL
> WARNING! - see http://btrfs.wiki.kernel.org before using
> 
> fs created label (null) on /dev/scratch/fs1
> 	nodesize 4096 leafsize 4096 sectorsize 4096 size 2.00GB
> Btrfs v0.18-ge3b0f66
> 
> # mount /dev/scratch/fstest /mnt
> # umount /mnt
> 
> # lvrename scratch fstest derek
>   Renamed "fstest" to "derek" in volume group "scratch"
> # mount /dev/scratch/derek /mnt
> mount: /dev/mapper/scratch-derek: can't read superblock
> 
> # lvrename scratch derek fstest
>   Renamed "derek" to "fstest" in volume group "scratch"
> # mount /dev/scratch/fstest /mnt
> [success]
> 
>    The rename works properly on a completely virgin filesystem, but
> not on one that's been mounted and unmounted (as above).

Whoops, we need to reset the pathname when a probe finds a given dev
uuid on a given device.  I'll patch it up when I get back next week.

Thanks for this bug report.

-chris





