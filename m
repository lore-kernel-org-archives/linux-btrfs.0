Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51010 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728313AbeIUVTP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 21 Sep 2018 17:19:15 -0400
Date: Fri, 21 Sep 2018 17:29:49 +0200
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.liu@linux.alibaba.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] Btrfs: remove wait_ordered_rane in btrfs_evict_inode
Message-ID: <20180921152949.GM5847@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1536703587-94565-3-git-send-email-bo.liu@linux.alibaba.com>
 <1536959008-17291-1-git-send-email-bo.liu@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1536959008-17291-1-git-send-email-bo.liu@linux.alibaba.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Sep 15, 2018 at 05:03:28AM +0800, Liu Bo wrote:
> When we delete an inode,
> 
> btrfs_evict_inode() {
>     truncate_inode_pages_final()
>         truncate_inode_pages_range()
>             lock_page()
>             truncate_cleanup_page()
>                  btrfs_invalidatepage()
>                       wait_on_page_writeback
>                            btrfs_lookup_ordered_range()
>                  cancel_dirty_page()
>            unlock_page()
>      ...    
>      btrfs_wait_ordered_range()
>      ...
> 
> As VFS has called ->invalidatepage() to get all ordered extents done
> (if there is any) and truncated all page cache pages (no dirty pages
> to writeback after this step), wait_ordered_range() is just a noop.
> 
> Reviewed-by: David Sterba <dsterba@suse.com>
> Signed-off-by: Liu Bo <bo.liu@linux.alibaba.com>
> ---
> v2: More details in the description.

Thanks, patch updated.
