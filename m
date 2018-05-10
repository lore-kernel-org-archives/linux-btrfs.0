Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49746 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751632AbeEJOLY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 10 May 2018 10:11:24 -0400
Date: Thu, 10 May 2018 16:08:45 +0200
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
        misono.tomohiro@jp.fujitsu.com
Subject: Re: [PATCH v2 1/8] btrfs: rename btrfs_update_iflags to reflect
 which flags it touches
Message-ID: <20180510140845.GI6649@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1525873677.git.dsterba@suse.com>
 <56697064041956d0bc084593a287136b799b97b7.1525873677.git.dsterba@suse.com>
 <950593c7-258a-db06-14a9-710ec7f1d2a5@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <950593c7-258a-db06-14a9-710ec7f1d2a5@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 10, 2018 at 09:34:21AM +0300, Nikolay Borisov wrote:
> > @@ -136,7 +136,7 @@ static unsigned int btrfs_flags_to_ioctl(unsigned int flags)
> >  /*
> >   * Update inode->i_flags based on the btrfs internal flags.
> >   */
> > -void btrfs_update_iflags(struct inode *inode)
> > +void btrfs_sync_inode_flags_to_i_flags(struct inode *inode)
> >  {
> 
> nit: imho that name is too verbose,

That's intentional to be descriptive enough so reading the comment at
the functions is not necessary.

> I think btrfs_sync_inode_flags
> should suffice alongside the one line comment at the top of the
> function.

There are too many flavors of inodes, which direction would
'btrfs_sync_inode_flags' sync?

> As a matter of fact what necessitates duplicating those flags
> in both the btrfs-specific data structure and the generic vfs inode?

Because btrfs inode flags are part of the on-disk format while the VFS
inode flags are in-memory and can change any time.

> So looking at how btrfs_update_iflags is used, we have:
> 
> btrfs_ioctl_setflags - we gain nothing by having those flags duplicated
> since in case of failure the revert procedure is the same - we have to
> set i_oldflags to both btrfs_inode and vfs_inode
> 
> btrfs_read_locked_inode - so here we read the flags from the on-disk
> inode and then use btrfs_update_iflags to set the generic vfs flags to
> the vfs_inode
> 
> btrfs_inherit_iflags - the call to btrfs_update_iflags is not even
> necessary since none of the flags which is being inherited:
> BTRFS_INODE_NOCOMPRESS/BTRFS_INODE_COMPRESS/BTRFS_INODE_NODATACOW
> is supported by btrfs_update_iflags.
> 
> Given this I'd be more inclined to rename the function to something
> like: btrfs_init_i_flags/btrfs_set_iflags or some such.
> 
> And to go a bit further imho those flags which are generic should always
> be set in the vfs_inode and when we are about to persist an inode item
> on-disk then we should get the necessary flags from the vfs_inode and
> put in the inode item.

Not all btrfs flags have the counterpart in vfs inode flags and vice
versa, they're different namespace and for that we need the conversion
helpers.
