Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:34536 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750795AbaL0RLc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 27 Dec 2014 12:11:32 -0500
From: Martin Steigerwald <Martin@lichtvoll.de>
To: Hugo Mills <hugo@carfax.org.uk>
Cc: Robert White <rwhite@pobox.com>, linux-btrfs@vger.kernel.org
Subject: Re: BTRFS free space handling still needs more work: Hangs again
Date: Sat, 27 Dec 2014 18:11:21 +0100
Message-ID: <9346949.uCfVN6IAc7@merkaba>
In-Reply-To: <20141227162642.GK25267@carfax.org.uk>
References: <3738341.y7uRQFcLJH@merkaba> <549EC829.8080808@pobox.com> <20141227162642.GK25267@carfax.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart1794851.O5moSLK8lM"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--nextPart1794851.O5moSLK8lM
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"

Am Samstag, 27. Dezember 2014, 16:26:42 schrieb Hugo Mills:
> On Sat, Dec 27, 2014 at 06:54:33AM -0800, Robert White wrote:
> > On 12/27/2014 05:55 AM, Martin Steigerwald wrote:
> [snip]
> > >while fio was just *laying* out the 4 GiB file. Yes, thats 100% sy=
stem CPU
> > >for 10 seconds while allocatiing a 4 GiB file on a filesystem like=
:
> > >
> > >martin@merkaba:~> LANG=3DC df -hT /home
> > >Filesystem             Type   Size  Used Avail Use% Mounted on
> > >/dev/mapper/msata-home btrfs  170G  156G   17G  91% /home
> > >
> > >where a 4 GiB file should easily fit, no? (And this output is with=
 the 4
> > >GiB file. So it was even 4 GiB more free before.)
> >=20
> > No. /usr/bin/df is an _approximation_ in BTRFS because of the limit=
s
> > of the fsstat() function call. The fstat function call was defined
> > in 1990 and "can't understand" the dynamic allocation model used in=

> > BTRFS as it assumes fixed geometry for filesystems. You do _not_
> > have 17G actually available. You need to rely on btrfs fi df and
> > btrfs fi show to figure out how much space you _really_ have.
> >=20
> > According to this block you have a RAID1 of ~ 160GB expanse (two 16=
0G disks)
> >=20
> > > merkaba:~> date; btrfs fi sh /home ; btrfs fi df /home
> > > Sa 27. Dez 13:26:39 CET 2014
> > > Label: 'home'  uuid: [some UUID]
> > >          Total devices 2 FS bytes used 152.83GiB
> > >          devid    1 size 160.00GiB used 160.00GiB path
> > /dev/mapper/msata-home
> > >          devid    2 size 160.00GiB used 160.00GiB path
> > /dev/mapper/sata-home
> >=20
> > And according to this block you have about 4.49GiB of data space:
> >=20
> > > Btrfs v3.17
> > > Data, RAID1: total=3D154.97GiB, used=3D149.58GiB
> > > System, RAID1: total=3D32.00MiB, used=3D48.00KiB
> > > Metadata, RAID1: total=3D5.00GiB, used=3D3.26GiB
> > > GlobalReserve, single: total=3D512.00MiB, used=3D0.00B
> >=20
> > 154.97
> >   5.00
> >   0.032
> > + 0.512
> >=20
> > Pretty much as close to 160GiB as you are going to get (those
> > numbers being rounded up in places for "human readability") BTRFS
> > has allocate 100% of the raw storage into typed extents.
> >=20
> > A large datafile can only fit in the 154.97-149.58 =3D 5.39
>=20
>    I appreciate that this is something of a minor point in the grand
> scheme of things, but I'm afraid I've lost the enthusiasm to engage
> with the broader (somewhat rambling, possibly-at-cross-purposes)
> conversation in this thread. However...
>=20
> > Trying to allocate that 4GiB file into that 5.39GiB of space become=
s
> > an NP-complete (e.g. "very hard") problem if it is very fragmented.=

