Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f195.google.com ([209.85.223.195]:34277 "EHLO
        mail-io0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751479AbdASMHT (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 19 Jan 2017 07:07:19 -0500
Received: by mail-io0-f195.google.com with SMTP id c80so4754442iod.1
        for <linux-btrfs@vger.kernel.org>; Thu, 19 Jan 2017 04:06:08 -0800 (PST)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <1483604700-21017-5-git-send-email-robbieko@synology.com>
References: <1483604700-21017-1-git-send-email-robbieko@synology.com> <1483604700-21017-5-git-send-email-robbieko@synology.com>
From: Filipe Manana <fdmanana@gmail.com>
Date: Thu, 19 Jan 2017 12:06:07 +0000
Message-ID: <CAL3q7H6r+S1v2axp61ncfyBQ+fC=+qCguLO61pBqvkdgsxW2XA@mail.gmail.com>
Subject: Re: [PATCH v3 4/6] Btrfs: incremental send, fix invalid path for
 rmdir operations
To: robbieko <robbieko@synology.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jan 5, 2017 at 8:24 AM, robbieko <robbieko@synology.com> wrote:
> From: Robbie Ko <robbieko@synology.com>
>
> Under certain situations, an incremental send operation can

Again, missing some word after the word "can".
Copy pasting change logs is not that good....

> a rmdir operation that will make the receiving end fail when
> attempting to execute it, because the path is not exist.
>
> Example scenario:
> Parent snapshot:
> |---- d259_old/         (ino 259, gen 96)
>     |---- d1/           (ino 258, gen 96)
> |---- f                 (ino 257, gen 96)
>
> Send snapshot:
> |---- d258/             (ino 258, gen 98)
> |---- d259/             (ino 259, gen 98)
>     |---- d1/           (ino 257, gen 98)

Please try to align things for easier readability.

>
> unlink f
> mkdir o257-98-0
> mkdir o259-98-0
> chown o257-98-0 - uid=0, gid=0
> chmod o257-98-0 - mode=0755
> rmdir o258-96-0
> ERROR: rmdir o258-96-0 failed: No such file or directory

Same comment as before (patch 1/6). Don't just paste the output of
receive -vv out of nowhere without mentioning what it is.

>
> While computing the send stream the following steps happen:
>
> 1) While processing inode 257 we create o257-98-0 and o259-98-0,
>    then delay o257-98-0 rename operation because its new parent
>    in the send snapshot, inode 259, was not yet processed and therefore
>    not yet renamed;
>
> 2) Later we want to delete d1 (ino 258, gen 96) while processing inode
>    258. In order to get its path for delete, we need to check if it is
>    overwritten in the send snapshot. And we find it is overwritten so
>    we delete it via unique name , which leads to error. The reason is
>    we will find out d1 is under parent directory (inode 259) in the send
>    snapshot, and for this case, because d1(inode 257, gen 98) is not same
>    as d1 (inode 258, gen 96), we conclude d1 has been overwritten.
>
> Fix this by adding generation check for the parent directory. Because
> both parent directory are not identical, we can just skip the overwrite
> check. In addition, inode 256 should not check for this since it is a
> subvolume.

I've heavily reworded the change log and included the patch in my 4.11
integration branch.

Thanks.

>
> Signed-off-by: Robbie Ko <robbieko@synology.com>
> ---
> V3: improve the change log
>  fs/btrfs/send.c | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
>
> diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
> index eaf1c92..139f492 100644
> --- a/fs/btrfs/send.c
> +++ b/fs/btrfs/send.c
> @@ -1938,6 +1938,19 @@ static int did_overwrite_ref(struct send_ctx *sctx,
>         if (ret <= 0)
>                 goto out;
>
> +       if (dir != BTRFS_FIRST_FREE_OBJECTID) {
> +               ret = get_inode_info(sctx->send_root, dir, NULL, &gen, NULL,
> +                                    NULL, NULL, NULL);
> +               if (ret < 0 && ret != -ENOENT)
> +                       goto out;
> +               if (ret) {
> +                       ret = 0;
> +                       goto out;
> +               }
> +               if (gen != dir_gen)
> +                       goto out;
> +       }
> +
>         /* check if the ref was overwritten by another ref */
>         ret = lookup_dir_item_inode(sctx->send_root, dir, name, name_len,
>                         &ow_inode, &other_type);
> --
> 1.9.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Filipe David Manana,

"People will forget what you said,
 people will forget what you did,
 but people will never forget how you made them feel."
