Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58005 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751623AbdIKRHt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 11 Sep 2017 13:07:49 -0400
Date: Mon, 11 Sep 2017 19:06:18 +0200
From: David Sterba <dsterba@suse.cz>
To: Christos Gkekas <chris.gekas@gmail.com>
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] btrfs: Clean up dead code in root-tree
Message-ID: <20170911170618.GA14538@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1504967374-14144-1-git-send-email-chris.gekas@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1504967374-14144-1-git-send-email-chris.gekas@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Sep 09, 2017 at 03:29:34PM +0100, Christos Gkekas wrote:
> The value of variable 'can_recover' is never used after being set, thus
> it should be removed.

Seems it has never been used since introduction in commit
68a7342c51c95042 .

Reviewed-by: David Sterba <dsterba@suse.com>
> 
> Signed-off-by: Christos Gkekas <chris.gekas@gmail.com>
> ---
>  fs/btrfs/root-tree.c | 4 ----
>  1 file changed, 4 deletions(-)
> 
> diff --git a/fs/btrfs/root-tree.c b/fs/btrfs/root-tree.c
> index 95bcc3c..3338407 100644
> --- a/fs/btrfs/root-tree.c
> +++ b/fs/btrfs/root-tree.c
> @@ -226,10 +226,6 @@ int btrfs_find_orphan_roots(struct btrfs_fs_info *fs_info)
>  	struct btrfs_root *root;
>  	int err = 0;
>  	int ret;
> -	bool can_recover = true;
> -
> -	if (sb_rdonly(fs_info->sb))
> -		can_recover = false;
>  
>  	path = btrfs_alloc_path();
>  	if (!path)
> -- 
> 2.7.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
