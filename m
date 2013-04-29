Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:49449 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751784Ab3D2OuP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 29 Apr 2013 10:50:15 -0400
Date: Mon, 29 Apr 2013 16:50:13 +0200
From: David Sterba <dsterba@suse.cz>
To: Stefan Behrens <sbehrens@giantdisaster.de>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 4/5] Btrfs: maintain subvolume items in the UUID tree
Message-ID: <20130429145013.GR16427@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1366384796.git.sbehrens@giantdisaster.de>
 <a1d5f4c0cad1e70800a8b678df684f03c8251cf9.1366384796.git.sbehrens@giantdisaster.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <a1d5f4c0cad1e70800a8b678df684f03c8251cf9.1366384796.git.sbehrens@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 19, 2013 at 05:41:05PM +0200, Stefan Behrens wrote:
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -57,6 +57,8 @@
>  #include "send.h"
>  #include "dev-replace.h"
>  
> +static char empty_uuid[BTRFS_UUID_SIZE] = {0};

+ const

> @@ -567,9 +573,10 @@ static int create_snapshot(struct btrfs_root *root, struct inode *dir,
>  	 * 1 - root item
>  	 * 2 - root ref/backref
>  	 * 1 - root of snapshot
> +	 * 1 - UUID item
>  	 */
>  	ret = btrfs_subvolume_reserve_metadata(BTRFS_I(dir)->root,
> -					&pending_snapshot->block_rsv, 7,
> +					&pending_snapshot->block_rsv, 8,
>  					&pending_snapshot->qgroup_reserved);
>  	if (ret)
>  		goto out;
> @@ -580,7 +587,7 @@ static int create_snapshot(struct btrfs_root *root, struct inode *dir,
>  	pending_snapshot->dir = dir;
>  	pending_snapshot->inherit = inherit;
>  
> -	trans = btrfs_start_transaction(root, 0);
> +	trans = btrfs_start_transaction(root->fs_info->extent_root, 8);

This look suspicious in 2 ways:

* why is root switched to extent_root
* what's the reason of 8 units being reserved

>  	if (IS_ERR(trans)) {
>  		ret = PTR_ERR(trans);
>  		goto fail;
> @@ -3925,7 +3954,7 @@ static long btrfs_ioctl_set_received_subvol(struct file *file,
>  		goto out;
>  	}
>  
> -	trans = btrfs_start_transaction(root, 1);
> +	trans = btrfs_start_transaction(root, 3);

Please document what's being reserved

>  	if (IS_ERR(trans)) {
>  		ret = PTR_ERR(trans);
>  		trans = NULL;
> --- a/fs/btrfs/transaction.c
> +++ b/fs/btrfs/transaction.c
> @@ -34,6 +34,8 @@
>  
>  #define BTRFS_ROOT_TRANS_TAG 0
>  
> +static char empty_uuid[BTRFS_UUID_SIZE] = {0};

second empty_uuid? well, alternatively you could implement a helper
"is uuid empty" and compare to zeros directly

> +
>  void put_transaction(struct btrfs_transaction *transaction)
>  {
>  	WARN_ON(atomic_read(&transaction->use_count) == 0);
