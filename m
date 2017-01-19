Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f193.google.com ([209.85.223.193]:34152 "EHLO
        mail-io0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752237AbdASMNr (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 19 Jan 2017 07:13:47 -0500
Received: by mail-io0-f193.google.com with SMTP id c80so4773140iod.1
        for <linux-btrfs@vger.kernel.org>; Thu, 19 Jan 2017 04:13:46 -0800 (PST)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <1483604700-21017-2-git-send-email-robbieko@synology.com>
References: <1483604700-21017-1-git-send-email-robbieko@synology.com> <1483604700-21017-2-git-send-email-robbieko@synology.com>
From: Filipe Manana <fdmanana@gmail.com>
Date: Thu, 19 Jan 2017 12:05:22 +0000
Message-ID: <CAL3q7H4YrXnZx_6jAhDXCVTH2fK8Fq2NwGFwAyUrHrH-Mer-kQ@mail.gmail.com>
Subject: Re: [PATCH v3 1/6] Btrfs: incremental send, fix failure to rename
 with the name collision
To: robbieko <robbieko@synology.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jan 5, 2017 at 8:24 AM, robbieko <robbieko@synology.com> wrote:
> From: Robbie Ko <robbieko@synology.com>
>
> Under certain situations, an incremental send operation can

Missing some word after the word "can".

> a rename operation that will make the receiving end fail when
> attempting to execute it, because the target is exist.
>
> Example scenario:
> Parent snapshot:

Two consecutive sentences ending with a colon is odd.

> |.                (ino 256, gen 5)

. is not a child of anything, shouldn't have the | preceding it.

> |---- a1/         (ino 257, gen 5)
> |---- a2/         (ino 258, gen 5)
>
> Send snapshot:
> |.                (ino 256, gen 7)

Same here.

> |---- a2          (ino 257, gen 7)
>
> rmdir a1
> mkfile o257-7-0
> rename o257-7-0 -> a2
> ERROR: rename o257-7-0 -> a2 failed: Is a directory

Alright what is this? So you just paste here the output of "btrfs
receive -vv" without mentioning where it comes from.
Let the reader guess and make some sense of it.

>
> While computing the send stream the following steps happen:
>
> 1) delete a1;
>
> 2) mkfile o257-7-0;
>
> 3) rename o257-7-0->a2;
>
> In step 3 we will check whether it will lead to overwrite.
>
> The generation number of inode 257's parent (ino 256) in send snapshot
> is 7, which is inconsistent with the one in parent snapshot (gen 5).
> For the general parent directory except inode 256, if its generation
> is not identical between parent and send snapshot, it will be removed
> then created. Thus it's not possible to happen overwrite under the new
> directory. However for the special inode 256, the above logic does not
> work since it is a subvolume. So overwrite check is required for the
> inode 256.
> Fix by skipping generation inconsistency check for inode 256.

I've heavily reworded the explanation and made other changes to the
changelog myself.
You should have given an example on how to create the snapshots so
that it's clear how to get different inodes with the same number but
different generations.

I've pushed into an integration branch in my git repository with the
goal of including it for 4.11:

https://git.kernel.org/cgit/linux/kernel/git/fdmanana/linux.git/log/?h=integration-4.11

The subject was also changed to "Btrfs: send, fix failure to rename
top level inode due to name collision".

So for this patch, you don't need to do anything else.
Thanks.

>
> Signed-off-by: Robbie Ko <robbieko@synology.com>
> ---
> V3: improve the change log
>  fs/btrfs/send.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
> index a87675f..2060e75 100644
> --- a/fs/btrfs/send.c
> +++ b/fs/btrfs/send.c
> @@ -1681,6 +1681,9 @@ static int is_inode_existent(struct send_ctx *sctx, u64 ino, u64 gen)
>  {
>         int ret;
>
> +       if (ino == BTRFS_FIRST_FREE_OBJECTID)
> +               return 1;
> +
>         ret = get_cur_inode_state(sctx, ino, gen);
>         if (ret < 0)
>                 goto out;
> @@ -1866,7 +1869,7 @@ static int will_overwrite_ref(struct send_ctx *sctx, u64 dir, u64 dir_gen,
>          * not deleted and then re-created, if it was then we have no overwrite
>          * and we can just unlink this entry.
>          */
> -       if (sctx->parent_root) {
> +       if (sctx->parent_root && dir != BTRFS_FIRST_FREE_OBJECTID) {
>                 ret = get_inode_info(sctx->parent_root, dir, NULL, &gen, NULL,
>                                      NULL, NULL, NULL);
>                 if (ret < 0 && ret != -ENOENT)
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
