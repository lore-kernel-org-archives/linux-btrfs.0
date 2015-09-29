Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55937 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965227AbbI2OWf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Sep 2015 10:22:35 -0400
Date: Tue, 29 Sep 2015 16:21:34 +0200
From: David Sterba <dsterba@suse.cz>
To: Zhao Lei <zhaolei@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: fix a compiler warning of may be used
 uninitialized
Message-ID: <20150929142134.GC11442@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <09827c6fe97dbbeb585e6214f7e40699061b8fc6.1441178370.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <09827c6fe97dbbeb585e6214f7e40699061b8fc6.1441178370.git.zhaolei@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Sep 02, 2015 at 03:19:59PM +0800, Zhao Lei wrote:
> Not real problem, just avoid warning of:
>  fs/btrfs/inode-map.c: In function 'btrfs_unpin_free_ino':
>  fs/btrfs/inode-map.c:252: warning: 'count' may be used uninitialized in this function
> In gcc 4.8.3
> 
> Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
> ---
>  fs/btrfs/inode-map.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/inode-map.c b/fs/btrfs/inode-map.c
> index d4a582a..e094e3b 100644
> --- a/fs/btrfs/inode-map.c
> +++ b/fs/btrfs/inode-map.c
> @@ -249,7 +249,7 @@ void btrfs_unpin_free_ino(struct btrfs_root *root)
>  	spinlock_t *rbroot_lock = &root->free_ino_pinned->tree_lock;
>  	struct btrfs_free_space *info;
>  	struct rb_node *n;
> -	u64 count;
> +	u64 count = 0;

AFAICS the codepath that would use uninitialized value of count is not
reachable:

		    add_to_ctl = true

270                 if (info->offset > root->ino_cache_progress)
271                         add_to_ctl = false;
272                 else if (info->offset + info->bytes > root->ino_cache_progress)
273                         count = root->ino_cache_progress - info->offset + 1;
274                 else
275                         count = info->bytes;
276
277                 rb_erase(&info->offset_index, rbroot);
278                 spin_unlock(rbroot_lock);
279                 if (add_to_ctl)
280                         __btrfs_add_free_space(ctl, info->offset, count);

count is defined iff add_to_ctl == true, so the patch is not necessary. And I'm
not quite sure that 0 passed down to __btrfs_add_free_space as 'bytes' makes
sense at all.
