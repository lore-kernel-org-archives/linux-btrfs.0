Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from syrinx.knorrie.org ([82.94.188.77]:41634 "EHLO
        syrinx.knorrie.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750898AbdLAPj0 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 1 Dec 2017 10:39:26 -0500
Subject: Re: btrfs-transacti hammering the system
To: Matt McKinnon <matt@techsquare.com>, linux-btrfs@vger.kernel.org
References: <bb2cfbcb-31dd-715c-114f-59d574a2012b@techsquare.com>
 <9703c200-28af-f26d-b3b2-6982fb289ac8@mendix.com>
 <1d11e03c-7d02-3f66-8b97-4c1b857566fa@techsquare.com>
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Message-ID: <b52265f9-2703-7f25-b1b9-6e84bc7db62e@mendix.com>
Date: Fri, 1 Dec 2017 16:39:22 +0100
MIME-Version: 1.0
In-Reply-To: <1d11e03c-7d02-3f66-8b97-4c1b857566fa@techsquare.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 12/01/2017 04:24 PM, Matt McKinnon wrote:
> Thanks for this.  Here's what I get:

Ok, and which one is displaying most of the time?

> [...]
> 
> [<ffffffffaa0a8406>] io_schedule+0x16/0x40
> [<ffffffffaa3b3cde>] get_request+0x23e/0x720
> [<ffffffffaa3b6861>] blk_queue_bio+0xc1/0x3a0
> [<ffffffffaa3b4a88>] generic_make_request+0xf8/0x2a0
> [<ffffffffaa3b4ca5>] submit_bio+0x75/0x150
> [<ffffffffc087fac5>] btrfs_map_bio+0xe5/0x2f0 [btrfs]
> [<ffffffffc084834c>] btree_submit_bio_hook+0x8c/0xe0 [btrfs]
> [<ffffffffc086f1e3>] submit_one_bio+0x63/0xa0 [btrfs]
> [<ffffffffc086f39b>] flush_epd_write_bio+0x3b/0x50 [btrfs]
> [<ffffffffc086f3be>] flush_write_bio+0xe/0x10 [btrfs]
> [<ffffffffc08777a9>] btree_write_cache_pages+0x379/0x450 [btrfs]
> [<ffffffffc08478ed>] btree_writepages+0x5d/0x70 [btrfs]
> [<ffffffffaa1a326c>] do_writepages+0x1c/0x70
> [<ffffffffaa196f2a>] __filemap_fdatawrite_range+0xaa/0xe0
> [<ffffffffaa197023>] filemap_fdatawrite_range+0x13/0x20
> [<ffffffffc084fba9>] btrfs_write_marked_extents+0xe9/0x110 [btrfs]
> [<ffffffffc084fc4d>] btrfs_write_and_wait_transaction.isra.22+0x3d/0x80
> [btrfs]
> [<ffffffffc0851645>] btrfs_commit_transaction+0x665/0x900 [btrfs]
> 
> [...]
> 
> [<ffffffffaa0a8406>] io_schedule+0x16/0x40
> [<ffffffffaa1959c8>] wait_on_page_bit+0xe8/0x120
> [<ffffffffc087639d>] read_extent_buffer_pages+0x1cd/0x2e0 [btrfs]
> [<ffffffffc0846fcf>] btree_read_extent_buffer_pages+0x9f/0x100 [btrfs]
> [<ffffffffc0848542>] read_tree_block+0x32/0x50 [btrfs]
> [<ffffffffc0828980>] read_block_for_search.isra.32+0x120/0x2e0 [btrfs]
> [<ffffffffc082daa5>] btrfs_next_old_leaf+0x215/0x400 [btrfs]
> [<ffffffffc082dca0>] btrfs_next_leaf+0x10/0x20 [btrfs]
> [<ffffffffc0843c3e>] btrfs_lookup_csums_range+0x12e/0x410 [btrfs]
> [<ffffffffc08d09ea>] csum_exist_in_range.isra.49+0x2a/0x81 [btrfs]
> [<ffffffffc08596a2>] run_delalloc_nocow+0x9b2/0xa10 [btrfs]
> [<ffffffffc0859768>] run_delalloc_range+0x68/0x340 [btrfs]
> [<ffffffffc0872070>] writepage_delalloc.isra.47+0xf0/0x140 [btrfs]
> [<ffffffffc0872f97>] __extent_writepage+0xc7/0x290 [btrfs]
> [<ffffffffc0873415>] extent_write_cache_pages.constprop.53+0x2b5/0x450
> [btrfs]
> [<ffffffffc0874fed>] extent_writepages+0x4d/0x70 [btrfs]
> [<ffffffffc0852d88>] btrfs_writepages+0x28/0x30 [btrfs]
> [<ffffffffaa1a326c>] do_writepages+0x1c/0x70
> [<ffffffffaa196f2a>] __filemap_fdatawrite_range+0xaa/0xe0
> [<ffffffffaa197023>] filemap_fdatawrite_range+0x13/0x20
> [<ffffffffc08695c0>] btrfs_fdatawrite_range+0x20/0x50 [btrfs]
> [<ffffffffc089abf9>] __btrfs_write_out_cache+0x3d9/0x420 [btrfs]
> [<ffffffffc089b066>] btrfs_write_out_cache+0x86/0x100 [btrfs]
> [<ffffffffc083bc61>] btrfs_write_dirty_block_groups+0x261/0x390 [btrfs]
> [<ffffffffc084e83b>] commit_cowonly_roots+0x1fb/0x290 [btrfs]
> [<ffffffffc0851414>] btrfs_commit_transaction+0x434/0x900 [btrfs]

1) The one right above, btrfs_write_out_cache, is the write-out of the
free space cache v1. Do you see this for multiple seconds going on, and
does it match the time when it's writing X MB/s to disk?

2) How big is this filesystem? What does your `btrfs fi df /mountpoint` say?

3) What kind of workload are you running? E.g. how can you describe it
within a range from "big files which just sit there" to "small writes
and deletes all over the place all the time"?

4) What kernel version is this? `uname -a` output?


-- 
Hans van Kranenburg
