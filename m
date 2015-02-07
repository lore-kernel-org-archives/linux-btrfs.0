Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yh0-f54.google.com ([209.85.213.54]:56197 "EHLO
	mail-yh0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754976AbbBGAXv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 6 Feb 2015 19:23:51 -0500
Received: by mail-yh0-f54.google.com with SMTP id 29so7701623yhl.13
        for <linux-btrfs@vger.kernel.org>; Fri, 06 Feb 2015 16:23:51 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAPn+qJhxzbG-FjUUG9VzzZvvA=nSyaFxp3PQrMSm10QXrCtNNw@mail.gmail.com>
References: <CAPn+qJhxzbG-FjUUG9VzzZvvA=nSyaFxp3PQrMSm10QXrCtNNw@mail.gmail.com>
Date: Fri, 6 Feb 2015 17:23:50 -0700
Message-ID: <CAJCQCtQn=HQU15D5qfS4ASR7HZM974f1p8xKQQCQRmR-NPXQ+w@mail.gmail.com>
Subject: Re: RAID1, SSD+non-SSD
From: Chris Murphy <lists@colorremedies.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Feb 6, 2015 at 1:01 PM, Brian B <canis8585@gmail.com> wrote:
> My laptop has two disks, a SSD and a traditional magnetic disk. I plan
> to make a partition on the mag disk equal in size the SSD and set up
> BTRFS RAID1. This I know how to do.

There isn't a write mostly option in btrfs like there is with md raid,
so I don't know how Btrfs will tolerate one device being exceptionally
slower than the other. It may be most of the time it won't matter, but
I can imagine with a ton of IOPS backing up on the hard drive, having
completed on the SSD, could maybe be a problem. I'd test it unless
someone else who has pipes up.

>
> The only reason I'm doing the RAID1 is for the self-healing. I realize
> writing large amounts of data will be slower than the SSD alone, but
> is it possible to set it up to only read from the magnetic drive if
> there's an error reading from the SSD?

No.
>
> In other words, is there a way to tell it to only read from the faster
> disk?  Is that even necessary?  Is there a better way to accomplish
> this?

No. No. And maybe. In order.

If there is an error detected by either drive, or by Btrfs, Btrfs will
get the correct data from the other drive and fix the problem on the
original drive. You don't need to configure anything. The only concern
is the asymmetric performance.

I think the use case is better achieved with two HDD's + two SSD
partitions, configured either with bcache or dmcache. The result is
two logical devices using HDDs as backing device and SSD partitions as
cache, and then format them as Btrfs raid1. The question there of
course, is maturity of bcache vs dmcache and their interactions with
Btrfs. But at least that's supposed to work.

-- 
Chris Murphy
