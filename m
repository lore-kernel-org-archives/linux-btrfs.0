Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from bay0-omc1-s14.bay0.hotmail.com ([65.54.190.25]:34061 "EHLO
	bay0-omc1-s14.bay0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754922Ab3FLQNP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 12 Jun 2013 12:13:15 -0400
Message-ID: <BAY172-DS17E458EC3FEFC5963F1FC7B0860@phx.gbl>
From: "Kyle Gates" <kylegates@hotmail.com>
To: "Miao Xie" <miaox@cn.fujitsu.com>, <linux-btrfs@vger.kernel.org>
Cc: "Liu Bo" <bo.li.liu@oracle.com>
References: <1370489283-4870-1-git-send-email-miaox@cn.fujitsu.com>
In-Reply-To: <1370489283-4870-1-git-send-email-miaox@cn.fujitsu.com>
Subject: Re: [PATCH] Btrfs: fix broken nocow after balance
Date: Wed, 12 Jun 2013 11:13:47 -0500
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wednesday, June 05, 2013 Miao Xie wrote:
> Balance will create reloc_root for each fs root, and it's going to
> record last_snapshot to filter shared blocks.  The side effect of
> setting last_snapshot is to break nocow attributes of files.
>
> Since the extents are not shared by the relocation tree after the balance,
> we can recover the old last_snapshot safely if no one snapshoted the
> source tree. We fix the above problem by this way.

This patch also fixed my problem. I tend to like this patch better as the 
fix lands on disk allowing nocow to function with an older kernel after 
being balanced.
Thanks,
Kyle

Tested-by: Kyle Gates <kylegates@hotmail.com>

> Reported-by: Kyle Gates <kylegates@hotmail.com>
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
> ---
> fs/btrfs/relocation.c | 44 ++++++++++++++++++++++++++++++++++++++++++++
> 1 file changed, 44 insertions(+)
>
> diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
> index 395b820..934ffe6 100644
> --- a/fs/btrfs/relocation.c
> +++ b/fs/btrfs/relocation.c
> @@ -1305,6 +1305,7 @@ static struct btrfs_root *create_reloc_root(struct 
> btrfs_trans_handle *trans,
>  struct extent_buffer *eb;
>  struct btrfs_root_item *root_item;
>  struct btrfs_key root_key;
> + u64 last_snap = 0;
>  int ret;
>
>  root_item = kmalloc(sizeof(*root_item), GFP_NOFS);
> @@ -1320,6 +1321,7 @@ static struct btrfs_root *create_reloc_root(struct 
> btrfs_trans_handle *trans,
>        BTRFS_TREE_RELOC_OBJECTID);
>  BUG_ON(ret);
>
> + last_snap = btrfs_root_last_snapshot(&root->root_item);
>  btrfs_set_root_last_snapshot(&root->root_item,
>       trans->transid - 1);
>  } else {
> @@ -1345,6 +1347,12 @@ static struct btrfs_root *create_reloc_root(struct 
> btrfs_trans_handle *trans,
>  memset(&root_item->drop_progress, 0,
>         sizeof(struct btrfs_disk_key));
>  root_item->drop_level = 0;
> + /*
> + * abuse rtransid, it is safe because it is impossible to
> + * receive data into a relocation tree.
> + */
> + btrfs_set_root_rtransid(root_item, last_snap);
> + btrfs_set_root_otransid(root_item, trans->transid);
>  }
>
>  btrfs_tree_unlock(eb);
> @@ -2273,8 +2281,12 @@ void free_reloc_roots(struct list_head *list)
> static noinline_for_stack
> int merge_reloc_roots(struct reloc_control *rc)
> {
> + struct btrfs_trans_handle *trans;
>  struct btrfs_root *root;
>  struct btrfs_root *reloc_root;
> + u64 last_snap;
> + u64 otransid;
> + u64 objectid;
>  LIST_HEAD(reloc_roots);
>  int found = 0;
>  int ret = 0;
> @@ -2308,12 +2320,44 @@ again:
>  } else {
>  list_del_init(&reloc_root->root_list);
>  }
> +
> + /*
> + * we keep the old last snapshod transid in rtranid when we
> + * created the relocation tree.
> + */
> + last_snap = btrfs_root_rtransid(&reloc_root->root_item);
> + otransid = btrfs_root_otransid(&reloc_root->root_item);
> + objectid = reloc_root->root_key.offset;
> +
>  ret = btrfs_drop_snapshot(reloc_root, rc->block_rsv, 0, 1);
>  if (ret < 0) {
>  if (list_empty(&reloc_root->root_list))
>  list_add_tail(&reloc_root->root_list,
>        &reloc_roots);
>  goto out;
> + } else if (!ret) {
> + /*
> + * recover the last snapshot tranid to avoid
> + * the space balance break NOCOW.
> + */
> + root = read_fs_root(rc->extent_root->fs_info,
> +     objectid);
> + if (IS_ERR(root))
> + continue;
> +
> + if (btrfs_root_refs(&root->root_item) == 0)
> + continue;
> +
> + trans = btrfs_join_transaction(root);
> + BUG_ON(IS_ERR(trans));
> +
> + /* Check if the fs/file tree was snapshoted or not. */
> + if (btrfs_root_last_snapshot(&root->root_item) ==
> +     otransid - 1)
> + btrfs_set_root_last_snapshot(&root->root_item,
> +      last_snap);
> +
> + btrfs_end_transaction(trans, root);
>  }
>  }
>
> -- 
> 1.8.1.4
>
> 
