Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f182.google.com ([209.85.223.182]:42535 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755986Ab3L3QCY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 30 Dec 2013 11:02:24 -0500
Received: by mail-ie0-f182.google.com with SMTP id as1so12110078iec.41
        for <linux-btrfs@vger.kernel.org>; Mon, 30 Dec 2013 08:02:24 -0800 (PST)
Message-ID: <52C1990D.9060704@gmail.com>
Date: Mon, 30 Dec 2013 11:02:21 -0500
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
MIME-Version: 1.0
To: Kai Krakow <hurikhan77+btrfs@gmail.com>, linux-btrfs@vger.kernel.org
Subject: Re: Migrate to bcache: A few questions
References: <kof6pa-akd.ln1@hurikhan77.spdns.de>
In-Reply-To: <kof6pa-akd.ln1@hurikhan77.spdns.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 12/29/2013 04:11 PM, Kai Krakow wrote:
> Hello list!
> 
> I'm planning to buy a small SSD (around 60GB) and use it for bcache in front 
> of my 3x 1TB HDD btrfs setup (mraid1+draid0) using write-back caching. Btrfs 
> is my root device, thus the system must be able to boot from bcache using 
> init ramdisk. My /boot is a separate filesystem outside of btrfs and will be 
> outside of bcache. I am using Gentoo as my system.
> 
> I have a few questions:
> 
> * How stable is it? I've read about some csum errors lately...
> 
> * I want to migrate my current storage to bcache without replaying a backup.
>   Is it possible?
> 
> * Did others already use it? What is the perceived performance for desktop
>   workloads in comparision to not using bcache?
> 
> * How well does bcache handle power outages? Btrfs does handle them very
>   well since many months.
> 
> * How well does it play with dracut as initrd? Is it as simple as telling it
>   the new device nodes or is there something complicate to configure?
> 
> * How does bcache handle a failing SSD when it starts to wear out in a few
>   years?
> 
> * Is it worth waiting for hot-relocation support in btrfs to natively use
>   a SSD as cache?
> 
> * Would you recommend going with a bigger/smaller SSD? I'm planning to use
>   only 75% of it for bcache so wear-leveling can work better, maybe use
>   another part of it for hibernation (suspend to disk).
I've actually tried a simmilar configuration myself a couple of times
(also using Gentoo in-fact), and I can tell you from experience that
unless things have changed greatly since kernel 3.12.1, it really isn't
worth the headaches.  Setting it up on an already installed system is a
serious pain because the backing device has to be reformatted with a
bcache super-block.  In addition, every kernel that I have tried that
had bcache compiled in or loaded as a module had issues, I would see a
kernel OOPS on average once a day from the bcache code, usually followed
shortly by a panic from some other unrelated subsystem.  I didn't get
any actual data corruption, but I wasn't using btrfs at the time for any
of my filesystems.

As an alternative to using bcache, you might try something simmilar to
the following:
    64G SSD with /boot, /, and /usr
    Other HDD with /var, /usr/portage, /usr/src, and /home
    tmpfs or ramdisk for /tmp and /var/tmp
This is essentially what I use now, and I have found that it
significantly improves system performance.
