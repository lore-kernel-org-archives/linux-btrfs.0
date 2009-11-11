From: Sage Weil <sage@newdream.net>
Subject: Re: [RFC] big fat transaction ioctl
Date: Wed, 11 Nov 2009 09:19:13 -0800 (PST)
Message-ID: <Pine.LNX.4.64.0911110758390.28467@cobra.newdream.net>
References: <Pine.LNX.4.64.0911101143120.31818@cobra.newdream.net>
 <2a31deca0911101244l2a84ece6p6c5dbcce5e101e9b@mail.gmail.com>
 <Pine.LNX.4.64.0911101400270.27554@cobra.newdream.net> <20091111150356.GC5566@think>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="557981400-997823584-1257956026=:28467"
Cc: Andrey Kuzmin <andrey.v.kuzmin@gmail.com>,
	linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20091111150356.GC5566@think>
List-ID: <linux-btrfs.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--557981400-997823584-1257956026=:28467
Content-Type: TEXT/PLAIN; CHARSET=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Content-ID: <Pine.LNX.4.64.0911110814301.28467@cobra.newdream.net>

On Wed, 11 Nov 2009, Chris Mason wrote:

> On Tue, Nov 10, 2009 at 02:13:10PM -0800, Sage Weil wrote:
> > On Tue, 10 Nov 2009, Andrey Kuzmin wrote:
> >=20
> > > On Tue, Nov 10, 2009 at 11:12 PM, Sage Weil <sage@newdream.net> wrote=
:
> > > > Hi all,
> > > >
> > > > This is an alternative approach to atomic user transactions for btr=
fs.
> > > > The old start/end ioctls suffer from some basic limitations, namely
> > > >
> > > > =A0- We can't properly reserve space ahead of time to avoid ENOSPC =
part
> > > > way through the transaction, and
> > > > =A0- The process may die (seg fault, SIGKILL) part way through the
> > > > transaction. =A0Currently when that happens the partial transaction=
 will
> > > > commit.
> > > >
> > > > This patch implements an ioctl that lets the application completely
> > > > specify the entire transaction in a single syscall. =A0If the proce=
ss gets
> > > > killed or seg faults part way through, the entire transaction will =
still
> > > > complete.
> > > >
> > > > The goal is to atomically commit updates to multiple files, xattrs,
> > > > directories. =A0But this is still a file system: we don't get rollb=
ack if
> > > > things go wrong. =A0Instead, do what we can up front to make sure t=
hings
> > > > will work out. =A0And if things do go wrong, optionally prevent a p=
artial
> > > > result from reaching the disk.
> > >=20
> > > Why not snapshot respective root (doesn't work if transaction spans
> > > multiple file-systems, but this doesn't look like a real-world
> > > limitation), run txn against that snapshot and rollback on failure
> > > instead? Snapshots are writable, cheap, and this looks like a real
> > > transaction abort mechanism.
> >=20
> > Good question.  :)
> >=20
> > I hadn't looked into this before, but I think the snapshots could be us=
ed=20
> > to achieve both atomicity and rollback.  If userspace uses an rw mutex =
to=20
> > quiesce writes, it can make sure all transactions complete before creat=
ing=20
> > a snapshot (commit).  The problem with this currently is the create=20
> > snapshot ioctl is relatively slow... it calls commit_transaction, which=
=20
> > blocks until everything reaches disk.  I think to perform well this=20
> > approach would need a hook to start a commit and then return as soon as=
 it=20
> > can guarantee than any subsequent operation's start_transaction can't j=
oin=20
> > in that commit.
> >=20
> > This may be a better way to go about this, though.  Does that sound=20
> > reasonable, Chris?
>=20
> Yes, we could do this, but I don't think it will perform very well
> compared to your multi-operation ioctl.  It really does depend on how
> often you need to do atomic ops (my guess is very).

The thing is, I'm not sure using snaps is that different from what I'm=20
doing now.  Currently the ioctl transactions don't hit disk until each=20
full commit (flushoncommit, no fsync).  Unless the presense of a snapshot=
=20
adds additional overhead (to the commit, or to cleaning up the slightly=20
longer-living snapped roots), the difference would be that starting=20
transactions would need to be blocked by the application instead of=20
wait_current_trans in start_transaction, and (currently at least) they=20
would wait longer (the extra writes between blocked =3D 0 and commit_done =
=3D=20
1 in commit_transaction). =20

The key, as now, is keeping the full fs syncs infrequent.  And, if=20
possible, reducing the duration of the blocked =3D=3D 1 period during=20
commit_transaction.


> Honestly you'll get better performance with a simple write-ahead log
> from userland:

There actually is a log, but it's optional and not strictly write-ahead...=
=20
it's only used to reduce the commit latency:

1- apply operations to fs (grouped into atomic transactions)
2- (optionally) write and flush log entry
=2E..repeat...
3- periodically sync the fs, then trim the log.  or sync early if a=20
client explicitly requests it.

But

1- I don't want to make the log required.  Sometimes you're more concerned=
=20
about total throughput, not latency, and the log halves your write bw=20
unless you add more spindles.

2- I don't want it strictly write-ahead because (in the absense of atomic=
=20
ops) it means you have to wait for the log to sync before applying the ops=
=20
to the fs (to ensure the fs doesn't get a partial transaction ahead of the=
=20
log).  This marries atomicity with your schedule for durability, which=20
isn't necessarily what you want.  (e.g., Ceph makes a distinction between=
=20
serialized and commited ops, allowing limited sharing of data before it=20
hits disk.  That's the nice thing about this ioctl... it's pretty common=20
that atomicity is the only requirement.)

With the optional (write-behind?) log and transaction ioctls, IF you want=
=20
low latency commits, enable the log and ideally give it it's own spindle,=
=20
and infrequently sync btrfs to get good layout and low overhead.=20


Unless you think I'm missing something with the snapshot approach, I can=20
give that a try and see how it does.  It requires explicit management of=20
the sync/commit schedule, but in my case at least I'm doing that already. =
=20
A transaction ioctl is simpler for userland and would be more generically=
=20
useful for other apps (particularly those who don't want to manage=20
commits), but will always have some small possibility of partial=20
failure/abort without rollback.

sage


>=20
> step1: write redo log somewhere in the FS, with enough information to
> bring all the objects you're about to touch to a consistent state.
> step2: fsync the log
> step3: do your operations
> step4: append a record to the undo log that invalidates the last log
> op, or just truncate it to zero.
> step5: fsync the log.
>=20
> The big advantage of the log is that you won't be tied to btrfs, but
> it's two fsyncs where the big transaction framework does none.  This
> should allow you to turn on the fast fsync log again, but I think the
> multi-operation ioctl would do that as well.
>=20
> -chris
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20
>=20
--557981400-997823584-1257956026=:28467--
