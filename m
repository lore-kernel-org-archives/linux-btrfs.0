Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-gh0-f174.google.com ([209.85.160.174]:59196 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755974Ab2HNLXv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 Aug 2012 07:23:51 -0400
Received: by ghrr11 with SMTP id r11so277244ghr.19
        for <linux-btrfs@vger.kernel.org>; Tue, 14 Aug 2012 04:23:51 -0700 (PDT)
Message-ID: <1344943428.20922.14.camel@ayu>
Subject: Re: raw partition or LV for btrfs?
From: Calvin Walton <calvin.walton@kepstin.ca>
To: "Fajar A. Nugraha" <list@fajar.net>
Cc: Daniel Pocock <daniel@pocock.com.au>, linux-btrfs@vger.kernel.org
Date: Tue, 14 Aug 2012 07:23:48 -0400
In-Reply-To: <CAG1y0scy=6NByQ9DBF_9m6MrmNrYe1WvX9-JkmbEUKWjd77w8Q@mail.gmail.com>
References: <5027DDFC.60504@pocock.com.au>
	 <CAG1y0scy=6NByQ9DBF_9m6MrmNrYe1WvX9-JkmbEUKWjd77w8Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 2012-08-13 at 05:48 +0700, Fajar A. Nugraha wrote:
> On Sun, Aug 12, 2012 at 11:46 PM, Daniel Pocock <daniel@pocock.com.au> wrote:

> > d) what about booting from a btrfs system?  Is it recommended to follow
> > the ages-old practice of keeping a real partition of 128-500MB,
> > formatting it as btrfs, even if all other data is in subvolumes as per (b)?
> 
> You can have one single partition only and boot directly from that.
> However btrfs has the same problems as zfs in this regard:
> - grub can read both, but can't write to either. In other words, no
> support for grubenv
> - the "best" compression method (gzip for zfs, lzo for btrfs) is not
> supported by grub

This is actually not true; the grub 2.00 release does support reading
from lzo-compressed btrfs filesystems. (Of course, if any other new
compression algorithms are added, this issue will happen again.)

> For the first problem, an easy workaroud is just to disable the grub
> configuration that uses grubenv. Easy enough, and no major
> functionality loss.
> 
> The second one is harder for btrfs. zfs allows you to have separate
> dataset (i.e. subvolume, in btfs terms) with different compression, so
> you can have a dedicated dataset for /boot with different compression
> setting from the rest of the dataset. With btrfs you're currently
> stuck with using the same compression setting for everything, so if
> you love lzo this might be a major setback.

It's possible to disable compression on individual files on btrfs. If
you disable compression on everything in /boot/grub{2,} and on your
kernels and initramfses then grub will be able to read them no matter
what.

Unfortunately, this is a bit tricky to do at the moment: you have to
remount the filesystem with `-o compress=no`, then run `btrfs fi defrag`
individually on all the files that you want uncompressed.

A patch to add support for `btrfs fi defrag -c none <file>` or so would
make this easier, and shouldn't be to hard to do :)

> Due to second and third problem, I'd recommend you just use a separate
> partition with ext2/4 for now.

Even with my comments, this is still my recommendation. (Although if
you're using a EFI bios, you could just stick all the bootloader stuff
on the VFAT EFI system partition instead.)

-- 
Calvin Walton <calvin.walton@kepstin.ca>

