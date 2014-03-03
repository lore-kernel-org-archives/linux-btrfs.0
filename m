Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:49148 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754352AbaCCPLs (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 3 Mar 2014 10:11:48 -0500
Date: Mon, 3 Mar 2014 07:10:56 -0800
From: Marc MERLIN <marc@merlins.org>
To: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: 3.14.0-rc3 btrfs scrub is preventing my laptop from going to
 sleep
Message-ID: <20140303151056.GA18231@merlins.org>
References: <20140227190656.GA28338@merlins.org>
 <530FE3CE.70809@cn.fujitsu.com>
 <20140301050937.GD18300@merlins.org>
 <20140301152235.GA26926@merlins.org>
 <5313F45F.9090709@cn.fujitsu.com>
 <20140303052147.GB24835@merlins.org>
 <53142639.3030600@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <53142639.3030600@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Mar 03, 2014 at 02:50:33PM +0800, Wang Shilong wrote:
> >Here's the log of failure:
> >http://marc.merlins.org/tmp/btrfs_nofreeze2.txt
> 
> Unfortunately, i could not reproduce this problem here.
> 
> It should not be the problem that i addressed before, there is not
> deadlock here.
> try the attached patch and hopely it could solve your problem.(I
> know this is
> not polite:-) )
 
No worries, I appreciate your help, if you can't reproduce yourself I'm
happy to help.

> If the attached patch could not solve your problem, i will find a laptop and
> try to reproduce myself.

Unfortunately that didn't help

Freezing of tasks failed after 20.007 seconds (1 tasks refusing to freeze

btrfs           D ffff8803b212e900     0 15484      1 0x00000084
 ffff8803b2353958 0000000000000082 ffff8803b2353fd8 ffff8803b212e3d0
 00000000000141c0 ffff8803b212e3d0 ffff88040311e000 ffff8800cd098600
 0000000000000000 ffff8803aa3a6740 ffff88040311e220 ffff8803b2353968
Call Trace:
 [<ffffffff8160c311>] schedule+0x73/0x75
 [<ffffffff8126eb66>] scrub_pages+0x27e/0x42b
 [<ffffffff810850c9>] ? finish_wait+0x65/0x65
 [<ffffffff81271951>] scrub_stripe+0xada/0xca3
 [<ffffffff81271bf0>] scrub_chunk.isra.9+0xd6/0x10d
 [<ffffffff81271e9a>] scrub_enumerate_chunks+0x273/0x49f
 [<ffffffff81085000>] ? prepare_to_wait_event+0xba/0xf2
 [<ffffffff81272666>] btrfs_scrub_dev+0x254/0x3cb
 [<ffffffff8116dde3>] ? __mnt_want_write+0x62/0x78
 [<ffffffff81255e82>] btrfs_ioctl+0x1114/0x24b1
 [<ffffffff81015efa>] ? paravirt_sched_clock+0x9/0xd
 [<ffffffff810164a0>] ? sched_clock+0x9/0xb
 [<ffffffff811408bd>] ? ____cache_alloc+0x23e/0x29b
 [<ffffffff81140a09>] ? kmem_cache_alloc_node+0xef/0x179
 [<ffffffff8160e9eb>] ? _raw_spin_unlock+0x17/0x2a
 [<ffffffff81163b16>] do_vfs_ioctl+0x3d2/0x41d
 [<ffffffff8116bd38>] ? __fget+0x6f/0x79
 [<ffffffff81163bb8>] SyS_ioctl+0x57/0x82
 [<ffffffff816154ad>] system_call_fastpath+0x1a/0x1f

Restarting tasks ... done.

Cheers,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
