Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36870 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756489AbdKOQRB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 15 Nov 2017 11:17:01 -0500
Date: Wed, 15 Nov 2017 17:15:07 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz,
        Filipe Manana <fdmanana@gmail.com>
Subject: Re: [PATCH v2 1/3] btrfs: tree-checker: Fix false panic for sanity
 test
Message-ID: <20171115161507.GQ28899@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20171108005426.17903-1-wqu@suse.com>
 <20171108005426.17903-2-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20171108005426.17903-2-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Nov 08, 2017 at 08:54:24AM +0800, Qu Wenruo wrote:
> [BUG]
> If we run btrfs with CONFIG_BTRFS_FS_RUN_SANITY_TESTS=y, it will
> instantly cause kernel panic like:
> 
> ------
> ...
> assertion failed: 0, file: fs/btrfs/disk-io.c, line: 3853
> ...
> Call Trace:
>  btrfs_mark_buffer_dirty+0x187/0x1f0 [btrfs]
>  setup_items_for_insert+0x385/0x650 [btrfs]
>  __btrfs_drop_extents+0x129a/0x1870 [btrfs]
> ...
> -----
> 
> [Cause]
> Btrfs will call btrfs_check_leaf() in btrfs_mark_buffer_dirty() to check
> if the leaf is valid with CONFIG_BTRFS_FS_RUN_SANITY_TESTS=y.
> 
> However quite some btrfs_mark_buffer_dirty() callers(*) don't really
> initialize its item data but only initialize its item pointers, leaving
> item data uninitialized.
> 
> This makes tree-checker catch uninitialized data as error, causing
> such panic.
> 
> *: These callers include but not limited to
> setup_items_for_insert()
> btrfs_split_item()
> btrfs_expand_item()
> 
> [Fix]
> Add a new parameter @check_item_data to btrfs_check_leaf().
> With @check_item_data set to false, item data check will be skipped and
> fallback to old btrfs_check_leaf() behavior.
> 
> So we can still get early warning if we screw up item pointers, and
> avoid false panic.
> 
> Cc: Filipe Manana <fdmanana@gmail.com>
> Reported-by: Lakshmipathi.G <lakshmipathi.g@gmail.com>
> Signed-off-by: Qu Wenruo <wqu@suse.com>

Reviewed-by: David Sterba <dsterba@suse.com>
