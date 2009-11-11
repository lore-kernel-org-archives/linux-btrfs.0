From: Andrey Kuzmin <andrey.v.kuzmin@gmail.com>
Subject: Re: [RFC] big fat transaction ioctl
Date: Wed, 11 Nov 2009 18:41:06 +0300
Message-ID: <2a31deca0911110741xb3529cbi982d982ef171de9f@mail.gmail.com>
References: <Pine.LNX.4.64.0911101143120.31818@cobra.newdream.net>
	<2a31deca0911101244l2a84ece6p6c5dbcce5e101e9b@mail.gmail.com>
	<Pine.LNX.4.64.0911101400270.27554@cobra.newdream.net> <20091111150356.GC5566@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Chris Mason <chris.mason@oracle.com>,
	Sage Weil <sage@newdream.net>,
	Andrey Kuzmin <andrey.v.kuzmin@gmail.com>,
	linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20091111150356.GC5566@think>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Nov 11, 2009 at 6:03 PM, Chris Mason <chris.mason@oracle.com> w=
rote:
> On Tue, Nov 10, 2009 at 02:13:10PM -0800, Sage Weil wrote:
>> On Tue, 10 Nov 2009, Andrey Kuzmin wrote:
>>
>> > On Tue, Nov 10, 2009 at 11:12 PM, Sage Weil <sage@newdream.net> wr=
ote:
>> > > Hi all,
>> > >
>> > > This is an alternative approach to atomic user transactions for =
btrfs.
>> > > The old start/end ioctls suffer from some basic limitations, nam=
ely
>> > >
>> > > =A0- We can't properly reserve space ahead of time to avoid ENOS=
PC part
>> > > way through the transaction, and
>> > > =A0- The process may die (seg fault, SIGKILL) part way through t=
he
>> > > transaction. =A0Currently when that happens the partial transact=
ion will
>> > > commit.
>> > >
>> > > This patch implements an ioctl that lets the application complet=
ely
>> > > specify the entire transaction in a single syscall. =A0If the pr=
ocess gets
>> > > killed or seg faults part way through, the entire transaction wi=
ll still
>> > > complete.
>> > >
>> > > The goal is to atomically commit updates to multiple files, xatt=
rs,
>> > > directories. =A0But this is still a file system: we don't get ro=
llback if
>> > > things go wrong. =A0Instead, do what we can up front to make sur=
e things
>> > > will work out. =A0And if things do go wrong, optionally prevent =
a partial
>> > > result from reaching the disk.
>> >
>> > Why not snapshot respective root (doesn't work if transaction span=
s
>> > multiple file-systems, but this doesn't look like a real-world
>> > limitation), run txn against that snapshot and rollback on failure
>> > instead? Snapshots are writable, cheap, and this looks like a real
>> > transaction abort mechanism.
>>
>> Good question. =A0:)
>>
>> I hadn't looked into this before, but I think the snapshots could be=
 used
>> to achieve both atomicity and rollback. =A0If userspace uses an rw m=
utex to
>> quiesce writes, it can make sure all transactions complete before cr=
eating
>> a snapshot (commit). =A0The problem with this currently is the creat=
e
>> snapshot ioctl is relatively slow... it calls commit_transaction, wh=
ich
>> blocks until everything reaches disk. =A0I think to perform well thi=
s
>> approach would need a hook to start a commit and then return as soon=
 as it
>> can guarantee than any subsequent operation's start_transaction can'=
t join
>> in that commit.
>>
>> This may be a better way to go about this, though. =A0Does that soun=
d
>> reasonable, Chris?
>
> Yes, we could do this, but I don't think it will perform very well
> compared to your multi-operation ioctl. =A0It really does depend on h=
ow
> often you need to do atomic ops (my guess is very).
>
> Honestly you'll get better performance with a simple write-ahead log
> from userland:

Write-ahead logging is necessary anyway if the aim is to provide
transactional semantics to an application. But, at the same time, w/o
snapshot there is no synchronization between the log and file-system
state.

Regards,
Andrey

>
> step1: write redo log somewhere in the FS, with enough information to
> bring all the objects you're about to touch to a consistent state.
> step2: fsync the log
> step3: do your operations
> step4: append a record to the undo log that invalidates the last log
> op, or just truncate it to zero.
> step5: fsync the log.
>
> The big advantage of the log is that you won't be tied to btrfs, but
> it's two fsyncs where the big transaction framework does none. =A0Thi=
s
> should allow you to turn on the fast fsync log again, but I think the
> multi-operation ioctl would do that as well.
>
> -chris
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
