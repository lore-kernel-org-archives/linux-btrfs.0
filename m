Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:53138 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753051AbaLGSsr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 7 Dec 2014 13:48:47 -0500
From: Martin Steigerwald <Martin@lichtvoll.de>
To: Hugo Mills <hugo@carfax.org.uk>, ashford@whisperpc.com,
        Shriramana Sharma <samjnaa@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Why is the actual disk usage of btrfs considered unknowable?
Date: Sun, 07 Dec 2014 19:48:38 +0100
Message-ID: <3351028.0EWMarDq2c@merkaba>
In-Reply-To: <20141207183444.GA1442@carfax.org.uk>
References: <CAH-HCWU9GEjvZLH=rwYev_O0S4_Cs9FJvRiJgBiOK8gdxqK5CQ@mail.gmail.com> <88937b9f24bc72160d80977c9edefba2.squirrel@webmail.wanet.net> <20141207183444.GA1442@carfax.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart2350652.QfzspclGaH"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--nextPart2350652.QfzspclGaH
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"

Am Sonntag, 7. Dezember 2014, 18:34:44 schrieb Hugo Mills:
> On Sun, Dec 07, 2014 at 10:20:27AM -0800, ashford@whisperpc.com wrote=
:
> [snip]
>=20
> > > 3) From what I gathered it is planned to allow different raid /
> > > redundancy levels for different subvolumes. BTRFS can=C3=82=C2=B4=
t know
> > > beforehand where applications request to save future data, i.e.
> > > in which subvolume.
> >=20
> > Same as above.
> >=20
> > If a user will be requesting to use a specific subvolume, it is up =
to them
> > to verify that adequate free space exists there, or handle the exce=
ption.
>=20
>    OK, so let's say I've got a filesystem with 100 GiB of unallocated=

> space. I have two subvolumes, one configured for RAID-1 and one
> configured for single storage.
>=20
>    What number should be shown in the free output of df?
>=20
>    100 GiB? But I can only write 50 GiB to the RAID-1 subvolume befor=
e
> it runs out of space.
>=20
>    50 GiB? I can get twice that much on the single subvolume.
>=20
>    *Any* value shown here is going to be inaccurate, and whatever way=

> round we show it, someone will complain.

Thats why I pointed out fallocate. If it suceeds, I would expect even B=
TRFS=20
with its special free space challenges guarantees the space is there.

A getfreespacebypath() syscall may yield quite accurate figures as well=
, cause=20
then BTRFS can know which subvolume the application wants to write it, =
but as=20
it cannot predict the future write behavior of all processes, it cannot=
=20
guarantee anything.

So for any guarantee as far as I know, the only thing you can do is fal=
locate.

I never liked the pre installation check of roughly having 5 GiB of fre=
e space=20
or so to suceed or fail otherwise. But on the other hand, running 90% t=
hrough=20
an installation and then failing to do not enough free space is also no=
t nice.=20
Similarily to copying 4 GiB of a 4,3 GB DVD image to an FAT32 before it=
 fails=20
the copy.

But for the FAT32 it is much easier to know it can=C2=B4t write a file =
larger 4 GiB=20
than for BTRFS or any other filesystem to know whether installing a set=
 of files=20
to a set of directories with a certain total size is going to work out.=


Only thing that could improve this, would be some kind of more flexible=
 space=20
allocation. Or=E2=80=A6 creating every directory and fallocating each f=
ile with the=20
exact size before doing the actual copy. And heck, somehow I like this =
idea.=20
It could help to avoid actions that just do not make sense. An rsync co=
uld=20
abort early if the total free space would not be enough. But especially=
 for=20
rsync since version 3 this again doesn=C2=B4t work, as rsync works incr=
ementally=20
since version 3. On the other hand if btrfs send could store size requi=
rements=20
in the send data, before the receive side thats working, then the recei=
ve side=20
could preallocate, but=E2=80=A6 then that would depend on how easy it w=
ould be for the=20
send size to get the size difference between two snapshots.

Thanks,
=2D-=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
--nextPart2350652.QfzspclGaH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEABECAAYFAlSEoQsACgkQmRvqrKWZhMdWFwCgoUqtdMteq1j2FupiPd1E8W/e
YIQAnijT46jzltRU0YCzMPKymBiPHLro
=deit
-----END PGP SIGNATURE-----

--nextPart2350652.QfzspclGaH--

