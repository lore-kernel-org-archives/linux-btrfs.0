Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from brockman.in8.de ([85.214.220.56]:48485 "EHLO mail.in8.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760524Ab3JPMtz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 Oct 2013 08:49:55 -0400
Message-ID: <525E8B72.1060706@jan-o-sch.net>
Date: Wed, 16 Oct 2013 14:49:54 +0200
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
MIME-Version: 1.0
To: Josef Bacik <jbacik@fusionio.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: use right root when checking for hash collision
References: <1381336002-3016-1-git-send-email-jbacik@fusionio.com>
In-Reply-To: <1381336002-3016-1-git-send-email-jbacik@fusionio.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, October 09, 2013 at 18:26 (+0200), Josef Bacik wrote:
> btrfs_rename was using the root of the old dir instead of the root of the new
> dir when checking for a hash collision, so if you tried to move a file into a
> subvol it would freak out because it would see the file you are trying to move
> in its current root.  This fixes the bug where this would fail
> 
> btrfs subvol create test1
> btrfs subvol create test2
> mv test1 test2.
> 
> Thanks to Chris Murphy for catching this,
> 
> Reported-by: Chris Murphy <lists@colorremedies.com>
> Signed-off-by: Josef Bacik <jbacik@fusionio.com>
> ---
>  fs/btrfs/inode.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 1d7ef37..d468246 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -7993,7 +7993,7 @@ static int btrfs_rename(struct inode *old_dir, struct dentry *old_dentry,
>  
>  
>  	/* check for collisions, even if the  name isn't there */
> -	ret = btrfs_check_dir_item_collision(root, new_dir->i_ino,
> +	ret = btrfs_check_dir_item_collision(dest, new_dir->i_ino,
>  			     new_dentry->d_name.name,
>  			     new_dentry->d_name.len);

Looks correct.

I claim that better variable names would have had avoided this bug. The code
uses old_dir / new_dir, old_entry / new_entry, old_inode / new_inode - so, while
you're at it: How about changing the variables to old_root / new_root instead of
keeping root / dest?

- Jan
