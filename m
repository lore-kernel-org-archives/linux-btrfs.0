Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f54.google.com ([209.85.215.54]:64100 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750946Ab3BVGe2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 Feb 2013 01:34:28 -0500
Received: by mail-la0-f54.google.com with SMTP id gw10so292644lab.27
        for <linux-btrfs@vger.kernel.org>; Thu, 21 Feb 2013 22:34:26 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1361478855-5059-1-git-send-email-jbacik@fusionio.com>
References: <1361478855-5059-1-git-send-email-jbacik@fusionio.com>
Date: Fri, 22 Feb 2013 01:34:26 -0500
Message-ID: <CAAdM647zVT4uJnZ-iHQky_RC7Lq1GdVYYaxLcEc1+TwRcyxVvQ@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: make sure NODATACOW also gets NODATASUM set
From: Marios Titas <redneb8888@gmail.com>
To: Josef Bacik <jbacik@fusionio.com>
Cc: btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

A few weeks ago I reported a similar bug [1]. It has to do with file
renaming. Do you think that it is related? This patch doesn't seem to
help.

[1] http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg21640.html

On Thu, Feb 21, 2013 at 3:34 PM, Josef Bacik <jbacik@fusionio.com> wrote:
> A user reported hitting the BUG_ON() in btrfs_finished_ordered_io() where we had
> csums on a NOCOW extent.  This can happen if we have NODATACOW set but not
> NODATASUM set, which can happen in two cases, either we mount with -o nodatacow
> and then write into preallocated space, or chattr +C a directory and move a file
> into that directory.  This patch fixes up those two cases and now we should
> uniformly have NODATACOW and NODATASUM set always.  Thanks,
>
> Signed-off-by: Josef Bacik <jbacik@fusionio.com>
> ---
>  fs/btrfs/inode.c |    6 ++++--
>  1 files changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 40d49da..5d7ceb5 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -5574,7 +5574,8 @@ static struct inode *btrfs_new_inode(struct btrfs_trans_handle *trans,
>                 if (btrfs_test_opt(root, NODATASUM))
>                         BTRFS_I(inode)->flags |= BTRFS_INODE_NODATASUM;
>                 if (btrfs_test_opt(root, NODATACOW))
> -                       BTRFS_I(inode)->flags |= BTRFS_INODE_NODATACOW;
> +                       BTRFS_I(inode)->flags |= BTRFS_INODE_NODATACOW |
> +                               BTRFS_INODE_NODATASUM;
>         }
>
>         insert_inode_hash(inode);
> @@ -8069,7 +8070,8 @@ static void fixup_inode_flags(struct inode *dir, struct inode *inode)
>         struct btrfs_inode *b_inode = BTRFS_I(inode);
>
>         if (b_dir->flags & BTRFS_INODE_NODATACOW)
> -               b_inode->flags |= BTRFS_INODE_NODATACOW;
> +               b_inode->flags |= BTRFS_INODE_NODATACOW |
> +                       BTRFS_INODE_NODATASUM;
>         else
>                 b_inode->flags &= ~BTRFS_INODE_NODATACOW;
>
> --
> 1.7.7.6
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
