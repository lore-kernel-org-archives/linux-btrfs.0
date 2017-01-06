Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f195.google.com ([209.85.223.195]:35391 "EHLO
        mail-io0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752752AbdAFL2H (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 6 Jan 2017 06:28:07 -0500
Received: by mail-io0-f195.google.com with SMTP id f73so65565561ioe.2
        for <linux-btrfs@vger.kernel.org>; Fri, 06 Jan 2017 03:28:07 -0800 (PST)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <1482455634-9185-1-git-send-email-bo.li.liu@oracle.com>
References: <1482455634-9185-1-git-send-email-bo.li.liu@oracle.com>
From: Filipe Manana <fdmanana@gmail.com>
Date: Fri, 6 Jan 2017 11:28:06 +0000
Message-ID: <CAL3q7H5LxEARAm0Gg5eKCNAtKKr-F-79c1PUE5ng4Xb3LFGD4w@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: adjust outstanding_extents counter properly when
 dio write is split
To: Liu Bo <bo.li.liu@oracle.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        David Sterba <dsterba@suse.cz>, Anand.Jain.anand.jain@oracle.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Dec 23, 2016 at 1:13 AM, Liu Bo <bo.li.liu@oracle.com> wrote:
> Currently how btrfs dio deals with split dio write is not good
> enough if dio write is split into several segments due to the
> lack of contiguous space, a large dio write like 'dd bs=1G count=1'
> can end up with incorrect outstanding_extents counter and endio
> would complain loudly with an assertion.
>
> This fixes the problem by compensating the outstanding_extents
> counter in inode if a large dio write gets split.
>
> Reported-by: Anand Jain <anand.jain@oracle.com>
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>

Bo, can you please create a test case for fstests?

Thanks

> ---
>  fs/btrfs/inode.c | 11 +++++++++--
>  1 file changed, 9 insertions(+), 2 deletions(-)
>
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index a4c8796..4175987 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -7641,11 +7641,18 @@ static void adjust_dio_outstanding_extents(struct inode *inode,
>          * within our reservation, otherwise we need to adjust our inode
>          * counter appropriately.
>          */
> -       if (dio_data->outstanding_extents) {
> +       if (dio_data->outstanding_extents >= num_extents) {
>                 dio_data->outstanding_extents -= num_extents;
>         } else {
> +               /*
> +                * If dio write length has been split due to no large enough
> +                * contiguous space, we need to compensate our inode counter
> +                * appropriately.
> +                */
> +               u64 num_needed = num_extents - dio_data->outstanding_extents;
> +
>                 spin_lock(&BTRFS_I(inode)->lock);
> -               BTRFS_I(inode)->outstanding_extents += num_extents;
> +               BTRFS_I(inode)->outstanding_extents += num_needed;
>                 spin_unlock(&BTRFS_I(inode)->lock);
>         }
>  }
> --
> 2.5.5
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
