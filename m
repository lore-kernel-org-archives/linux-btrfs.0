Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-1.hut.fi ([130.233.228.91]:41284 "EHLO smtp-1.hut.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752066Ab2GBXJG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 2 Jul 2012 19:09:06 -0400
Received: from localhost (katosiko.hut.fi [130.233.228.115])
	by smtp-1.hut.fi (8.13.6/8.12.10) with ESMTP id q62N93YQ032042
	for <linux-btrfs@vger.kernel.org>; Tue, 3 Jul 2012 02:09:03 +0300
Received: from smtp-1.hut.fi ([130.233.228.91])
 by localhost (katosiko.hut.fi [130.233.228.115]) (amavisd-new, port 10024)
 with LMTP id 31773-1051 for <linux-btrfs@vger.kernel.org>;
 Tue,  3 Jul 2012 02:09:03 +0300 (EEST)
Received: from kosh.localdomain (kosh.hut.fi [130.233.228.12])
	by smtp-1.hut.fi (8.13.6/8.12.10) with ESMTP id q62N8q2D032040
	for <linux-btrfs@vger.kernel.org>; Tue, 3 Jul 2012 02:08:52 +0300
Date: Tue, 3 Jul 2012 02:08:52 +0300
From: Sami Liedes <sami.liedes@iki.fi>
To: linux-btrfs@vger.kernel.org
Subject: Re: btrfs GPF in read_extent_buffer() while scrubbing with kernel
 3.4.2
Message-ID: <20120702230851.GE12755@sli.dy.fi>
References: <20120702230121.GD12755@sli.dy.fi>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="vOmOzSkFvhd7u8Ms"
In-Reply-To: <20120702230121.GD12755@sli.dy.fi>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--vOmOzSkFvhd7u8Ms
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jul 03, 2012 at 02:01:21AM +0300, Sami Liedes wrote:
> The oops is transcribed from photos, so it may contain some errors. I
> tried to be careful, and double checked the backtrace.

Forgot to menion, the fs is a two-partition filesystem, with both data
and metadata mirrored.

------------------------------------------------------------
Label: none  uuid: f26f08b1-89e6-4f2d-b7f9-857010dd2517
        Total devices 2 FS bytes used 778.31GB
        devid    2 size 1.07TB used 1.05TB path /dev/dm-6
        devid    1 size 1.07TB used 1.05TB path /dev/dm-5
------------------------------------------------------------

	Sami

--vOmOzSkFvhd7u8Ms
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCgAGBQJP8ioDAAoJEKLT589SE0a03/YQAIibLL6jyUiTjRgp5Etg6L4H
fDhobl5rgKlHw30kXeF2tnyruYLWKXLzPl70GiYcjvplHRULSImSL5EAeJzUFk/3
fNsZLnqQJibXG8B6syOw7kciNWRG59PgaBtjmU/zyE9wC0eM4huGLffocZ55tcBD
4oU7LQMILRlO3TC0wnHYMsaJuHN2chuvwrzMbm+iqzBQPx6Vl3nquBiRDFhb6n0H
Lfwdy2Qcf7/Wn9UuCaq7Mn0Mtzz5mlM9AvpUQKy9lQsRpYKDKI2HF/UslaYZidyA
Cv0ar+wGSYbp0UXYif3Xvk0I0VtZ26m5KMdllWH/OedFWeRkEPwYMMIjVIC2Rzig
sB+RJGSnsEChU04SSxIA/By30nEfjvjLxQL2dJ41LXEXyqyNhyul/BTXuOtLgySl
LvFWVF/zCS1gIFQcxom3O2wqaki7SzBgiyjNbfc/u9I8g3dj8TgK41XZ0qFIDie0
hM5GNHQ2oGsn4ckuIVWuwQKZm0MTEP6YaxcYD/Evmzd7riYkNpwZBsjILVUYnaJn
6VFhjb1b4lxQbt1qPbbzZ3Od/9gf10OE40+NTEUQaidCJOcJsczwFhtJw2rk+gwA
ig7toEq7qIT28pGbqcQXPWdtXbXVSBmzckukikXo6i0KrrmPYGVTrIWAhvbGfp+e
C+/3v2Gg6Sx9IlePT0Ap
=MxpV
-----END PGP SIGNATURE-----

--vOmOzSkFvhd7u8Ms--
