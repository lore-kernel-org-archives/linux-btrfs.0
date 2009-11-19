From: jim owens <jowens@hp.com>
Subject: Re: Unable to mount loopback devices in RAID mode
Date: Thu, 19 Nov 2009 18:35:39 -0500
Message-ID: <4B05D64B.7070705@hp.com>
References: <200911192026.04694.lists-receive@programmierforen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Cc: linux-btrfs@vger.kernel.org
To: Andi Drebes <lists-receive@programmierforen.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <200911192026.04694.lists-receive@programmierforen.de>
List-ID: <linux-btrfs.vger.kernel.org>

Andi Drebes wrote:
> Hi!
> I recently tried to mount a filesystem in RAID1 mode using loopback devices. I followed the instructions at [1]. Here's exactly what I've done:
> 
> $ dd if=/dev/zero of=raid1_0.img bs=1M count=500
> $ dd if=/dev/zero of=raid1_1.img bs=1M count=500
> $ mkfs.btrfs -m raid1 -d raid1 raid1_0.img raid1_1.img
> $ losetup /dev/loop0 raid1_0.img
> $ losetup /dev/loop1 raid1_1.img
> $ mount -t btrfs /dev/loop0 /mnt/btrfs
> mount: wrong fs type, bad option, bad superblock on /dev/loop0,
>        missing codepage or helper program, or other error
>        In some cases useful info is found in syslog - try
>        dmesg | tail  or so

The problem is btrfs randomly changes the "current master"
superblock of the filesystem.  Only 1 of the devices will
be mountable.  You just have to try the other ones, like:

 > $ mount -t btrfs /dev/loop0 /mnt/btrfs
 > mount: wrong fs type, bad option, bad superblock on /dev/loop0,

$ mount -t btrfs /dev/loop1 /mnt/btrfs

until you find one that works.  I've been testing 4 devices
and often have to try all 4.  Maybe someday we will fix this
so ANY raid member can start the mount (but this may need
a disk format change).

jim
