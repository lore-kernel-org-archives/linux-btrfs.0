Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:51984 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932213AbaLHPwf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 8 Dec 2014 10:52:35 -0500
From: Martin Steigerwald <Martin@lichtvoll.de>
To: Austin S Hemmelgarn <ahferroin7@gmail.com>
Cc: Robert White <rwhite@pobox.com>, Shriramana Sharma <samjnaa@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Why is the actual disk usage of btrfs considered unknowable?
Date: Mon, 08 Dec 2014 16:52:25 +0100
Message-ID: <4374730.0la5jyvaQV@merkaba>
In-Reply-To: <5485BC6E.8010604@gmail.com>
References: <CAH-HCWU9GEjvZLH=rwYev_O0S4_Cs9FJvRiJgBiOK8gdxqK5CQ@mail.gmail.com> <1447188.5moEuATfqD@merkaba> <5485BC6E.8010604@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart3623993.Edem33NTMt"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--nextPart3623993.Edem33NTMt
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"

Am Montag, 8. Dezember 2014, 09:57:50 schrieb Austin S Hemmelgarn:
> On 2014-12-08 09:47, Martin Steigerwald wrote:
> > Hi,
> >=20
> > Am Sonntag, 7. Dezember 2014, 21:32:01 schrieb Robert White:
> >> On 12/07/2014 07:40 AM, Martin Steigerwald wrote:
> >>> Well what would be possible I bet would be a kind of system call =
like
> >>> this:
> >>>=20
> >>> I need to write 5 GB of data in 100 of files to /opt/mynewshinyso=
ftware,
> >>> can I do it *and* give me a guarentee I can.
> >>>=20
> >>> So like a more flexible fallocate approach as fallocate just allo=
cates
> >>> one
> >>> file and you would need to run it for all files you intend to cre=
ate.
> >>> But
> >>> challenge would be to estimate metadata allocation beforehand
> >>> accurately.
> >>>=20
> >>> Or have tar --fallocate -xf which for all files in the archive wi=
ll
> >>> first
> >>> call fallocate and only if that succeeded, actually write them. B=
ut due
> >>> to the nature of tar archives with their content listing across t=
he
> >>> whole
> >>> archive, this means it may have to read the tar archive twice, so=
 ZIP
> >>> archives might be better suited for that.
> >>=20
> >> What you suggest is Still Not Practical=E2=84=A2 (the tar thing mi=
ght have some
> >> ability if you were willing to analyze every file to the byte leve=
l).
> >>=20
> >> Compression _can_ make a file _bigger_ than its base size. BTRFS d=
ecides
> >> whether or not to compress a file based on the results it gets whe=
n
> >> tying to compress the first N bytes. (I do not know the value of N=
). But
> >> it is _easy_ to have a file where the first N bytes compress well =
but
> >> the bytes after N take up more space than their byte count. So to
> >> fallocate() the right size in blocks you'd have to compress the in=
put
> >> and determine what BTRFS _would_ _do_ and then allocate that much =
space
> >> instead of the file size.
> >>=20
> >> And even then, if you didn't create all the names and directories =
you
> >> might find that the RBtree had to expand (allocate another tree no=
de)
> >> one or more times to accommodate the actual files. Lather rinse re=
peat
> >> for any checksum trees and anything hitting a flush barrier becaus=
e of
> >> commit=3D or sync() events or other writers perturbing your result=
s
> >> because it only matters if the filesystem is nearly full and nearl=
y full
> >> filesystems may not be quiescent at all.
> >>=20
> >> So while the core problem isn't insoluble, in real life it is _not=
_
> >> _worth_ _solving_.
> >>=20
> >> On a nearly empty filesystem, it's going to fit.
> >>=20
> >> In a reasonably empty filesystem, it's going to fit.
> >>=20
> >> On a nearly full filesystem, it may or may not fit.
> >>=20
> >> On a filesystem that is so close to full that you have reason to d=
oubt
> >> it will fit, you are going to have a very bad time even if it fits=
.
> >>=20
> >> If you did manage to invent and implement an fallocate algorythm t=
hat
> >> could make this promise and make it stick, then some other running=

> >> program is what's going to crash when you use up that last byte an=
yway.
> >>=20
> >> Almost full filesystems are their own reward.
> >=20
> > So you basically say that BTRFS with compression  does not meet the=

> > fallocate guarantee. Now thats interesting, cause it basically viol=
ates
> > the
> > documentation for the system call:
> >=20
> > DESCRIPTION
> >=20
> >         The function posix_fallocate() ensures that disk space  is =
 allo=E2=80=90
> >         cated for the file referred to by the descriptor fd for the=
 bytes
> >         in the range starting at offset and  continuing  for  len  =
bytes.
> >         After  a  successful call to posix_fallocate(), subsequent =
writes
> >         to bytes in the  specified  range  are  guaranteed  not  to=
  fail
> >         because of lack of disk space.
> >=20
> > So in order to be standard compliant there, BTRFS would need to wri=
te
> > fallocated files uncompressed=E2=80=A6 wow this is getting complex.=

>=20
> The other option would be to allocate based on the worst case size
> increase for the compression algorithm, (which works out to about 5%
> IIRC for zlib and a bit more for lzo) and then possibly discard the
> unwritten extents at some later point.

Now that seems like a workable solution.

=2D-=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
--nextPart3623993.Edem33NTMt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEABECAAYFAlSFyT4ACgkQmRvqrKWZhMfJZQCfVYLMlOdvt6r5JqNbBxjHhqhO
W8oAn0j0F2tqorOX07qQUY+JarpZ3LYI
=f8fD
-----END PGP SIGNATURE-----

--nextPart3623993.Edem33NTMt--

