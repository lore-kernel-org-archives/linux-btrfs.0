Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:63917 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755919AbaAHPWY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 8 Jan 2014 10:22:24 -0500
Message-ID: <52CD6D2A.9090900@fb.com>
Date: Wed, 8 Jan 2014 10:22:18 -0500
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: Liu Bo <bo.li.liu@oracle.com>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 2/2] Btrfs: release subvolume's block_rsv before transaction
 commit
References: <1388324691-24507-1-git-send-email-bo.li.liu@oracle.com> <1388324691-24507-2-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1388324691-24507-2-git-send-email-bo.li.liu@oracle.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On 12/29/2013 08:44 AM, Liu Bo wrote:
> We don't have to keep subvolume's block_rsv during transaction commit,
> and within transaction commit, we may also need the free space reclaimed
> from this block_rsv to process delayed refs.
>
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> ---
>   fs/btrfs/ioctl.c | 7 ++++---
>   1 file changed, 4 insertions(+), 3 deletions(-)
>
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index 21da576..347bf61 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -417,7 +417,8 @@ static noinline int create_subvol(struct inode *dir,
>   	trans = btrfs_start_transaction(root, 0);
>   	if (IS_ERR(trans)) {
>   		ret = PTR_ERR(trans);
> -		goto out;
> +		btrfs_subvolume_release_metadata(root, &block_rsv, qgroup_reserved);
> +		return ret;
>   	}
>   	trans->block_rsv = &block_rsv;
>   	trans->bytes_reserved = block_rsv.size;
> @@ -542,6 +543,8 @@ static noinline int create_subvol(struct inode *dir,
>   fail:
>   	trans->block_rsv = NULL;
>   	trans->bytes_reserved = 0;
> +	btrfs_subvolume_release_metadata(root, &block_rsv, qgroup_reserved);
> +
>   	if (async_transid) {
>   		*async_transid = trans->transid;
>   		err = btrfs_commit_transaction_async(trans, root, 1);
> @@ -555,8 +558,6 @@ fail:
>   
>   	if (!ret)
>   		d_instantiate(dentry, btrfs_lookup_dentry(dir, dentry));
> -out:
> -	btrfs_subvolume_release_metadata(root, &block_rsv, qgroup_reserved);
>   	return ret;
>   }
>   

Doesn't compile, please rebase onto new btrfs-next and resubmit. Thanks,

Josef
