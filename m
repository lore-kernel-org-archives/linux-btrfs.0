From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [RFC] big fat transaction ioctl
Date: Wed, 11 Nov 2009 10:55:08 -0500
Message-ID: <20091111155508.GE5566@think>
References: <Pine.LNX.4.64.0911101143120.31818@cobra.newdream.net>
 <2a31deca0911101244l2a84ece6p6c5dbcce5e101e9b@mail.gmail.com>
 <Pine.LNX.4.64.0911101400270.27554@cobra.newdream.net>
 <20091111150356.GC5566@think>
 <2a31deca0911110741xb3529cbi982d982ef171de9f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Cc: Sage Weil <sage@newdream.net>, linux-btrfs@vger.kernel.org
To: Andrey Kuzmin <andrey.v.kuzmin@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <2a31deca0911110741xb3529cbi982d982ef171de9f@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Nov 11, 2009 at 06:41:06PM +0300, Andrey Kuzmin wrote:
> >> I hadn't looked into this before, but I think the snapshots could =
be used
> >> to achieve both atomicity and rollback. =A0If userspace uses an rw=
 mutex to
> >> quiesce writes, it can make sure all transactions complete before =
creating
> >> a snapshot (commit). =A0The problem with this currently is the cre=
ate
> >> snapshot ioctl is relatively slow... it calls commit_transaction, =
which
> >> blocks until everything reaches disk. =A0I think to perform well t=
his
> >> approach would need a hook to start a commit and then return as so=
on as it
> >> can guarantee than any subsequent operation's start_transaction ca=
n't join
> >> in that commit.
> >>
> >> This may be a better way to go about this, though. =A0Does that so=
und
> >> reasonable, Chris?
> >
> > Yes, we could do this, but I don't think it will perform very well
> > compared to your multi-operation ioctl. =A0It really does depend on=
 how
> > often you need to do atomic ops (my guess is very).
> >
> > Honestly you'll get better performance with a simple write-ahead lo=
g
> > from userland:
>=20
> Write-ahead logging is necessary anyway if the aim is to provide
> transactional semantics to an application.

Sage's big fat ioctl does provide the subset of transactional semantics
that ceph (and many other apps) require.  In this case, they just want
to know that a given set of operations will happen together.

> But, at the same time, w/o
> snapshot there is no synchronization between the log and file-system
> state.

Synchronizing the log and the filesystem state happens when the
application starts up after the crash (either app crash or system
crash).  The application would be in charge of applying the log to its
own files to get the system into whatever state the app thinks is
consistent.

-chris

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
