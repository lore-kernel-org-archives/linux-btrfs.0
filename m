Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from asuka.romanrm.net ([128.199.93.76]:55813 "EHLO
	asuka.romanrm.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751809AbbCUS3d (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 21 Mar 2015 14:29:33 -0400
Date: Sat, 21 Mar 2015 23:22:25 +0500
From: Roman Mamedov <rm@romanrm.net>
To: Petr Bena <benapetr@gmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: New tool to recursive compress / decompress of files
Message-ID: <20150321232225.5f7e997e@natsu>
In-Reply-To: <CA+4EQ5cL53dS5k8fPNauT1fPGaYXjKBSzo7jTt1nz5p=w+c_SQ@mail.gmail.com>
References: <CA+4EQ5cL53dS5k8fPNauT1fPGaYXjKBSzo7jTt1nz5p=w+c_SQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/Gl_9S./jVG70u2.BjN6WE2l"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/Gl_9S./jVG70u2.BjN6WE2l
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 21 Mar 2015 18:56:12 +0100
Petr Bena <benapetr@gmail.com> wrote:

> unlike NTFS, compressing files in btrfs is not so simple

There shouldn't be any need to micro-manage compression on Btrfs on a
per-folder or per-file basis. Just mount the whole volume as compress=3D[me=
thod]
(but not compress-force), there shouldn't be any downside, on the contrary,
with the current ratio of CPU core count and their performance to disk I/O
speed, you are likely to even see a speed-up. Also files which are detected=
 to
be incompressible are automatically skipped from compression (at least that=
's
what it tries to do by design).

If you want higher performance and less fragmentation on certain files/fold=
ers,
you are supposed to set them NOCOW, at which point the compression is also
automatically disabled.

--=20
With respect,
Roman

--Sig_/Gl_9S./jVG70u2.BjN6WE2l
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlUNtuEACgkQTLKSvz+PZwjQigCfRmIN8+r8+rR+B2bW5El/cDNg
qzsAn3m3wuDY+OtJRBGBR520Qplb2QNu
=12uX
-----END PGP SIGNATURE-----

--Sig_/Gl_9S./jVG70u2.BjN6WE2l--
