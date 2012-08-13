Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from col0-omc1-s6.col0.hotmail.com ([65.55.34.16]:47576 "EHLO
	col0-omc1-s6.col0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750867Ab2HMEUC (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 13 Aug 2012 00:20:02 -0400
Message-ID: <COL113-DS2059BCB791EE611DDBA0A5B0B00@phx.gbl>
From: Kyle Gates <kylegates@hotmail.com>
To: "Fajar A. Nugraha" <list@fajar.net>,
        "Daniel Pocock" <daniel@pocock.com.au>
CC: <linux-btrfs@vger.kernel.org>
References: <5027DDFC.60504@pocock.com.au> <CAG1y0scy=6NByQ9DBF_9m6MrmNrYe1WvX9-JkmbEUKWjd77w8Q@mail.gmail.com>
In-Reply-To: <CAG1y0scy=6NByQ9DBF_9m6MrmNrYe1WvX9-JkmbEUKWjd77w8Q@mail.gmail.com>
Subject: Re: raw partition or LV for btrfs?
Date: Sun, 12 Aug 2012 23:19:46 -0500
MIME-Version: 1.0
Content-Type: text/plain; format=flowed; charset="iso-8859-1";
	reply-type=original
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I'm currently running a 1GB raid1 btrfs /boot with no problems.
Also, I think the current grub2 has lzo support.

-----Original Message----- 
From: Fajar A. Nugraha
Sent: Sunday, August 12, 2012 5:48 PM
To: Daniel Pocock
Cc: linux-btrfs@vger.kernel.org
Subject: Re: raw partition or LV for btrfs?

On Sun, Aug 12, 2012 at 11:46 PM, Daniel Pocock <daniel@pocock.com.au> 
wrote:
>
>
> I notice this question on the wiki/faq:
>
>
> https://btrfs.wiki.kernel.org/index.php/UseCases#What_is_best_practice_when_partitioning_a_device_that_holds_one_or_more_btr-filesystems
>
> and as it hasn't been answered, can anyone make any comments on the 
> subject
>
> Various things come to mind:
>
> a) partition the disk, create an LVM partition, and create lots of small
> LVs, format each as btrfs
>
> b) partition the disk, create an LVM partition, and create one big LV,
> format as btrfs, make subvolumes
>
> c) what about using btrfs RAID1?  Does either approach (a) or (b) seem
> better for someone who wants the RAID1 feature?

IMHO when the qgroup feature is "stable" (i.e. adopted by distros, or
at least in stable kernel) then simply creating one big partition (and
letting btrfs handle RAID1, if you use it) is better. When 3.6 is out,
perhaps?

Until then I'd use LVM.

>
> d) what about booting from a btrfs system?  Is it recommended to follow
> the ages-old practice of keeping a real partition of 128-500MB,
> formatting it as btrfs, even if all other data is in subvolumes as per 
> (b)?

You can have one single partition only and boot directly from that.
However btrfs has the same problems as zfs in this regard:
- grub can read both, but can't write to either. In other words, no
support for grubenv
- the "best" compression method (gzip for zfs, lzo for btrfs) is not
supported by grub

For the first problem, an easy workaroud is just to disable the grub
configuration that uses grubenv. Easy enough, and no major
functionality loss.

The second one is harder for btrfs. zfs allows you to have separate
dataset (i.e. subvolume, in btfs terms) with different compression, so
you can have a dedicated dataset for /boot with different compression
setting from the rest of the dataset. With btrfs you're currently
stuck with using the same compression setting for everything, so if
you love lzo this might be a major setback.

There's also a btrfs-specific problem: it's hard to have a system
which have /boot on a separate subvol while managing it with current
automatic tools (e.g. update-grub).

Due to second and third problem, I'd recommend you just use a separate
partition with ext2/4 for now.

-- 
Fajar
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html 

