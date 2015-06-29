Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f170.google.com ([209.85.223.170]:35774 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752613AbbF2I77 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 29 Jun 2015 04:59:59 -0400
Received: by iecuq6 with SMTP id uq6so11383826iec.2
        for <linux-btrfs@vger.kernel.org>; Mon, 29 Jun 2015 01:59:58 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <1435528041-20878-2-git-send-email-dccitaliano@gmail.com>
References: <1435528041-20878-1-git-send-email-dccitaliano@gmail.com>
	<1435528041-20878-2-git-send-email-dccitaliano@gmail.com>
Date: Mon, 29 Jun 2015 09:59:58 +0100
Message-ID: <CAL3q7H4jyL00OepP9GZxLOFLYF-GWKUN6JJc6o623u+Atepj8g@mail.gmail.com>
Subject: Re: [PATCH 1/2] [btrfs] btrfs_rename: abort transaction in case of error.
From: Filipe David Manana <fdmanana@gmail.com>
To: "Davide C. C. Italiano" <dccitaliano@gmail.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Jun 28, 2015 at 10:47 PM, Davide C. C. Italiano
<dccitaliano@gmail.com> wrote:
> From: Davide Italiano <dccitaliano@gmail.com>
>
> btrfs_insert_inode_ref() may fail and we want to make sure
> the transaction is aborted before calling btrfs_end_transaction(),
> as it already happens everywhere else in this function in case
> of error.
>
> Signed-off-by: Davide Italiano <dccitaliano@gmail.com>
> ---
>  fs/btrfs/inode.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 8bb0136..59c475c 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -9114,8 +9114,11 @@ static int btrfs_rename(struct inode *old_dir, struct dentry *old_dentry,
>                                              new_dentry->d_name.len,
>                                              old_ino,
>                                              btrfs_ino(new_dir), index);
> -               if (ret)
> +               if (ret) {
> +                       btrfs_abort_transaction(trans, root, ret);
>                         goto out_fail;
> +               }
> +

Hi,

I don't think we need a transaction abortion here. The reason it's not
being done is likely because at that point the trees are in a
consistent state (i.e. we haven't touched any of them yet) and not
because it was forgotten. So an abortion there is
unnecessary/excessive.

thanks

>                 /*
>                  * this is an ugly little race, but the rename is required
>                  * to make sure that if we crash, the inode is either at the
> --
> 2.4.3
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
