Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from len.romanrm.net ([176.31.121.172]:36494 "EHLO len.romanrm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755384Ab3DBFVq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 2 Apr 2013 01:21:46 -0400
Date: Tue, 2 Apr 2013 11:21:41 +0600
From: Roman Mamedov <rm@romanrm.ru>
To: Josef Bacik <jbacik@fusionio.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: BTRFS error in __btrfs_inc_extent_ref:1935: Object already
 exists
Message-ID: <20130402112141.0792aa72@natsu>
In-Reply-To: <20130402004645.GM1876@localhost.localdomain>
References: <20130401041540.4b8a4ab3@natsu>
	<20130402004645.GM1876@localhost.localdomain>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/fn/VVZ7CY/RyQKBSKm/b4Mm"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/fn/VVZ7CY/RyQKBSKm/b4Mm
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 1 Apr 2013 20:46:45 -0400
Josef Bacik <jbacik@fusionio.com> wrote:

> I just posted a patch for this bug, I can mount your image now without it
> panicing and it passes fsck on either side of the mount.  Let me know if =
it
> doesn't work for you.  Thanks,

Thank you, it now mounted and works without issues.

--=20
With respect,
Roman

--Sig_/fn/VVZ7CY/RyQKBSKm/b4Mm
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlFaauUACgkQTLKSvz+PZwicKgCeMfG3aIXRYcQdqQDSVQLrtav1
P3UAnA7YFdVyRsZN8FuxV2J49PJVEJ2U
=RXPe
-----END PGP SIGNATURE-----

--Sig_/fn/VVZ7CY/RyQKBSKm/b4Mm--
