Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail02.iobjects.de ([188.40.134.68]:49292 "EHLO
        mail02.iobjects.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756110AbcINNTV (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 14 Sep 2016 09:19:21 -0400
Subject: Re: [PATCH] Btrfs: fix memory leak in do_walk_down
To: Liu Bo <bo.li.liu@oracle.com>, linux-btrfs@vger.kernel.org
References: <1473818547-615-1-git-send-email-bo.li.liu@oracle.com>
Cc: David Sterba <dsterba@suse.cz>, Josef Bacik <jbacik@fb.com>
From: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>
Message-ID: <57D94E56.7040501@applied-asynchrony.com>
Date: Wed, 14 Sep 2016 15:19:18 +0200
MIME-Version: 1.0
In-Reply-To: <1473818547-615-1-git-send-email-bo.li.liu@oracle.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09/14/16 04:02, Liu Bo wrote:
> The extent buffer 'next' needs to be free'd conditionally.
> 
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> ---
>  fs/btrfs/extent-tree.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 5a940ab..779fd72 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -8882,6 +8882,7 @@ static noinline int do_walk_down(struct btrfs_trans_handle *trans,
>  				       &wc->flags[level - 1]);
>  	if (ret < 0) {
>  		btrfs_tree_unlock(next);
> +		free_extent_buffer(next);
>  		return ret;
>  	}
>  
> 

This was fixed a long time ago by the following patch by Josef:

"Btrfs: don't BUG() during drop snapshot"
https://patchwork.kernel.org/patch/7002791/

..which never got merged. I've been using it since 4.1.x until today
without problems.

Note that apparently Patchwork got confused here: downloading only the
"patch" fragment won't work; you'll need the full "mbox" attachment.
It also seems to have been sorted into the wrong list bucket for some
reason.

-h

