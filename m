Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f193.google.com ([209.85.213.193]:34595 "EHLO
	mail-ig0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753066AbcC3Vs1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Mar 2016 17:48:27 -0400
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <1459371219-1815-2-git-send-email-luisbg@osg.samsung.com>
References: <1459371219-1815-1-git-send-email-luisbg@osg.samsung.com>
	<1459371219-1815-2-git-send-email-luisbg@osg.samsung.com>
Date: Wed, 30 Mar 2016 22:48:26 +0100
Message-ID: <CAL3q7H7fFg0UNL_hR=rUpbGmFpM2QHK+ME4_NMn3zB4vuJYMcA@mail.gmail.com>
Subject: Re: [PATCH 2/2] btrfs: avoid overflowing f_bfree
From: Filipe Manana <fdmanana@gmail.com>
To: Luis de Bethencourt <luisbg@osg.samsung.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Mar 30, 2016 at 9:53 PM, Luis de Bethencourt
<luisbg@osg.samsung.com> wrote:
> Since mixed block groups accounting isn't byte-accurate and f_bree is an
> unsigned integer, it could overflow. Avoid this.
>
> Signed-off-by: Luis de Bethencourt <luisbg@osg.samsung.com>
> Suggested-by: David Sterba <dsterba@suse.com>
> ---
>  fs/btrfs/super.c | 5 +++++
>  1 file changed, 5 insertions(+)
>
> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> index bdca79c..93376d0 100644
> --- a/fs/btrfs/super.c
> +++ b/fs/btrfs/super.c
> @@ -2101,6 +2101,11 @@ static int btrfs_statfs(struct dentry *dentry, struct kstatfs *buf)
>         /* Account global block reserve as used, it's in logical size already */
>         spin_lock(&block_rsv->lock);
>         buf->f_bfree -= block_rsv->size >> bits;

You forgot to remove the line above, didn't you?

> +       /* Mixed block groups accounting is not byte-accurate, avoid overflow */
> +       if (buf->f_bfree >= block_rsv->size >> bits)
> +               buf->f_bfree -= block_rsv->size >> bits;
> +       else
> +               buf->f_bfree = 0;
>         spin_unlock(&block_rsv->lock);
>
>         buf->f_bavail = div_u64(total_free_data, factor);
> --
> 2.5.3
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
