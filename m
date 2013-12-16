Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:60292 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754395Ab3LPP1c (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 16 Dec 2013 10:27:32 -0500
Date: Mon, 16 Dec 2013 16:27:30 +0100
From: David Sterba <dsterba@suse.cz>
To: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, mfasheh@suse.de
Subject: Re: [PATCH] Btrfs: fix error check of btrfs_lookup_dentry()
Message-ID: <20131216152730.GI6498@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <201312130051.AA00031@FM-323941448.jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <201312130051.AA00031@FM-323941448.jp.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Dec 13, 2013 at 09:51:42AM +0900, Tsutomu Itoh wrote:
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -4974,10 +4974,17 @@ static void btrfs_dentry_release(struct dentry *dentry)
>  static struct dentry *btrfs_lookup(struct inode *dir, struct dentry *dentry,
>  				   unsigned int flags)
>  {
> -	struct dentry *ret;
> +	struct inode *inode;
>  
> -	ret = d_splice_alias(btrfs_lookup_dentry(dir, dentry), dentry);
> -	return ret;
> +	inode = btrfs_lookup_dentry(dir, dentry);
> +	if (IS_ERR(inode)) {
> +		if (PTR_ERR(inode) == -ENOENT)
> +			inode = NULL;
> +		else
> +			return ERR_CAST(inode);
> +	}
> +
> +	return d_splice_alias(inode, dentry);

btrfs_lookup used to be a simple d_splice_alias(btrfs_lookup_dentry ...)
and the expanded back and forth with the DCACHE_NEED_LOOKUP flag.

a66e7cc626f42de6c745963fe0d807518fa49d39 added
39e3c9553f34381a1b664c27b0c696a266a5735e removed

d_splice_alias has been made robust in
a9049376ee05bf966bfe2b081b5071326856890a
"make d_splice_alias(ERR_PTR(err), dentry) = ERR_PTR(err)"

you can drop the error handling from btrfs_lookup completely.

The rest looks ok.
