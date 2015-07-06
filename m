Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from meiko.romanrm.net ([195.154.92.155]:47664 "EHLO
	meiko.romanrm.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751062AbbGFQpr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 6 Jul 2015 12:45:47 -0400
Date: Mon, 6 Jul 2015 21:45:44 +0500
From: Roman Mamedov <rm@romanrm.net>
To: Johannes Pfrang <johannespfrang@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Btrfs - distribute files equally across multiple devices
Message-ID: <20150706214544.184908dd@natsu>
In-Reply-To: <559AAB5C.1030001@gmail.com>
References: <559AAB5C.1030001@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/aMEJvRbD0PQa1Eyoki9OpUJ"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/aMEJvRbD0PQa1Eyoki9OpUJ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 6 Jul 2015 18:22:52 +0200
Johannes Pfrang <johannespfrang@gmail.com> wrote:

> The simplest implementation would probably be something like: Always
> write files to the disk with the least amount of space used. I think
> this may be a valid software-raid use-case, as it combines RAID 0 (w/o
> some of the performance gains[2]) with recoverability of about half of
> the data/files (balanced by filled space or amount of files) in the
> event of a drive-failure[3] by using filesystem information a
> hardware-raid doesn't have. In the end this is more or less JBOD with
> balanced disk usage + filesystem intelligence.

mhddfs does exactly that: https://romanrm.net/mhddfs

--=20
With respect,
Roman

--Sig_/aMEJvRbD0PQa1Eyoki9OpUJ
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlWasLgACgkQTLKSvz+PZwhrgACdGvcbBFFuSwAqc4NGTvBxIzdu
TckAn2p1HqEThIBWDEnpKjWO00Mcpz5E
=8Aor
-----END PGP SIGNATURE-----

--Sig_/aMEJvRbD0PQa1Eyoki9OpUJ--
