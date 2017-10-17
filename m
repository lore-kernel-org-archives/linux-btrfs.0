Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:52260 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S932782AbdJQW57 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 17 Oct 2017 18:57:59 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1e4anw-0005Oq-VN
        for linux-btrfs@vger.kernel.org; Wed, 18 Oct 2017 00:57:44 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Best strategie to remove devices from pool
Date: Tue, 17 Oct 2017 22:57:27 +0000 (UTC)
Message-ID: <pan$9b46f$9dad1141$c719d4ab$389f4bee@cox.net>
References: <1508263135.2887.1.camel@cloud.haefemeier.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Cloud Admin posted on Tue, 17 Oct 2017 19:58:55 +0200 as excerpted:

> Hi,
> I want to remove two devices from a BTRFS RAID 1 pool. It should be
> enough free space to do it, but what is the best strategie. Remove both
> device in one call 'btrfs dev rem /dev/sda1 /dev/sdb1' (for example) or
> should it be better in two separate calls? What is faster? Are there
> other constraints to think about?

As a general policy, I'd first ensure that I had current backups in case 
something goes wrong, unless of course you consider the data trivial 
enough not to bother with backups.  No sense unnecessarily tempting fate. 
=:^\

Then I'd use the two devices in one call remove, because btrfs device 
remove has an implicit rebalance that moves chunks off the device being 
removed to the other available devices, and a rebalance can take awhile, 
so doing two removals at once should go much faster than one at a time.

I'd also suggest that if you use btrfs quota functionality, you disable 
it at least while doing the removes/balances, as trying to recalculate 
the quotas constantly slows things down considerably, and if you have 
lots of subvolume snapshots on the filesystem, I suggest you first delete 
as many of those as you can reasonably delete (and turn off any scheduled 
snapshotting during the remove/rebalance), as well, because they too can 
slow down balances quite a bit.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

