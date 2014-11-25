Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:47849 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750891AbaKYReb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Nov 2014 12:34:31 -0500
Date: Tue, 25 Nov 2014 18:34:26 +0100
From: Jan Kara <jack@suse.cz>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: linux-fsdevel@vger.kernel.org,
        Ext4 Developers List <linux-ext4@vger.kernel.org>, xfs@oss.sgi.com,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 4/4] ext4: add support for a lazytime mount option
Message-ID: <20141125173426.GF3228@quack.suse.cz>
References: <1416599964-21892-1-git-send-email-tytso@mit.edu>
 <1416599964-21892-5-git-send-email-tytso@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1416599964-21892-5-git-send-email-tytso@mit.edu>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri 21-11-14 14:59:24, Ted Tso wrote:
> Add an optimization for the MS_LAZYTIME mount option so that we will
> opportunistically write out any inodes with the I_DIRTY_TIME flag set
> in a particular inode table block when we need to update some inode in
> that inode table block anyway.
> 
> Also add some temporary code so that we can set the lazytime mount
> option without needing a modified /sbin/mount program which can set
> MS_LAZYTIME.  We can eventually make this go away once util-linux has
> added support.
...
> diff --git a/fs/inode.c b/fs/inode.c
> index f0d6232..89cfca7 100644
> --- a/fs/inode.c
> +++ b/fs/inode.c
> @@ -1292,6 +1292,42 @@ struct inode *ilookup(struct super_block *sb, unsigned long ino)
>  }
>  EXPORT_SYMBOL(ilookup);
>  
> +/**
> + * find_active_inode_nowait - find an active inode in the inode cache
> + * @sb:		super block of file system to search
> + * @ino:	inode number to search for
> + *
> + * Search for an active inode @ino in the inode cache, and if the
> + * inode is in the cache, the inode is returned with an incremented
> + * reference count.  If the inode is being freed or is newly
> + * initialized, return nothing instead of trying to wait for the inode
> + * initialization or destruction to be complete.
> + */
> +struct inode *find_active_inode_nowait(struct super_block *sb,
> +				       unsigned long ino)
> +{
> +	struct hlist_head *head = inode_hashtable + hash(sb, ino);
> +	struct inode *inode, *ret_inode = NULL;
> +
> +	spin_lock(&inode_hash_lock);
> +	hlist_for_each_entry(inode, head, i_hash) {
> +		if ((inode->i_ino != ino) ||
> +		    (inode->i_sb != sb))
> +			continue;
> +		spin_lock(&inode->i_lock);
> +		if ((inode->i_state & (I_FREEING | I_WILL_FREE | I_NEW)) == 0) {
> +			__iget(inode);
> +			ret_inode = inode;
> +		}
> +		spin_unlock(&inode->i_lock);
> +		goto out;
> +	}
> +out:
> +	spin_unlock(&inode_hash_lock);
> +	return ret_inode;
> +}
> +EXPORT_SYMBOL(find_active_inode_nowait);
> +
  Please move this function definition into a separate patch so that it
isn't hidden in an ext4-specific patch. Otherwise it looks good.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
