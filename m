From: Andi Drebes <lists-receive@programmierforen.de>
Subject: Re: Unable to mount loopback devices in RAID mode
Date: Fri, 20 Nov 2009 20:22:18 +0100
Message-ID: <200911202022.19306.lists-receive@programmierforen.de>
References: <200911192026.04694.lists-receive@programmierforen.de> <4B05D64B.7070705@hp.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Cc: linux-btrfs@vger.kernel.org
To: jim owens <jowens@hp.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4B05D64B.7070705@hp.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hi!

> The problem is btrfs randomly changes the "current master"
> superblock of the filesystem.  Only 1 of the devices will
> be mountable.  You just have to try the other ones, like:
> 
>  > $ mount -t btrfs /dev/loop0 /mnt/btrfs
>  > mount: wrong fs type, bad option, bad superblock on /dev/loop0,
> 
> $ mount -t btrfs /dev/loop1 /mnt/btrfs
> 
> until you find one that works.
Thanks for the hint.

	Cheers,
		Andi
