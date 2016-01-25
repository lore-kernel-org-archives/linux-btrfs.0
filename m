Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from meiko.romanrm.net ([195.154.92.155]:51447 "EHLO
	meiko.romanrm.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932224AbcAYPxZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Jan 2016 10:53:25 -0500
Date: Mon, 25 Jan 2016 20:53:21 +0500
From: Roman Mamedov <rm@romanrm.net>
To: Roman Mamedov <rm@romanrm.net>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Reproduced deadlock after upgrade from 3.18 to 4.1 or 4.3 (+
 more info)
Message-ID: <20160125205321.51b002ba@natsu>
In-Reply-To: <20160110053119.45e05246@natsu>
References: <20151226070004.461eebaf@natsu>
 <CAJCQCtRTNgUFnjGyF6wBeiX2LzMjO8Avc8xGb9NAFLnvgGyM3Q@mail.gmail.com>
 <20160110053119.45e05246@natsu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/fl21Zl5sylCdyi7hN+Oydr1"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/fl21Zl5sylCdyi7hN+Oydr1
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 10 Jan 2016 05:31:19 +0500
Roman Mamedov <rm@romanrm.net> wrote:

> After this case I went back to 3.18.25, and the system worked fine for ab=
out 2
> weeks more. However now I decided to try upgrading again, this time to 4.=
3.3 -
> and hit the deadlock on the very first attempt to use the same script.

For the record, this does not happen after upgrade to 4.4.0.

It seems only 4.1 and 4.3 series are affected.

--=20
With respect,
Roman

--Sig_/fl21Zl5sylCdyi7hN+Oydr1
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlamRPEACgkQTLKSvz+PZwgQ0wCfSRbTHjnY4qjtj0lEdljQRM5u
iVQAoJdCpKaTEPoafAU1fW8SS+fd8Yqy
=pU1Y
-----END PGP SIGNATURE-----

--Sig_/fl21Zl5sylCdyi7hN+Oydr1--
