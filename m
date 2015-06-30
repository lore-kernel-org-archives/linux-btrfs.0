Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f177.google.com ([209.85.223.177]:34890 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751754AbbF3IYc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 30 Jun 2015 04:24:32 -0400
Received: by iecuq6 with SMTP id uq6so7280770iec.2
        for <linux-btrfs@vger.kernel.org>; Tue, 30 Jun 2015 01:24:32 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <1435637715-16332-1-git-send-email-dccitaliano@gmail.com>
References: <1435528041-20878-3-git-send-email-dccitaliano@gmail.com>
	<1435637715-16332-1-git-send-email-dccitaliano@gmail.com>
Date: Tue, 30 Jun 2015 09:24:32 +0100
Message-ID: <CAL3q7H7uA=JoYbK1H_1mURrNDMyg2A=T+e57QAa98pRgwjt01Q@mail.gmail.com>
Subject: Re: [PATCH 2/2] [btrfs] btrfs_rename(): don't ignore
 btrfs_end_transaction() return
From: Filipe David Manana <fdmanana@gmail.com>
To: "Davide C. C. Italiano" <dccitaliano@gmail.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 30, 2015 at 5:15 AM, Davide C. C. Italiano
<dccitaliano@gmail.com> wrote:
> From: Davide Italiano <dccitaliano@gmail.com>
>
> btrfs_end_transaction() can return an error -- this happens, e.g.
> if it tries to commit and the transaction was aborted in the meanhwile.
> Swallowing the error is wrong, so explicitly return it.
>
> Signed-off-by: Davide Italiano <dccitaliano@gmail.com>
> ---
>  fs/btrfs/inode.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 59c475c..61b26be 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -9199,7 +9199,8 @@ static int btrfs_rename(struct inode *old_dir, struct dentry *old_dentry,
>                 btrfs_end_log_trans(root);
>         }
>  out_fail:
> -       btrfs_end_transaction(trans, root);
> +       if (!ret)
> +               ret = btrfs_end_transaction(trans, root);

So it an error happened before, we still want to call
btrfs_end_transaction(), otherwise the transaction's refcount never
drops to 0 and its resources are never freed (memory).

Something like this:

if (ret)
    btrfs_end_transaction(trans, root);
else
    ret = btrfs_end_transaction(trans, root);

or

int ret2;

ret2 = btrfs_end_transaction(trans, root);
if (!ret)
    ret = ret2;

Also don't forget to target your patches with V<number> and describe
and what changed between patch versions (see
https://btrfs.wiki.kernel.org/index.php/Writing_patch_for_btrfs for
instructions about how to do it).

thanks

>  out_notrans:
>         if (old_ino == BTRFS_FIRST_FREE_OBJECTID)
>                 up_read(&root->fs_info->subvol_sem);
> --
> 2.4.3
>



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
