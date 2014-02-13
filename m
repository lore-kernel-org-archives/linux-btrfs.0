Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from luka.romanrm.net ([213.163.64.74]:40557 "EHLO luka.romanrm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751517AbaBMVAs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 13 Feb 2014 16:00:48 -0500
Date: Fri, 14 Feb 2014 03:00:45 +0600
From: Roman Mamedov <rm@romanrm.net>
To: kreijack@inwind.it
Cc: kreijack@libero.it, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 5/8] Add command btrfs filesystem disk-usage
Message-ID: <20140214030045.415e21da@natsu>
In-Reply-To: <52FD21B4.4050502@libero.it>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/BpMJ2jnhZM=+Lt0C6Sj//Zo"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <52FD1AD6.50500@libero.it>
 <20140214012810.26297146@natsu>
 <52FD21B4.4050502@libero.it>

--Sig_/BpMJ2jnhZM=+Lt0C6Sj//Zo
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 13 Feb 2014 20:49:08 +0100
Goffredo Baroncelli <kreijack@libero.it> wrote:

> Thanks for the comments, however I don't like du not usage; but you are r=
ight=20
> when you don't like "disk-usage". What about "btrfs filesystem chunk-usag=
e" ?

Personally I don't see the point of being super-pedantic here, i.e. "look t=
his
is not just filesystem usage, this is filesystem CHUNK usage"... Consistency
of having a matching "dev usage" and "fi usage" would have been nicer.

--=20
With respect,
Roman

--Sig_/BpMJ2jnhZM=+Lt0C6Sj//Zo
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlL9Mn0ACgkQTLKSvz+PZwjSkwCfVkoIz64y+J4EZ7zgHSPrPZ+2
CJUAoIkAeosqRPv61auTuy/BkaDkJuS6
=nDod
-----END PGP SIGNATURE-----

--Sig_/BpMJ2jnhZM=+Lt0C6Sj//Zo--
