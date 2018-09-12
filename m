Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59958 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725966AbeILMKR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 12 Sep 2018 08:10:17 -0400
Subject: Re: [PATCH] Btrfs: remove unused code in __btrfs_unlink_inode
To: Liu Bo <bo.liu@linux.alibaba.com>, linux-btrfs@vger.kernel.org
References: <1536703587-94565-6-git-send-email-bo.liu@linux.alibaba.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <b74cd61e-21bf-d71d-e561-74046448e25e@suse.com>
Date: Wed, 12 Sep 2018 10:07:05 +0300
MIME-Version: 1.0
In-Reply-To: <1536703587-94565-6-git-send-email-bo.liu@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 12.09.2018 01:06, Liu Bo wrote:
> It might get @leaf and @key in order to do some sanity checks on key's
> fields, but since we don't check it any more, it's fine to remove the
> code.

This is actually false, leaf and key weren't used for sanity checks.
Instead this code was first introduced in 5f39d397dfbe ("Btrfs: Create
extent_buffer interface for large blocksizes") and the function was
named btrfs_unlink_trans. It later got renamed to __btrfs_unlink_inode
and finally commit 16cdcec736cd ("btrfs: implement delayed inode items
operation") changed the way inodes are deleted and obviated the need for
those two members.

Generally when unused variables are deleted you need to do a bit of
archeology and explain how they got to be unused in the changelog.


> 
> Signed-off-by: Liu Bo <bo.liu@linux.alibaba.com>
> ---
>  fs/btrfs/inode.c | 4 ----
>  1 file changed, 4 deletions(-)
> 
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index d3febc3a6bc0..fd64d7ac76f9 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -3911,9 +3911,7 @@ static int __btrfs_unlink_inode(struct btrfs_trans_handle *trans,
>  	struct btrfs_fs_info *fs_info = root->fs_info;
>  	struct btrfs_path *path;
>  	int ret = 0;
> -	struct extent_buffer *leaf;
>  	struct btrfs_dir_item *di;
> -	struct btrfs_key key;
>  	u64 index;
>  	u64 ino = btrfs_ino(inode);
>  	u64 dir_ino = btrfs_ino(dir);
> @@ -3935,8 +3933,6 @@ static int __btrfs_unlink_inode(struct btrfs_trans_handle *trans,
>  		ret = -ENOENT;
>  		goto err;
>  	}
> -	leaf = path->nodes[0];
> -	btrfs_dir_item_key_to_cpu(leaf, di, &key);
>  	ret = btrfs_delete_one_dir_name(trans, root, path, di);
>  	if (ret)
>  		goto err;
> 
