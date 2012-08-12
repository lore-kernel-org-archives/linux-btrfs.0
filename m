Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qa0-f53.google.com ([209.85.216.53]:57896 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752021Ab2HLWsV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 12 Aug 2012 18:48:21 -0400
Received: by qaas11 with SMTP id s11so1516175qaa.19
        for <linux-btrfs@vger.kernel.org>; Sun, 12 Aug 2012 15:48:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5027DDFC.60504@pocock.com.au>
References: <5027DDFC.60504@pocock.com.au>
Date: Mon, 13 Aug 2012 05:48:20 +0700
Message-ID: <CAG1y0scy=6NByQ9DBF_9m6MrmNrYe1WvX9-JkmbEUKWjd77w8Q@mail.gmail.com>
Subject: Re: raw partition or LV for btrfs?
From: "Fajar A. Nugraha" <list@fajar.net>
To: Daniel Pocock <daniel@pocock.com.au>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Aug 12, 2012 at 11:46 PM, Daniel Pocock <daniel@pocock.com.au> wrote:
>
>
> I notice this question on the wiki/faq:
>
>
> https://btrfs.wiki.kernel.org/index.php/UseCases#What_is_best_practice_when_partitioning_a_device_that_holds_one_or_more_btr-filesystems
>
> and as it hasn't been answered, can anyone make any comments on the subject
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
> formatting it as btrfs, even if all other data is in subvolumes as per (b)?

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
