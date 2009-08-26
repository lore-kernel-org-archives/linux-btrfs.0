From: Chris Mason <chris.mason@oracle.com>
Subject: Re: snapshot/subvol deletion
Date: Wed, 26 Aug 2009 02:50:29 -0400
Message-ID: <20090826065029.GA30017@think>
References: <4A93F749.3010708@oracle.com>
 <20090825150351.GB16561@think>
 <4A94C735.2000102@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: "Yan, Zheng" <zheng.yan@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4A94C735.2000102@oracle.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Aug 26, 2009 at 01:25:09PM +0800, Yan, Zheng wrote:
> On 08/25/2009 11:03 PM, Chris Mason wrote:
> > On Tue, Aug 25, 2009 at 10:38:01PM +0800, Yan, Zheng wrote:
> >> Hi,
> >>
> >> I will send a series patches that add snapshot/subvol deletion soon.
> >> But the way to delete snapshot/subvol is far from people's expectancy.
> >> To delete a snapshot/subvol, we need four steps: 1) snapshot/subvol
> >> deletion ioctl or rmdir; 2) umount; 3) btrfsck; 4) mount the fs.
> >>
> >> The reason for this is bug in root back & forward references. In simple
> >> terms, the bug prevents us from knowing how many places a snapshot/subvol
> >> is referenced. So it's unsafe delete corresponding fs tree immediately
> >> after a link to snapshot/subvol is removed.
> > 
> > Thanks for working on this, its a major feature.  The problem with the
> > forward/backward reference counting is that our links to a subvolume or
> > snapshot are really more like symbolic links than active references.
> >
> > If a directory entry points to a subvolume and someone uses rm -rf to
> > delete the files inside that subvolume or snapshot, you get the same kind of
> > semantics as deleting the subvolume with the ioctl.
> >
> 
> I don't think so. For each links to a subvolume, there is a separate dentry.
> For all symbolic links to a directory, there is only one dentry. So the
> semantics are different, at least from VFS' point of view.

Yes, in terms of how things are implemented in the VFS, it is different.
In terms of the behavior seen by users its a symbolic link.  We could
actually implement them as symlinks, but I didn't like the idea of
having to follow links as part of cp -a.

> 
> > So, we should be able to delete the snapshot without the unmount step.
> > It may create an invalid reference but the code to follow snapshot
> > directory items will have to be changed to deal with that.
> > 
> > If we later on allow root ids to be reused, the directory item pointing
> > to a subvol will again be like a symbolic link.  You'll end up in the
> > new subvol instead of the old.
> > 
> 
> The extent back reference does not allow reusing objectid of deleted
> root.

Right, at least not until all tree blocks that have that obectid as a
reference are gone.

-chris

