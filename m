Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:45161 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753420AbbF2Rwn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 29 Jun 2015 13:52:43 -0400
Date: Mon, 29 Jun 2015 10:52:41 -0700
From: Mark Fasheh <mfasheh@suse.de>
To: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.cz>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 5/5] btrfs: don't update mtime on deduped inodes
Message-ID: <20150629175240.GB7507@wotan.suse.de>
Reply-To: Mark Fasheh <mfasheh@suse.de>
References: <1435352461-17689-1-git-send-email-mfasheh@suse.de>
 <1435352461-17689-6-git-send-email-mfasheh@suse.de>
 <20150627214427.GC14931@hungrycats.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20150627214427.GC14931@hungrycats.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Jun 27, 2015 at 05:44:28PM -0400, Zygo Blaxell wrote:
> On Fri, Jun 26, 2015 at 02:01:01PM -0700, Mark Fasheh wrote:
> > One issue users have reported is that dedupe changes mtime on files,
> > resulting in tools like rsync thinking that their contents have changed when
> > in fact the data is exactly the same. Clone still wants an mtime change, so
> > we special case this in the code.
> > 
> > This was tested with the btrfs-extent-same tool.
> > 
> > Signed-off-by: Mark Fasheh <mfasheh@suse.de>
> > ---
> >  fs/btrfs/ioctl.c | 25 +++++++++++++++----------
> >  1 file changed, 15 insertions(+), 10 deletions(-)
> > 
> > diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> > index 83f4679..0af0f13 100644
> > --- a/fs/btrfs/ioctl.c
> > +++ b/fs/btrfs/ioctl.c
> > @@ -87,7 +87,8 @@ struct btrfs_ioctl_received_subvol_args_32 {
> >  
> >  
> >  static int btrfs_clone(struct inode *src, struct inode *inode,
> > -		       u64 off, u64 olen, u64 olen_aligned, u64 destoff);
> > +		       u64 off, u64 olen, u64 olen_aligned, u64 destoff,
> > +		       int no_mtime);
> >  
> >  /* Mask out flags that are inappropriate for the given type of inode. */
> >  static inline __u32 btrfs_mask_flags(umode_t mode, __u32 flags)
> > @@ -3054,7 +3055,7 @@ static int btrfs_extent_same(struct inode *src, u64 loff, u64 olen,
> >  	/* pass original length for comparison so we stay within i_size */
> >  	ret = btrfs_cmp_data(src, loff, dst, dst_loff, olen, &cmp);
> >  	if (ret == 0)
> > -		ret = btrfs_clone(src, dst, loff, olen, len, dst_loff);
> > +		ret = btrfs_clone(src, dst, loff, olen, len, dst_loff, 1);
> >  
> >  	if (same_inode)
> >  		unlock_extent(&BTRFS_I(src)->io_tree, same_lock_start,
> > @@ -3219,13 +3220,17 @@ static int clone_finish_inode_update(struct btrfs_trans_handle *trans,
> >  				     struct inode *inode,
> >  				     u64 endoff,
> >  				     const u64 destoff,
> > -				     const u64 olen)
> > +				     const u64 olen,
> > +				     int no_mtime)
> >  {
> >  	struct btrfs_root *root = BTRFS_I(inode)->root;
> >  	int ret;
> >  
> >  	inode_inc_iversion(inode);
> > -	inode->i_mtime = inode->i_ctime = CURRENT_TIME;
> > +	if (no_mtime)
> > +		inode->i_ctime = CURRENT_TIME;
> 
> I don't see a good reason to modify the ctime either.  Again, nothing
> is changing here.  All we are doing is shuffling physical storage around.
> 
> Defrag and balance (which also move physical extents around) don't
> touch ctime, mtime, or even atime.

To be fair, those may actually be oversights, it's not uncommon to update
ctime on metadata changes.

Does a ctime change hurt any backup software (the reason for my first
patch)? I guess it could cause revaluation of meta data, but does that
actually happen? From what I can tell stuff like rsync is using mtime +
i_size to see if an inode changed.

Is there any software out there that monitors an inodes extent state which
might *want* ctime updates when this happens? Is that kind of usage a
stretch (or even something we care about?).

So my thinking is if it doesn't hurt anything, leave it in. Obviously if it
*is* causing issues then we should take it right out :)

Thanks for the discussion and review btw,
	--Mark

--
Mark Fasheh
