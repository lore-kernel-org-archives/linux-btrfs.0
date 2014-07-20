Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:63728 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751113AbaGTJuv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 20 Jul 2014 05:50:51 -0400
Date: Sun, 20 Jul 2014 11:50:40 +0200
From: Marc Joliet <marcec@gmx.de>
To: linux-btrfs@vger.kernel.org
Cc: Chris Murphy <lists@colorremedies.com>
Subject: Re: ENOSPC errors during balance
Message-ID: <20140720115040.630f56a9@marcec>
In-Reply-To: <1236DA1E-80DE-4240-840E-97CB131D8966@colorremedies.com>
References: <20140719221051.57378a41@marcec>
 <20140719225810.7a28d13b@marcec>
 <1236DA1E-80DE-4240-840E-97CB131D8966@colorremedies.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/61V=+_TI0m86QtpyDZzr=sX"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/61V=+_TI0m86QtpyDZzr=sX
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Am Sat, 19 Jul 2014 18:53:03 -0600
schrieb Chris Murphy <lists@colorremedies.com>:

>=20
> On Jul 19, 2014, at 2:58 PM, Marc Joliet <marcec@gmx.de> wrote:
>=20
> > Am Sat, 19 Jul 2014 22:10:51 +0200
> > schrieb Marc Joliet <marcec@gmx.de>:
> >=20
> > [...]
> >> Another random idea:  the number of errors decreased the second time I=
 ran
> >> balance (from 4 to 2), I could run another full balance and see if it =
keeps
> >> decreasing.
> >=20
> > Well, this time there were still 2 ENOSPC errors.  But I can show the d=
f output
> > after such an ENOSPC error, to illustrate what I meant with the sudden =
surge
> > in total usage:
> >=20
> > # btrfs filesystem df /run/media/marcec/MARCEC_BACKUP=20
> > Data, single: total=3D236.00GiB, used=3D229.04GiB
> > System, DUP: total=3D32.00MiB, used=3D36.00KiB
> > Metadata, DUP: total=3D4.00GiB, used=3D3.20GiB
> > unknown, single: total=3D512.00MiB, used=3D0.00
> >=20
> > And then after running a balance and (almost) immediately cancelling:
> >=20
> > # btrfs filesystem df /run/media/marcec/MARCEC_BACKUP=20
> > Data, single: total=3D230.00GiB, used=3D229.04GiB
> > System, DUP: total=3D32.00MiB, used=3D36.00KiB
> > Metadata, DUP: total=3D4.00GiB, used=3D3.20GiB
> > unknown, single: total=3D512.00MiB, used=3D0.00
>=20
> I think it's a bit weird. Two options: a. Keep using the file system, wit=
h judicious backups, if a dev wants more info they'll reply to the thread; =
b. Migrate the data to a new file system, first capture the file system wit=
h btrfs-image in case a dev wants more info and you've since blown away the=
 filesystem, and then move it to a new btrfs fs. I'd use send/receive for t=
his to preserve subvolumes and snapshots.

OK, I'll keep that in mind.  I'll keep running the file system for now, jus=
t in
case it's a run-time error (i.e., a bug in the balance code, and not a prob=
lem
with the file system itself).  If it gets trashed on its own, or I move to =
a new
file system, I'll be sure to follow the steps you outlined.

> Chris Murphy

Thanks
--=20
Marc Joliet
--
"People who think they know everything really annoy those of us who know we
don't" - Bjarne Stroustrup

--Sig_/61V=+_TI0m86QtpyDZzr=sX
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTy5D0AAoJEL/Q5oYsiHj0iIAQAK3KLCq9BhPg3nBHkfupqFNa
EG0ndS3ZDKOxvJ6xQeRT70+HSfzuFWW0IATMixdwsKQ6iY6FU2gDbfyMHv/ufZAn
VDur49kVPPSd7M1M3Vr6orz+w0wdSOpCXsX82mFUrCGjpUp7bpBwjU6md41ltb6J
MDVI5f7tVQEPJ3bhALsy7uCJkhF/MiXr+gW0zN8efNb8BcJKGTZEe5zQHtlMjP3P
60AZ4G/kw+wbGVjlSZm6hVS6mt5I4f2+og2cxlrcwOPBHdsvDFvejNT4Y65mBZM8
dcQPySPNjUI3uiJdIKa1dwlMHuWUOV2CUPhWIFM4noT8++qlJrZxvpC8oSVq4fjy
Ksz9zAH0/es1Liu4ACiotIHLZ2lCVmpAmyHoW1FiERY27MfPXUiE1fAxyGXYxFMp
ILuNV9+goGWeCiVIWd2ShnxENwIbYbrdCsbHRxkOFmyHe+2iPujhaEyff1Cikdhr
u2yRE0h3kbrJN1dyVvu5nYiTaqlH3jXRv/aDUU0PnSEQQvCd8EYbjx6SUqcqWttH
fcSd7V6mifur0iq2FM5DS94lNsnAJuj2vSSn0wuJAnmf1ZKMTm32qdUPuosBS2/h
ANJI/6y6ZeAr0tfSqSYpfKXyEcjSN5DOVjI8Qfxh9T31GK7S4ueIZkolDcVjQ+dN
j59aF4bf+9VBAPpImCNj
=boUu
-----END PGP SIGNATURE-----

--Sig_/61V=+_TI0m86QtpyDZzr=sX--
