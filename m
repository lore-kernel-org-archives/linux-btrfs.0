Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:52396 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751243AbaL0R7r (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 27 Dec 2014 12:59:47 -0500
From: Martin Steigerwald <Martin@lichtvoll.de>
To: Hugo Mills <hugo@carfax.org.uk>
Cc: Robert White <rwhite@pobox.com>, linux-btrfs@vger.kernel.org
Subject: Re: BTRFS free space handling still needs more work: Hangs again
Date: Sat, 27 Dec 2014 18:59:31 +0100
Message-ID: <6579515.E2MeSbCGLA@merkaba>
In-Reply-To: <9346949.uCfVN6IAc7@merkaba>
References: <3738341.y7uRQFcLJH@merkaba> <20141227162642.GK25267@carfax.org.uk> <9346949.uCfVN6IAc7@merkaba>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart6261015.F95yUKkHEz"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--nextPart6261015.F95yUKkHEz
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="us-ascii"

Am Samstag, 27. Dezember 2014, 18:11:21 schrieb Martin Steigerwald:
> Am Samstag, 27. Dezember 2014, 16:26:42 schrieb Hugo Mills:
> > On Sat, Dec 27, 2014 at 06:54:33AM -0800, Robert White wrote:
> > > On 12/27/2014 05:55 AM, Martin Steigerwald wrote:
> > [snip]
> > > >while fio was just *laying* out the 4 GiB file. Yes, thats 100% =
system CPU
> > > >for 10 seconds while allocatiing a 4 GiB file on a filesystem li=
ke:
> > > >
> > > >martin@merkaba:~> LANG=3DC df -hT /home
> > > >Filesystem             Type   Size  Used Avail Use% Mounted on
> > > >/dev/mapper/msata-home btrfs  170G  156G   17G  91% /home
> > > >
> > > >where a 4 GiB file should easily fit, no? (And this output is wi=
th the 4
> > > >GiB file. So it was even 4 GiB more free before.)
> > >=20
> > > No. /usr/bin/df is an _approximation_ in BTRFS because of the lim=
its
> > > of the fsstat() function call. The fstat function call was define=
d
> > > in 1990 and "can't understand" the dynamic allocation model used =
in
> > > BTRFS as it assumes fixed geometry for filesystems. You do _not_
> > > have 17G actually available. You need to rely on btrfs fi df and
> > > btrfs fi show to figure out how much space you _really_ have.
> > >=20
> > > According to this block you have a RAID1 of ~ 160GB expanse (two =
160G disks)
> > >=20
> > > > merkaba:~> date; btrfs fi sh /home ; btrfs fi df /home
> > > > Sa 27. Dez 13:26:39 CET 2014
> > > > Label: 'home'  uuid: [some UUID]
> > > >          Total devices 2 FS bytes used 152.83GiB
> > > >          devid    1 size 160.00GiB used 160.00GiB path
> > > /dev/mapper/msata-home
> > > >          devid    2 size 160.00GiB used 160.00GiB path
> > > /dev/mapper/sata-home
> > >=20
> > > And according to this block you have about 4.49GiB of data space:=

> > >=20
> > > > Btrfs v3.17
> > > > Data, RAID1: total=3D154.97GiB, used=3D149.58GiB
> > > > System, RAID1: total=3D32.00MiB, used=3D48.00KiB
> > > > Metadata, RAID1: total=3D5.00GiB, used=3D3.26GiB
> > > > GlobalReserve, single: total=3D512.00MiB, used=3D0.00B
> > >=20
> > > 154.97
> > >   5.00
> > >   0.032
> > > + 0.512
> > >=20
> > > Pretty much as close to 160GiB as you are going to get (those
> > > numbers being rounded up in places for "human readability") BTRFS=

> > > has allocate 100% of the raw storage into typed extents.
> > >=20
> > > A large datafile can only fit in the 154.97-149.58 =3D 5.39
> >=20
> >    I appreciate that this is something of a minor point in the gran=
d
> > scheme of things, but I'm afraid I've lost the enthusiasm to engage=

> > with the broader (somewhat rambling, possibly-at-cross-purposes)
> > conversation in this thread. However...
> >=20
> > > Trying to allocate that 4GiB file into that 5.39GiB of space beco=
mes
> > > an NP-complete (e.g. "very hard") problem if it is very fragmente=
d.
> >=20
> >    This is... badly mistaken, at best. The problem of where to writ=
e a
> > file into a set of free extents is definitely *not* an NP-hard
> > problem. It's a P problem, with an O(n log n) solution, where n is =
the
> > number of free extents in the free space cache. The simple approach=
:
> > fill the first hole with as many bytes as you can, then move on to =
the
> > next hole. More complex: order the free extents by size first. Both=
 of
> > these are O(n log n) algorithms, given an efficient general-purpose=

> > index of free space.
> >=20
> >    The problem of placing file data isn't a bin-packing problem; it=
's
> > not like allocating RAM (where each allocation must be contiguous).=

> > The items being placed may be split as much as you like, although
> > minimising the amount of splitting is a goal.
> >=20
> >    I suspect that the performance problems that Martin is seeing ma=
y
> > indeed be related to free space fragmentation, in that finding and
> > creating all of those tiny extents for a huge file is causing
> > problems. I believe that btrfs isn't alone in this, but it may well=
 be
> > showing the problem to a far greater degree than other FSes. I don'=
t
> > have figures to compare, I'm afraid.
>=20
> Thats what I wanted to hint at.
>=20
> I suspect an issue with free space fragmentation and do what I think =
I see:
>=20
> btrfs balance minimizes free space in chunk fragmentation.
>=20
> And that is my whole case on why I think it does help with my /home
> filesystem.
>=20
> So while btrfs filesystem defragment may help with defragmenting indi=
vidual
> files, possibly at the cost of fragmenting free space at least on fil=
esystem
> almost full conditions, I think to help with free space fragmentation=
 there
> are only three options at the moment:
>=20
> 1) reformat and restore via rsync or btrfs send from backup (i.e. fil=
e based)
>=20
> 2) make the BTRFS in itself bigger
>=20
> 3) btrfs balance at least chunks, at least those that are not more th=
an 70%
> or 80% full.
>=20
> Do you know of any other ways to deal with it?

Yes.

4) Delete some stuff from it or move it over to a different filesystem.=


=2D-=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
--nextPart6261015.F95yUKkHEz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEABECAAYFAlSe84wACgkQmRvqrKWZhMcPIwCgq+6R9hjgph1iZREH7TQVVkh8
kHgAmwe8hm1gdBjtg+33HJkoi9ECE7nj
=gZRO
-----END PGP SIGNATURE-----

--nextPart6261015.F95yUKkHEz--

