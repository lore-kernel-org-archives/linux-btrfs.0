Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wj0-f193.google.com ([209.85.210.193]:34664 "EHLO
        mail-wj0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755247AbcLNKRr (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 14 Dec 2016 05:17:47 -0500
Date: Wed, 14 Dec 2016 11:17:44 +0100
From: Michal Hocko <mhocko@kernel.org>
To: David Arendt <admin@prnet.org>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Sterba <dsterba@suse.cz>, Chris Mason <clm@fb.com>
Subject: Re: page allocation stall in kernel 4.9 when copying files from one
 btrfs hdd to another
Message-ID: <20161214101743.GA25578@dhcp22.suse.cz>
References: <bd1cf980-56cc-3212-8de0-b2cc1bf576cf@prnet.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <bd1cf980-56cc-3212-8de0-b2cc1bf576cf@prnet.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue 13-12-16 18:11:01, David Arendt wrote:
> Hi,
> 
> I receive the following page allocation stall while copying lots of
> large files from one btrfs hdd to another.
> 
> Dec 13 13:04:29 server kernel: kworker/u16:8: page allocation stalls for 12260ms, order:0, mode:0x2400840(GFP_NOFS|__GFP_NOFAIL)
> Dec 13 13:04:29 server kernel: CPU: 0 PID: 24959 Comm: kworker/u16:8 Tainted: P           O    4.9.0 #1
[...]
> Dec 13 13:04:29 server kernel: Call Trace:
> Dec 13 13:04:29 server kernel:  [<ffffffff813f3a59>] ? dump_stack+0x46/0x5d
> Dec 13 13:04:29 server kernel:  [<ffffffff81114fc1>] ? warn_alloc+0x111/0x130
> Dec 13 13:04:33 server kernel:  [<ffffffff81115c38>] ? __alloc_pages_nodemask+0xbe8/0xd30
> Dec 13 13:04:33 server kernel:  [<ffffffff8110de74>] ? pagecache_get_page+0xe4/0x230
> Dec 13 13:04:33 server kernel:  [<ffffffff81323a8b>] ? alloc_extent_buffer+0x10b/0x400
> Dec 13 13:04:33 server kernel:  [<ffffffff812ef8c5>] ? btrfs_alloc_tree_block+0x125/0x560

OK, so this is
	find_or_create_page(mapping, index, GFP_NOFS|__GFP_NOFAIL)

The main question is whether this really needs to be NOFS request...

> Dec 13 13:04:33 server kernel:  [<ffffffff8132442f>] ? read_extent_buffer_pages+0x21f/0x280
> Dec 13 13:04:33 server kernel:  [<ffffffff812d81f1>] ? __btrfs_cow_block+0x141/0x580
> Dec 13 13:04:33 server kernel:  [<ffffffff812d87b0>] ? btrfs_cow_block+0x100/0x150
> Dec 13 13:04:33 server kernel:  [<ffffffff812dc1d9>] ?  btrfs_search_slot+0x1e9/0x9c0
> Dec 13 13:04:33 server kernel:  [<ffffffff8131ead2>] ? __set_extent_bit+0x512/0x550
> Dec 13 13:04:33 server kernel:  [<ffffffff812e1ab5>] ? lookup_inline_extent_backref+0xf5/0x5e0
> Dec 13 13:04:34 server kernel:  [<ffffffff8131f0a4>] ? set_extent_bit+0x24/0x30
> Dec 13 13:04:34 server kernel:  [<ffffffff812e4334>] ? update_block_group.isra.34+0x114/0x380
> Dec 13 13:04:34 server kernel:  [<ffffffff812e4694>] ? __btrfs_free_extent.isra.35+0xf4/0xd20
> Dec 13 13:04:34 server kernel:  [<ffffffff8134d561>] ? btrfs_merge_delayed_refs+0x61/0x5d0
> Dec 13 13:04:34 server kernel:  [<ffffffff812e8bd2>] ? __btrfs_run_delayed_refs+0x902/0x10a0
> Dec 13 13:04:34 server kernel:  [<ffffffff812ec0f0>] ? btrfs_run_delayed_refs+0x90/0x2a0
> Dec 13 13:04:34 server kernel:  [<ffffffff812ec384>] ? delayed_ref_async_start+0x84/0xa0

What would cause the reclaim recursion?

> Dec 13 13:04:34 server kernel: Mem-Info:
> Dec 13 13:04:34 server kernel: active_anon:20 inactive_anon:34
> isolated_anon:0\x0a active_file:7370032 inactive_file:450105
> isolated_file:320\x0a unevictable:0 dirty:522748 writeback:189
> unstable:0\x0a slab_reclaimable:178255 slab_unreclaimable:124617\x0a
> mapped:4236 shmem:0 pagetables:1163 bounce:0\x0a free:38224 free_pcp:241
> free_cma:0

This speaks for itself. There is a lot of dirty data, basically no
anonymous memory and GFP_NOFS cannot do much to reclaim obviously. This
is either a configuraion bug as somebody noted down the thread (setting
the dirty_ratio) or suboptimality of the btrfs code which might request
NOFS even though it is not strictly necessary. This would be more for
btrfs developers.
-- 
Michal Hocko
SUSE Labs
