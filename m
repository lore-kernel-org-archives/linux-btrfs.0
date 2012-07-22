Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from len.romanrm.ru ([176.31.121.172]:53173 "EHLO len.romanrm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751654Ab2GVPhT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 22 Jul 2012 11:37:19 -0400
Date: Sun, 22 Jul 2012 21:37:14 +0600
From: Roman Mamedov <rm@romanrm.ru>
To: =?UTF-8?B?U3fDom1p?= Petaramesh <swami@petaramesh.org>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Change "small" filesystem to normal
Message-ID: <20120722213714.2b5be0e1@natsu>
In-Reply-To: <500C16F0.6000205@petaramesh.org>
References: <500C16F0.6000205@petaramesh.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/BlUNSGihpM=tO8x=+TxmHcs"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/BlUNSGihpM=tO8x=+TxmHcs
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Sun, 22 Jul 2012 17:06:24 +0200
Sw=C3=A2mi Petaramesh <swami@petaramesh.org> wrote:

> Hi,
>=20
> I've created a "small" BTRFS filesystem, where metadata+data are mixed
> (and metadata are not DUP'ed).
>=20
> Then I've enlarged the FS to 1 GB ; now I'd like to make it "normal"
> with separate data and metadata, and "DUP'ed" metadata.

Considering the metadata overallocation bug [1] is still not fixed even in =
the
latest kernels and no one seems to care all that much, I would not recommend
doing that.

Personally I now use a "mixed" filesystem on a 1TB disk without any problem=
s,
and do not think there's anything wrong with "mixed". In fact there's been
some talk of moving to the mixed mode allocation to be used by default, and
maybe even removing support for the "split" mode: see [2].

[1] http://comments.gmane.org/gmane.comp.file-systems.btrfs/17848

[2] http://kerneltrap.org/mailarchive/linux-btrfs/2010/10/29/6885925


--=20
With respect,
Roman

~~~~~~~~~~~~~~~~~~~~~~~~~~~
"Stallman had a printer,
with code he could not see.
So he began to tinker,
and set the software free."

--Sig_/BlUNSGihpM=tO8x=+TxmHcs
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlAMHisACgkQTLKSvz+PZwiTRwCeNA0tUu9fduF5Djyc+82ySAXw
XAgAn2LuMehGcpJoat1YvqTrYyqKveHt
=3pxB
-----END PGP SIGNATURE-----

--Sig_/BlUNSGihpM=tO8x=+TxmHcs--
