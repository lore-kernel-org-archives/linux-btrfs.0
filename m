Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from asuka.romanrm.net ([128.199.93.76]:60699 "EHLO
	asuka.romanrm.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752670AbbDBONR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 2 Apr 2015 10:13:17 -0400
Date: Thu, 2 Apr 2015 19:13:12 +0500
From: Roman Mamedov <rm@romanrm.net>
To: Hugo Mills <hugo@carfax.org.uk>
Cc: Timofey Titovets <nefelim4ag@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Btrfs hangs 3.19-10
Message-ID: <20150402191312.1ee31af3@natsu>
In-Reply-To: <20150402114608.GG32078@carfax.org.uk>
References: <CAGqmi74e_U5-UVUy+MHbxc2f-38pRyjK1Zo0Up-V9ndFpv-bXA@mail.gmail.com>
	<20150402114608.GG32078@carfax.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/LKSb8Fb+eQ1nSD5Sw1rcU5q"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/LKSb8Fb+eQ1nSD5Sw1rcU5q
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 2 Apr 2015 11:46:08 +0000
Hugo Mills <hugo@carfax.org.uk> wrote:

> On Thu, Apr 02, 2015 at 02:38:24PM +0300, Timofey Titovets wrote:
> > I've get it several times, after rebooting or unclean shutdown system.
> >=20
> > This is very strange bug, because if i reboot, and mount it from live
> > cd, all that okay, and after reboot in system, system successful mount
> > all and working good.
> > i did try to found any previous issues on it, and found nothing.
>=20
>    Try 4.0-rc6, which should have the fix for the problem in it. This
> was introduced in the stable series, and is now fixed in mainline. It
> should also be fixed in the next stable release, I believe.

Yeah I believe I just hit that in 3.14.37, system unbootable (locks up at
"Scanning for Btrfs filesystems"), resulted in a many hour downtime as it w=
as
a remote system w/o IPMI. Fine after a reboot to 3.14.34. Too bad that even
staying on the "stable" series kernel can back-stab you like that from time=
 to
time.

--=20
With respect,
Roman

--Sig_/LKSb8Fb+eQ1nSD5Sw1rcU5q
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlUdTngACgkQTLKSvz+PZwjVOwCfQpsU0LdF0+tSAv4lEC57dqcR
TtoAnA4P1qjjU+1LrLVrJsFvLTI/tn7V
=ilMX
-----END PGP SIGNATURE-----

--Sig_/LKSb8Fb+eQ1nSD5Sw1rcU5q--
