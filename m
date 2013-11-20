Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:33587 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754093Ab3KTRIk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 Nov 2013 12:08:40 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1VjBGY-00081N-Vz
	for linux-btrfs@vger.kernel.org; Wed, 20 Nov 2013 18:08:38 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 20 Nov 2013 18:08:38 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 20 Nov 2013 18:08:38 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfsck --repair /dev/sdc (Was: [PATCH] Btrfs-progs: allow
 --init-extent-tree to work when extent tree is borked)
Date: Wed, 20 Nov 2013 17:08:17 +0000 (UTC)
Message-ID: <pan$809d5$4354febd$5ff6e929$a8235336@cox.net>
References: <1382724100-5276-1-git-send-email-jbacik@fusionio.com>
	<l4ed62$8r3$1@ger.gmane.org> <20131025183134.GA4543@localhost.localdomain>
	<l4hifj$ni1$1@ger.gmane.org> <20131028151148.GB4543@localhost.localdomain>
	<l5eq5s$m8l$1@ger.gmane.org> <l5rn2s$m3p$1@ger.gmane.org>
	<l5vq48$2dh$1@ger.gmane.org> <l65l0s$lpm$1@ger.gmane.org>
	<l6f0pb$m6h$1@ger.gmane.org> <l6hm4u$s02$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Martin posted on Wed, 20 Nov 2013 06:51:20 +0000 as excerpted:

> It's now gone back to a pattern from a full week ago:
> 
> (gdb) bt #0  0x000000000042d576 in read_extent_buffer ()
> #1  0x000000000041ee79 in btrfs_check_node ()
> #2  0x0000000000420211 in check_block ()
> #3  0x0000000000420813 in btrfs_search_slot ()
> #4  0x0000000000427bb4 in btrfs_read_block_groups ()
> #5  0x0000000000423e40 in btrfs_setup_all_roots ()
> #6  0x000000000042406d in __open_ctree_fd ()
> #7  0x0000000000424126 in open_ctree_fs_info ()
> #8  0x000000000041812e in cmd_check ()
> #9  0x0000000000404904 in main ()
> 
> 
> I don't know if that has gone through that pattern during the week but
> at a-week-a-time, this is not going to finish in reasonable time.
> 
> How come so very slow?
> 
> Any hints/tips/fixes or abandon the test?

You're a patient man. =:^)

While I don't have any personal knowledge of btrfs on spinning rust 
times, nor of TiB sized times even on SSD, there's a comment in the wiki 
FAQ about balance times saying 20 hours is "normal" for 1 TB.

( https://btrfs.wiki.kernel.org/index.php/FAQ , search on "hours". )

OK, so we round that to a day a TB, double for your two TB, and double 
again in case your drive is much slower than the "normal" drive the 
comment might have been considering and because that's for a balance but 
you're doing a btrfsck --repair, which for all we know takes longer.

That's still "only" four days, and you've been going well over a week.  
At this point I think it's reasonably safe to conclude it's in some sort 
of loop and likely will never finish.

Which leads to the question of what to do next.  Obviously, there have 
been a number of update patches since then, some of which might address 
your problem.  You could update your kernel and userspace and try 
again... /if/ you have the patience... or just consider it lost, get 
anything you can off of it if you need to (I've forgotten what you tried 
in terms of that previously, or how desperate you are for that data, but 
if you've been waiting well over a week, I'd guess you have some reason 
to try to save it), do a mkfs (possibly with a wipe first) and try 
again.  You're a patient man, definitely, but at a week a shot, there 
comes a time when it's simply time to declare a loss and move on.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

