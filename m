Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49067 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757182AbeEJOBR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 10 May 2018 10:01:17 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 5C712AEE0
        for <linux-btrfs@vger.kernel.org>; Thu, 10 May 2018 14:01:16 +0000 (UTC)
Date: Thu, 10 May 2018 15:58:38 +0200
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: David Sterba <dsterba@suse.cz>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 4/8] btrfs: Open-code add_delayed_tree_ref
Message-ID: <20180510135838.GH6649@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1524579504-30304-1-git-send-email-nborisov@suse.com>
 <1524579504-30304-5-git-send-email-nborisov@suse.com>
 <7fd7e755-65ca-5784-4525-40222b66eb53@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <7fd7e755-65ca-5784-4525-40222b66eb53@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 10, 2018 at 04:55:24PM +0300, Nikolay Borisov wrote:
> > @@ -795,12 +752,25 @@ int btrfs_add_delayed_tree_ref(struct btrfs_fs_info *fs_info,
> >  	struct btrfs_qgroup_extent_record *record = NULL;
> >  	int qrecord_inserted;
> >  	int is_system = (ref_root == BTRFS_CHUNK_TREE_OBJECTID);
> > +	int ret;
> > +	u8 ref_type = parent ? BTRFS_SHARED_BLOCK_REF_KEY :
> > +		BTRFS_TREE_BLOCK_REF_KEY;
> >  
> >  	BUG_ON(extent_op && extent_op->is_data);
> >  	ref = kmem_cache_alloc(btrfs_delayed_tree_ref_cachep, GFP_NOFS);
> >  	if (!ref)
> >  		return -ENOMEM;
> >  
> > +	if (parent)
> > +		ref_type = BTRFS_SHARED_BLOCK_REF_KEY;
> > +	else
> > +		ref_type = BTRFS_TREE_BLOCK_REF_KEY;
> 
> Ooops, this if (parent) check is duplicated with the "parent ? " at the
> beginning of the function. Would you care to delete either of them -
> perhaps this one, or should I send a fixlet for you to squash ?

I removed it.
