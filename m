From: Josef Bacik <josef@redhat.com>
Subject: Re: [LSF/MM TOPIC] COWing writeback pages
Date: Fri, 10 Feb 2012 15:54:51 -0500
Message-ID: <20120210205450.GD9049@localhost.localdomain>
References: <Pine.LNX.4.64.1202081055170.24717@cobra.newdream.net>
 <20120210195149.GC9049@localhost.localdomain>
 <Pine.LNX.4.64.1202101242520.30850@cobra.newdream.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Josef Bacik <josef@redhat.com>, linux-btrfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, dan.mick@dreamhost.com,
	jecluis@gmail.com
To: Sage Weil <sage@newdream.net>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.1202101242520.30850@cobra.newdream.net>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Feb 10, 2012 at 12:49:50PM -0800, Sage Weil wrote:
> On Fri, 10 Feb 2012, Josef Bacik wrote:
> > On Fri, Feb 10, 2012 at 11:25:27AM -0800, Sage Weil wrote:
> > > Hi everyone,
> > > 
> > > The takeaway from the 'stable pages' discussions in the last few workshops 
> > > was that pages under writeback should remain locked so that subsequent 
> > > writers don't touch them while they are en route to the disk.  This 
> > > prevents bad checksums and DIF/DIX type failures (whereas previously we 
> > > didn't really care whether old or new data reached the disk).
> > > 
> > > The fear is/was that anyone subsequently modifying the page will have to 
> > > wait for writeback io to complete before continuing.  I seem to remember 
> > > somebody (Martin?) saying that in practice, under "real" workloads, that 
> > > doesn't actually happen, so don't worry about it.  (Does anyone remember 
> > > the details of what testing led to that conclusion?)
> > > 
> > > Anyway, we are seeing what looks like an analogous problem with btrfs, 
> > > where operations sometimes block waiting for writeback of the btree pages.  
> > > Although the 'keep rewriting the same page' pattern may not be prevalent 
> > > in normal file workloads, it does seem to happen with the btrfs btree.
> > > 
> > > The obvious solution seems to be to COW the page if it is under writeback 
> > > and we want to remodify it.  Presumably that can be done just in btrfs, to 
> > > address the btrfs-specific symptoms we're hitting, but I'm interested in 
> > > hearing from other folks about whether it's more generally useful VM 
> > > functionality for other filesystems and other workloads.
> > > 
> > > Unfortunately, we haven't been able to pinpoint the exact scenarios under 
> > > which this triggers under btrfs.  We regularly see long stalls for 
> > > metadata operations (create() and similar metadata-only operations) that 
> > > block after btrfs_commit_transaction has "finished" the previous 
> > > transaction and is doing
> > > 
> > > 		return filemap_write_and_wait(btree_inode->i_mapping);
> > > 
> > > What we're less clear about is when btrfs will modify the in-memory page 
> > > in place (and thus wait) versus COWing the page... still digging into this 
> > > now.
> > > 
> > 
> > Heh so I'm working on this now, specifically in the heavy create() workload, and
> > I've just about got it nailed down.  A lot of this problem is because we rely on
> > normal pagecache for our metadata so I'm copying xfs and creating our own
> > caching.
> > 
> > The thing is since we have an inode hanging out with normal pagecache pages we
> > can have multiple people trying to write out dirty pages in our inode at the
> > same time, and since it goes through our normal write path we'll end up in this
> > case where we're waiting on writeback for pages we won't actually end up writing
> > out.  My code will fix this, if we're talking about the same problem ;).
> 
> Oh, I hadn't thought of that... that sounds like a similar but slightly 
> different problem, since it probably wouldn't correlate with the 
> filemap_write_and_wait().  As long as we don't have a btree update waiting 
> on btree writeback, though, both problems should be addressed.
> 

Oh yeah that problem is taken care of, IO is completely seperate from updating,
we set the BUF_WRITTEN flag in the header right before writing out so then the
thing will be COW'ed if anybody tries to modify it while it's in flight, they
won't have to wait or anything.  Course now that I think about it thats what
should be happening today anyway, so I'm confused about what you are seeing.

> In any case, we're definitely interested in checking out the code when 
> it's ready to share!
> 

Well I've been committing my progress to my git tree so you can check it out,
but what's there won't work at all, and what I have (and will commit shortly)
works pretty well provided you don't do anything with the tree-log, for some
reason I'm screwing something up there and its crashing :).  Thanks,

Josef
