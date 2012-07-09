Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:56208 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753198Ab2GIUdP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 9 Jul 2012 16:33:15 -0400
Date: Mon, 9 Jul 2012 13:33:14 -0700
From: Mark Fasheh <mfasheh@suse.de>
To: Jan Schmidt <list.btrfs@jan-o-sch.net>
Cc: linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH 1/3] btrfs: extended inode refs
Message-ID: <20120709203314.GD8323@wotan.suse.de>
Reply-To: Mark Fasheh <mfasheh@suse.de>
References: <1337636781-12575-1-git-send-email-mfasheh@suse.de> <1337636781-12575-2-git-send-email-mfasheh@suse.de> <4FF6FCA8.2060100@jan-o-sch.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4FF6FCA8.2060100@jan-o-sch.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


> > diff --git a/fs/btrfs/inode-item.c b/fs/btrfs/inode-item.c
> > index baa74f3..496fb1c 100644
> > --- a/fs/btrfs/inode-item.c
> > +++ b/fs/btrfs/inode-item.c
> > @@ -18,6 +18,7 @@
> >  
> >  #include "ctree.h"
> >  #include "disk-io.h"
> > +#include "hash.h"
> >  #include "transaction.h"
> >  
> >  static int find_name_in_backref(struct btrfs_path *path, const char *name,
> > @@ -49,18 +50,56 @@ static int find_name_in_backref(struct btrfs_path *path, const char *name,
> >  	return 0;
> >  }
> >  
> > -struct btrfs_inode_ref *
> > +int find_name_in_ext_backref(struct btrfs_path *path, const char *name,
> > +			     int name_len,
> > +			     struct btrfs_inode_extref **extref_ret)
> 
> Exported functions should be prefixed "btrfs_". What about btrfs_find_extref_name?
> 
> > +{
> > +	struct extent_buffer *leaf;
> > +	struct btrfs_inode_extref *extref;
> > +	unsigned long ptr;
> > +	unsigned long name_ptr;
> > +	u32 item_size;
> > +	u32 cur_offset = 0;
> > +	int ref_name_len;
> > +
> > +	leaf = path->nodes[0];
> > +	item_size = btrfs_item_size_nr(leaf, path->slots[0]);
> > +	ptr = btrfs_item_ptr_offset(leaf, path->slots[0]);
> > +
> > +	/*
> > +	 * Search all extended backrefs in this item. We're only
> > +	 * looking through any collisions so most of the time this is
> > +	 * just going to compare against one buffer. If all is well,
> > +	 * we'll return success and the inode ref object.
> > +	 */
> > +	while (cur_offset < item_size) {
> > +		extref = (struct btrfs_inode_extref *) (ptr + cur_offset);
> > +		name_ptr = (unsigned long)(&extref->name);
> > +		ref_name_len = btrfs_inode_extref_name_len(leaf, extref);
> > +
> > +		if (ref_name_len == name_len
> > +		    && (memcmp_extent_buffer(leaf, name, name_ptr, name_len) == 0)) {
> > +			if (extref_ret)
> > +				*extref_ret = extref;
> > +			return 1;
> > +		}
> > +
> > +		cur_offset += ref_name_len + sizeof(*extref);
> > +	}
> > +	return 0;
> 
> For consistency, I'd like to switch return 0 and 1.

Ok so btrfs_find_name_in_ext_backref() is designed to mirror
btrfs_find_name_in_backref() for obvious reasons - it does the same thing
except for extended backrefs. So it'd actually be inconsistent if I change
this (unless I change both but I don't think we want to do that).

The name is kept without the btrfs_ prefix for the same reasons, however I
don't think prefixing it is a big deal so I'll go ahead and make _that_
change unless you feel otherwise.

Thanks,
	--Mark


--
Mark Fasheh
