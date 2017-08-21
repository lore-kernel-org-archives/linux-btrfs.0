Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:36469 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752234AbdHUM0A (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 21 Aug 2017 08:26:00 -0400
Received: by mail-oi0-f68.google.com with SMTP id p62so5233304oih.3
        for <linux-btrfs@vger.kernel.org>; Mon, 21 Aug 2017 05:25:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1503308630-6652-7-git-send-email-nborisov@suse.com>
References: <1503308630-6652-1-git-send-email-nborisov@suse.com> <1503308630-6652-7-git-send-email-nborisov@suse.com>
From: Timofey Titovets <nefelim4ag@gmail.com>
Date: Mon, 21 Aug 2017 15:25:19 +0300
Message-ID: <CAGqmi75yEtURKxnyKiHXow9ZzqXWV=Y8opHS2VfcSRP=1OF7Zw@mail.gmail.com>
Subject: Re: [PATCH 06/10] btrfs: Remove unused parameter from check_direct_IO
To: Nikolay Borisov <nborisov@suse.com>
Cc: David Sterba <dsterba@suse.cz>, linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Reviewed-by: Timofey Titovets <nefelim4ag@gmail.com>

2017-08-21 12:43 GMT+03:00 Nikolay Borisov <nborisov@suse.com>:
> Introduced by 5a5f79b57069 ("Btrfs: allow unaligned DIO") and never used,
>
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> ---
>  fs/btrfs/inode.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 61f1ad89e97a..f1b3d6146924 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -8764,7 +8764,6 @@ static void btrfs_submit_direct(struct bio *dio_bio, struct inode *inode,
>  }
>
>  static ssize_t check_direct_IO(struct btrfs_fs_info *fs_info,
> -                              struct kiocb *iocb,
>                                const struct iov_iter *iter, loff_t offset)
>  {
>         int seg;
> @@ -8811,7 +8810,7 @@ static ssize_t btrfs_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
>         bool relock = false;
>         ssize_t ret;
>
> -       if (check_direct_IO(fs_info, iocb, iter, offset))
> +       if (check_direct_IO(fs_info, iter, offset))
>                 return 0;
>
>         inode_dio_begin(inode);
> --
> 2.7.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Have a nice day,
Timofey.
