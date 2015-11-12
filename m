Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from meiko.romanrm.net ([195.154.92.155]:55405 "EHLO
	meiko.romanrm.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932098AbbKLOJV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 12 Nov 2015 09:09:21 -0500
Date: Thu, 12 Nov 2015 19:09:18 +0500
From: Roman Mamedov <rm@romanrm.net>
To: Austin S Hemmelgarn <ahferroin7@gmail.com>
Cc: Vytautas D <vytdau@gmail.com>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Ideas for btrfs-convert fix(or rework)
Message-ID: <20151112190918.3820dd2a@natsu>
In-Reply-To: <564493D5.2070609@gmail.com>
References: <56418E5D.9020604@gmx.com>
	<20151110125501.1aa6f155@natsu>
	<5641A7DA.6010102@gmx.com>
	<20151110140855.3ae7297c@natsu>
	<5641B64A.9020606@gmx.com>
	<pan$edd20$481e3529$4248bf13$5caaf119@cox.net>
	<CAO5K3OfBy72Yn1s4Ow2h_2KkE7U4wQA66oxjQLva82-D2LqScA@mail.gmail.com>
	<564493D5.2070609@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/u63wHCCZQfSiZCgg6Ec.3yy"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/u63wHCCZQfSiZCgg6Ec.3yy
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 12 Nov 2015 08:27:49 -0500
Austin S Hemmelgarn <ahferroin7@gmail.com> wrote:

> know of (Arch and Gentoo), because the very fact that you installed a=20
> system with either one means that you are fully capable of backing up=20
> your data, and reprovisioning the system using BTRFS instead of whatever=
=20
> filesystem you are already using

Uhm, what?... How does the fact that I use one particular distro or another,
reflect on my ability to (easily) back up and restore my 10 TB storage arra=
y?
"You should maintain backups anyway so you could easily restore" -- yeah I =
do,
and they are in a remote location over a relatively slow link.

I chose Ext4 instead of the other options which seemed more attractive
(primarily XFS, but also JFS) for this array back when creating it a long t=
ime
ago, when Btrfs was still in its much earlier days than now, **SPECIFICALLY=
**
with the intent to use btrfs-convert "as soon as Btrfs somewhat matures". So
as time went, it did, I acted on this plan, and everything went just perfec=
tly.

Why are people so quick to project "If I don't need this, nobody likely doe=
s".
Btrfs-convert is an amazing feature and it will be extremely sad if it ever
goes away.

--=20
With respect,
Roman

--Sig_/u63wHCCZQfSiZCgg6Ec.3yy
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlZEnY4ACgkQTLKSvz+PZwixkQCeKKBhiTexcoiuu/he4WuPEs5t
F/YAn0h/jbTV4WOJFIKQlvGVwQEVFec4
=emrl
-----END PGP SIGNATURE-----

--Sig_/u63wHCCZQfSiZCgg6Ec.3yy--
