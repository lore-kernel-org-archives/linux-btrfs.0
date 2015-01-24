Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:41107 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750913AbbAXKUH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 24 Jan 2015 05:20:07 -0500
From: Martin Steigerwald <martin@lichtvoll.de>
To: Zygo Blaxell <zblaxell@furryterror.org>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: 3.19-rc5: Bug 91911: [REGRESSION] rm command hangs big time with deleting a lot of files at once
Date: Sat, 24 Jan 2015 11:20 +0100
Message-ID: <6466291.Yc27r3pZsf@merkaba>
In-Reply-To: <20150123232934.GA14858@hungrycats.org>
References: <2506104.3YBgc9qdaM@merkaba> <20150123232934.GA14858@hungrycats.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart1451861.ZB0gAXeRl2"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--nextPart1451861.ZB0gAXeRl2
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"

Am Freitag, 23. Januar 2015, 18:29:40 schrieb Zygo Blaxell:
> On Fri, Jan 23, 2015 at 03:01:28PM +0100, Martin Steigerwald wrote:
> > Hi!
> >=20
> > Anyone seen this?
> >=20
> > Reported as:
> >=20
> > https://bugzilla.kernel.org/show_bug.cgi?id=3D91911
>=20
> I have seen something like this since 3.15.
>=20
> I've also seen its cousin, which gets stuck in evict_inode, but the
> stacks of the hanging processes start from renameat2() instead of
> unlinkat(). I haven't seen the renameat2() variant of this bug since
> 3.18-rc6.

I see.

Well than it is at least not only happening here. So we have some more=20=

BTRFS getting stuck issues. And this hangs happened here with BTRFS sti=
ll=20
being able to allocate some hungs and there is also no kworker kthread =
at=20
100% of one core, so this is a different issue.

> > I just want to get rid of some 127000+ akonadi lost+found files, an=
y
> > delete command I start just gets rid of some thousands and then
> > hangs.

> > merkaba:~> btrfs fi df /home
> > Data, RAID1: total=3D160.92GiB, used=3D111.09GiB
> > System, RAID1: total=3D32.00MiB, used=3D48.00KiB
> > Metadata, RAID1: total=3D5.99GiB, used=3D2.49GiB
> > GlobalReserve, single: total=3D512.00MiB, used=3D0.00B
> > merkaba:~> btrfs fi sh /home
> > Label: 'home'  uuid: [=E2=80=A6]

> >         Total devices 2 FS bytes used 113.58GiB
> >         devid    1 size 170.00GiB used 166.94GiB path
> >         /dev/mapper/msata-home
> >         devid    2 size 170.00GiB used 166.94GiB path
> >         /dev/mapper/sata-home

> > Btrfs v3.18

Also there is a lot of free space inside the allocated chunks.

[=E2=80=A6 description + dmesg as in bug report linked above =E2=80=A6]=

=2D-=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
--nextPart1451861.ZB0gAXeRl2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEABECAAYFAlTDcdUACgkQmRvqrKWZhMer0ACgjLNhoaghMoZOyETkJGP1QpUT
0ikAn1Gf05ZkqRE4uCIsqX2I07dwgeAA
=ljlM
-----END PGP SIGNATURE-----

--nextPart1451861.ZB0gAXeRl2--

