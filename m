From: Sage Weil <sage@newdream.net>
Subject: user transactions and ENOSPC...
Date: Fri, 25 Sep 2009 14:10:14 -0700 (PDT)
Message-ID: <Pine.LNX.4.64.0909251405560.9827@cobra.newdream.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi everyone,

So, the btrfs user transaction ioctls work like so

 ioctl(fd, BTRFS_IOC_TRANS_START);
 /* do many operations: write(), setxattr(), rmdir(), whatever. */
 ioctl(fd, BTRFS_IOC_TRANS_END);    /* or close(fd); */

and allow an application to ensure some number of operations commit to 
disk together.  Ceph's storage daemon uses this to avoid the overhead of 
maintaining a write-ahead journal for complex updates.  I can see this 
being useful for lots of other services too, since it can avoid all kinds 
of (often slow) atomicity games.

But there are two problems with the user transaction ioctls as 
implemented...

The first is that we may get ENOSPC somewhere between START and END
without any prior warning.  The patch below is intended to fix that by
adding a new reservation category used only by a new TRANS_RESV_START
ioctl.  It'll allow an application to specify the total amount of data
it wants to write when the transaction starts, and get ENOSPC right
away before it starts making changes.

This isn't a perfect solution: a mix of a transaction workload a regular
workload will violate the reservations, and we can't really fix that
without knowing whether any given write() or whatever belongs to a user
transaction or not.

The second problem is that the application may die between START and 
END. The current ioctls are "safe" in that the transaction handle is 
closed when the struct file is released, so the fs won't get wedged if 
you say segfault.  On the other hand, they're "unsafe" in that a process 
that is killed or segfaults will result in an imcomplete transaction 
making it to disk, which leaves the file system in an inconsistent state 
(from the point of view of the application).

One possibility is to (optionally) disable that safety mechanism with a 
mount option, so that the file system will wedge if the process dies.  
That's probably better than nothing.  A cautious app may prefer a wedged 
system to a partial transaction reaching disk. (Remember these ioctls 
are already dangerous and require CAP_SYS_ADMIN.  A process can 
similarly wedge the fs by simply holding a transaction open.)


An alternative approach would be to describe the full contents of the 
user transaction, and submit the entire thing to btrfs at once using a 
single ioctl().  This makes for an awkward data structure to define the 
whole thing, but it would allow us to determine which operations belong 
to a user transaction and reserve/account for free space accordingly.  
It would also solve the problem of committing partial user transactions, 
since we could run the full transaction to completion even if the 
process gets a SIGKILL or seg faults or something.

I had some rough patches for this a while back that just called into vfs_* 
methods, but they ran up against those methods not being exported to 
modules.  If exporting those is not a deal breaker, then I can use 
filp->private_data to mark operations contained by the transaction so that 
the reservation accounting works, while still taking advantage of the 
generic vfs_* code.

It would also potentially let us make these non-privileged operations, 
since submiting the transaction as a unit would avoid the current 
situation where a misbehaving process can hold a transaction open 
and wedge the system.

I'm partial to the latter approach, but it'd be nice to have some 
confidence that it won't be shot down out of hand on principle ("modules 
should call vfs_*", etc.) before spending too much time on it...

In the meantime, patches to add reservations to the current ioctl 
approach follow.  Any feedback on how these might be improved are 
welcome, too!

Thanks-
sage

