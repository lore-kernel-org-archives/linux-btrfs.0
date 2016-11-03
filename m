Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from sym2.noone.org ([178.63.92.236]:51925 "EHLO sym2.noone.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754155AbcKCMwh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 3 Nov 2016 08:52:37 -0400
Date: Thu, 3 Nov 2016 13:43:50 +0100
From: Tobias Klauser <tklauser@distanz.ch>
To: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: clm@fb.com, jbacik@fb.com, dsterba@suse.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] btrfs: Remove some dead code
Message-ID: <20161103124349.GA819@distanz.ch>
References: <20161101102606.27006-1-christophe.jaillet@wanadoo.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20161101102606.27006-1-christophe.jaillet@wanadoo.fr>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-11-01 at 11:26:06 +0100, Christophe JAILLET <christophe.jaillet@wanadoo.fr> wrote:
> 'btrfs_iget()' can not return an error pointer, so this test can be
> removed.

This descrption does not match what the patch actually does. Shouldn't
it say "...can not return NULL, so this test can be removed."?


> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> ---
>  fs/btrfs/free-space-cache.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
> index e4b48f377d3a..afd8b0c10acd 100644
> --- a/fs/btrfs/free-space-cache.c
> +++ b/fs/btrfs/free-space-cache.c
> @@ -75,8 +75,6 @@ static struct inode *__lookup_free_space_inode(struct btrfs_root *root,
>  	btrfs_release_path(path);
>  
>  	inode = btrfs_iget(root->fs_info->sb, &location, root, NULL);
> -	if (!inode)
> -		return ERR_PTR(-ENOENT);
>  	if (IS_ERR(inode))
>  		return inode;
>  	if (is_bad_inode(inode)) {
> -- 
> 2.9.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe kernel-janitors" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
