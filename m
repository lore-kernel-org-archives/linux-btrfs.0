From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [RFC] big fat transaction ioctl
Date: Wed, 11 Nov 2009 10:03:56 -0500
Message-ID: <20091111150356.GC5566@think>
References: <Pine.LNX.4.64.0911101143120.31818@cobra.newdream.net>
 <2a31deca0911101244l2a84ece6p6c5dbcce5e101e9b@mail.gmail.com>
 <Pine.LNX.4.64.0911101400270.27554@cobra.newdream.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Cc: Andrey Kuzmin <andrey.v.kuzmin@gmail.com>,
	linux-btrfs@vger.kernel.org
To: Sage Weil <sage@newdream.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0911101400270.27554@cobra.newdream.net>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Nov 10, 2009 at 02:13:10PM -0800, Sage Weil wrote:
> On Tue, 10 Nov 2009, Andrey Kuzmin wrote:
>=20
> > On Tue, Nov 10, 2009 at 11:12 PM, Sage Weil <sage@newdream.net> wro=
te:
> > > Hi all,
> > >
> > > This is an alternative approach to atomic user transactions for b=
trfs.
> > > The old start/end ioctls suffer from some basic limitations, name=
ly
> > >
> > > =A0- We can't properly reserve space ahead of time to avoid ENOSP=
C part
> > > way through the transaction, and
> > > =A0- The process may die (seg fault, SIGKILL) part way through th=
e
> > > transaction. =A0Currently when that happens the partial transacti=
on will
> > > commit.
> > >
> > > This patch implements an ioctl that lets the application complete=
ly
> > > specify the entire transaction in a single syscall. =A0If the pro=
cess gets
> > > killed or seg faults part way through, the entire transaction wil=
l still
> > > complete.
> > >
> > > The goal is to atomically commit updates to multiple files, xattr=
s,
> > > directories. =A0But this is still a file system: we don't get rol=
lback if
> > > things go wrong. =A0Instead, do what we can up front to make sure=
 things
> > > will work out. =A0And if things do go wrong, optionally prevent a=
 partial
> > > result from reaching the disk.
> >=20
> > Why not snapshot respective root (doesn't work if transaction spans
> > multiple file-systems, but this doesn't look like a real-world
> > limitation), run txn against that snapshot and rollback on failure
> > instead? Snapshots are writable, cheap, and this looks like a real
> > transaction abort mechanism.
>=20
> Good question.  :)
>=20
> I hadn't looked into this before, but I think the snapshots could be =
used=20
> to achieve both atomicity and rollback.  If userspace uses an rw mute=
x to=20
> quiesce writes, it can make sure all transactions complete before cre=
ating=20
> a snapshot (commit).  The problem with this currently is the create=20
> snapshot ioctl is relatively slow... it calls commit_transaction, whi=
ch=20
> blocks until everything reaches disk.  I think to perform well this=20
> approach would need a hook to start a commit and then return as soon =
as it=20
> can guarantee than any subsequent operation's start_transaction can't=
 join=20
> in that commit.
>=20
> This may be a better way to go about this, though.  Does that sound=20
> reasonable, Chris?

Yes, we could do this, but I don't think it will perform very well
compared to your multi-operation ioctl.  It really does depend on how
often you need to do atomic ops (my guess is very).

Honestly you'll get better performance with a simple write-ahead log
from userland:

step1: write redo log somewhere in the FS, with enough information to
bring all the objects you're about to touch to a consistent state.
step2: fsync the log
step3: do your operations
step4: append a record to the undo log that invalidates the last log
op, or just truncate it to zero.
step5: fsync the log.

The big advantage of the log is that you won't be tied to btrfs, but
it's two fsyncs where the big transaction framework does none.  This
should allow you to turn on the fast fsync log again, but I think the
multi-operation ioctl would do that as well.

-chris

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
