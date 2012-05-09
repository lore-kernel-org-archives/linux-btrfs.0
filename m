From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH 3/3] btrfs: extended inode refs
Date: Wed, 9 May 2012 13:02:28 -0400
Message-ID: <20120509170228.GA4025@shiny>
References: <1333656543-4843-1-git-send-email-mfasheh@suse.de>
 <1333656543-4843-4-git-send-email-mfasheh@suse.de>
 <4F871808.3050309@jan-o-sch.net>
 <20120508225739.GW17950@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Schmidt <list.btrfs@jan-o-sch.net>,
	linux-btrfs@vger.kernel.org, Josef Bacik <josef@redhat.com>
To: Mark Fasheh <mfasheh@suse.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120508225739.GW17950@wotan.suse.de>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 08, 2012 at 03:57:39PM -0700, Mark Fasheh wrote:
> Hi Jan, comments inline as usual!
> 
> > This function must not call free_extent_buffer(eb) in line 1306 after
> > applying your patch set (immediately before the break). Second, I think
> > we'd better add a blocking read lock on eb after incrementing it's
> > refcount, because we need the current content to stay as it is. Both
> > isn't part of your patches, but it might be easier if you make that
> > bugfix change as a 3/4 patch within your set and turn this one into 4/4.
> > If you don't like that, I'll send a separate patch for it. Don't miss
> > the unlock if you do it ;-)
> 
> Ok, I think I was able to figure out and add the correct locking calls.
> 
> Basically I believe I need to wrap access around:
> 
> btrfs_tree_read_lock(eb);
> btrfs_set_lock_blocking_rw(eb, BTRFS_READ_LOCK);
> 
> <read eb contents>
> 
> btrfs_tree_read_unlock_blocking(eb);

You only need a blocking lock if you're scheduling.  Otherwise the
spinlock variant is fine.

> > > +
> > > +	while (1) {
> > > +		ret = btrfs_find_one_extref(fs_root, inum, offset, path, &iref2,
> > > +					    &offset);
> > > +		if (ret < 0)
> > > +			break;
> > > +		if (ret) {
> > > +			ret = found ? 0 : -ENOENT;
> > > +			break;
> > > +		}
> > > +		++found;
> > > +
> > > +		slot = path->slots[0];
> > > +		eb = path->nodes[0];
> > > +		/* make sure we can use eb after releasing the path */
> > > +		atomic_inc(&eb->refs);
> > 
> > You need a blocking read lock here, too. Grab it before releasing the path.

If you're calling btrfs_search_slot, it will give you a blocking lock
on the leaf.  If you set path->leave_spinning before the call, you'll
have a spinning lock on the leaf.

If you unlock a block that you got from a path (like eb =
path->nodes[0]), the path structure has a flag for each level that
indicates if that block was locked or not.  See btrfs_release_path().
So, don't fiddle the locks without fiddling the paths.

You can switch from spinning to/from blocking without touching the path, it
figures that out.

-chris

