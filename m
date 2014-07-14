Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:56239 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755545AbaGNWDW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 14 Jul 2014 18:03:22 -0400
Received: from merkaba.localnet (host-188-174-206-217.customer.m-online.net [188.174.206.217])
	by mail.lichtvoll.de (Postfix) with ESMTPSA id A52C541E
	for <linux-btrfs@vger.kernel.org>; Tue, 15 Jul 2014 00:03:21 +0200 (CEST)
From: Martin Steigerwald <Martin@lichtvoll.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: BTRFS hang with 3.16-rc5
Date: Tue, 15 Jul 2014 00:03:21 +0200
Message-ID: <2200430.lB6XKANyxs@merkaba>
In-Reply-To: <pan$10815$10a07b04$fff89252$8ecbdf83@cox.net>
References: <1502954.OtX3SzjMKZ@merkaba> <3226395.MP6iD3ZiSL@merkaba> <pan$10815$10a07b04$fff89252$8ecbdf83@cox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Montag, 14. Juli 2014, 17:51:37 schrieben Sie:
> Martin Steigerwald posted on Mon, 14 Jul 2014 17:10:30 +0200 as excerpted:
> > Am Montag, 14. Juli 2014, 17:04:22 schrieben Sie:
> >> Hi!
> >> 
> >> While with 3.16-rc3 and rc4 I didn´t have a BTRFS hang in several days
> >> of usage, with 3-16-rc5 I had a hang again. Less than a hour since
> >> booting it.
> >> 
> >> Since the hang bug I and others had with 3.15 and upto 3.16-rc2 usually
> >> didn´t happen that quickly after boot and since backtrace looks a bit
> >> different from what I have in memory, I post this in a new thread.
> >> See thread "Blocked tasks on 3.15.1" for a discussion of previous hang
> >> issues.
> > 
> > Probably good to add some basic information on the filesystem: [...]
> > 
> > I think I switched it to skinny extents, but I am not completely sure.
> > 
> > 
> > Dual SSD BTRFS RAID 1
> > 
> > No snapshots at the moment. And plenty of space free.
> 
> FWIW, I've been updating every few days, running two different snapshots
> between 3.16-rc4 and rc5, and now rc5 itself, and haven't noticed this
> issue.  Dual SSDs btrfs raid1, but partitioned up so the biggest
> partition is under 50 GB.
> 
> I've been doing some very heavy (gentoo) package building and shuffling
> around the last few days trying out the kde-frameworks/workspaces-5
> stuff, then deciding it's not yet ready for me, too, so I've been working
> it a bit, too.
> 
> But certainly YMMV, and I did have some nasty trouble a few weeks ago,
> which triggered a btrfs restore and then a mkfs on a couple of the
> filesystems.  But nothing at all strange with btrfs since then, or
> really, for awhile before that either.

Do you have compression enabled?

I have:

/dev/mapper/msata-home /home btrfs rw,noatime,compress=lzo,ssd,space_cache 0 0


-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
