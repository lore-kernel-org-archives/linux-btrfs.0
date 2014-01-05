Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from len.romanrm.net ([91.229.20.24]:48176 "EHLO len.romanrm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751805AbaAEXEc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 5 Jan 2014 18:04:32 -0500
Date: Mon, 6 Jan 2014 04:57:04 +0600
From: Roman Mamedov <rm@romanrm.net>
To: Brendan Hide <brendan@swiftspirit.co.za>
Cc: Sulla <Sulla@gmx.at>, Chris Murphy <lists@colorremedies.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: btrfs-transaction blocked for more than 120 seconds
Message-ID: <20140106045704.7f20872f@natsu>
In-Reply-To: <52C9DE66.8080706@swiftspirit.co.za>
References: <52C2AE7C.5020601@gmx.at>
	<64E70864-9830-4145-9EDF-F53A79977999@colorremedies.com>
	<52C9CBEF.2000309@gmx.at>
	<52C9DE66.8080706@swiftspirit.co.za>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/IERUNuczDZQxeBcVLvwYxyS"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/IERUNuczDZQxeBcVLvwYxyS
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 06 Jan 2014 00:36:22 +0200
Brendan Hide <brendan@swiftspirit.co.za> wrote:

> I had 8x 1.5TB WD1500EARS drives in an mdRAID5 array. With it I had a=20
> single 250GB IDE disk for the OS. When the very old IDE disk inevitably=20
> died, I decided to use a spare 1.5TB drive for the OS. Performance was=20
> bad enough that I simply bought my first SSD the same week.

Did you align your partitions to accommodate for the 4K sector of the EARS?

--=20
With respect,
Roman

--Sig_/IERUNuczDZQxeBcVLvwYxyS
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlLJ40AACgkQTLKSvz+PZwgG8wCfXbSgeGKY5rrzBJYm787UPYKx
kIIAnAxtHd34593p/VRstEJ/9NHHtg6X
=yrg6
-----END PGP SIGNATURE-----

--Sig_/IERUNuczDZQxeBcVLvwYxyS--
