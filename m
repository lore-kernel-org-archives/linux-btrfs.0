Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:55861 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932072Ab3E0MHE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 May 2013 08:07:04 -0400
Date: Mon, 27 May 2013 14:07:00 +0200
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/5] Btrfs: fix use-after-free bug during umount
Message-ID: <20130527120700.GB28422@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1369576231-17836-1-git-send-email-bo.li.liu@oracle.com>
 <1369576231-17836-2-git-send-email-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1369576231-17836-2-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, May 26, 2013 at 09:50:27PM +0800, Liu Bo wrote:
> Commit be283b2e674a09457d4563729015adb637ce7cc1
> (    Btrfs: use helper to cleanup tree roots) introduced the following bug,

Well, it did not introduce the bug, but made it visible.

> We've free'ed commit_root before actually getting to free block groups where
> caching thread needs valid extent_root->commit_root.
> 
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> ---
>  fs/btrfs/disk-io.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index e7b3cb5..a5c8f28 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -3512,10 +3512,10 @@ int close_ctree(struct btrfs_root *root)
>  		       percpu_counter_sum(&fs_info->delalloc_bytes));
>  	}
>  
> -	free_root_pointers(fs_info, 1);
> -
>  	btrfs_free_block_groups(fs_info);
>  
> +	free_root_pointers(fs_info, 1);
> +
>  	del_fs_roots(fs_info);
>  
>  	iput(fs_info->btree_inode);

This makes it just harder to hit, but the worker threads that get
stopped after iput may still access the freed roots, like mentioned here

http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg24239.html

david
