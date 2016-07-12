Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:49078 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754391AbcGLRGB (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Jul 2016 13:06:01 -0400
Date: Tue, 12 Jul 2016 10:08:45 -0700
From: Liu Bo <bo.li.liu@oracle.com>
To: Chris Mason <clm@fb.com>
Cc: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH] Btrfs: fix panic in balance due to EIO
Message-ID: <20160712170845.GA2870@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1468283820-25471-1-git-send-email-bo.li.liu@oracle.com>
 <855a29a1-1b46-c1be-418c-de08cb484bd7@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <855a29a1-1b46-c1be-418c-de08cb484bd7@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jul 12, 2016 at 11:05:48AM -0400, Chris Mason wrote:
> 
> 
> On 07/11/2016 08:37 PM, Liu Bo wrote:
> > During build_backref_tree(), if we fail to read a btree node,
> > we can eventually run into BUG_ON(cache->nr_nodes) that we put
> > in backref_cache_cleanup(), meaning we have at least one
> > memory leak.
> > 
> > This frees the backref_node that we allocate at the very beginning of build_backref_tree().
> > 
> > Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> > ---
> >  fs/btrfs/relocation.c | 7 +++++++
> >  1 file changed, 7 insertions(+)
> > 
> > diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
> > index 0477dca..f00267a 100644
> > --- a/fs/btrfs/relocation.c
> > +++ b/fs/btrfs/relocation.c
> > @@ -1135,6 +1135,8 @@ out:
> >  	btrfs_free_path(path1);
> >  	btrfs_free_path(path2);
> >  	if (err) {
> > +		int orig_free = 0;
> > +
> >  		while (!list_empty(&useless)) {
> >  			lower = list_entry(useless.next,
> >  					   struct backref_node, list);
> > @@ -1171,8 +1173,13 @@ out:
> >  			lower = list_entry(useless.next,
> >  					   struct backref_node, list);
> >  			list_del_init(&lower->list);
> > +			if (lower == node)
> > +				orig_free = 1;
> >  			free_backref_node(cache, lower);
> >  		}
> > +
> > +		if (!orig_free)
> > +			free_backref_node(cache, node);
> >  		return ERR_PTR(err);
> >  	}
> >  	ASSERT(!node || !node->detached);
> 
> Instead of doing the orig_free set and test
> 
> 	...
> 	if (lower == node)
> 		node = NULL
> 	free_backref_node(cache, lower)
> }
> free_backref_node(cache, node);
> return ERR_PTR(err);
> 
> Your patch isn't wrong, but having node NULL after it was free'd makes us
> less likely to make mistakes as the code changes.

Golden rule indeed.

Thanks,

-liubo
