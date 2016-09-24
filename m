Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from len.romanrm.net ([195.154.117.182]:46566 "EHLO len.romanrm.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754918AbcIXMkS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 24 Sep 2016 08:40:18 -0400
Date: Sat, 24 Sep 2016 17:40:12 +0500
From: Roman Mamedov <rm@romanrm.net>
To: Alexander Tomokhov <alexoundos@ya.ru>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Does data checksumming remain for files with No_COW file
 attribute?
Message-ID: <20160924174012.51d44caa@natsu>
In-Reply-To: <767591474719974@web21o.yandex.ru>
References: <767591474719974@web21o.yandex.ru>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/IJt7Q5ZrWRjOOMC_WycJ/QN"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/IJt7Q5ZrWRjOOMC_WycJ/QN
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 24 Sep 2016 15:26:14 +0300
Alexander Tomokhov <alexoundos@ya.ru> wrote:

> does setting No_COW on a file (chattr +C) imply disabling data checksummi=
ng on it?

Yes. IIRC the reasoning was that it's more difficult to track checksums of
data which is being overwritten in-place (as opposed to CoW).

> may it disable checksumming only for newly written extents and keep for r=
eading existing ones?

You can't apply chattr +C to any files of non-zero length, so by definition
there won't be any pre-existing checksummed extents in that file.

--=20
With respect,
Roman

--Sig_/IJt7Q5ZrWRjOOMC_WycJ/QN
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEARECAAYFAlfmdC4ACgkQTLKSvz+PZwjbBwCfd9EbRCcgQYDYkcxL1XmbN7/+
CTEAoI+AWTJGiC1Hf7v3BadtpDnkFWLD
=DrZQ
-----END PGP SIGNATURE-----

--Sig_/IJt7Q5ZrWRjOOMC_WycJ/QN--
