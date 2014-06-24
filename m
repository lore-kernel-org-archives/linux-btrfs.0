Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mari.romanrm.net ([157.7.203.202]:38282 "EHLO mari.romanrm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750806AbaFXE6M (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 24 Jun 2014 00:58:12 -0400
Date: Tue, 24 Jun 2014 10:58:04 +0600
From: Roman Mamedov <rm@romanrm.net>
To: Filipe David Borba Manana <fdmanana@gmail.com>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] generic/017: skip invalid block sizes for btrfs
Message-ID: <20140624105804.528ad83d@natsu>
In-Reply-To: <1403519280-24216-1-git-send-email-fdmanana@gmail.com>
References: <1403519280-24216-1-git-send-email-fdmanana@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/JKyI2x8wEZbUIP4DK_sS3J1"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/JKyI2x8wEZbUIP4DK_sS3J1
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 23 Jun 2014 11:28:00 +0100
Filipe David Borba Manana <fdmanana@gmail.com> wrote:

> In btrfs the block size (called sector size in btrfs) can not be
> smaller then the page size.

Just in case anyone misses this, there is some work to address this limitat=
ion:
http://www.spinics.net/lists/linux-btrfs/msg34814.html

So perhaps keep in mind to roll-back the proposed patch after the above gets
finalized and merged.

--=20
With respect,
Roman

--Sig_/JKyI2x8wEZbUIP4DK_sS3J1
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlOpBV0ACgkQTLKSvz+PZwivogCghxbuqNRZyEGajHsiMHWam4Oe
ZIMAmwRXv7Ch0zrhCGXTpoQzKUsBkBbO
=t4t2
-----END PGP SIGNATURE-----

--Sig_/JKyI2x8wEZbUIP4DK_sS3J1--
