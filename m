Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from len.romanrm.net ([176.31.121.172]:55065 "EHLO len.romanrm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754014Ab3ESL11 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 19 May 2013 07:27:27 -0400
Date: Sun, 19 May 2013 17:15:10 +0600
From: Roman Mamedov <rm@romanrm.ru>
To: george@chinilu.com
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Virtual Device Support
Message-ID: <20130519171510.54897415@natsu>
In-Reply-To: <518CFE3A.3080900@chinilu.com>
References: <518CFE3A.3080900@chinilu.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/LFrvqdp7+rZHiXbRYcxu//X"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/LFrvqdp7+rZHiXbRYcxu//X
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 10 May 2013 07:03:38 -0700
George Mitchell <george@chinilu.com> wrote:

> One the things that is frustrating me the most at this point from a user=
=20
> perspective regarding btrfs is the current lack of virtual devices to=20
> describe volumes and subvolumes.

=46rom a user perspective btrfs subvolumes have a lot in common with just
regular directories aka folders, and nothing in common with (block)devices.
"Describing them with virtual devices" does not seem to make a whole lot of
sense.

--=20
With respect,
Roman

--Sig_/LFrvqdp7+rZHiXbRYcxu//X
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlGYtD4ACgkQTLKSvz+PZwjHugCfUSfZqUd3A6LE/PE6ZseUQw+r
Gl8Anj38YDwvp7DrQqT6H7Rixy3terUe
=+8gh
-----END PGP SIGNATURE-----

--Sig_/LFrvqdp7+rZHiXbRYcxu//X--
