Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from len.romanrm.net ([176.31.121.172]:54198 "EHLO len.romanrm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751487Ab3CBLMk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 2 Mar 2013 06:12:40 -0500
Date: Sat, 2 Mar 2013 17:12:37 +0600
From: Roman Mamedov <rm@romanrm.ru>
To: Gabriel de Perthuis <g2p.code@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Permanent uncancellable balance
Message-ID: <20130302171237.00afdc78@natsu>
In-Reply-To: <kgsj1h$oo1$1@ger.gmane.org>
References: <kgsj1h$oo1$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/SCn/lZ1+.4o8DcbH5tpwhWw"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/SCn/lZ1+.4o8DcbH5tpwhWw
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 2 Mar 2013 10:07:45 +0000 (UTC)
Gabriel de Perthuis <g2p.code@gmail.com> wrote:

> Hello,
> I have a filesystem that has become unusable because of a balance I can't=
=20
> stop. It is very close to full, and the balance is preventing me from=20
> growing it.
>=20
> It was started like this:
> sudo btrfs filesystem balance start -v -musage=3D60 -dusage=3D60 /srv/bac=
kups
>=20
> It has been stuck at 0% across reboots and kernel upgrades (currently on=
=20
> 3.8.1), and cancelling it had no effect:
>=20
> Balance on '/srv/backups' is running
> 0 out of about 5 chunks balanced (95 considered), 100% left
>=20
> According to atop it is writing but not reading anything.
> Unmounting never terminates, so does remounting ro, the only way to=20
> temporarilly kill it is to reboot. SIGKILL has no effect either. Is there=
=20
> *any* way I can get rid of it?
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Mount with the "skip_balance" option
https://btrfs.wiki.kernel.org/index.php/Mount_options
then you can issue "btrfs fi balance cancel" and it will succeed.

--=20
With respect,
Roman

--Sig_/SCn/lZ1+.4o8DcbH5tpwhWw
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlEx3qUACgkQTLKSvz+PZwgcJQCglTT/ISBGnL87c7jQKC8plH5M
cRQAnj40DAD2GUZ9R/wLHZmfB9pOML9c
=k7r7
-----END PGP SIGNATURE-----

--Sig_/SCn/lZ1+.4o8DcbH5tpwhWw--
