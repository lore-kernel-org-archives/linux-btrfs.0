Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40678 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726450AbeG3JvH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 30 Jul 2018 05:51:07 -0400
Subject: Re: [PATCH 14/16] btrfs: simplify btrfs_iget()
To: Al Viro <viro@ZenIV.linux.org.uk>, linux-fsdevel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Miklos Szeredi <mszeredi@redhat.com>,
        David Sterba <dsterba@suse.cz>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <20180729220317.GB30522@ZenIV.linux.org.uk>
 <20180729220453.13431-1-viro@ZenIV.linux.org.uk>
 <20180729220453.13431-14-viro@ZenIV.linux.org.uk>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <4d23323d-9c85-bcfc-ffb8-6477a9ef3c38@suse.com>
Date: Mon, 30 Jul 2018 11:17:14 +0300
MIME-Version: 1.0
In-Reply-To: <20180729220453.13431-14-viro@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

[ADDED David Sterba and Linux-btrfs ml to cc. ]

On 30.07.2018 01:04, Al Viro wrote:
> From: Al Viro <viro@zeniv.linux.org.uk>
> 
> don't open-code iget_failed(), don't bother with btrfs_free_path(NULL),
> move handling of positive return values of btrfs_lookup_inode() from
> btrfs_read_locked_inode() to btrfs_iget() and kill now obviously pointless
> ASSERT() in there.
> 
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

Reviewed-by: Nikolay Borisov <nborisov@suse.com>

> ---
>  fs/btrfs/inode.c | 24 ++++++++----------------
>  1 file changed, 8 insertions(+), 16 deletions(-)
> 
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 8f0b2592feb0..388b2dba68a0 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -3610,18 +3610,15 @@ static int btrfs_read_locked_inode(struct inode *inode)
>  		filled = true;
>  
>  	path = btrfs_alloc_path();
> -	if (!path) {
> -		ret = -ENOMEM;
> -		goto make_bad;
> -	}
> +	if (!path)
> +		return -ENOMEM;
>  
>  	memcpy(&location, &BTRFS_I(inode)->location, sizeof(location));
>  
>  	ret = btrfs_lookup_inode(NULL, root, path, &location, 0);
>  	if (ret) {
> -		if (ret > 0)
> -			ret = -ENOENT;
> -		goto make_bad;
> +		btrfs_free_path(path);
> +		return ret;
>  	}
>  
>  	leaf = path->nodes[0];
> @@ -3774,10 +3771,6 @@ static int btrfs_read_locked_inode(struct inode *inode)
>  
>  	btrfs_sync_inode_flags_to_i_flags(inode);
>  	return 0;
> -
> -make_bad:
> -	btrfs_free_path(path);
> -	return ret;
>  }
>  
>  /*
> @@ -5713,11 +5706,10 @@ struct inode *btrfs_iget(struct super_block *s, struct btrfs_key *location,
>  			if (new)
>  				*new = 1;
>  		} else {
> -			make_bad_inode(inode);
> -			unlock_new_inode(inode);
> -			iput(inode);
> -			ASSERT(ret < 0);
> -			inode = ERR_PTR(ret < 0 ? ret : -ESTALE);
> +			iget_failed(inode);
> +			if (ret > 0)
> +				ret = -ENOENT;
> +			inode = ERR_PTR(ret);
>  		}
>  	}
>  
> 
