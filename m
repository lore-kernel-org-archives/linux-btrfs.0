Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41649 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754999AbeEHROE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 8 May 2018 13:14:04 -0400
Date: Tue, 8 May 2018 19:11:26 +0200
From: David Sterba <dsterba@suse.cz>
To: Su Yue <suy.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH v5 00/16] btrfs-progs: lowmem: avoid extents overwrite
Message-ID: <20180508171126.GK6649@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180508083012.12090-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180508083012.12090-1-suy.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 08, 2018 at 04:29:56PM +0800, Su Yue wrote:
> Su Yue (16):
>   btrfs-progs: check: move pin_down_tree_blocks to mode-common.c
>   btrfs-progs: lowmem: exclude extents of metadata blocks
>   btrfs-progs: lowmem: introduce mark/clear_block_groups_full()
>   btrfs-progs: lowmem: introduce try_force_cow_in_new_chunk()
>   btrfs-progs: lowmem: introduce avoid_extents_overwrite()
>   btrfs-progs: lowmem: exclude extents if init-extent-tree in lowmem
>   btrfs-progs: lowmem: start to remove parameters @trans in lowmem
>   btrfs-progs: lowmem: remove parameter @trans of delete_extent_item()
>   btrfs-progs: lowmem: remove parameter @trans of repair_chunk_item()
>   btrfs-progs: lowmem: remove parameter @trans of repair_extent_item()
>   btrfs-progs: lowmem: remove parameter @trans of check_leaf_items()
>   btrfs-progs: lowmem: remove parameter @trans of repair_tree_back_ref()
>   btrfs-progs: lowmem: remove parameter @trans of check_btrfs_root()
>   btrfs-progs: lowmem: introduce repair_block_accounting()
>   btrfs-progs: lowmem: end of removing parameters @trans in lowmem
>   btrfs-progs: fsck-tests: add image no extent with normal device size

Applied, thanks. I did a light review and run some tests, please send
any updates as incremental changes if you find bugs or need cleanups
related to this patchset or lowmem mode.
