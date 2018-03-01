Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ua0-f194.google.com ([209.85.217.194]:43201 "EHLO
        mail-ua0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1030544AbeCAMwN (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 1 Mar 2018 07:52:13 -0500
Received: by mail-ua0-f194.google.com with SMTP id b13so3758884uam.10
        for <linux-btrfs@vger.kernel.org>; Thu, 01 Mar 2018 04:52:12 -0800 (PST)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <20180228011058.23906-1-bo.li.liu@oracle.com>
References: <20180228011058.23906-1-bo.li.liu@oracle.com>
From: Filipe Manana <fdmanana@gmail.com>
Date: Thu, 1 Mar 2018 12:52:11 +0000
Message-ID: <CAL3q7H5zgigVQdOmQedB8NZ12f1h-hoFjeed6nwz50qPqRpeMQ@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: dev-replace: skip prealloc extents when copy nocow pages
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Feb 28, 2018 at 1:10 AM, Liu Bo <bo.li.liu@oracle.com> wrote:
> It doens't make sense to process prealloc extents as pages will be
> filled with zero when reading prealloc extents.
>
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
Reviewed-by: Filipe Manana <fdmanana@suse.com>

Makes sense.

> ---
>  fs/btrfs/scrub.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
> index ec56f33..9882513 100644
> --- a/fs/btrfs/scrub.c
> +++ b/fs/btrfs/scrub.c
> @@ -4480,7 +4480,8 @@ static int check_extent_to_block(struct btrfs_inode *inode, u64 start, u64 len,
>          * move on to the next inode.
>          */
>         if (em->block_start > logical ||
> -           em->block_start + em->block_len < logical + len) {
> +           em->block_start + em->block_len < logical + len ||
> +           test_bit(EXTENT_FLAG_PREALLOC, &em->flags)) {
>                 free_extent_map(em);
>                 ret = 1;
>                 goto out_unlock;
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
