Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53861 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751040AbcFWMnJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 23 Jun 2016 08:43:09 -0400
Date: Thu, 23 Jun 2016 14:43:33 +0200
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [RFC][PATCH] btrfs-progs: inspect: new subcommand to dump chunks
Message-ID: <20160623124332.GA4915@suse.cz>
Reply-To: dsterba@suse.cz
References: <1466616406-28087-1-git-send-email-dsterba@suse.com>
 <20160623015352.GA15815@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160623015352.GA15815@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 22, 2016 at 06:53:52PM -0700, Liu Bo wrote:
> > +static u64 fill_usage(int fd, u64 lstart)
> > +{
> > +	struct btrfs_ioctl_search_args args;
> > +	struct btrfs_ioctl_search_key *sk = &args.key;
> > +	struct btrfs_ioctl_search_header sh;
> > +	struct btrfs_block_group_item *item;
> > +	int ret;
> > +
> > +	memset(&args, 0, sizeof(args));
> > +	sk->tree_id = BTRFS_EXTENT_TREE_OBJECTID;
> > +	sk->min_objectid = lstart;
> > +	sk->max_objectid = lstart;
> > +	sk->min_type = BTRFS_BLOCK_GROUP_ITEM_KEY;
> > +	sk->max_type = BTRFS_BLOCK_GROUP_ITEM_KEY;
> > +	sk->min_offset = 0;
> > +	sk->max_offset = (u64)-1;
> > +	sk->max_transid = (u64)-1;
> > +
> > +	sk->nr_items = 4096;
> 
> What if we set nr_items = 1?  From the code review, this can let us
> stop and return immediately.

Indeed, I've copy-pasted the search code. When it's 1 it returns
immediatelly if the metadata are cached, cold read took a few seconds on
a terabyte-sized filesystem.
