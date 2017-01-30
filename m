Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f194.google.com ([209.85.223.194]:36051 "EHLO
        mail-io0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751463AbdA3T5k (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 30 Jan 2017 14:57:40 -0500
Received: by mail-io0-f194.google.com with SMTP id q20so15669694ioi.3
        for <linux-btrfs@vger.kernel.org>; Mon, 30 Jan 2017 11:56:51 -0800 (PST)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <1475805689-9989-1-git-send-email-robbieko@synology.com>
References: <1475805689-9989-1-git-send-email-robbieko@synology.com>
From: Filipe Manana <fdmanana@gmail.com>
Date: Mon, 30 Jan 2017 19:56:50 +0000
Message-ID: <CAL3q7H4G6rWybSRG6sZLndRwAXSJae5VnwCdT7=UANxV1jENhg@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: fix leak subvol subv_writers conter
To: robbieko <robbieko@synology.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Oct 7, 2016 at 3:01 AM, robbieko <robbieko@synology.com> wrote:
> From: Robbie Ko <robbieko@synology.com>
>
> In run_delalloc_nocow, maybe not release subv_writers conter,
> will lead to create snapshot hang.
>
> Signed-off-by: Robbie Ko <robbieko@synology.com>

I've picked this into my integration branch for 4.11 and rewrote the
changelog and subject.

Thanks.

> ---
>  fs/btrfs/inode.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
>
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index e6811c4..9722554 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -1386,11 +1386,17 @@ next_slot:
>                          * this ensure that csum for a given extent are
>                          * either valid or do not exist.
>                          */
> -                       if (csum_exist_in_range(root, disk_bytenr, num_bytes))
> +                       if (csum_exist_in_range(root, disk_bytenr, num_bytes)) {
> +                               if (!nolock)
> +                                       btrfs_end_write_no_snapshoting(root);
>                                 goto out_check;
> +                       }
>                         if (!btrfs_inc_nocow_writers(root->fs_info,
> -                                                    disk_bytenr))
> +                                                    disk_bytenr)) {
> +                               if (!nolock)
> +                                       btrfs_end_write_no_snapshoting(root);
>                                 goto out_check;
> +                       }
>                         nocow = 1;
>                 } else if (extent_type == BTRFS_FILE_EXTENT_INLINE) {
>                         extent_end = found_key.offset +
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
