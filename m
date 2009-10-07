From: Valerie Aurora <vaurora@redhat.com>
Subject: Re: user transactions and ENOSPC...
Date: Wed, 7 Oct 2009 17:58:04 -0400
Message-ID: <20091007215804.GE17516@shell>
References: <Pine.LNX.4.64.0909251405560.9827@cobra.newdream.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Sage Weil <sage@newdream.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0909251405560.9827@cobra.newdream.net>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 25, 2009 at 02:10:14PM -0700, Sage Weil wrote:
> Hi everyone,
> 
> So, the btrfs user transaction ioctls work like so
> 
>  ioctl(fd, BTRFS_IOC_TRANS_START);
>  /* do many operations: write(), setxattr(), rmdir(), whatever. */
>  ioctl(fd, BTRFS_IOC_TRANS_END);    /* or close(fd); */
> 
> and allow an application to ensure some number of operations commit to 
> disk together.  Ceph's storage daemon uses this to avoid the overhead of 
> maintaining a write-ahead journal for complex updates.  I can see this 
> being useful for lots of other services too, since it can avoid all kinds 
> of (often slow) atomicity games.
> 
> But there are two problems with the user transaction ioctls as 
> implemented...
> The first is that we may get ENOSPC somewhere between START and END
> without any prior warning.  The patch below is intended to fix that by
> adding a new reservation category used only by a new TRANS_RESV_START
> ioctl.  It'll allow an application to specify the total amount of data
> it wants to write when the transaction starts, and get ENOSPC right
> away before it starts making changes.
> 
> This isn't a perfect solution: a mix of a transaction workload a regular
> workload will violate the reservations, and we can't really fix that
> without knowing whether any given write() or whatever belongs to a user
> transaction or not.
> 
> The second problem is that the application may die between START and 
> END. The current ioctls are "safe" in that the transaction handle is 
> closed when the struct file is released, so the fs won't get wedged if 
> you say segfault.  On the other hand, they're "unsafe" in that a process 
> that is killed or segfaults will result in an imcomplete transaction 
> making it to disk, which leaves the file system in an inconsistent state 
> (from the point of view of the application).

This is a pet peeve of mine - exporting file system transactions to
user space usually has these problems.

I would be quite interested in seeing the Featherstitch-style
patchgroups implemented on btrfs.  Do you think the ordering
guarantees they give would work for Ceph's storage daemon?

http://featherstitch.cs.ucla.edu/
http://lwn.net/Articles/354861/

-VAL
