From: Sage Weil <sage@newdream.net>
Subject: Re: [PATCH] Btrfs: reserve sufficient space for ioctl clone
Date: Mon, 15 Aug 2011 21:33:18 -0700 (PDT)
Message-ID: <Pine.LNX.4.64.1108152117370.2126@cobra.newdream.net>
References: <1312911997-5075-1-git-send-email-sage@newdream.net>
 <4E49D15B.8010209@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-btrfs@vger.kernel.org
To: Miao Xie <miaox@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E49D15B.8010209@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 16 Aug 2011, Miao Xie wrote:
> On tue, 9 Aug 2011 10:46:37 -0700, Sage Weil wrote:
> > Fix a crash/BUG_ON in the clone ioctl due to insufficient reservation. We
> > need to reserve space for:
> > 
> >  - adjusting the old extent (possibly splitting it)
> >  - adding the new extent
> >  - updating the inode
> > 
> > Signed-off-by: Sage Weil <sage@newdream.net>
> > ---
> >  fs/btrfs/ioctl.c |    7 ++++++-
> >  1 files changed, 6 insertions(+), 1 deletions(-)
> > 
> > diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> > index a3c4751..f038d4a 100644
> > --- a/fs/btrfs/ioctl.c
> > +++ b/fs/btrfs/ioctl.c
> > @@ -2320,7 +2320,12 @@ static noinline long btrfs_ioctl_clone(struct file *file, unsigned long srcfd,
> >  			else
> >  				new_key.offset = destoff;
> >  
> > -			trans = btrfs_start_transaction(root, 1);
> > +			/*
> > +			 * 1 - adjusting old extent (we may have to split it)
> 
> I don't think it is enough. If we have lots of file extents and their extent items are stored
> in many contiguous leaves, the drop operation may cause those leaves to be COWed. So I think we
> must calculate the number of leaves which will be COWed at first.

Hmm, yes, but if that's the case, most of the other btrfs_drop_extents() 
callers are broken too.  Take btrfs_cont_expand(), which does more or less 
the same thing that we're doing too but reserves 2 (no inode update).

Josef, correct me if I'm wrong, but I'm guessing how this works is that we 
are reserving space for something along the lines of 2 * tree depth, or 
enough space to cow the leaf blocks and their parents (plus any space for 
splits/merges).  For inserts, we'd need to be careful about how many items 
we insert (more new leaves), but for removals, as long as we are deleting 
sequential items, we need at most two leaves, for the new versions of each 
end of the deleted range.  Is that right?

Hmm, how does the reservation interace with the extent backrefs, though?  
Is space reserved for that?

sage



> 
> Thanks
> Miao
> 
> > +			 * 1 - add new extent
> > +			 * 1 - inode update
> > +			 */
> > +			trans = btrfs_start_transaction(root, 3);
> >  			if (IS_ERR(trans)) {
> >  				ret = PTR_ERR(trans);
> >  				goto out;
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
