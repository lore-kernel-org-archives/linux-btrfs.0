Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f67.google.com ([209.85.213.67]:43076 "EHLO
        mail-vk0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752850AbeB1QGl (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 28 Feb 2018 11:06:41 -0500
Received: by mail-vk0-f67.google.com with SMTP id p189so1769222vkd.10
        for <linux-btrfs@vger.kernel.org>; Wed, 28 Feb 2018 08:06:41 -0800 (PST)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <20180125180256.10844-9-bo.li.liu@oracle.com>
References: <20180125180256.10844-9-bo.li.liu@oracle.com>
From: Filipe Manana <fdmanana@gmail.com>
Date: Wed, 28 Feb 2018 16:06:40 +0000
Message-ID: <CAL3q7H6XiMGuJkiiW8svi8vvxCjPii1DOG1CnTuM6dauk_bAXg@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: fix unexpected -EEXIST when creating new inode
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jan 25, 2018 at 6:02 PM, Liu Bo <bo.li.liu@oracle.com> wrote:
> The highest objectid, which is assigned to new inode, is decided at
> the time of initializing fs roots.  However, in cases where log replay
> gets processed, the btree which fs root owns might be changed, so we
> have to search it again for the highest objectid, otherwise creating
> new inode would end up with -EEXIST.
>
> cc: <stable@vger.kernel.org> v4.4-rc6+
> Fixes: f32e48e92596 ("Btrfs: Initialize btrfs_root->highest_objectid when loading tree root and subvolume roots")
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>

Hi Bo,

Any reason to not have submitted a test case for fstests?
Unless I missed something this should be easy to reproduce, deterministic issue.

thanks

> ---
>  fs/btrfs/tree-log.c | 19 +++++++++++++++++++
>  1 file changed, 19 insertions(+)
>
> diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
> index a7e6235..646cdbf 100644
> --- a/fs/btrfs/tree-log.c
> +++ b/fs/btrfs/tree-log.c
> @@ -28,6 +28,7 @@
>  #include "hash.h"
>  #include "compression.h"
>  #include "qgroup.h"
> +#include "inode-map.h"
>
>  /* magic values for the inode_only field in btrfs_log_inode:
>   *
> @@ -5715,6 +5716,24 @@ int btrfs_recover_log_trees(struct btrfs_root *log_root_tree)
>                                                       path);
>                 }
>
> +               if (!ret && wc.stage == LOG_WALK_REPLAY_ALL) {
> +                       struct btrfs_root *root = wc.replay_dest;
> +
> +                       btrfs_release_path(path);
> +
> +                       /*
> +                        * We have just replayed everything, and the highest
> +                        * objectid of fs roots probably has changed in case
> +                        * some inode_item's got replayed.
> +                        */
> +                       /*
> +                        * root->objectid_mutex is not acquired as log replay
> +                        * could only happen during mount.
> +                        */
> +                       ret = btrfs_find_highest_objectid(root,
> +                                                 &root->highest_objectid);
> +               }
> +
>                 key.offset = found_key.offset - 1;
>                 wc.replay_dest->log_root = NULL;
>                 free_extent_buffer(log->node);
> --
> 2.9.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Filipe David Manana,

“Whether you think you can, or you think you can't — you're right.”
