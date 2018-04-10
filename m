Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39639 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752721AbeDJMIo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 10 Apr 2018 08:08:44 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 976F6AD8E
        for <linux-btrfs@vger.kernel.org>; Tue, 10 Apr 2018 12:08:43 +0000 (UTC)
Date: Tue, 10 Apr 2018 14:06:14 +0200
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 7/7] btrfs: use fs_info for btrfs_handle_em_exist
 tracepoint
Message-ID: <20180410120614.GB2817@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1523275048.git.dsterba@suse.com>
 <03827d85f2986d6c4dd1d72b477c74464559ebd3.1523275048.git.dsterba@suse.com>
 <5080f406-2d72-59c1-3c63-b441186d1c89@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5080f406-2d72-59c1-3c63-b441186d1c89@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Apr 10, 2018 at 10:45:39AM +0300, Nikolay Borisov wrote:
> On  9.04.2018 14:58, David Sterba wrote:
> > We really want to know to which filesystem the extent map events belong,
> > but as it cannot be reached from the extent_map pointers, we need to
> > pass it down the callchain.
> 
> I really dislike propagating arguments solely for tracepoints purposes,
> but if we don't have any other choice then I guess we should go with it.
> However...
> 
> > @@ -7092,7 +7092,7 @@ struct extent_map *btrfs_get_extent(struct btrfs_inode *inode,
> >  
> >  	err = 0;
> >  	write_lock(&em_tree->lock);
> > -	err = btrfs_add_extent_mapping(em_tree, &em, start, len);
> > +	err = btrfs_add_extent_mapping(fs_info, em_tree, &em, start, len);
> 
> This function is called only here, and we know that em_tree passed
> points to a struct, stored in btrfs_inode. So can't we use container_of
> to get the btrfs_inode in this function, from where we can reference the
> fs_info? I guess it could be a problem for tests.
> 
> 
> Admittedly  this feels somewhat hacky and I guess is not very
> future-proof, but it's still a viable alternative.

Sounds too fragile to me, from all the alternatives passing fs_info
looks like the cleanest way for now.  The filesystem UUID in the
tracepoint is IMO an important part.
