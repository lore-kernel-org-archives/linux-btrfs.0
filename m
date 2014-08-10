Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:58942 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751307AbaHJKQc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 10 Aug 2014 06:16:32 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XGQAu-0004XZ-6D
	for linux-btrfs@vger.kernel.org; Sun, 10 Aug 2014 12:16:28 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 10 Aug 2014 12:16:28 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 10 Aug 2014 12:16:28 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: 40TB volume taking over 16 hours to mount, any ideas?
Date: Sun, 10 Aug 2014 10:16:15 +0000 (UTC)
Message-ID: <pan$5f2d0$4150a54b$fca9a377$6a5344e7@cox.net>
References: <CAETJ_S-BOjatUFPVPwKCmgMRfWG6K0WEJgE=F_Di2i=52fqGCQ@mail.gmail.com>
	<2242759.aOKEuU2TTR@xev> <20140809143206.GJ11855@bitfolk.com>
	<CAETJ_S8rf4Y_7x4+fDB19JfNZYa1wjQOwTHcdCxd9eHq17NgXg@mail.gmail.com>
	<CAETJ_S-VZk5pxgT4HCJnQwenL6eDP88z7tW-KEHYqtnn=NWbww@mail.gmail.com>
	<pan$29b1$ee1dac$e6091513$d07b2702@cox.net>
	<CAETJ_S8347mtU6-o9BW=_Q27atdcj6P-aFZ1551S6G6rXBS8=A@mail.gmail.com>
	<CAETJ_S9HsWEYrV2zrfr8ZSD69SoFCiHnND38HLo8pq7ENiEPbw@mail.gmail.com>
	<CAETJ_S8DT=yW6V8bmAJ5s-+ZbuLjnDUK_XWEFRwK_p8hoR+LWA@mail.gmail.com>
	<pan$d6d2e$b19333f0$ee4ea84e$5a707866@cox.net>
	<CAGqmi75ne1BNzZdzU_RxOBEBaCgZsH0K1dLLUZ6y-YUn_byCbg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Timofey Titovets posted on Sun, 10 Aug 2014 11:50:39 +0300 as excerpted:

> Jose, I add my 50 cents,
> i know, what you want backup data from raid through network and what you
> have only 11 TB data from 40 TB fs As i now, you can safety resize btrfs
> fs, without btrfs fi resize, something like that:
> $ btrfs fi df /
> Data, single: total=81.00GiB, used=60.33GiB
> System, DUP: total=32.00MiB, used=16.00KiB
> Metadata, DUP: total=1.50GiB, used=507.48MiB
> GlobalReserve, single: total=176.00MiB, used=0.00B
> 
> - I can cut partitions to 81+1.5+~256 = 83g and + 1G for safety = 84G.
> And my data not lost and btrfs still working after this.
> After, you can use free space on the disk, to create new fs and backup
> data to him without problems,
> Developers, please сorrect me if I'm wrong.

You're correct, but two points, plus another less related one:

1) Most critical for the OP, he has to get the filesystem mounted and 
working first, and that's proving troublesome (tho with the patches I 
mentioned it might be doable).

2) While in theory you /could/ cut your filesystem even a bit further 
than that after a balance to trim down data usage (trimming it to ~61 GB 
allocated data area from the 81 GB current), given that btrfs can 
allocate chunks but requires a balance to deallocate, and data and 
metadata chunks can only be allocated from unallocated, not switched from 
one to the other directly, it's good to keep a reasonable safety margin 
of unallocated space.

The 1 GiB of unallocated space you propose since you didn't mention a 
balance is cutting it rather close, particularly since data chunks are 
normally 1 GiB.  On a filesystem around that size I'd recommend keeping 
10 GiB or so free at least, so maybe 95 GiB minimum in the example, or 
about 75 GiB minimum if you did a data-balance first, cutting data chunk 
allocation to 61 GiB and total allocated to ~63 GiB.

On a bit over 10 TiB of usage, however, I'd suggest keeping perhaps half 
a TiB spare/unallocated, so on 11 TiB data usage and perhaps half a TiB 
of metadata usage, resizing the filesystem no smaller than say 12 TiB, 
but 15 TiB would be somewhat more comfortable.

3) But that's a lot of data in a single filesystem basket.  Balancing or 
btrfs checking simply takes a LONG time at that size, let alone backup 
and restore of the entire thing.  So I'd suggest breaking it up into 
perhaps TiB sized independent filesystems, as well, if possible.  If say 
only half of them need mounted at a time, and half of those can be read-
only mounted, then that's "only" 2-3 TiB of data to balance/check/restore 
if something goes wrong, the rest with any luck should be unaffected as 
it wasn't mounted or was read-only mounted, and 2-3 TiB will take a lot 
less time to process than 10+ TiB, for sure.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

