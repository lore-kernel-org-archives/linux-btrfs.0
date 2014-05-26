Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mari.romanrm.net ([157.7.203.202]:40146 "EHLO mari.romanrm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751436AbaEZQjX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 26 May 2014 12:39:23 -0400
Date: Mon, 26 May 2014 22:39:16 +0600
From: Roman Mamedov <rm@romanrm.net>
To: David Bloquel <david.bloquel@jimywoo.fr>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Btrfs filesystem freezing during snapshots
Message-ID: <20140526223916.25dfea52@natsu>
In-Reply-To: <CA+3u+RcGa2Xr+mzwGL-V89A7DEa05B_NS+cgS-Es1b3d8b5xKg@mail.gmail.com>
References: <CA+3u+RcGa2Xr+mzwGL-V89A7DEa05B_NS+cgS-Es1b3d8b5xKg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/YNG.=450.D0gH.gWStz3R6+"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/YNG.=450.D0gH.gWStz3R6+
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 26 May 2014 14:28:51 +0200
David Bloquel <david.bloquel@jimywoo.fr> wrote:

> [69537.117439]       Not tainted 3.12-0.bpo.1-amd64 #1

Try upgrading to the kernel 3.14. From what I can tell it has significant
improvements/bugfixes in the snapshot deletion area. Just a couple of days =
ago
I got a recurring lock-up after deleting 50 snapshots with tens of thousand=
s of
fragments of files in each (VM images, like in your case). Googled around a
little bit, and found a similar issue with a report that 3.14 solves the
problem. Upgraded to 3.14.4 (from 3.12.20), and voila, indeed it does.

--=20
With respect,
Roman

--Sig_/YNG.=450.D0gH.gWStz3R6+
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlODbjQACgkQTLKSvz+PZwgMlgCfWOT+96tabQUeJWjgdVbjv3xR
jOYAmwa9Mf0r6y8mgbMN64TzYERnZirM
=Q9CP
-----END PGP SIGNATURE-----

--Sig_/YNG.=450.D0gH.gWStz3R6+--
