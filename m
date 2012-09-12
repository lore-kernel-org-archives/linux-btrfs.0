Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from len.romanrm.net ([176.31.121.172]:59228 "EHLO len.romanrm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751901Ab2ILVXN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 12 Sep 2012 17:23:13 -0400
Received: from natsu (unknown [IPv6:fd14:8086:1337:1:1e6f:65ff:fea1:3ea6])
	by len.romanrm.net (Postfix) with ESMTPS id 20F642038F
	for <linux-btrfs@vger.kernel.org>; Wed, 12 Sep 2012 21:23:12 +0000 (UTC)
Date: Thu, 13 Sep 2012 03:23:10 +0600
From: Roman Mamedov <rm@romanrm.ru>
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Deadlock in btrfs-cleaner, related to snapshot deletion
Message-ID: <20120913032310.75088ea9@natsu>
In-Reply-To: <505059E4.1080903@oracle.com>
References: <20120912135315.32d670c2@natsu>
 <505059E4.1080903@oracle.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/py=2Ej9qs=8d1GdhNSruqnY"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/py=2Ej9qs=8d1GdhNSruqnY
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 12 Sep 2012 17:46:12 +0800
Liu Bo <bo.li.liu@oracle.com> wrote:

> I try to figure out where goes wrong, but the listed stacks seems to be n=
ot enough for solving the deadlock,
> so could you please use a lockdep debug kernel and post the result here?=
=20

Hello,

Thanks; I have saved the problematic FS into an image file, and will try to=
 run
some experiments with it in a VM a bit later. Also I will have to read up on
how to properly use lockdep to get debug information.

--=20
With respect,
Roman

~~~~~~~~~~~~~~~~~~~~~~~~~~~
"Stallman had a printer,
with code he could not see.
So he began to tinker,
and set the software free."

--Sig_/py=2Ej9qs=8d1GdhNSruqnY
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlBQ/T4ACgkQTLKSvz+PZwgiMgCfb9q2o4bqNs4J4MtcQbgoVGFi
xTwAn0LNQy/jHCNNfWIx7HNhS/giF5Fs
=7f3H
-----END PGP SIGNATURE-----

--Sig_/py=2Ej9qs=8d1GdhNSruqnY--
