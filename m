Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.160]:53672 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751270Ab3JSIuo (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 19 Oct 2013 04:50:44 -0400
Message-ID: <526247E3.9000804@giantdisaster.de>
Date: Sat, 19 Oct 2013 10:50:43 +0200
From: Stefan Behrens <sbehrens@giantdisaster.de>
MIME-Version: 1.0
To: Wang Shilong <wangshilong1991@gmail.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: fix race condition between writting and scrubing
 supers
References: <1382156250-2336-1-git-send-email-wangshilong1991@gmail.com>
In-Reply-To: <1382156250-2336-1-git-send-email-wangshilong1991@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10/19/2013 06:17, Wang Shilong wrote:
> From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
>
> Scrubing supers is not in a transaction context, when trying to
> write supers to disk, we should check if we are trying to
> scrub supers.Fix it.
>
> Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
> ---
>   fs/btrfs/disk-io.c     | 2 ++
>   fs/btrfs/transaction.c | 2 ++
>   2 files changed, 4 insertions(+)
>
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 419968e..0debb19 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -3582,7 +3582,9 @@ int btrfs_commit_super(struct btrfs_root *root)
>   		return ret;
>   	}
>
> +	btrfs_scrub_pause_super(root);
>   	ret = write_ctree_super(NULL, root, 0);
> +	btrfs_scrub_continue_super(root);
>   	return ret;
>   }
>
> diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
> index 277fe81..3ebcbbd 100644
> --- a/fs/btrfs/transaction.c
> +++ b/fs/btrfs/transaction.c
> @@ -1892,7 +1892,9 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
>   		goto cleanup_transaction;
>   	}
>
> +	btrfs_scrub_pause_super(root);
>   	ret = write_ctree_super(trans, root, 0);
> +	btrfs_scrub_continue_super(root);
>   	if (ret) {
>   		mutex_unlock(&root->fs_info->tree_log_mutex);
>   		goto cleanup_transaction;
>

What kind of race do you see between writing the 4K superblock and scrub 
checking its checksum? Or in other words, what could happen?


