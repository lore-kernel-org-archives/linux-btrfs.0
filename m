Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37059 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751889AbeDLNiL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 12 Apr 2018 09:38:11 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id D822FADCC
        for <linux-btrfs@vger.kernel.org>; Thu, 12 Apr 2018 13:38:09 +0000 (UTC)
Date: Thu, 12 Apr 2018 15:35:40 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH for 4.7-rc 1/2] btrfs: Remove first key verification
 since it's causing false alerts
Message-ID: <20180412133540.GJ21272@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180412100003.31907-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180412100003.31907-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Apr 12, 2018 at 06:00:02PM +0800, Qu Wenruo wrote:
> When looping btrfs/074 with many cpus (>= 8), it's possible to trigger
> kernel warning due to first key verification:
> 
> [ 4239.523446] WARNING: CPU: 5 PID: 2381 at fs/btrfs/disk-io.c:460 btree_read_extent_buffer_pages+0x1ad/0x210
> [ 4239.523830] Modules linked in:
> [ 4239.524630] RIP: 0010:btree_read_extent_buffer_pages+0x1ad/0x210
> [ 4239.527101] Call Trace:
> [ 4239.527251]  read_tree_block+0x42/0x70
> [ 4239.527434]  read_node_slot+0xd2/0x110
> [ 4239.527632]  push_leaf_right+0xad/0x1b0
> [ 4239.527809]  split_leaf+0x4ea/0x700
> [ 4239.527988]  ? leaf_space_used+0xbc/0xe0
> [ 4239.528192]  ? btrfs_set_lock_blocking_rw+0x99/0xb0
> [ 4239.528416]  btrfs_search_slot+0x8cc/0xa40
> [ 4239.528605]  btrfs_insert_empty_items+0x71/0xc0
> [ 4239.528798]  __btrfs_run_delayed_refs+0xa98/0x1680
> [ 4239.529013]  btrfs_run_delayed_refs+0x10b/0x1b0
> [ 4239.529205]  btrfs_commit_transaction+0x33/0xaf0
> [ 4239.529445]  ? start_transaction+0xa8/0x4f0
> [ 4239.529630]  btrfs_alloc_data_chunk_ondemand+0x1b0/0x4e0
> [ 4239.529833]  btrfs_check_data_free_space+0x54/0xa0
> [ 4239.530045]  btrfs_delalloc_reserve_space+0x25/0x70
> [ 4239.531907]  btrfs_direct_IO+0x233/0x3d0
> [ 4239.532098]  generic_file_direct_write+0xcb/0x170
> [ 4239.532296]  btrfs_file_write_iter+0x2bb/0x5f4
> [ 4239.532491]  aio_write+0xe2/0x180
> [ 4239.532669]  ? lock_acquire+0xac/0x1e0
> [ 4239.532839]  ? __might_fault+0x3e/0x90
> [ 4239.533032]  do_io_submit+0x594/0x860
> [ 4239.533223]  ? do_io_submit+0x594/0x860
> [ 4239.533398]  SyS_io_submit+0x10/0x20
> [ 4239.533560]  ? SyS_io_submit+0x10/0x20
> [ 4239.533729]  do_syscall_64+0x75/0x1d0
> [ 4239.533979]  entry_SYSCALL_64_after_hwframe+0x42/0xb7
> [ 4239.534182] RIP: 0033:0x7f8519741697
> 
> The possibility is low, around 4~7/128 runs with 8 cores.
> The problem here is, at btree_read_extent_buffer_pages() we don't have
> acquired read/write lock on that extent buffer, only basic info like
> level/bytenr is reliable.
> 
> To get correct first key, we must require at least read lock for that
> extent buffer, which can't be done in btree_read_extent_buffer_pages(),
> but deep into core btree operation code.
> 
> This patch will remove the unreliable first key check to avoid false
> alerts, and allow later patch to re-implement first key check correctly.

We'll have to disable the first key check in a less intrusive way, eg.
taking a shortcut in verify_level_key. The patch has was added in
recent pull, I'm not going to do full a revert now.
