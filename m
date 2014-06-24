Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mari.romanrm.net ([157.7.203.202]:38399 "EHLO mari.romanrm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751676AbaFXLCn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 24 Jun 2014 07:02:43 -0400
Date: Tue, 24 Jun 2014 17:02:36 +0600
From: Roman Mamedov <rm@romanrm.net>
To: Gerald Hopf <gerald.hopf@nv-systems.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: "-d single" for data blocks on a multiple devices doesn't work
 as it should
Message-ID: <20140624170236.28d5bfa9@natsu>
In-Reply-To: <53A955F8.8090101@nv-systems.net>
References: <53A955F8.8090101@nv-systems.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/yDIsUEa1IbrrnVSsilLxsoI"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/yDIsUEa1IbrrnVSsilLxsoI
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 24 Jun 2014 12:42:00 +0200
Gerald Hopf <gerald.hopf@nv-systems.net> wrote:

> The "-d single" allocator is useless (or broken?).

It's just not designed with your use case in mind. It operates on the level=
 of
allocation extents (if I'm not mistaken), not of whole files.

If you want to join multiple devices with a per-file granularity (so that a
single file is wholely stored on one given device), check out the FUSE
filesystem called mhddfs; I wrote an article about it some time ago:
https://romanrm.net/mhddfs

--=20
With respect,
Roman

--Sig_/yDIsUEa1IbrrnVSsilLxsoI
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlOpWswACgkQTLKSvz+PZwgiLwCeL3hyHq54Ctb+fR61YFMqL1PC
X2sAn0/pjs5vmIj0lBs/q8+/YcW0Lbjb
=r1qs
-----END PGP SIGNATURE-----

--Sig_/yDIsUEa1IbrrnVSsilLxsoI--
