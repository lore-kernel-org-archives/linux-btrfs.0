Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f172.google.com ([209.85.213.172]:34204 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753451AbbF2JDq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 29 Jun 2015 05:03:46 -0400
Received: by igcsj18 with SMTP id sj18so74839132igc.1
        for <linux-btrfs@vger.kernel.org>; Mon, 29 Jun 2015 02:03:45 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <1435528041-20878-3-git-send-email-dccitaliano@gmail.com>
References: <1435528041-20878-1-git-send-email-dccitaliano@gmail.com>
	<1435528041-20878-3-git-send-email-dccitaliano@gmail.com>
Date: Mon, 29 Jun 2015 10:03:45 +0100
Message-ID: <CAL3q7H6_VXn2E_4ydTW3jhJ8wK1Pi7RG-K4J9TxiT+R67PBaeA@mail.gmail.com>
Subject: Re: [PATCH 2/2] [btrfs] btrfs_rename(): don't ignore
 btrfs_end_transaction() return
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
> btrfs_end_transaction() can return an error -- this happens, e.g.
> if it tries to commit and the transaction was aborted in the meanhwile.
> Swallowing the error is wrong, so explicitly return it.
>
> Signed-off-by: Davide Italiano <dccitaliano@gmail.com>
> ---
>  fs/btrfs/inode.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 59c475c..7764132 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -9199,7 +9199,7 @@ static int btrfs_rename(struct inode *old_dir, struct dentry *old_dentry,
>                 btrfs_end_log_trans(root);
>         }
>  out_fail:
> -       btrfs_end_transaction(trans, root);
> +       ret = btrfs_end_transaction(trans, root);

Hi,

Good intention but it's now swallowing errors from earlier places in
the code that jump to the out_fail label. For e.g. if the call to
btrfs_set_inode_index() fails, we jump to out_fail and we lose the
error value that it returned (btrfs_end_transaction() returns 0 for
e.g.), so userspace thinks everything succeed when it didn't.
Correct fix is to set ret to the return value of
btrfs_end_transaction() only if ret is currently zero.

thanks

>  out_notrans:
>         if (old_ino == BTRFS_FIRST_FREE_OBJECTID)
>                 up_read(&root->fs_info->subvol_sem);
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
