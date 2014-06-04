Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mari.romanrm.net ([157.7.203.202]:42542 "EHLO mari.romanrm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751413AbaFDWko (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 4 Jun 2014 18:40:44 -0400
Date: Thu, 5 Jun 2014 04:40:37 +0600
From: Roman Mamedov <rm@romanrm.net>
To: "Fajar A. Nugraha" <list@fajar.net>
Cc: Igor M <igork20@gmail.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Very slow filesystem
Message-ID: <20140605044037.3e3a27b2@natsu>
In-Reply-To: <CAG1y0sfrmSD31iKfqyR9jMJSBNvs=dihiHtd8nMwiawkhykUQw@mail.gmail.com>
References: <CAEezp7uMXA3t8-GDVcVzx9An+hPBZmynYZ-wUXzhJuP93czs1w@mail.gmail.com>
	<CAG1y0sfrmSD31iKfqyR9jMJSBNvs=dihiHtd8nMwiawkhykUQw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/HxB8Qse3YQcY5RTq1=AftTJ"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/HxB8Qse3YQcY5RTq1=AftTJ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 5 Jun 2014 05:27:33 +0700
"Fajar A. Nugraha" <list@fajar.net> wrote:

> On Thu, Jun 5, 2014 at 5:15 AM, Igor M <igork20@gmail.com> wrote:
> > Hello,
> >
> > Why btrfs becames EXTREMELY slow after some time (months) of usage ?
>=20
> > # btrfs fi show
> > Label: none  uuid: b367812a-b91a-4fb2-a839-a3a153312eba
> >         Total devices 1 FS bytes used 2.36TiB
> >         devid    1 size 2.73TiB used 2.38TiB path /dev/sde
>=20
> > # btrfs fi df /mnt/old
> > Data, single: total=3D2.36TiB, used=3D2.35TiB
>=20
> Is that the fs that is slow?
>=20
> It's almost full.

Really, is it? The device size is 2.75 TiB, while only 2.35 TiB is used. Ab=
out
400 GiB should be free. That's not "almost full". The "btrfs fi df" readings
may be a little confusing, but usually it's those who ask questions on this
list are confused by them, not those who (try to) answer. :)

--=20
With respect,
Roman

--Sig_/HxB8Qse3YQcY5RTq1=AftTJ
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlOPoGUACgkQTLKSvz+PZwioawCggUtTKLZabI9tomRMzXZX0h5m
CgQAn2GzPrplwRV4XfcObKjjSSeG9G04
=Uc9W
-----END PGP SIGNATURE-----

--Sig_/HxB8Qse3YQcY5RTq1=AftTJ--
