Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx5-phx2.redhat.com ([209.132.183.37]:58671 "EHLO
	mx5-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754969AbaGJD0G convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 9 Jul 2014 23:26:06 -0400
Content-Type: text/plain;
	charset=us-ascii
Subject: Re: [PATCH] btrfs: remove unnecessary error check
References: <53BE0656.1020202@jp.fujitsu.com>
From: Eric Sandeen <esandeen@redhat.com>
MIME-Version: 1.0
In-Reply-To: <53BE0656.1020202@jp.fujitsu.com>
Message-Id: <797384C7-AC2D-45A3-BAAC-B5C717B0C6F1@redhat.com>
Date: Wed, 9 Jul 2014 23:26:03 -0400 (EDT)
To: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



> On Jul 9, 2014, at 10:20 PM, Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com> wrote:
> 
> From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
> 
> If "(!IS_ERR(trans) || PTR_ERR(trans) != -ENOSPC))" is false,
> obviously "trans" is -ENOSPC. So we can safely remove the redundant
> "(PTR_ERR(trans) == -ENOSPC)" check.
> 

True, but now a comment like:

/* Handle ENOSPC */

might still be nice...

Eric

> Signed-off-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
> 
> ---
> fs/btrfs/inode.c | 27 +++++++++++++--------------
> 1 file changed, 13 insertions(+), 14 deletions(-)
> 
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 3668048..01bb43c 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -3803,22 +3803,21 @@ static struct btrfs_trans_handle *__unlink_start_trans(struct inode *dir)
>    if (!IS_ERR(trans) || PTR_ERR(trans) != -ENOSPC)
>        return trans;
> 
> -    if (PTR_ERR(trans) == -ENOSPC) {
> -        u64 num_bytes = btrfs_calc_trans_metadata_size(root, 5);
> +    u64 num_bytes = btrfs_calc_trans_metadata_size(root, 5);
> 
> -        trans = btrfs_start_transaction(root, 0);
> -        if (IS_ERR(trans))
> -            return trans;
> -        ret = btrfs_cond_migrate_bytes(root->fs_info,
> -                           &root->fs_info->trans_block_rsv,
> -                           num_bytes, 5);
> -        if (ret) {
> -            btrfs_end_transaction(trans, root);
> -            return ERR_PTR(ret);
> -        }
> -        trans->block_rsv = &root->fs_info->trans_block_rsv;
> -        trans->bytes_reserved = num_bytes;
> +    trans = btrfs_start_transaction(root, 0);
> +    if (IS_ERR(trans))
> +        return trans;
> +    ret = btrfs_cond_migrate_bytes(root->fs_info,
> +                       &root->fs_info->trans_block_rsv,
> +                       num_bytes, 5);
> +    if (ret) {
> +        btrfs_end_transaction(trans, root);
> +        return ERR_PTR(ret);
>    }
> +    trans->block_rsv = &root->fs_info->trans_block_rsv;
> +    trans->bytes_reserved = num_bytes;
> +
>    return trans;
> }
> 
> -- 
> 1.9.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
