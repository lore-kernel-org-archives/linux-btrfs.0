Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from luka.romanrm.net ([213.163.64.74]:39728 "EHLO luka.romanrm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751224AbaBIBJF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 8 Feb 2014 20:09:05 -0500
Date: Sun, 9 Feb 2014 07:08:56 +0600
From: Roman Mamedov <rm@romanrm.net>
To: Kai Krakow <hurikhan77+btrfs@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Provide a better free space estimate on RAID1
Message-ID: <20140209070856.55c39e8d@natsu>
In-Reply-To: <0erisa-t5d.ln1@hurikhan77.spdns.de>
References: <20140206021516.304732cd@natsu>
	<52F3EED4.7030603@fb.com>
	<agsfsa-mks.ln1@hurikhan77.spdns.de>
	<20140208173310.1f90af3b@natsu>
	<20140208114634.GH6490@carfax.org.uk>
	<cikisa-qf7.ln1@hurikhan77.spdns.de>
	<20140209041050.529ff6f9@natsu>
	<0erisa-t5d.ln1@hurikhan77.spdns.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/kOag.bdPLtGvnzuU2R8f9sm"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/kOag.bdPLtGvnzuU2R8f9sm
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 09 Feb 2014 00:32:47 +0100
Kai Krakow <hurikhan77+btrfs@gmail.com> wrote:

> When I started to use unix, df returned blocks, not bytes. Without your=20
> proposed patch, it does that right. With your patch, it does it wrong.

It returns total/used/available space that is usable/used/available by/for
user data. Whether that be in sectors, blocks, kilobytes, megabytes or in s=
ome
other unit, is a secondary detail which is also unrelated to the change bei=
ng
currently discussed and not affected by it.

--=20
With respect,
Roman

--Sig_/kOag.bdPLtGvnzuU2R8f9sm
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlL21SgACgkQTLKSvz+PZwhugACgg9EaP9c/rP9ZYP5YbpxcL5+1
ypUAn0OOdFcK/LKf9Zlm+nHlG0FtEK5l
=nyvN
-----END PGP SIGNATURE-----

--Sig_/kOag.bdPLtGvnzuU2R8f9sm--
