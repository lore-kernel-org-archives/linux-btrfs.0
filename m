Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f195.google.com ([209.85.223.195]:33778 "EHLO
        mail-io0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751627AbcLELLW (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 5 Dec 2016 06:11:22 -0500
Received: by mail-io0-f195.google.com with SMTP id j92so21708412ioi.0
        for <linux-btrfs@vger.kernel.org>; Mon, 05 Dec 2016 03:11:22 -0800 (PST)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <1480628704-18216-1-git-send-email-bo.li.liu@oracle.com>
References: <1480628704-18216-1-git-send-email-bo.li.liu@oracle.com>
From: Filipe Manana <fdmanana@gmail.com>
Date: Mon, 5 Dec 2016 11:11:21 +0000
Message-ID: <CAL3q7H7Mga43SXfKHet+M8w9TxF-Gq7O57h_FgtmDzkNuwygRA@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: fix lockdep warning about log_mutex
To: Liu Bo <bo.li.liu@oracle.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        David Sterba <dsterba@suse.cz>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Dec 1, 2016 at 9:45 PM, Liu Bo <bo.li.liu@oracle.com> wrote:
> While checking INODE_REF/INODE_EXTREF for a corner case, we may acquire a
> different inode's log_mutex with holding the current inode's log_mutex, and
> lockdep has complained this with a possilble deadlock warning.
>
> Fix this by using mutex_lock_nested() when processing the other inode's
> log_mutex.
>
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
Reviewed-by: Filipe Manana <fdmanana@suse.com>

Thanks, it works and it's simple.

> ---
>  fs/btrfs/tree-log.c | 12 +++++++++---
>  1 file changed, 9 insertions(+), 3 deletions(-)
>
> diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
> index 3d33c4e..e961451 100644
> --- a/fs/btrfs/tree-log.c
> +++ b/fs/btrfs/tree-log.c
> @@ -37,6 +37,7 @@
>   */
>  #define LOG_INODE_ALL 0
>  #define LOG_INODE_EXISTS 1
> +#define LOG_OTHER_INODE 2
>
>  /*
>   * directory trouble cases
> @@ -4624,7 +4625,7 @@ static int btrfs_log_inode(struct btrfs_trans_handle *trans,
>         if (S_ISDIR(inode->i_mode) ||
>             (!test_bit(BTRFS_INODE_NEEDS_FULL_SYNC,
>                        &BTRFS_I(inode)->runtime_flags) &&
> -            inode_only == LOG_INODE_EXISTS))
> +            inode_only >= LOG_INODE_EXISTS))
>                 max_key.type = BTRFS_XATTR_ITEM_KEY;
>         else
>                 max_key.type = (u8)-1;
> @@ -4648,7 +4649,12 @@ static int btrfs_log_inode(struct btrfs_trans_handle *trans,
>                 return ret;
>         }
>
> -       mutex_lock(&BTRFS_I(inode)->log_mutex);
> +       if (inode_only == LOG_OTHER_INODE) {
> +               inode_only = LOG_INODE_EXISTS;
> +               mutex_lock_nested(&BTRFS_I(inode)->log_mutex, 1);
> +       } else {
> +               mutex_lock(&BTRFS_I(inode)->log_mutex);
> +       }
>
>         /*
>          * a brute force approach to making sure we get the most uptodate
> @@ -4800,7 +4806,7 @@ static int btrfs_log_inode(struct btrfs_trans_handle *trans,
>                                  * unpin it.
>                                  */
>                                 err = btrfs_log_inode(trans, root, other_inode,
> -                                                     LOG_INODE_EXISTS,
> +                                                     LOG_OTHER_INODE,
>                                                       0, LLONG_MAX, ctx);
>                                 iput(other_inode);
>                                 if (err)
> --
> 2.5.5
>



-- 
Filipe David Manana,

"People will forget what you said,
 people will forget what you did,
 but people will never forget how you made them feel."
