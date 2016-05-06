Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47431 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758209AbcEFOkE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 6 May 2016 10:40:04 -0400
Date: Fri, 6 May 2016 16:39:44 +0200
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org, vegard.nossum@oracle.com
Subject: Re: [PATCH 1/2] Btrfs: add more valid checks for superblock
Message-ID: <20160506143944.GE29353@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1462212951-28113-1-git-send-email-bo.li.liu@oracle.com>
 <20160504132935.GU29353@twin.jikos.cz>
 <20160504174001.GA14909@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160504174001.GA14909@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 04, 2016 at 10:40:02AM -0700, Liu Bo wrote:
> > > +		printk(KERN_ERR "BTRFS: bytes_used is too small %llu\n",
> > > +		       btrfs_super_bytes_used(sb));
> > > +		ret = -EINVAL;
> > > +	}
> > > +	if (btrfs_super_stripesize(sb) != 4096) {
> > 
> > This is too strict. The stripesize is unused, but we not force it to be
> > 4k, a multiple of nodesize/sectorsize should be enough.
> 
> Hmm, in fact stripesize is used in find_free_extent(),
> 
> find_free_extent() {
> 	...
> 	search_start = ALIGN(offset, root->stripesize);
> 	...
> }
> 
> and in open_ctree(),
> 
> open_ctree() {
> 	...
> 	stripesize = btrfs_super_stripesize(disk_super);
> 	...
> 	tree_root->stripesize = stripesize;
> 	...
> }
> 
> btrfs_read_roots() {
> 	...
> 	btrfs_read_tree_root()  --> __setup_root(..., tree_root->stripesize, ...)
> }
> 
> Thus, this stripesize has to be sectorsize at least.

Yes, and must be power of two because of ALIGN for now.
