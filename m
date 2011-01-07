From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Atomic file data replace API
Date: Fri, 07 Jan 2011 11:12:11 -0500
Message-ID: <1294416073-sup-5254@think>
References: <AANLkTi=paCEdAFZkHWTSwTCjYavMPOaGY8MsLknryk=_@mail.gmail.com> <1294412141-sup-1734@think> <AANLkTi=Z1RCwMKSMRzg4fwN55ZQs4F91nNjdEfv6veyb@mail.gmail.com> <1294412553-sup-9058@think> <AANLkTimB-gpHFJMXY3TRcfxGJjwo94ffEVZSPw6746bC@mail.gmail.com> <1294412980-sup-1924@think> <AANLkTi=o4w9wDoh6f8iaJF=vPQ-Xs1XBnJMbym08cOa-@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Olaf van der Spek <olafvdspek@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <AANLkTi=o4w9wDoh6f8iaJF=vPQ-Xs1XBnJMbym08cOa-@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Olaf van der Spek's message of 2011-01-07 10:17:31 -0500:
> On Fri, Jan 7, 2011 at 4:13 PM, Chris Mason <chris.mason@oracle.com> =
wrote:
> >> That's not what I asked. ;)
> >> I asked to wait until the first write (or close). That way, you do=
n't
> >> get unintentional empty files.
> >> One step further, you don't have to keep the data in memory, you'r=
e
> >> free to write them to disk. You just wouldn't update the meta-data
> >> (yet).
> >
> > Sorry ;) Picture an application that truncates 1024 files without c=
losing any
> > of them. =C2=A0Basically any operation that includes the kernel wai=
ting for
> > applications because they promise to do something soon is a denial =
of
> > service attack, or a really easy way to run out of memory on the bo=
x.
>=20
> I'm not sure why you would run out of memory in that case.

Well, lets make sure I've got a good handle on the proposed interface:

1) fd =3D open(some_file, O_ATOMIC)
2) truncate(fd, 0)
3) write(fd, new data)

The semantics are that we promise not to let the truncate hit the disk
until the application does the write.

We have a few choices on how we do this:

1) Leave the disk untouched, but keep something in memory that says thi=
s
inode is really truncated

2) Record on disk that we've done our atomic truncate but it is still
pending.  We'd need some way to remove or invalidate this record after =
a
crash.

3) Go ahead and do the operation but don't allow the transaction to
commit until the write is done.

option #1: keep something in memory.  Well, any time we have a
requirement to pin something in memory until userland decides to do a
write, we risk oom.

option #2: disk format change.  Actually somewhat complex because if we
haven't crashed, we need to be able to read the inode in again without
invalidating the record but if we do crash, we have to invalidate the
record.  Not impossible, but not trivial.

option #3: Pin the whole transaction.  Depending on the FS this may be
impossible.  Certain operations require us to commit the transaction to
reclaim space, and we cannot allow userland to put that on hold without
deadlocking.

What most people don't realize about the crash safe filesystems is they
don't have fine grained transactions.  There is one single transaction
for all the operations done.  This is mostly because it is less complex
and much faster, but it also makes any 'pin the whole transaction' type
system unusable.

-chris
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
