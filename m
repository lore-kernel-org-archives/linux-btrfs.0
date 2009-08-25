From: Chris Mason <chris.mason@oracle.com>
Subject: Re: snapshot/subvol deletion
Date: Tue, 25 Aug 2009 12:04:14 -0400
Message-ID: <20090825160414.GC16561@think>
References: <4A93F749.3010708@oracle.com>
 <20090825150351.GB16561@think>
 <20090825155317.GA6155@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Yan, Zheng" <zheng.yan@oracle.com>, linux-btrfs@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090825155317.GA6155@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Aug 25, 2009 at 11:53:17AM -0400, Josef Bacik wrote:
> On Tue, Aug 25, 2009 at 11:03:51AM -0400, Chris Mason wrote:
> > On Tue, Aug 25, 2009 at 10:38:01PM +0800, Yan, Zheng wrote:
> > > Hi,
> > > 
> > > I will send a series patches that add snapshot/subvol deletion soon.
> > > But the way to delete snapshot/subvol is far from people's expectancy.
> > > To delete a snapshot/subvol, we need four steps: 1) snapshot/subvol
> > > deletion ioctl or rmdir; 2) umount; 3) btrfsck; 4) mount the fs.
> > > 
> > > The reason for this is bug in root back & forward references. In simple
> > > terms, the bug prevents us from knowing how many places a snapshot/subvol
> > > is referenced. So it's unsafe delete corresponding fs tree immediately
> > > after a link to snapshot/subvol is removed.
> > 
> > Thanks for working on this, its a major feature.  The problem with the
> > forward/backward reference counting is that our links to a subvolume or
> > snapshot are really more like symbolic links than active references.
> > 
> > If a directory entry points to a subvolume and someone uses rm -rf to
> > delete the files inside that subvolume or snapshot, you get the same kind of
> > semantics as deleting the subvolume with the ioctl.
> > 
> > So, we should be able to delete the snapshot without the unmount step.
> > It may create an invalid reference but the code to follow snapshot
> > directory items will have to be changed to deal with that.
> > 
> > If we later on allow root ids to be reused, the directory item pointing
> > to a subvol will again be like a symbolic link.  You'll end up in the
> > new subvol instead of the old.
> > 
> 
> So the problem is the directory entry for the snapshot?  What if we just went
> ahead and added an orphan item for the inode, remove the dir index and dir
> item's so that it doesn't show up on ls and such, and then the next time we
> mount the orphan entry gets cleaned up.  That way we can skip the fsck
> altogether.  Or am I missing something as per usual?

;) The problem is the directory entry for the snapshot, but its a little
more complex. Lets say subvolA has a directory entry for snapshotZ, and
then someone wanders in and snapshots subvolA, creating snapshotA'.

This means that both subvolA and snashotA' have a directory entry for
snapshotZ.  If we delete snapshotZ we have to deal with both directory
entries.

We can solve this by expanding the backref code for subvol roots, but
then taking a new snapshot becomes O(number of snapshots in the
original) for updating backrefs.

Or we could give in and admit that snapshot references in the filesystem
are symbolic links.  Both methods have disadvantages ;)

-chris

