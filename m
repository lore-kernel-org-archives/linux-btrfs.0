Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from len.romanrm.net ([176.31.121.172]:33657 "EHLO len.romanrm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751600Ab3ALLGt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 12 Jan 2013 06:06:49 -0500
Date: Sat, 12 Jan 2013 17:06:45 +0600
From: Roman Mamedov <rm@romanrm.ru>
To: Hugo Mills <hugo@carfax.org.uk>
Cc: Rick Liu <rickliu@broadcom.com>,
        Joshua =?UTF-8?B?U2Now7xsZXI=?= <joshua.schueler@gmail.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: how to resize (grow) device partition of a multi-device BTRFS
 filesystem?
Message-ID: <20130112170645.3214f437@natsu>
In-Reply-To: <20130112022848.GX19051@carfax.org.uk>
References: <7D0754FFADBD2D4785C1D233C497C47B1BCD81D0@SJEXCHMB06.corp.ad.broadcom.com>
	<20130112022848.GX19051@carfax.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/EfT00rj=/gjklb2PYr/Q6v6"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/EfT00rj=/gjklb2PYr/Q6v6
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 12 Jan 2013 02:28:49 +0000
Hugo Mills <hugo@carfax.org.uk> wrote:

> As long as the start of the partition isn't changed, deleting and
> resizing in fdisk isn't damaging. It's just... slightly disconcerting.
> :)

For that reason I very much prefer the cfdisk implementation from the
gnu-fdisk package. It has an option to really resize the partition. While
resizing the filesystem within it will usually fail, the dialog goes like t=
his:

Select the patition, click "Resize".

"Failed to resize filesystem, change partition size (EXPERT)?" - "Yes"

"Start location? [Fixed start], [Specify different]?" - "Fixed start"

"Partition size? [Max is nnnnMB]" - "nnnnMB".

Done.

--=20
With respect,
Roman

~~~~~~~~~~~~~~~~~~~~~~~~~~~
"Stallman had a printer,
with code he could not see.
So he began to tinker,
and set the software free."

--Sig_/EfT00rj=/gjklb2PYr/Q6v6
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlDxQ8UACgkQTLKSvz+PZwisfgCfb4KlxcOOkAQSztyImNzhPbCr
FbAAn0YQeK5DSRK6YJIT2fg/QJEq7v5J
=h4ii
-----END PGP SIGNATURE-----

--Sig_/EfT00rj=/gjklb2PYr/Q6v6--
