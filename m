Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51232 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751352AbdFBOYK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 2 Jun 2017 10:24:10 -0400
Date: Fri, 2 Jun 2017 16:23:02 +0200
From: David Sterba <dsterba@suse.cz>
To: Omar Sandoval <osandov@osandov.com>
Cc: linux-btrfs@vger.kernel.org, Chris Mason <clm@fb.com>,
        Josef Bacik <jbacik@fb.com>, kernel-team@fb.com,
        stable@vger.kernel.org
Subject: Re: [PATCH] Btrfs: fix delalloc accounting leak caused by u32
 overflow
Message-ID: <20170602142302.GN12135@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <4d268ba97ee6511e4a8c42d39c64316d20eed9d0.1496391402.git.osandov@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4d268ba97ee6511e4a8c42d39c64316d20eed9d0.1496391402.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jun 02, 2017 at 01:20:01AM -0700, Omar Sandoval wrote:
> From: Omar Sandoval <osandov@fb.com>
> 
> btrfs_calc_trans_metadata_size() does an unsigned 32-bit multiplication,
> which can overflow if num_items >= 4 GB / (nodesize * BTRFS_MAX_LEVEL * 2).
> For a nodesize of 16kB, this overflow happens at 16k items. Usually,
> num_items is a small constant passed to btrfs_start_transaction(), but
> we also use btrfs_calc_trans_metadata_size() for metadata reservations
> for extent items in btrfs_delalloc_{reserve,release}_metadata().
> 
> In drop_outstanding_extents(), num_items is calculated as
> inode->reserved_extents - inode->outstanding_extents. The difference
> between these two counters is usually small, but if many delalloc
> extents are reserved and then the outstanding extents are merged in
> btrfs_merge_extent_hook(), the difference can become large enough to
> overflow in btrfs_calc_trans_metadata_size().
> 
> The overflow manifests itself as a leak of a multiple of 4 GB in
> delalloc_block_rsv and the metadata bytes_may_use counter. This in turn
> can cause early ENOSPC errors. Additionally, these WARN_ONs in
> extent-tree.c will be hit when unmounting:
> 
>     WARN_ON(fs_info->delalloc_block_rsv.size > 0);
>     WARN_ON(fs_info->delalloc_block_rsv.reserved > 0);
>     WARN_ON(space_info->bytes_pinned > 0 ||
>             space_info->bytes_reserved > 0 ||
>             space_info->bytes_may_use > 0);
> 
> Fix it by casting nodesize to a u64 so that
> btrfs_calc_trans_metadata_size() does a full 64-bit multiplication.
> While we're here, do the same in btrfs_calc_trunc_metadata_size(); this
> can't overflow with any existing uses, but it's better to be safe here
> than have another hard-to-debug problem later on.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Omar Sandoval <osandov@fb.com>

Reviewed-by: David Sterba <dsterba@suse.com>
