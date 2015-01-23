Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:41907 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750912AbbAWMUD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 23 Jan 2015 07:20:03 -0500
Date: Fri, 23 Jan 2015 13:20:00 +0100
From: David Sterba <dsterba@suse.cz>
To: Zach Brown <zab@zabbo.net>
Cc: linux-btrfs@vger.kernel.org, chandan r <chandanrmail@gmail.com>
Subject: Re: [PATCH v2] Btrfs: Add code to support file creation time
Message-ID: <20150123122000.GL13289@suse.cz>
Reply-To: dsterba@suse.cz
References: <1421947241-9323-1-git-send-email-dsterba@suse.cz>
 <20150122200109.GA688@lenny.home.zabbo.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20150122200109.GA688@lenny.home.zabbo.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jan 22, 2015 at 12:01:10PM -0800, Zach Brown wrote:
> > @@ -5729,6 +5744,7 @@ static struct inode *btrfs_new_inode(struct btrfs_trans_handle *trans,
> >  	struct btrfs_path *path;
> >  	struct btrfs_inode_ref *ref;
> >  	struct btrfs_key key[2];
> > +	struct timespec current_time;
> >  	u32 sizes[2];
> >  	int nitems = name ? 2 : 1;
> >  	unsigned long ptr;
> > @@ -5824,7 +5840,13 @@ static struct inode *btrfs_new_inode(struct btrfs_trans_handle *trans,
> >  
> >  	inode_init_owner(inode, dir, mode);
> >  	inode_set_bytes(inode, 0);
> > -	inode->i_mtime = inode->i_atime = inode->i_ctime = CURRENT_TIME;
> > +
> > +	current_time = CURRENT_TIME;
> > +	inode->i_mtime = current_time;
> > +	inode->i_atime = current_time;
> > +	inode->i_ctime = current_time;
> > +	BTRFS_I(inode)->i_otime = current_time;
> 
> I might have just set mtime to CURRENT_TIME then the rest to mtime.
> It'd be a touch less noisy.  Author's choice, though :).

Ok, less churn sounds better. I'll do a v2 anyway because I left a fixup
uncommitted (use of btrfs_inode_otime).

> Any plans to add it to send/recv?
> 
> 766702ef (Alexander Block           2012-07-28 14:11:31 +0200 2480)
> 	/* TODO Add otime support when the otime patches get into upstream */

This is part of the send protocol update, otime and other changes. I
don't remember how many pieces are still missing to do the version bump.

