Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:20410 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754721AbaGKOXd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 11 Jul 2014 10:23:33 -0400
Message-ID: <53BFF363.9010207@redhat.com>
Date: Fri, 11 Jul 2014 09:23:31 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v3] btrfs: remove unnecessary error check
References: <53BE0656.1020202@jp.fujitsu.com> <797384C7-AC2D-45A3-BAAC-B5C717B0C6F1@redhat.com> <53BE3662.5060201@jp.fujitsu.com> <53BE94C6.6000502@redhat.com> <53BF3F71.1010703@jp.fujitsu.com>
In-Reply-To: <53BF3F71.1010703@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 7/10/14, 8:35 PM, Satoru Takeuchi wrote:

> This is the v3 patch.
> 
> ===
> From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
> 
> If "(!IS_ERR(trans) || PTR_ERR(trans) != -ENOSPC))" is false,
> obviously "trans" is -ENOSPC. So we can safely remove the redundant
> "(PTR_ERR(trans) == -ENOSPC)" check.
> 
> Signed-off-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  fs/btrfs/inode.c | 28 ++++++++++++++--------------
>  1 file changed, 14 insertions(+), 14 deletions(-)
> 
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 3668048..e7ac779 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -3790,6 +3790,7 @@ static struct btrfs_trans_handle *__unlink_start_trans(struct inode *dir)
>  {
>      struct btrfs_trans_handle *trans;
>      struct btrfs_root *root = BTRFS_I(dir)->root;
> +    u64 num_bytes = btrfs_calc_trans_metadata_size(root, 5);
>      int ret;
>  
>      /*
> @@ -3803,22 +3804,21 @@ static struct btrfs_trans_handle *__unlink_start_trans(struct inode *dir)
>      if (!IS_ERR(trans) || PTR_ERR(trans) != -ENOSPC)
>          return trans;
>  
> -    if (PTR_ERR(trans) == -ENOSPC) {
> -        u64 num_bytes = btrfs_calc_trans_metadata_size(root, 5);
> +    /* Handle ENOSPC */
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
> +                    &root->fs_info->trans_block_rsv,
> +                    num_bytes, 5);
> +    if (ret) {
> +        btrfs_end_transaction(trans, root);
> +        return ERR_PTR(ret);
>      }
> +    trans->block_rsv = &root->fs_info->trans_block_rsv;
> +    trans->bytes_reserved = num_bytes;
> +
>      return trans;
>  }
>  

