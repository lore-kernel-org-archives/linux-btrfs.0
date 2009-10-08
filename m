From: Sage Weil <sage@newdream.net>
Subject: Re: user transactions and ENOSPC...
Date: Wed, 7 Oct 2009 21:07:27 -0700 (PDT)
Message-ID: <Pine.LNX.4.64.0910072039470.5085@cobra.newdream.net>
References: <Pine.LNX.4.64.0909251405560.9827@cobra.newdream.net>
 <20091007215804.GE17516@shell>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-btrfs@vger.kernel.org
To: Valerie Aurora <vaurora@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20091007215804.GE17516@shell>
List-ID: <linux-btrfs.vger.kernel.org>

Hi Val!

On Wed, 7 Oct 2009, Valerie Aurora wrote:

> On Fri, Sep 25, 2009 at 02:10:14PM -0700, Sage Weil wrote:
> > Hi everyone,
> > 
> > So, the btrfs user transaction ioctls work like so
> > 
> >  ioctl(fd, BTRFS_IOC_TRANS_START);
> >  /* do many operations: write(), setxattr(), rmdir(), whatever. */
> >  ioctl(fd, BTRFS_IOC_TRANS_END);    /* or close(fd); */
> > 
> > and allow an application to ensure some number of operations commit to 
> > disk together.  Ceph's storage daemon uses this to avoid the overhead of 
> > maintaining a write-ahead journal for complex updates.  I can see this 
> > being useful for lots of other services too, since it can avoid all kinds 
> > of (often slow) atomicity games.
> > 
> > But there are two problems with the user transaction ioctls as 
> > implemented...
> > The first is that we may get ENOSPC somewhere between START and END
> > without any prior warning.  The patch below is intended to fix that by
> > adding a new reservation category used only by a new TRANS_RESV_START
> > ioctl.  It'll allow an application to specify the total amount of data
> > it wants to write when the transaction starts, and get ENOSPC right
> > away before it starts making changes.
> > 
> > This isn't a perfect solution: a mix of a transaction workload a regular
> > workload will violate the reservations, and we can't really fix that
> > without knowing whether any given write() or whatever belongs to a user
> > transaction or not.
> > 
> > The second problem is that the application may die between START and 
> > END. The current ioctls are "safe" in that the transaction handle is 
> > closed when the struct file is released, so the fs won't get wedged if 
> > you say segfault.  On the other hand, they're "unsafe" in that a process 
> > that is killed or segfaults will result in an imcomplete transaction 
> > making it to disk, which leaves the file system in an inconsistent state 
> > (from the point of view of the application).
> 
> This is a pet peeve of mine - exporting file system transactions to
> user space usually has these problems.
> 
> I would be quite interested in seeing the Featherstitch-style
> patchgroups implemented on btrfs.  Do you think the ordering
> guarantees they give would work for Ceph's storage daemon?
> 
> http://featherstitch.cs.ucla.edu/
> http://lwn.net/Articles/354861/

It sounds to me like like the patchgroups give you a slick way to describe 
how you want operations ordered, but don't give you a general way to 
atomically commit multiple operations. At the end of the day, I think 
atomicity is much simpler to provide, and all that the Ceph storage daemon 
needs.  The typical update pattern is:

 - write some (fragment of a) file
 - update the file's xattr with a new version #
 - write a log entry

The logs are there to let nodes quickly resynchronize any changes when 
they fail/restart. 

This _could_ be accomplished with ordering, if e.g. the log entry is 
forced to commit before the data update, and if the data is written twice 
(i.e. data=journal).

Or if there is an efficient way to swap bytes into a file (say from the 
journal into the file).  The clone range ioctl can actually do this, but 
requires that the data is first flushed to disk, and invalidates the page 
cache in the process, and that's not good for read/write workloads.

Or if we limit ourselves to an atomic pwrite + xattr update (on the same 
file), we could order an intent log record, and then the actual write, and 
it could detect which writes committed during recovery.

I'm not sure it's an improvement over the current (proposed) approach to 
user transactions, though.  Handing the kernel a description of the entire 
transaction should eliminate the usual problems with userspace 
transactions you're referring to.

(And I'm a bit lazy; the ceph storage daemon was built on a transaction 
primitive, and it's used throughout in other convenient but not 
necessarily necessary ways.  Originally it was all done using a 
userspace file system and O_DIRECT, like any other database with 
transactions, but implementing yet another COW file system is exactly 
what I'm trying to avoid.  :)

But, I'm certainly open to other ideas!  I think both user transactions 
and patchgroups would be generally useful tools for applications...

sage
