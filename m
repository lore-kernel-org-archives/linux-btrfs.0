Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from meiko.romanrm.net ([195.154.92.155]:43130 "EHLO
	meiko.romanrm.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423672AbcFHJXf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 8 Jun 2016 05:23:35 -0400
Date: Wed, 8 Jun 2016 14:23:23 +0500
From: Roman Mamedov <rm@romanrm.net>
To: cdlscpmv <cdlscpmv@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Can't remove read-only snapshot with immutable flag set
Message-ID: <20160608142323.265d2f35@natsu>
In-Reply-To: <20160608083757.GA30823@localhost>
References: <20160608083757.GA30823@localhost>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/NNPEe8DSNO2kyRJ7PQDWQiE"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/NNPEe8DSNO2kyRJ7PQDWQiE
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 8 Jun 2016 08:37:57 +0000
cdlscpmv <cdlscpmv@gmail.com> wrote:

> It happened that I set the immutable flag (via `chattr +i`) on a subvolum=
e.
> Then I made a read-only snapshot of that subvolume. Now I can't remove
> this snapshot.
> =09
> 	#> btrfs subvolume delete my_snapshot
> 	Delete subvolume (no-commit): 'my_snapshot'
> 	ERROR: cannot delete 'my_snapshot': Operation not permitted
> 	#> chattr -i my_snapshot=20
> 	chattr: Read-only file system while setting flags on my_snapshot
> 	#> btrfs --version
> 	btrfs-progs v4.4.1
> 	#> uname -r
> 	4.5.2
>=20
> Is there any other way to do this? Or is it a bug?


You could try doing:

  btrfs property set my_snapshot ro false

normally this should change it to a read-write snapshot. But it seems like
changing btrfs properties is also blocked by chattr +i (at least I can't
change compression methods on a +i file).

--=20
With respect,
Roman

--Sig_/NNPEe8DSNO2kyRJ7PQDWQiE
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEARECAAYFAldX5A4ACgkQTLKSvz+PZwj0DACghGEWgNHB3gDqpmhMHXjiGvTT
kYoAn024R4abq52mHVK2M3/UworcHC/4
=HG6S
-----END PGP SIGNATURE-----

--Sig_/NNPEe8DSNO2kyRJ7PQDWQiE--
