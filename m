Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:51537 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754429AbcIFWEI (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 6 Sep 2016 18:04:08 -0400
Date: Tue, 6 Sep 2016 15:04:01 -0700
From: Liu Bo <bo.li.liu@oracle.com>
To: dsterba@suse.cz
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 7/7] Btrfs: fix memory leak due to invalid btree height
Message-ID: <20160906220401.GC31641@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1463184422-13584-1-git-send-email-bo.li.liu@oracle.com>
 <1463184422-13584-7-git-send-email-bo.li.liu@oracle.com>
 <20160906165019.GE16983@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160906165019.GE16983@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Sep 06, 2016 at 06:50:19PM +0200, David Sterba wrote:
> On Fri, May 13, 2016 at 05:07:02PM -0700, Liu Bo wrote:
> > Thanks to fuzz testing, we can have invalid btree root node height.
> 
> Shouldn't we do this kind of sanity checks earlier? Not at the search
> slot time but when it's read from disk. The check that you're adding can
> stay, but without the early check we could hit it very often thus making
> it very noisy.

We do have such an early check when it's read from disk
(btree_readpage_end_io_hook) and this can protect us from 99.9% cases,
the only corner case is that the fuzz image changes our chunk root node
to superblock bytenr, so we firstly reads superblock into a dummy eb, and when
we get to read chunk root, we firstly search eb tree and find one eb
matching the bytenr, then we take this invalid eb to do
btrfs_search_slot() and we come cross this surprise.

Anyway, this patch was made before I found we could actually free
superblock's eb immediately after use.  Now with freeing that eb I don't
think we can have the above problem.

Thanks,

-liubo

> 
> > Btrfs limits btree height to 7 and if the given height is 9, then btrfs
> > will have problems in both releasing root node's lock and freeing the node.
> 
> 
> > 
> > Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> > ---
> >  fs/btrfs/ctree.c | 7 +++++++
> >  1 file changed, 7 insertions(+)
> > 
> > diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
> > index ec7928a..3fccbcc 100644
> > --- a/fs/btrfs/ctree.c
> > +++ b/fs/btrfs/ctree.c
> > @@ -2756,6 +2756,13 @@ again:
> >  			}
> >  		}
> >  	}
> > +	if (level > BTRFS_MAX_LEVEL - 1 || level < 0) {
> > +		WARN_ONCE(1, KERN_WARNING "Invalid btree height %d\n", level);
> > +		if (!p->skip_locking)
> > +			btrfs_tree_unlock_rw(b, root_lock);
> > +		free_extent_buffer(b);
> > +		return -EINVAL;
> > +	}
> >  	p->nodes[level] = b;
> >  	if (!p->skip_locking)
> >  		p->locks[level] = root_lock;
> > -- 
> > 2.5.5
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
