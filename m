From: devzero@web.de
Subject: Re: Compressed Filesystem
Date: Tue, 16 Dec 2008 19:14:23 +0100
Message-ID: <545082891@web.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>,
	Lee Trager <lt73@cs.drexel.edu>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

> I'd much rather have just one compression scheme per FS.  If people n=
eed
> a specific compression scheme for a specific file, they can just
> compress it in userland.

yes, i also think one compression scheme per FS is absolutely sufficien=
t.

> -----Urspr=FCngliche Nachricht-----
> Von: "Chris Mason" <chris.mason@oracle.com>
> Gesendet: 16.12.08 16:26:28
> An: Lee Trager <lt73@cs.drexel.edu>
> CC: linux-btrfs@vger.kernel.org
> Betreff: Re: Compressed Filesystem


> On Tue, 2008-12-16 at 10:20 -0500, Lee Trager wrote:
> > While I agree that the command you send should be possible it wasn'=
t
> > exactly what I was thinking. Currently I am working on a way for th=
e
> > user to individually set which files/directories they want compress=
ed or
> > not. What I was saying is that assuming you are in a mounted btrfs
> > directory you could do something like
> >=20
> > chattr -R +c zlib dir1	Compress dir1 and all its contents with zlib
> > chattr -R +c bzip dir2	Compress dir2 and all its contents with bzip
> > chattr +c lzo file1	Compress fil1 with lzo
> > chattr -c file2		Uncompress file2
> > chattr +c none dir3	Uncompress dir3 but leave contents as is
> >=20
> > If the user did something like=20
> > mount -o compress,cscheme=3Dzlib /dev/xyz /mntpoint
> > and then
> > chattr +c /mntpoint/dir
> > /mntpoint/dir would default to zlib as would anything else written =
to
> > the disk.
> >=20
>=20
> This is one of those places where more options isn't always better.
> Every option adds complexity to the filesystem and the testing matrix=
=2E =20
>=20
> I'd much rather have just one compression scheme per FS.  If people n=
eed
> a specific compression scheme for a specific file, they can just
> compress it in userland.
>=20
> -chris
>=20
>=20
>=20


_______________________________________________________________________
Sensationsangebot verl=E4ngert: WEB.DE FreeDSL - Telefonanschluss + DSL
f=FCr nur 16,37 Euro/mtl.!* http://dsl.web.de/?ac=3DOM.AD.AD008K15039B7=
069a

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
