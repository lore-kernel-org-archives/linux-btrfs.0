Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f174.google.com ([209.85.213.174]:36538 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752360AbbHJCZf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 9 Aug 2015 22:25:35 -0400
Received: by igbij6 with SMTP id ij6so61234537igb.1
        for <linux-btrfs@vger.kernel.org>; Sun, 09 Aug 2015 19:25:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20150809124725.GA5486@carfax.org.uk>
References: <CAMoY8LpmhQtSvW-sWbGKDFKNN3xaKPwe+QxU5wCMg2Wcz3ObWA@mail.gmail.com>
	<20150809124725.GA5486@carfax.org.uk>
Date: Sun, 9 Aug 2015 22:25:35 -0400
Message-ID: <CAGfcS_kZmWY8PkG8YH_Wp5nFuFygK=VWi7fcimPCubHwwm6M9Q@mail.gmail.com>
Subject: Re: raid1 on uneven-sized disks
From: Rich Freeman <r-btrfs@thefreemanclan.net>
To: Hugo Mills <hugo@carfax.org.uk>, Jim MacBaine <jmacbaine@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Aug 9, 2015 at 8:47 AM, Hugo Mills <hugo@carfax.org.uk> wrote:
> On Sun, Aug 09, 2015 at 02:29:53PM +0200, Jim MacBaine wrote:
>> Hi,
>>
>> How does btrfs handle raid1 on a bunch of uneven sized disks? Can I
>> just keep adding arbitrarily sized disks to an existing raid1 and
>> expect the file system to continue to keep two copies of everything,
>> so I could survive the loss of any single disk without data loss? Does
>> btrfs work this way?
>
>    Yes, exactly.
>
>    You may find that http://carfax.org.uk/btrfs-usage/ is helpful.
>

The key is that btrfs manages "raid" at the chunk level, not the
device level.  When btrfs needs more disk space it allocates a new
chunk from unallocated space on a device.  If it is in raid1 mode it
will allocate a pair of chunks from two different drives, storing the
same data in each.  The allocation algorithm is reasonably smart so if
you have 2x1TB drives and 1x3TB drive you'll end up with about 2TB of
data stored and not 1TB on each of the two 1TB drives and an empty
unusable 3TB drive.

This is also why you can switch between raid modes "on the fly" -
switching modes only affects newly-allocated chunks, and the old ones
operate in whatever mode they were previously in.  A balance operation
rewrites the existing data to new chunks which would force everything
to use the new mode.

This also lets you do things like add a disk to a raid5.  If you have
5 disks and add one more, existing chunks will be striped across 5
drives, and new chunks will be striped across 6, unless you balance
them.

That may be a bit oversimplified, and obviously others on the list
know all the details...

--
Rich
