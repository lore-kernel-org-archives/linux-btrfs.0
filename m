From: Mark Lord <lkml@rtr.ca>
Subject: Re: Why does stat() return invalid st_dev field for btrfs ??
Date: Mon, 17 Aug 2009 17:15:22 -0400
Message-ID: <4A89C86A.1040207@rtr.ca>
References: <4A89C1DA.6040601@rtr.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
To: linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4A89C1DA.6040601@rtr.ca>
List-ID: <linux-btrfs.vger.kernel.org>

Mark Lord wrote:
> Chris / list,
> 
> stat(2) seems to return invalid major/minor device info
> for btrfs filesystems.
> 
> Why?  Is this a bug?
> 
> Eg.
> 
>     [~] uname -r
>     2.6.31-rc6
>     [~] mkfs.btrfs /dev/sdb
>     
>     WARNING! - Btrfs Btrfs v0.19 IS EXPERIMENTAL
>     WARNING! - see http://btrfs.wiki.kernel.org before using
>     
>     fs created label (null) on /dev/sdb
>             nodesize 4096 leafsize 4096 sectorsize 4096 size 30.06GB
>     Btrfs Btrfs v0.19
>     [~] mount /dev/sdb /x -t btrfs
>     [~] stat --format="%04D" /x
>     0017
>     [~] touch /x/junk
>     [~] stat --format="%04D" /x/junk
>     0017
> 
> This gives major=0x00, minor=0x17 for /dev/sdb,
> which should have major=8, minor=0x10.
..

Mmm.. btrfs appears to configure itself as a "pseudo" filesystem,
which is why it returns fake device numbers via stat(),
similar to procfs or sysfs.

The problem I'm trying to solve, is how to determine the underlying
block device node for a mounted btrfs filesystem.

Well, actually, the other way around:  given a block device major:minor,
how to determine whether or not this block device is currently mounted.

Simple, eh?  Except for the silly "/dev/root" stuff that some distros practice.

????????
