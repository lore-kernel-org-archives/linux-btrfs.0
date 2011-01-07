From: Hubert Kario <hka@qbs.com.pl>
Subject: Re: Atomic file data replace API
Date: Fri, 7 Jan 2011 17:26:02 +0100
Message-ID: <201101071726.02958.hka@qbs.com.pl>
References: <AANLkTi=paCEdAFZkHWTSwTCjYavMPOaGY8MsLknryk=_@mail.gmail.com> <AANLkTi=o4w9wDoh6f8iaJF=vPQ-Xs1XBnJMbym08cOa-@mail.gmail.com> <1294416073-sup-5254@think>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
Cc: Olaf van der Spek <olafvdspek@gmail.com>,
	"linux-btrfs" <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1294416073-sup-5254@think>
List-ID: <linux-btrfs.vger.kernel.org>

On Friday, January 07, 2011 17:12:11 Chris Mason wrote:
> Excerpts from Olaf van der Spek's message of 2011-01-07 10:17:31 -050=
0:
> > On Fri, Jan 7, 2011 at 4:13 PM, Chris Mason <chris.mason@oracle.com=
>=20
wrote:
> > >> That's not what I asked. ;)
> > >> I asked to wait until the first write (or close). That way, you =
don't
> > >> get unintentional empty files.
> > >> One step further, you don't have to keep the data in memory, you=
're
> > >> free to write them to disk. You just wouldn't update the meta-da=
ta
> > >> (yet).
> > >=20
> > > Sorry ;) Picture an application that truncates 1024 files without
> > > closing any of them.  Basically any operation that includes the k=
ernel
> > > waiting for applications because they promise to do something soo=
n is
> > > a denial of service attack, or a really easy way to run out of me=
mory
> > > on the box.
> >=20
> > I'm not sure why you would run out of memory in that case.
>=20
> Well, lets make sure I've got a good handle on the proposed interface=
:
>=20
> 1) fd =3D open(some_file, O_ATOMIC)
> 2) truncate(fd, 0)
> 3) write(fd, new data)
>=20
> The semantics are that we promise not to let the truncate hit the dis=
k
> until the application does the write.
>=20
> We have a few choices on how we do this:
>=20
> 1) Leave the disk untouched, but keep something in memory that says t=
his
> inode is really truncated
>=20
> 2) Record on disk that we've done our atomic truncate but it is still
> pending.  We'd need some way to remove or invalidate this record afte=
r a
> crash.
>=20
> 3) Go ahead and do the operation but don't allow the transaction to
> commit until the write is done.
>=20
> option #1: keep something in memory.  Well, any time we have a
> requirement to pin something in memory until userland decides to do a
> write, we risk oom.

Userland has already a file descriptor allocated (which can fail anyway=
=20
because of OOM), I see no problem in increasing the size of kernel memo=
ry=20
usage by 4 bytes (if not less) just to note that the application wants =
to see=20
the file as truncated (1 bit) and the next write has to be atomic (2nd =
bit?).

--=20
Hubert Kario
QBS - Quality Business Software
02-656 Warszawa, ul. Ksawer=C3=B3w 30/85
tel. +48 (22) 646-61-51, 646-74-24
www.qbs.com.pl
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
