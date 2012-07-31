Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from len.romanrm.net ([176.31.121.172]:54292 "EHLO len.romanrm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751710Ab2GaFcu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 31 Jul 2012 01:32:50 -0400
Date: Tue, 31 Jul 2012 11:32:47 +0600
From: Roman Mamedov <rm@romanrm.ru>
To: serialhex@lavabit.com
Cc: linux-btrfs@vger.kernel.org
Subject: Re: filesystem finder / fixer
Message-ID: <20120731113247.11aab72a@natsu>
In-Reply-To: <36321.99.101.148.183.1343705202.squirrel@lavabit.com>
References: <36321.99.101.148.183.1343705202.squirrel@lavabit.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/q2WnfXzMY73ojdjPNGUIRBx"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/q2WnfXzMY73ojdjPNGUIRBx
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 30 Jul 2012 23:26:42 -0400 (EDT)
serialhex@lavabit.com wrote:

> 1) is there a tool to help me recover data from my fs? I don't have a
> backup of my partition table and so I have about 500GB of space where a
> few partitionns might reside... GPT partitions mind you

If you only lost the partition table, there's a tool (strangely)named
TestDisk, which can find the actual partitions on disk and restore it.
Don't know if it supports GPT and BTRFS, though.

--=20
With respect,
Roman

~~~~~~~~~~~~~~~~~~~~~~~~~~~
"Stallman had a printer,
with code he could not see.
So he began to tinker,
and set the software free."

--Sig_/q2WnfXzMY73ojdjPNGUIRBx
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlAXbf8ACgkQTLKSvz+PZwi8AACffna78iZJpqghUitrxnSeYxrx
AOwAn3fWX1pa9XkiXTbngMym6eXfnyTA
=lsy7
-----END PGP SIGNATURE-----

--Sig_/q2WnfXzMY73ojdjPNGUIRBx--
