Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:58433 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754179Ab3JJAwX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 9 Oct 2013 20:52:23 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 5A9E09A041C
	for <linux-btrfs@vger.kernel.org>; Wed,  9 Oct 2013 18:52:23 -0600 (MDT)
Date: Wed, 9 Oct 2013 20:52:20 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: "Geyslan G. Bem" <geyslan@gmail.com>
CC: <chris.mason@fusionio.com>, <linux-btrfs@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <kernel-br@googlegroups.com>
Subject: Re: [PATCH v3] btrfs: Fix memory leakage in the tree-log.c
Message-ID: <20131010005220.GI16461@localhost.localdomain>
References: <1381362030-29595-1-git-send-email-geyslan@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1381362030-29595-1-git-send-email-geyslan@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Oct 09, 2013 at 08:40:30PM -0300, Geyslan G. Bem wrote:
> In some cases, add_inode_ref() is returning without freeing
> the 'name' pointer.
> 
> Added bail out to explicitly call kfree when necessary.
> 
> Signed-off-by: Geyslan G. Bem <geyslan@gmail.com>
> ---
>  fs/btrfs/tree-log.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
> index 79f057c..ad7cc5f 100644
> --- a/fs/btrfs/tree-log.c
> +++ b/fs/btrfs/tree-log.c
> @@ -1170,13 +1170,16 @@ static noinline int add_inode_ref(struct btrfs_trans_handle *trans,
>  			if (!dir)
>  				dir = read_one_inode(root, parent_objectid);
>  			if (!dir)
> -				return -ENOENT;
> +			{
> +				ret = -ENOENT;
> +				goto bail;
> +			}

Code formatting is

if () {
}

not

if ()
{
}


>  		} else {
>  			ret = ref_get_fields(eb, ref_ptr, &namelen, &name,
>  					     &ref_index);
>  		}
>  		if (ret)
> -			return ret;
> +			goto bail;
>  
>  		/* if we already have a perfect match, we're done */
>  		if (!inode_in_dir(root, path, btrfs_ino(dir), btrfs_ino(inode),
> @@ -1227,6 +1230,9 @@ out:
>  	btrfs_release_path(path);
>  	iput(dir);
>  	iput(inode);
> +bail:
> +	if (name)
> +		kfree(name);

kfree already does the if (name) part of this so this is redundant.  Also if you
are going to do this you need to set name = NULL; after the kfree above it
otherwise we have a double free.  Thanks,

Josef
