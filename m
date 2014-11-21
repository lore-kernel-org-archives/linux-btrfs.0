Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f54.google.com ([209.85.220.54]:50486 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750793AbaKUSXq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 21 Nov 2014 13:23:46 -0500
Received: by mail-pa0-f54.google.com with SMTP id fb1so5420001pad.27
        for <linux-btrfs@vger.kernel.org>; Fri, 21 Nov 2014 10:23:46 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <pan$29e1e$f368f5df$85fe86e7$dd12c3b5@cox.net>
References: <54699CC7.1050909@swiftspirit.co.za>
	<546A46A5.8030603@inwind.it>
	<CAE8gLh=VubBbZdeKTAuWRjOxPF7C+ouUeeVvmGfT2ckYWGhQVA@mail.gmail.com>
	<CAE8gLh=Lf+z2B_9EXQM_ODSOa5HZsFpFMB=kKGmQXJSjYdy5kg@mail.gmail.com>
	<27BDAC3B-789C-4477-B065-E703CE425F54@colorremedies.com>
	<546B68F8.6080008@ubuntu.com>
	<FC0BA13C-21E3-44DD-A87C-4BEAE4FBF9EA@colorremedies.com>
	<546BA96D.4050805@ubuntu.com>
	<2A57F99C-80AA-4FD4-AA41-57F02AD4E1A2@colorremedies.com>
	<546CB531.2060509@ubuntu.com>
	<20141121042814.GR17395@hungrycats.org>
	<pan$29e1e$f368f5df$85fe86e7$dd12c3b5@cox.net>
Date: Fri, 21 Nov 2014 11:23:45 -0700
Message-ID: <CAJCQCtR26DBb9KqYTXXew6TPQhAyya318oLXfBf=Q+NfL_dSPQ@mail.gmail.com>
Subject: Re: BTRFS messes up snapshot LV with origin
From: Chris Murphy <lists@colorremedies.com>
To: Duncan <1i5t5.duncan@cox.net>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Nov 20, 2014 at 11:22 PM, Duncan <1i5t5.duncan@cox.net> wrote:

>
> When I have such a filesystem level problem, I simply dd from the backing
> device to some other location, generally to a file that's on a different
> filesystem (preferrably non-btrfs, I use reiserfs as I've found it very
> resilient, here), in which case btrfs device scan won't see the UUID on
> the copy as it scans block devices, not inside non-device files.

That's hours of dd and you have to find space to do it.


> After all, an LVM block-level snapshot takes the same space as a file
> containing the same raw data, and if there's room for the data in an LVM
> snapshot, given a different layout, there's room for exactly the same
> amount of data as a file on a different filesystem, piped thru some
> compressor if necessary due to tight datasize constraints.

That's not true for thin volume snapshots. They take up next to no
space upon creation, they don't need space reserved in advance.
They're more like a qcow2 snapshot than a conventional LVM snapshot; a
big difference being if you delete the snapshot, or you delete a bunch
of files in a thin volume and follow it with fstrim, the unused
extents are returned to the thin pool.

There has been a fragmentation problem with thin volumes; I don't know
if that's solved yet. And I don't know if it exacerbates things with
Btrfs fragmentation.


-- 
Chris Murphy
