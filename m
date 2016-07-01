Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from len.romanrm.net ([195.154.117.182]:48538 "EHLO len.romanrm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750803AbcGAW3h (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 1 Jul 2016 18:29:37 -0400
Date: Sat, 2 Jul 2016 03:29:30 +0500
From: Roman Mamedov <rm@romanrm.net>
To: g6094199@freenet.de
Cc: linux-btrfs@vger.kernel.org
Subject: Re: FYI: *buntu - btrfs kernel error
Message-ID: <20160702032930.7ccb1d26@natsu>
In-Reply-To: <dc10db83-ce23-161e-0307-9011f4ed4ec7@chefmail.de>
References: <dc10db83-ce23-161e-0307-9011f4ed4ec7@chefmail.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/DeuyC1fU0/dR2LDjCDtwaLb"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/DeuyC1fU0/dR2LDjCDtwaLb
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 1 Jul 2016 20:09:55 +0200
g6094199@freenet.de wrote:

> he guys,
>=20
> yes i know its *buntu xenial and nobody knows what they have backported,
> but maybe its still interesting for someone....

That's not an error, but just a warning that some operation was taking so
long, that the kernel was concerned it might be hung. You can adjust the
warning time threshold from 120 seconds back and forth as you like via the
sysfs interface.

What you're missing to report is whether or not the system works fine after
this, or the FS operations lock up entirely and server requires a reboot. If
it works fine, then you shouldn't worry about this too much.

--=20
With respect,
Roman

--Sig_/DeuyC1fU0/dR2LDjCDtwaLb
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEARECAAYFAld27s0ACgkQTLKSvz+PZwjHKgCfedGJraWjF1GDwIMfepP6HyC9
AxYAn0J5Zg3i2tK43wJdZgpOy49sd7Nm
=p6Rd
-----END PGP SIGNATURE-----

--Sig_/DeuyC1fU0/dR2LDjCDtwaLb--
