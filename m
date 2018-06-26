Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57853 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752110AbeFZQWD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 26 Jun 2018 12:22:03 -0400
Date: Tue, 26 Jun 2018 18:19:10 +0200
From: David Sterba <dsterba@suse.cz>
To: Chengguang Xu <cgxu519@gmx.com>
Cc: clm@fb.com, jbacik@fb.com, linux-btrfs@vger.kernel.org, nborisov@suse.com
Subject: Re: [PATCH v3] btrfs: code cleanups for btrfs_get_acl()
Message-ID: <20180626161910.GM27958@suse.cz>
Reply-To: dsterba@suse.cz
References: <20180626060827.21121-1-cgxu519@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180626060827.21121-1-cgxu519@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 26, 2018 at 02:08:27PM +0800, Chengguang Xu wrote:
> There is no chance to get into -ERANGE error condition because
> we first call btrfs_getxattr to get the length of the attribute,
> then we do a subsequent call with the size from the first call.
> Between the 2 calls the size shouldn't change. So remove the
> unnecessary -ERANGE error check and meanwhile fix some other
> bad practices as well.
> 
> Detail fixes in this patch.
> - return ERR_PTR(-EINVAL) instead of crashing kernel in default
> case of switch.
> - return original error code when failing from btrfs_getxattr().
> - remove unnecessary bracket.
> - remove unnecessary -ERANGE check.

Hm, that should be really 3 patches, but Nikolay is to blame as he
should have mentioned that when asking for the other things to fix.

> Signed-off-by: Chengguang Xu <cgxu519@gmx.com>
> ---
> v3:
> - Fix some other bad practices.
> - Add more information to commit log.
> 
> v2:
> - Avoid errno overriding instead of print error message in error case.
> - Change commit log for better understanding.
> 
>  fs/btrfs/acl.c | 13 ++++++-------
>  1 file changed, 6 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/btrfs/acl.c b/fs/btrfs/acl.c
> index 15e1dfef56a5..3b66c957ea6f 100644
> --- a/fs/btrfs/acl.c
> +++ b/fs/btrfs/acl.c
> @@ -30,23 +30,22 @@ struct posix_acl *btrfs_get_acl(struct inode *inode, int type)
>  		name = XATTR_NAME_POSIX_ACL_DEFAULT;
>  		break;
>  	default:
> -		BUG();
> +		return ERR_PTR(-EINVAL);

First patch

>  	}
>  
> -	size = btrfs_getxattr(inode, name, "", 0);
> +	size = btrfs_getxattr(inode, name, NULL, 0);

Second patch

>  	if (size > 0) {
>  		value = kzalloc(size, GFP_KERNEL);
>  		if (!value)
>  			return ERR_PTR(-ENOMEM);
>  		size = btrfs_getxattr(inode, name, value, size);
>  	}
> -	if (size > 0) {
> +	if (size > 0)
>  		acl = posix_acl_from_xattr(&init_user_ns, value, size);
> -	} else if (size == -ERANGE || size == -ENODATA || size == 0) {
> +	else if (size == -ENODATA || size == 0)
>  		acl = NULL;
> -	} else {
> -		acl = ERR_PTR(-EIO);
> -	}
> +	else
> +		acl = ERR_PTR(size);

And third patch.

>From current changelog only the 3rd is covered, otherwise 1st and 2nd
are under the "and other bad things", but this deserves a more specific
explanation.

So please split and resend. Thanks.
