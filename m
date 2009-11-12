From: Andrey Kuzmin <andrey.v.kuzmin@gmail.com>
Subject: Re: [RFC] big fat transaction ioctl
Date: Thu, 12 Nov 2009 06:56:03 +0300
Message-ID: <2a31deca0911111956r56a40b3etc868ab8a28793a22@mail.gmail.com>
References: <Pine.LNX.4.64.0911101143120.31818@cobra.newdream.net>
	<2a31deca0911101244l2a84ece6p6c5dbcce5e101e9b@mail.gmail.com>
	<Pine.LNX.4.64.0911101400270.27554@cobra.newdream.net> <20091111150356.GC5566@think>
	<Pine.LNX.4.64.0911110758390.28467@cobra.newdream.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org
To: Sage Weil <sage@newdream.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0911110758390.28467@cobra.newdream.net>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Nov 11, 2009 at 8:19 PM, Sage Weil <sage@newdream.net> wrote:
> On Wed, 11 Nov 2009, Chris Mason wrote:
>
>> On Tue, Nov 10, 2009 at 02:13:10PM -0800, Sage Weil wrote:
>> > On Tue, 10 Nov 2009, Andrey Kuzmin wrote:
>> >
>> > > On Tue, Nov 10, 2009 at 11:12 PM, Sage Weil <sage@newdream.net> =
wrote:
>> > > > Hi all,
>> > > >
>> > > > This is an alternative approach to atomic user transactions fo=
r btrfs.
>> > > > The old start/end ioctls suffer from some basic limitations, n=
amely
>> > > >
>> > > > =A0- We can't properly reserve space ahead of time to avoid EN=
OSPC part
>> > > > way through the transaction, and
>> > > > =A0- The process may die (seg fault, SIGKILL) part way through=
 the
>> > > > transaction. =A0Currently when that happens the partial transa=
ction will
>> > > > commit.
>> > > >
>> > > > This patch implements an ioctl that lets the application compl=
etely
>> > > > specify the entire transaction in a single syscall. =A0If the =
process gets
>> > > > killed or seg faults part way through, the entire transaction =
will still
>> > > > complete.
>> > > >
>> > > > The goal is to atomically commit updates to multiple files, xa=
ttrs,
>> > > > directories. =A0But this is still a file system: we don't get =
rollback if
>> > > > things go wrong. =A0Instead, do what we can up front to make s=
ure things
>> > > > will work out. =A0And if things do go wrong, optionally preven=
t a partial
>> > > > result from reaching the disk.
>> > >
>> > > Why not snapshot respective root (doesn't work if transaction sp=
ans
>> > > multiple file-systems, but this doesn't look like a real-world
>> > > limitation), run txn against that snapshot and rollback on failu=
re
>> > > instead? Snapshots are writable, cheap, and this looks like a re=
al
>> > > transaction abort mechanism.
>> >
>> > Good question. =A0:)
>> >
>> > I hadn't looked into this before, but I think the snapshots could =
be used
>> > to achieve both atomicity and rollback. =A0If userspace uses an rw=
 mutex to
>> > quiesce writes, it can make sure all transactions complete before =
creating
>> > a snapshot (commit). =A0The problem with this currently is the cre=
ate
>> > snapshot ioctl is relatively slow... it calls commit_transaction, =
which
>> > blocks until everything reaches disk. =A0I think to perform well t=
his
>> > approach would need a hook to start a commit and then return as so=
on as it
>> > can guarantee than any subsequent operation's start_transaction ca=
n't join
>> > in that commit.
>> >
>> > This may be a better way to go about this, though. =A0Does that so=
und
>> > reasonable, Chris?
>>
>> Yes, we could do this, but I don't think it will perform very well
>> compared to your multi-operation ioctl. =A0It really does depend on =
how
>> often you need to do atomic ops (my guess is very).
>
> The thing is, I'm not sure using snaps is that different from what I'=
m
> doing now. =A0Currently the ioctl transactions don't hit disk until e=
ach
> full commit (flushoncommit, no fsync). =A0Unless the presense of a sn=
apshot
> adds additional overhead (to the commit, or to cleaning up the slight=
ly
> longer-living snapped roots), the difference would be that starting
> transactions would need to be blocked by the application instead of
> wait_current_trans in start_transaction, and (currently at least) the=
y
> would wait longer (the extra writes between blocked =3D 0 and commit_=
done =3D
> 1 in commit_transaction).
>
> The key, as now, is keeping the full fs syncs infrequent. =A0And, if
> possible, reducing the duration of the blocked =3D=3D 1 period during
> commit_transaction.

It took me some time to associate you with Ceph project and to recall
what Ceph is, so my original snapshot suggestion was out-of-context.
When put into Ceph context, it looks too heavy-weight and may turn an
overkill. Chris's write-ahead logging idea looks much more realistic
for your use case.

>
>
>> Honestly you'll get better performance with a simple write-ahead log
>> from userland:
>
> There actually is a log, but it's optional and not strictly write-ahe=
ad...
> it's only used to reduce the commit latency:
>
> 1- apply operations to fs (grouped into atomic transactions)
> 2- (optionally) write and flush log entry
> ...repeat...
> 3- periodically sync the fs, then trim the log. =A0or sync early if a
> client explicitly requests it.
>
> But
>
> 1- I don't want to make the log required. =A0Sometimes you're more co=
ncerned
> about total throughput, not latency, and the log halves your write bw
> unless you add more spindles.

Log-induced latency penalty is the price for transactional consistency
:). Traditional mitigation recipe involves low-latency log device
(NVRAM and, recently, SLC flash). Since you specifically target
distributed systems, you have a distributed in-memory logging option.

Regards,
Andrey

>
> 2- I don't want it strictly write-ahead because (in the absense of at=
omic
> ops) it means you have to wait for the log to sync before applying th=
e ops
> to the fs (to ensure the fs doesn't get a partial transaction ahead o=
f the
> log). =A0This marries atomicity with your schedule for durability, wh=
ich
> isn't necessarily what you want. =A0(e.g., Ceph makes a distinction b=
etween
> serialized and commited ops, allowing limited sharing of data before =
it
> hits disk. =A0That's the nice thing about this ioctl... it's pretty c=
ommon
> that atomicity is the only requirement.)
>
> With the optional (write-behind?) log and transaction ioctls, IF you =
want
> low latency commits, enable the log and ideally give it it's own spin=
dle,
> and infrequently sync btrfs to get good layout and low overhead.
>
>
> Unless you think I'm missing something with the snapshot approach, I =
can
> give that a try and see how it does. =A0It requires explicit manageme=
nt of
> the sync/commit schedule, but in my case at least I'm doing that alre=
ady.
> A transaction ioctl is simpler for userland and would be more generic=
ally
> useful for other apps (particularly those who don't want to manage
> commits), but will always have some small possibility of partial
> failure/abort without rollback.
>
> sage
>
>
>>
>> step1: write redo log somewhere in the FS, with enough information t=
o
>> bring all the objects you're about to touch to a consistent state.
>> step2: fsync the log
>> step3: do your operations
>> step4: append a record to the undo log that invalidates the last log
>> op, or just truncate it to zero.
>> step5: fsync the log.
>>
>> The big advantage of the log is that you won't be tied to btrfs, but
>> it's two fsyncs where the big transaction framework does none. =A0Th=
is
>> should allow you to turn on the fast fsync log again, but I think th=
e
>> multi-operation ioctl would do that as well.
>>
>> -chris
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrf=
s" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>>
>>
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
