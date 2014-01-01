Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f53.google.com ([209.85.214.53]:40162 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754303AbaAAPBh (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 1 Jan 2014 10:01:37 -0500
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <1388553589-26778-1-git-send-email-mina86@mina86.com>
References: <1388553589-26778-1-git-send-email-mina86@mina86.com>
Date: Wed, 1 Jan 2014 15:01:36 +0000
Message-ID: <CAL3q7H6ftrPyGK56i2EQ8fZaHa+RvaiFPR9SdJ4C9QrpFGPe=A@mail.gmail.com>
Subject: Re: [PATCH RESEND] btrfs: remove dead code
From: Filipe David Manana <fdmanana@gmail.com>
To: Michal Nazarewicz <mina86@mina86.com>
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 1, 2014 at 5:19 AM, Michal Nazarewicz <mina86@mina86.com> wrote:
> [commit 8185554d: fix incorrect inode acl reset] introduced a dead
> code by adding a condition which can never be true to an else
> branch.  The condition can never be true because it is already
> checked by a previous if statement which causes function to return.
>
> Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
> Reviewed-By: Filipe David Borba Manana <fdmanana@gmail.com>
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
> 1.8.4

Hi Michal,

Josef already added this patch to btrfs-next weeks ago:

http://git.kernel.org/cgit/linux/kernel/git/josef/btrfs-next.git/commit/?id=c4a886e433dce2b902324a54ef2d13691a760312

regards,

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
