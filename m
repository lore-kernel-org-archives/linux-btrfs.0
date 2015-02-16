Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f42.google.com ([209.85.215.42]:35416 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932238AbbBPJsW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 16 Feb 2015 04:48:22 -0500
Received: by labgm9 with SMTP id gm9so27352907lab.2
        for <linux-btrfs@vger.kernel.org>; Mon, 16 Feb 2015 01:48:21 -0800 (PST)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <1424079178-21976-1-git-send-email-bo.li.liu@oracle.com>
References: <1424079178-21976-1-git-send-email-bo.li.liu@oracle.com>
Date: Mon, 16 Feb 2015 09:48:21 +0000
Message-ID: <CAL3q7H6UdQBvBDQzkWhSBHzAu_BtxisTAuSqeYQ_O2rA8Qf3mg@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: cleanup alloc_chunk
From: Filipe David Manana <fdmanana@gmail.com>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Feb 16, 2015 at 9:32 AM, Liu Bo <bo.li.liu@oracle.com> wrote:
> "alloc_chunk" is used to avoid alloc_chunk for free space cache inode, but since
> it's safe now to do that, let's just remove it.

Already submitted 2 times before:

https://patchwork.kernel.org/patch/5828631/
https://patchwork.kernel.org/patch/5798441/

>
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> ---
>  fs/btrfs/extent-tree.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index a684086..765e72a 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -3679,7 +3679,7 @@ int btrfs_check_data_free_space(struct inode *inode, u64 bytes)
>         struct btrfs_root *root = BTRFS_I(inode)->root;
>         struct btrfs_fs_info *fs_info = root->fs_info;
>         u64 used;
> -       int ret = 0, committed = 0, alloc_chunk = 1;
> +       int ret = 0, committed = 0;
>
>         /* make sure bytes are sectorsize aligned */
>         bytes = ALIGN(bytes, root->sectorsize);
> @@ -3707,7 +3707,7 @@ again:
>                  * if we don't have enough free bytes in this space then we need
>                  * to alloc a new chunk.
>                  */
> -               if (!data_sinfo->full && alloc_chunk) {
> +               if (!data_sinfo->full) {
>                         u64 alloc_target;
>
>                         data_sinfo->force_alloc = CHUNK_ALLOC_FORCE;
> --
> 1.8.1.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
