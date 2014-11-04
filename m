Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:42969 "EHLO
	james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751218AbaKDEbt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 3 Nov 2014 23:31:49 -0500
Date: Mon, 3 Nov 2014 23:31:45 -0500
From: Zygo Blaxell <zblaxell@furryterror.org>
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: filesystem corruption
Message-ID: <20141104043130.GN17395@hungrycats.org>
References: <CAGwxe4hoJa6h3=qmsa6k+AzienjwZ2eifakKzhanXZVCru9koA@mail.gmail.com>
 <CAGwxe4inBLYrbq2t1T004dGR_vfE-GwgU=fho=SCDBa6LOkWow@mail.gmail.com>
 <CAGfcS_=f2TRGbeWpE186xE89jnXmPb=qiN6mPgjQGJRRX3UJ1g@mail.gmail.com>
 <CAGwxe4hC_BtPd41YCnFnyMD3TnOeuNgAZ1dZUFRUYuOkFjy0Yg@mail.gmail.com>
 <5455B7E7.3020404@pobox.com>
 <1C1C5F8B-DD79-4E4B-A530-D98DABA53E74@colorremedies.com>
 <20141103034337.GM17395@hungrycats.org>
 <935F962F-7DD6-4C18-88F3-65EF614B80E4@colorremedies.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NZtAI5QFBF0GmLcW"
In-Reply-To: <935F962F-7DD6-4C18-88F3-65EF614B80E4@colorremedies.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--NZtAI5QFBF0GmLcW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 03, 2014 at 10:11:18AM -0700, Chris Murphy wrote:
>=20
> On Nov 2, 2014, at 8:43 PM, Zygo Blaxell <zblaxell@furryterror.org> wrote:
> > btrfs seems to assume the data is correct on both disks (the generation
> > numbers and checksums are OK) but gets confused by equally plausible but
> > different metadata on each disk.  It doesn't take long before the
> > filesystem becomes data soup or crashes the kernel.
>=20
> This is a pretty significant problem to still be present, honestly. I
> can understand the "catchup" mechanism is probably not built yet,
> but clearly the two devices don't have the same generation. The lower
> generation device should probably be booted/ignored or declared missing
> in the meantime to prevent trashing the file system.

The problem with generation numbers is when both devices get divergent
generation numbers but we can't tell them apart, e.g.

	1.  sda generation =3D 5, sdb generation =3D 5

	2.  sdb temporarily disconnects, so we are degraded on just sda

	3.  sda gets more generations 6..9

	4.  sda temporarily disconnects, so we have no disks at all.

	5.  the machine reboots, gets sdb back but not sda

If we allow degraded here, then:

	6.  sdb gets more generations 6..9

	7.  sdb disconnects, no disks so no filesystem

	8.  the machine reboots again, this time with sda and sdb present

Now we have two disks with equal generation numbers.  Generations 6..9
on sda are not the same as generations 6..9 on sdb, so if we mix the
two disks' metadata we get bad confusion.

It needs to be more than a sequential number.  If one of the disks
disappears we need to record this fact on the surviving disks, and also
cope with _both_ disks claiming to be the "surviving" one.



>=20
> Chris Murphy
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--NZtAI5QFBF0GmLcW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlRYVpQACgkQgfmLGlazG5yOKgCfUGZsy52+iV3NPJrRKLtkp2Mx
S7gAoNOIGEmOAbENHsNABKkeZjbdsQz7
=zsr5
-----END PGP SIGNATURE-----

--NZtAI5QFBF0GmLcW--
