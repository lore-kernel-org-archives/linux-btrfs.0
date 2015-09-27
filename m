Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f44.google.com ([209.85.220.44]:33947 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754054AbbI0AyN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 26 Sep 2015 20:54:13 -0400
Received: by padhy16 with SMTP id hy16so139872613pad.1
        for <linux-btrfs@vger.kernel.org>; Sat, 26 Sep 2015 17:54:12 -0700 (PDT)
Date: Sat, 26 Sep 2015 17:54:11 -0700
From: Omar Sandoval <osandov@osandov.com>
To: Josef Bacik <jbacik@fb.com>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH V2] Btrfs: end transaction if we abort when creating
 qgroup root
Message-ID: <20150927005411.GA3213@mew>
References: <1443034603-5542-1-git-send-email-jbacik@fb.com>
 <1443034837-1723-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1443034837-1723-1-git-send-email-jbacik@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Sep 23, 2015 at 03:00:37PM -0400, Josef Bacik wrote:
> We still need to call btrfs_end_transaction if we call btrfs_abort_transaction,
> otherwise we hang and make me super grumpy.  Thanks,

I made the same mistake in the free space tree, I'll fix that before I
forget.

> Signed-off-by: Josef Bacik <jbacik@fb.com>
> ---
> V1->V2: should have compiled before I hit send.
> 
>  fs/btrfs/volumes.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index fbe7c10..ff64689 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -4028,6 +4028,7 @@ int btrfs_create_uuid_tree(struct btrfs_fs_info *fs_info)

The subject says the qgroup root but this is the uuid tree.

>  	if (IS_ERR(uuid_root)) {
>  		ret = PTR_ERR(uuid_root);
>  		btrfs_abort_transaction(trans, tree_root, ret);
> +		btrfs_end_transaction(trans, tree_root);
>  		return ret;
>  	}
>  
> -- 
> 1.8.3.1

-- 
Omar
