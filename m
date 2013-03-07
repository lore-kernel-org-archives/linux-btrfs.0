Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:48387 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933459Ab3CGV3W (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 7 Mar 2013 16:29:22 -0500
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 2B8699A0405
	for <linux-btrfs@vger.kernel.org>; Thu,  7 Mar 2013 14:29:21 -0700 (MST)
Date: Thu, 7 Mar 2013 16:29:18 -0500
From: Josef Bacik <jbacik@fusionio.com>
To: Zach Brown <zab@redhat.com>
CC: Josef Bacik <JBacik@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: add a incompatible format change for smaller
 metadata extent refs
Message-ID: <20130307212918.GB1905@localhost.localdomain>
References: <1362684477-19402-1-git-send-email-jbacik@fusionio.com>
 <20130307195042.GI3565@lenny.home.zabbo.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20130307195042.GI3565@lenny.home.zabbo.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Mar 07, 2013 at 12:50:42PM -0700, Zach Brown wrote:
> 
> > +static inline int btrfs_fs_incompat(struct btrfs_fs_info *fs_info, u64 flag)
> > +{
> > +	struct btrfs_super_block *disk_super;
> > +	disk_super = fs_info->super_copy;
> > +	return (btrfs_super_incompat_flags(disk_super) & flag);
> > +}
> 
> That'll fail if there are ever flag bits that don't fit in an int.  The
> sneakest fix is wrapping the conditional in the obscure !!().  Making it
> a bool and really returning true and false would probably be easier on
> the brain.
> 

We can't do bool but i'll do the !!() thing.

> 
> >  	ret = btrfs_search_slot(trans, root, &key, path, extra_size, 1);
> >  	if (ret < 0) {
> >  		err = ret;
> >  		goto out;
> >  	}
> > +
> > +	/*
> > +	 * We may be a newly converted file system which still has the old fat
> > +	 * extent entries for metadata, so try and see if we have one of those.
> > +	 */
> > +	if (ret > 0 && skinny_metadata) {
> > +		skinny_metadata = false;
> > +		if (path->slots[0]) {
> > +			path->slots[0]--;
> > +			btrfs_item_key_to_cpu(path->nodes[0], &key,
> > +					      path->slots[0]);
> > +			if (key.objectid == bytenr &&
> > +			    key.type == BTRFS_EXTENT_ITEM_KEY &&
> > +			    key.offset == num_bytes)
> > +				ret = 0;
> > +		}
> > +		if (ret) {
> > +			key.type = BTRFS_EXTENT_ITEM_KEY;
> > +			key.offset = num_bytes;
> > +			btrfs_release_path(path);
> > +			goto again;
> > +		}
> > +	}
> > +
> 
> >  			ret = btrfs_search_slot(trans, extent_root,
> >  						&key, path, -1, 1);
> > +			if (ret > 0 && skinny_metadata && path->slots[0]) {
> > +				/*
> > +				 * Couldn't find our skinny metadata item,
> > +				 * see if we have ye olde extent item.
> > +				 */
> > +				path->slots[0]--;
> > +				btrfs_item_key_to_cpu(path->nodes[0], &key,
> > +						      path->slots[0]);
> > +				if (key.objectid == bytenr &&
> > +				    key.type == BTRFS_EXTENT_ITEM_KEY &&
> > +				    key.offset == num_bytes)
> > +					ret = 0;
> > +			}
> > +
> > +			if (ret > 0 && skinny_metadata) {
> > +				skinny_metadata = false;
> > +				key.type = BTRFS_EXTENT_ITEM_KEY;
> > +				key.offset = num_bytes;
> > +				btrfs_release_path(path);
> > +				ret = btrfs_search_slot(trans, extent_root,
> > +							&key, path, -1, 1);
> > +			}
> > +
> 
> These blobs of similar code sure look like they should be in a function.
> 

The searches do different things in different places so we have to have samey
blobs like this until we get everybody on skinny metadata and can delete the old
code.  Thanks,

Josef