>=20
>    This is... badly mistaken, at best. The problem of where to write =
a
> file into a set of free extents is definitely *not* an NP-hard
> problem. It's a P problem, with an O(n log n) solution, where n is th=
e
> number of free extents in the free space cache. The simple approach:
> fill the first hole with as many bytes as you can, then move on to th=
e
> next hole. More complex: order the free extents by size first. Both o=
f
> these are O(n log n) algorithms, given an efficient general-purpose
> index of free space.
>=20
>    The problem of placing file data isn't a bin-packing problem; it's=

> not like allocating RAM (where each allocation must be contiguous).
> The items being placed may be split as much as you like, although
> minimising the amount of splitting is a goal.
>=20
>    I suspect that the performance problems that Martin is seeing may
> indeed be related to free space fragmentation, in that finding and
> creating all of those tiny extents for a huge file is causing
> problems. I believe that btrfs isn't alone in this, but it may well b=
e
> showing the problem to a far greater degree than other FSes. I don't
> have figures to compare, I'm afraid.

Thats what I wanted to hint at.

I suspect an issue with free space fragmentation and do what I think I =
see:

btrfs balance minimizes free space in chunk fragmentation.

And that is my whole case on why I think it does help with my /home
filesystem.

So while btrfs filesystem defragment may help with defragmenting indivi=
dual
files, possibly at the cost of fragmenting free space at least on files=
ystem
almost full conditions, I think to help with free space fragmentation t=
here
are only three options at the moment:

1) reformat and restore via rsync or btrfs send from backup (i.e. file =
based)

2) make the BTRFS in itself bigger

3) btrfs balance at least chunks, at least those that are not more than=
 70%
or 80% full.

Do you know of any other ways to deal with it?

So yes, in case it really is freespace fragmentation, I do think a bala=
nce
may be helpful. Even if usually one should not use a balance.
=20
> > I also don't know what kind of tool you are using, but it might be
> > repeatedly trying and failing to fallocate the file as a single
> > extent or something equally dumb.
>=20
>    Userspace doesn't as far as I know, get to make that decision. I'v=
e
> just read the fallocate(2) man page, and it says nothing at all about=

> the contiguity of the extent(s) storage allocated by the call.

fio fallocates just once. And then writes, even if the fallocate call f=
ails.

Was nice to see at some point as BTRFS returned out of space on the
fallocate but was still be able to write the 4GiB of random data. I bet=

the latter was due to compression. Thus while it could not guarentee
that the 4 GiB will be there in all cases, i.e. even with uncompressibl=
e
data, it was able to wrote out the random buffer fio repeatedly wrote.


I think I will step back from this now, its weekend and a quiet time af=
ter
all.

I probably got a bit too engaged with this discussion. Yet, I had the f=
eeling
I was treated by Robert like someone who doesn=C2=B4t know a thing. I w=
ant to
approach this with a willingness to learn, and I don=C2=B4t want to int=
erpret
an empirical result away before someone even had a closer look at it.

I had this before where an expert claimed that he wouldn=C2=B4t reduce =
the
dirty_background_ratio on an rsync via NFS case and I actually needed t=
o
prove the result to him before he =E2=80=93 I don=C2=B4t even know =E2=80=
=93 eventually
accepted it.

I may be off with my free space fragmentation idea, thus let the kern.l=
og
and my results speak for itself. I don=C2=B4t see much point in proceed=
ing this
discussion before a BTRFS developer had a look at it.

I put up the sysrq-trigger t kern.log onto the bug report. The bugzilla=
 does
not seem to be available from here at the moment, nginx reports "502 ba=
d
gateway, but the kern.log I attached to it. And in case someone needs i=
t by
mail, just ping me.

=2D-=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
--nextPart1794851.O5moSLK8lM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEABECAAYFAlSe6D4ACgkQmRvqrKWZhMekuwCfaJPB2hcCruWSWGA7Aqjbn80N
uFcAnjTuYnSvkDNPeMObSdSmF4dvlO1o
=poi1
-----END PGP SIGNATURE-----

--nextPart1794851.O5moSLK8lM--

