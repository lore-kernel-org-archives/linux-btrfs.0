Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from len.romanrm.net ([195.154.117.182]:38278 "EHLO len.romanrm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932398AbcHIN4M (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 9 Aug 2016 09:56:12 -0400
Date: Tue, 9 Aug 2016 18:56:05 +0500
From: Roman Mamedov <rm@romanrm.net>
To: Noah Massey <noah.massey@gmail.com>
Cc: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>, Thomas <c.monty@web.de>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Issue: errno:28 (No space left on device)
Message-ID: <20160809185605.3fc06903@natsu>
In-Reply-To: <CADfjVrgzMNrsfv=S9+zPBZEcvkfiP=fg-Pi8gB+W1gYaJTxcRA@mail.gmail.com>
References: <e4671ca6-38bc-ce32-0bc9-c1e7bc9873cd@web.de>
	<1b31f650-6c29-7b46-eafb-0434a26f15d6@gmail.com>
	<CADfjVrgzMNrsfv=S9+zPBZEcvkfiP=fg-Pi8gB+W1gYaJTxcRA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/LG6cLEq4sqUtSPCvEnVsQ_t"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/LG6cLEq4sqUtSPCvEnVsQ_t
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 9 Aug 2016 09:39:45 -0400
Noah Massey <noah.massey@gmail.com> wrote:

> Since your data and metadata profiles are both 'single', you may want
> to consider creating the filesystem with the --mixed option, which
> allows / forces BTRFS to use a single collection of data blocks for
> both data and metadata.

That also seems to be detrimental to performance, I had servers with mixed
profile FSes which went painfully slow after a couple of years (daily snaps=
hot
creation and deletion, ~30-60 snapshots kept at all times), migrated them a=
ll
now to the regular split profile. Fresh off mkfs they are fast of course, so
not entirely certain "mixed" was the culprit, will see.

One more problem with mixed is that you can't use the leaf and nodesize of =
16k,
which are accepted to be faster than the older default (and mixed's only
option) of 4k.

--=20
With respect,
Roman

--Sig_/LG6cLEq4sqUtSPCvEnVsQ_t
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEARECAAYFAlep4PcACgkQTLKSvz+PZwgN3gCeLyhFEjAqh32073LyM0uHtozE
GIsAn2PWHJT1I5oWej1i+/2Tw0YF/A+i
=fmH6
-----END PGP SIGNATURE-----

--Sig_/LG6cLEq4sqUtSPCvEnVsQ_t--
