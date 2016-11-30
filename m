Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f196.google.com ([209.85.223.196]:36721 "EHLO
        mail-io0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755506AbcK3QO6 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 30 Nov 2016 11:14:58 -0500
Received: by mail-io0-f196.google.com with SMTP id k19so3332770iod.3
        for <linux-btrfs@vger.kernel.org>; Wed, 30 Nov 2016 08:14:58 -0800 (PST)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <1477621974-1103-1-git-send-email-robbieko@synology.com>
References: <1477621974-1103-1-git-send-email-robbieko@synology.com>
From: Filipe Manana <fdmanana@gmail.com>
Date: Wed, 30 Nov 2016 16:14:56 +0000
Message-ID: <CAL3q7H4QnMc1nikiL_sLU2rBRN9gR4whKoc-yRLhyjP--Znfvw@mail.gmail.com>
Subject: Re: [PATCH v2] Btrfs: fix enospc in hole punching
To: robbieko <robbieko@synology.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Oct 28, 2016 at 3:32 AM, robbieko <robbieko@synology.com> wrote:
> From: Robbie Ko <robbieko@synology.com>
>
> The hole punching can result in adding new leafs (and as a consequence
> new nodes) to the tree because when we find file extent items that span
> beyond the hole range we may end up not deleting them (just adjusting them)
> and add new file extent items representing holes.
>
> That after splitting a leaf (therefore creating a new one), a new node
> might be added to each level of the tree (since there's a new key and
> every parent node was full).
>
> Fix this by use btrfs_calc_trans_metadata_size instead of
> btrfs_calc_trunc_metadata_size.
>
> v2:
> * Improve the change log

Version information does not belong in the changelog but after the ---
below (it wouldn't make sense to have it in the git changelogs...).
See https://btrfs.wiki.kernel.org/index.php/Developer's_FAQ#Repeated_submissions
and examples from others that submit patches to this list.

>
> Signed-off-by: Robbie Ko <robbieko@synology.com>

I've reworded the changelog for clarity and added it to my branch at:
https://git.kernel.org/cgit/linux/kernel/git/fdmanana/linux.git/log/?h=for-chris-4.10

Thanks.

> ---
>  fs/btrfs/file.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
> index fea31a4..809ca85 100644
> --- a/fs/btrfs/file.c
> +++ b/fs/btrfs/file.c
> @@ -2322,7 +2322,7 @@ static int btrfs_punch_hole(struct inode *inode, loff_t offset, loff_t len)
>         u64 tail_len;
>         u64 orig_start = offset;
>         u64 cur_offset;
> -       u64 min_size = btrfs_calc_trunc_metadata_size(root, 1);
> +       u64 min_size = btrfs_calc_trans_metadata_size(root, 1);
>         u64 drop_end;
>         int ret = 0;
>         int err = 0;
> @@ -2469,7 +2469,7 @@ static int btrfs_punch_hole(struct inode *inode, loff_t offset, loff_t len)
>                 ret = -ENOMEM;
>                 goto out_free;
>         }
> -       rsv->size = btrfs_calc_trunc_metadata_size(root, 1);
> +       rsv->size = btrfs_calc_trans_metadata_size(root, 1);
>         rsv->failfast = 1;
>
>         /*
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
