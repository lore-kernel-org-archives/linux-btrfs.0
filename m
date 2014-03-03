Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:52490 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754568AbaCCWGC (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 3 Mar 2014 17:06:02 -0500
Date: Mon, 3 Mar 2014 14:05:58 -0800
From: Marc MERLIN <marc@merlins.org>
To: Josef Bacik <jbacik@fb.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: 3.14.0-rc3 btrfs scrub is preventing my laptop from going to
 sleep
Message-ID: <20140303220558.GA16865@merlins.org>
References: <20140227190656.GA28338@merlins.org>
 <5314B446.6000400@fb.com>
 <5314B737.10609@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5314B737.10609@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Mar 03, 2014 at 12:09:11PM -0500, Josef Bacik wrote:
> Ok I lied I just went ahead and did it, please let me know if this
> fixes it

This looked promising, but I still have the problem.

PM: Syncing filesystems ... done.
PM: Preparing system for mem sleep
Freezing user space processes ... 
Freezing of tasks failed after 20.005 seconds (1 tasks refusing to freeze, wq_busy=0):
btrfs           D ffff8800b9c60840     0 12711      1 0x00000084
 ffff8803bc475958 0000000000000086 ffff8803bc475fd8 ffff8800b9c60310
 00000000000141c0 ffff8800b9c60310 ffff8803cd8d8000 ffff8800ca31d300
 0000000000000000 ffff8803b2306b40 ffff8803cd8d8220 ffff8803bc475968
Call Trace:
 [<ffffffff8160c331>] schedule+0x73/0x75
 [<ffffffff8126eb7e>] scrub_pages+0x27e/0x426
 [<ffffffff810850c9>] ? finish_wait+0x65/0x65
 [<ffffffff81271964>] scrub_stripe+0xada/0xc9e
 [<ffffffff81271bfe>] scrub_chunk.isra.9+0xd6/0x10d
 [<ffffffff81271ea8>] scrub_enumerate_chunks+0x273/0x49f
 [<ffffffff81085000>] ? prepare_to_wait_event+0xba/0xf2
 [<ffffffff81272674>] btrfs_scrub_dev+0x254/0x3cb
 [<ffffffff8116dde3>] ? __mnt_want_write+0x62/0x78
 [<ffffffff81255e9a>] btrfs_ioctl+0x1114/0x24b1
 [<ffffffff8114069b>] ? ____cache_alloc+0x1c/0x29b
 [<ffffffff81140a09>] ? kmem_cache_alloc_node+0xef/0x179
 [<ffffffff8160ea0b>] ? _raw_spin_unlock+0x17/0x2a
 [<ffffffff81163b16>] do_vfs_ioctl+0x3d2/0x41d
 [<ffffffff8116bd38>] ? __fget+0x6f/0x79
 [<ffffffff81163bb8>] SyS_ioctl+0x57/0x82
 [<ffffffff816154ad>] system_call_fastpath+0x1a/0x1f

I compared with the previous kernel, and it's mostly the same trace:
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

I'm not too sure why the scrub didn't stop as per your patch.

Maybe it will work if we cancel the scrub as opposed to pausing it, but
of course it's not ideal.
Is that the next step?

Thanks,
Marc
-- 
"a mouse is a device used to point at the xterm you want to type in" - a.s.r.
microsoft is to operating systems ....
                                      .... what mcdonalds is to gourmet cooking
home page: http://marc.merlins.org/                         | pgp 1024r/763be901
