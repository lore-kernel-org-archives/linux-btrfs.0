Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39566 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726444AbeG3JtV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 30 Jul 2018 05:49:21 -0400
Subject: Re: [PATCH 13/16] btrfs: lift make_bad_inode() into btrfs_iget()
To: Al Viro <viro@ZenIV.linux.org.uk>, linux-fsdevel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Miklos Szeredi <mszeredi@redhat.com>,
        David Sterba <dsterba@suse.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <20180729220317.GB30522@ZenIV.linux.org.uk>
 <20180729220453.13431-1-viro@ZenIV.linux.org.uk>
 <20180729220453.13431-13-viro@ZenIV.linux.org.uk>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <34cf62f3-3acc-0ef7-6c5b-906df2b75b29@suse.com>
Date: Mon, 30 Jul 2018 11:15:28 +0300
MIME-Version: 1.0
In-Reply-To: <20180729220453.13431-13-viro@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 30.07.2018 01:04, Al Viro wrote:
> From: Al Viro <viro@zeniv.linux.org.uk>
> 
> we don't need to check is_bad_inode() after the call of
> btrfs_read_locked_inode() - it's exactly the same as checking
> return value for being non-zero.
> 
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

Reviewed-by: Nikolay Borisov <nborisov@suse.com>

> ---
>  fs/btrfs/inode.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 9382e0881900..8f0b2592feb0 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -3777,7 +3777,6 @@ static int btrfs_read_locked_inode(struct inode *inode)
>  
>  make_bad:
>  	btrfs_free_path(path);
> -	make_bad_inode(inode);
>  	return ret;
>  }
>  
> @@ -5708,12 +5707,13 @@ struct inode *btrfs_iget(struct super_block *s, struct btrfs_key *location,
>  		int ret;
>  
>  		ret = btrfs_read_locked_inode(inode);
> -		if (!is_bad_inode(inode)) {
> +		if (!ret) {
>  			inode_tree_add(inode);
>  			unlock_new_inode(inode);
>  			if (new)
>  				*new = 1;
>  		} else {
> +			make_bad_inode(inode);
>  			unlock_new_inode(inode);
>  			iput(inode);
>  			ASSERT(ret < 0);
> 
