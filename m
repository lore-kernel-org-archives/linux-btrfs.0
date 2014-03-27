Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f169.google.com ([209.85.213.169]:41271 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756815AbaC0Pu6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 27 Mar 2014 11:50:58 -0400
Received: by mail-ig0-f169.google.com with SMTP id h18so1619425igc.2
        for <linux-btrfs@vger.kernel.org>; Thu, 27 Mar 2014 08:50:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201303210432.AA00023@FM-323941448.jp.fujitsu.com>
References: <201303210432.AA00023@FM-323941448.jp.fujitsu.com>
Date: Thu, 27 Mar 2014 17:50:57 +0200
Message-ID: <CAOcd+r22WnYSEns8Aw51=Qp4m3e-kweaxPG-m2+SvkboLtDsWA@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: fix memory leak in btrfs_create_tree()
From: Alex Lyakas <alex.btrfs@zadarastorage.com>
To: Tsutomu Itoh <t-itoh@jp.fujitsu.com>, Josef Bacik <jbacik@fb.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>,
        Filipe Manana <fdmanana@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Tsutomu Itoh,

On Thu, Mar 21, 2013 at 6:32 AM, Tsutomu Itoh <t-itoh@jp.fujitsu.com> wrote:
> We should free leaf and root before returning from the error
> handling code.
>
> Signed-off-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
> ---
>  fs/btrfs/disk-io.c | 12 +++++++++---
>  1 file changed, 9 insertions(+), 3 deletions(-)
>
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 7d84651..b1b5baa 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -1291,6 +1291,7 @@ struct btrfs_root *btrfs_create_tree(struct btrfs_trans_handle *trans,
>                                       0, objectid, NULL, 0, 0, 0);
>         if (IS_ERR(leaf)) {
>                 ret = PTR_ERR(leaf);
> +               leaf = NULL;
>                 goto fail;
>         }
>
> @@ -1334,11 +1335,16 @@ struct btrfs_root *btrfs_create_tree(struct btrfs_trans_handle *trans,
>
>         btrfs_tree_unlock(leaf);
>
> +       return root;
> +
>  fail:
> -       if (ret)
> -               return ERR_PTR(ret);
> +       if (leaf) {
> +               btrfs_tree_unlock(leaf);
> +               free_extent_buffer(leaf);
I believe this is not enough. Few lines above, another reference on
the root is taken by
root->commit_root = btrfs_root_node(root);

So I believe the proper fix would be:
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index d9698fd..260af79 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1354,10 +1354,10 @@ struct btrfs_root *btrfs_create_tree(struct
btrfs_trans_handle *trans,
        return root;

 fail:
-       if (leaf) {
+       if (leaf)
                btrfs_tree_unlock(leaf);
-               free_extent_buffer(leaf);
-       }
+       free_extent_buffer(root->node);
+       free_extent_buffer(root->commit_root);
        kfree(root);

        return ERR_PTR(ret);



Thanks,
Alex.



> +       }
> +       kfree(root);
>
> -       return root;
> +       return ERR_PTR(ret);
>  }
>
>  static struct btrfs_root *alloc_log_tree(struct btrfs_trans_handle *trans,
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
