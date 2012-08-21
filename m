Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:51624 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753979Ab2HUOdT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 21 Aug 2012 10:33:19 -0400
Date: Tue, 21 Aug 2012 16:33:04 +0200
From: David Sterba <dave@jikos.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: David Sterba <dave@jikos.cz>,
        =?iso-8859-1?Q?Llu=EDs?= Batlle i Rossell <viric@viric.name>,
        Btrfs mailing list <linux-btrfs@vger.kernel.org>, andrei.popa@i-neo.ro
Subject: Re: State of nocow file attribute
Message-ID: <20120821143304.GK17430@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <20120815101229.GH25996@vicerveza.homeunix.net>
 <502DA230.6010202@oracle.com>
 <20120817145940.GI17430@twin.jikos.cz>
 <502E6386.700@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <502E6386.700@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 17, 2012 at 11:30:14PM +0800, Liu Bo wrote:
> IMO the following is better, just make use of the original check.  If you agree with this,
> I'll send it as a patch :)

I think it's cleaner to keep all flags that get inherited from the
directory -> new file at one place, ie btrfs_inherit_iflags(), than
having them scattered over the code.

> 
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 6e8f416..d4e58df 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -4721,8 +4721,10 @@ static struct inode *btrfs_new_inode(struct btrfs_trans_handle *trans,
>  		if (btrfs_test_opt(root, NODATASUM))
>  			BTRFS_I(inode)->flags |= BTRFS_INODE_NODATASUM;
>  		if (btrfs_test_opt(root, NODATACOW) ||
> -		    (BTRFS_I(dir)->flags & BTRFS_INODE_NODATACOW))
> +		    (BTRFS_I(dir)->flags & BTRFS_INODE_NODATACOW)) {
>  			BTRFS_I(inode)->flags |= BTRFS_INODE_NODATACOW;
> +			BTRFS_I(inode)->flags |= BTRFS_INODE_NODATASUM;
> +		}
>  	}

And even better, this particular check of dir->flags should be removed
entirely, because it duplicates the equivalent in
btrfs_inherit_iflags().

>  
>  	insert_inode_hash(inode);


david
