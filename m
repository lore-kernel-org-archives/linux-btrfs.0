Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f50.google.com ([209.85.214.50]:53278 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754031Ab3K2UAn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 29 Nov 2013 15:00:43 -0500
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <1385744475-9614-1-git-send-email-mpn@google.com>
References: <1385744475-9614-1-git-send-email-mpn@google.com>
Date: Fri, 29 Nov 2013 20:00:42 +0000
Message-ID: <CAL3q7H7-g9YVr9cCmH3qeLTn+U5hv_Dz5EhkJXGh7rp-RScn6g@mail.gmail.com>
Subject: Re: [PATCH] btrfs: remove dead code
From: Filipe David Manana <fdmanana@gmail.com>
To: Michal Nazarewicz <mpn@google.com>
Cc: Chris Mason <chris.mason@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Nov 29, 2013 at 5:01 PM, Michal Nazarewicz <mpn@google.com> wrote:
> From: Michal Nazarewicz <mina86@mina86.com>
>
> [commit 8185554d: fix incorrect inode acl reset] introduced a dead
> code by adding a condition which can never be true to an else
> branch.  The condition can never be true because it is already
> checked by a previous if statement which causes function to return.
>
> Signed-off-by: Michal Nazarewicz <mina86@mina86.com>

Reviewed-By: Filipe David Borba Manana <fdmanana@gmail.com>

> ---
>  fs/btrfs/acl.c | 7 +------
>  1 file changed, 1 insertion(+), 6 deletions(-)
>
> diff --git a/fs/btrfs/acl.c b/fs/btrfs/acl.c
> index 0890c83..460f36b 100644
> --- a/fs/btrfs/acl.c
> +++ b/fs/btrfs/acl.c
> @@ -225,13 +225,8 @@ int btrfs_init_acl(struct btrfs_trans_handle *trans,
>                 ret = posix_acl_create(&acl, GFP_NOFS, &inode->i_mode);
>                 if (ret < 0)
>                         return ret;
> -
> -               if (ret > 0) {
> -                       /* we need an acl */
> +               if (ret > 0) /* we need an acl */
>                         ret = btrfs_set_acl(trans, inode, acl, ACL_TYPE_ACCESS);
> -               } else if (ret < 0) {
> -                       cache_no_acl(inode);
> -               }
>         } else {
>                 cache_no_acl(inode);
>         }
> --
> 1.8.4.1
>



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
