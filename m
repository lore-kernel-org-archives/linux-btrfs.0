Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42390 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934303AbcIVPDI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 22 Sep 2016 11:03:08 -0400
Date: Thu, 22 Sep 2016 17:01:06 +0200
From: David Sterba <dsterba@suse.cz>
To: Holger =?iso-8859-1?Q?Hoffst=E4tte?=
        <holger@applied-asynchrony.com>
Cc: Liu Bo <bo.li.liu@oracle.com>, linux-btrfs@vger.kernel.org,
        David Sterba <dsterba@suse.cz>, Josef Bacik <jbacik@fb.com>
Subject: Re: [PATCH] Btrfs: fix memory leak in do_walk_down
Message-ID: <20160922150106.GP16983@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1473818547-615-1-git-send-email-bo.li.liu@oracle.com>
 <57D94E56.7040501@applied-asynchrony.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <57D94E56.7040501@applied-asynchrony.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Sep 14, 2016 at 03:19:18PM +0200, Holger Hoffstätte wrote:
> On 09/14/16 04:02, Liu Bo wrote:
> > The extent buffer 'next' needs to be free'd conditionally.
> > 
> > Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> > ---
> >  fs/btrfs/extent-tree.c | 1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> > index 5a940ab..779fd72 100644
> > --- a/fs/btrfs/extent-tree.c
> > +++ b/fs/btrfs/extent-tree.c
> > @@ -8882,6 +8882,7 @@ static noinline int do_walk_down(struct btrfs_trans_handle *trans,
> >  				       &wc->flags[level - 1]);
> >  	if (ret < 0) {
> >  		btrfs_tree_unlock(next);
> > +		free_extent_buffer(next);
> >  		return ret;
> >  	}
> >  
> > 
> 
> This was fixed a long time ago by the following patch by Josef:
> 
> "Btrfs: don't BUG() during drop snapshot"
> https://patchwork.kernel.org/patch/7002791/
> 
> ..which never got merged.

The patch was buried in some thread, not even a subject gives a hint
there's a patch, but anyway thanks for pointing it out.
