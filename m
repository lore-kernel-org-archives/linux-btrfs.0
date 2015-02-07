Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f52.google.com ([209.85.220.52]:49890 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754974AbbBGR26 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 7 Feb 2015 12:28:58 -0500
Received: by mail-pa0-f52.google.com with SMTP id kq14so16567048pab.11
        for <linux-btrfs@vger.kernel.org>; Sat, 07 Feb 2015 09:28:57 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAPn+qJhxzbG-FjUUG9VzzZvvA=nSyaFxp3PQrMSm10QXrCtNNw@mail.gmail.com>
References: <CAPn+qJhxzbG-FjUUG9VzzZvvA=nSyaFxp3PQrMSm10QXrCtNNw@mail.gmail.com>
Date: Sat, 7 Feb 2015 09:28:57 -0800
Message-ID: <CAM9fjH5Df5ov-XPNgi0gH+Z3oJ8K3ZLWVRwgFrJDtDyB05meLg@mail.gmail.com>
Subject: Re: RAID1, SSD+non-SSD
From: Kyle Manna <2bluesc@gmail.com>
To: Brian B <canis8585@gmail.com>, linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri Feb 06 2015 at 12:06:33 PM Brian B <canis8585@gmail.com> wrote:
>
> My laptop has two disks, a SSD and a traditional magnetic disk. I plan
> to make a partition on the mag disk equal in size the SSD and set up
> BTRFS RAID1. This I know how to do.
>
> The only reason I'm doing the RAID1 is for the self-healing. I realize
> writing large amounts of data will be slower than the SSD alone, but
> is it possible to set it up to only read from the magnetic drive if
> there's an error reading from the SSD?
>
> In other words, is there a way to tell it to only read from the faster
> disk?  Is that even necessary?  Is there a better way to accomplish
> this?


What you may want to look at is lvmcache + btrfs.  I've played with
lvmcache (using ext4 on top) and btrfs independently, but not
together.  Too many new technologies at the same time for my taste. :)

The best documentation I've found on lvm cache is the man page:
http://man7.org/linux/man-pages/man7/lvmcache.7.html

LVM cache uses dm-cache behind the scenes and makes it much more
manageable (i.e. construction, manipulation, and teardown of devices.
An lvm cache won't help with redundancy, the blocks will either exist
on the caching device or slower device.   To remove the cache, you can
force a flush of the blocks out of the to the traditional HDD and use
it without the cache without having to recreate the file system.
