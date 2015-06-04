Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f176.google.com ([209.85.223.176]:35615 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751660AbbFDQOM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 4 Jun 2015 12:14:12 -0400
Received: by iesa3 with SMTP id a3so39602639ies.2
        for <linux-btrfs@vger.kernel.org>; Thu, 04 Jun 2015 09:14:12 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <1433416690-19177-6-git-send-email-robbieko@synology.com>
References: <1433416690-19177-1-git-send-email-robbieko@synology.com>
	<1433416690-19177-6-git-send-email-robbieko@synology.com>
Date: Thu, 4 Jun 2015 17:14:12 +0100
Message-ID: <CAL3q7H4LR_72Gs6mrtoaanEum__U8h_tq=VR0CgdV3saJKu1Xw@mail.gmail.com>
Subject: Re: [PATCH 5/5] Btrfs: incremental send, fix rmdir not send utimes
From: Filipe David Manana <fdmanana@gmail.com>
To: Robbie Ko <robbieko@synology.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 4, 2015 at 12:18 PM, Robbie Ko <robbieko@synology.com> wrote:
> There's one case where we can't issue a utimes operation for a directory.
> When 263 will delete, waiting 261 and set 261 rmdir_ino, but 262 earlier
> processed and update uime between two parent directory.
> So fix this by not update non exist utimes for this case.

So you mean that we attempt to update utimes for an inode,
corresponding to a directory, that exists in the parent snapshot but
not in the send snapshot.

So the subject should be something like "Btrfs: incremental send,
don't send utimes for non-existing directory" instead of "Btrfs:
incremental send, fix rmdir not send utimes"

>
> Example:
>
> Parent snapshot:
> |---- a/ (ino 259)
>   |---- c (ino 264)
> |---- b/ (ino 260)
>   |---- d (ino 265)
> |---- del/ (ino 263)
>   |---- item1/ (ino 261)
>   |---- item2/ (ino 262)
>
> Send snapshot:
> |---- a/ (ino 259)
> |---- b/ (ino 260)
> |---- c/ (ino 2)
>   |---- item2 (ino 259)
> |---- d/ (ino 257)
>   |---- item1/ (ino 258)
>
> Signed-off-by: Robbie Ko <robbieko@synology.com>
> ---
>  fs/btrfs/send.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
> index e8eb3ab..46f954c 100644
> --- a/fs/btrfs/send.c
> +++ b/fs/btrfs/send.c
> @@ -2468,7 +2468,7 @@ verbose_printk("btrfs: send_utimes %llu\n", ino);
>         key.type = BTRFS_INODE_ITEM_KEY;
>         key.offset = 0;
>         ret = btrfs_search_slot(NULL, sctx->send_root, &key, path, 0, 0);
> -       if (ret < 0)
> +       if (ret != 0)
>                 goto out;

So I don't think this is a good fix. The problem is in some code that
calls this function (send_utimes) against the directory that doesn't
exist - it just shouldn't do that, its logic should be fixed.
Following this approach, while it works, it's just hiding logic errors
in one or more code paths, and none of its callers checks for a return
value of 1 - they only react to values < 0 and introduces the
possibility of propagating a return value of 1 to user space.

thanks

>
>         eb = path->nodes[0];
> --
> 1.9.1
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
