Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:63061 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752655AbbAPNaB (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 16 Jan 2015 08:30:01 -0500
Received: by mail-lb0-f174.google.com with SMTP id 10so18439097lbg.5
        for <linux-btrfs@vger.kernel.org>; Fri, 16 Jan 2015 05:29:59 -0800 (PST)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <1415968484-9648-1-git-send-email-dsterba@suse.cz>
References: <6b5fe46dfa52441f49c7432b1c1b1cb767834708.1415894837.git.dsterba@suse.cz>
	<1415968484-9648-1-git-send-email-dsterba@suse.cz>
Date: Fri, 16 Jan 2015 13:29:59 +0000
Message-ID: <CAL3q7H5i7LgcdRryhZFDP+1n7MKOSSzX96ixKh5q+K6+nPm9kQ@mail.gmail.com>
Subject: Re: [PATCH 2/6 v2] btrfs: do commit in sync_fs if there are pending changes
From: Filipe David Manana <fdmanana@gmail.com>
To: David Sterba <dsterba@suse.cz>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Nov 14, 2014 at 12:34 PM, David Sterba <dsterba@suse.cz> wrote:
> If a pending change is requested, it's not processed unless there is a
> transaction commit about to happen, not even after sync or SYNC_FS
> ioctl. For example a remount that toggles the inode_cache option will
> not take effect after sync on a quiescent filesystem.
>
> Signed-off-by: David Sterba <dsterba@suse.cz>
> ---
>
> v2: catch error from btrfs_start_transaction

V2 didn't make it to 3.19:
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=6b5fe46dfa52441f49c7432b1c1b1cb767834708

>
>  fs/btrfs/super.c | 14 +++++++++++---
>  1 file changed, 11 insertions(+), 3 deletions(-)
>
> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> index 54bd91ece35b..0cf589402d8d 100644
> --- a/fs/btrfs/super.c
> +++ b/fs/btrfs/super.c
> @@ -993,9 +993,17 @@ int btrfs_sync_fs(struct super_block *sb, int wait)
>         trans = btrfs_attach_transaction_barrier(root);
>         if (IS_ERR(trans)) {
>                 /* no transaction, don't bother */
> -               if (PTR_ERR(trans) == -ENOENT)
> -                       return 0;
> -               return PTR_ERR(trans);
> +               if (PTR_ERR(trans) == -ENOENT) {
> +                       /*
> +                        * Exit unless we have some pending changes
> +                        * that need to go through commit
> +                        */
> +                       if (fs_info->pending_changes == 0)
> +                               return 0;
> +                       trans = btrfs_start_transaction(root, 0);
> +               }
> +               if (IS_ERR(trans))
> +                       return PTR_ERR(trans);
>         }
>         return btrfs_commit_transaction(trans, root);
>  }
> --
> 2.1.3
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
