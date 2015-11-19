Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from meiko.romanrm.net ([195.154.92.155]:42982 "EHLO
	meiko.romanrm.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750908AbbKSF6e (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 19 Nov 2015 00:58:34 -0500
Date: Thu, 19 Nov 2015 10:58:30 +0500
From: Roman Mamedov <rm@romanrm.net>
To: linux-btrfs.tebulin@xoxy.net
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Kernel 3.19 and still "disk full" even though 'btrfs fi df"
 reports enough room left?
Message-ID: <20151119105830.48b57273@natsu>
In-Reply-To: <564CC90F.3060703@gmail.com>
References: <564CC90F.3060703@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/pfpES.sIAO6VwFzu=h_r5+z"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/pfpES.sIAO6VwFzu=h_r5+z
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 18 Nov 2015 19:53:03 +0100
linux-btrfs.tebulin@xoxy.net wrote:

>   $ uname -a
>   Linux neptun 3.19.0-31-generic #36~14.04.1-Ubuntu SMP Thu Oct 8
> 10:21:08 UTC 2015 x86_64 x86_64 x86_64 GNU/Linux

For whatever unknown reason, Ubuntu repeatedly chooses to stabilize on exac=
tly
the wrong kernel versions. Their recent releases were based on kernels 3.11,
3.13 and 3.19. None of these were chosen by the upstream as the "longterm"
branches, and as you can see none are listed anymore on https://www.kernel.=
org/

To emphasize -- the mainline Linux kernel developers (and Btrfs developers)
basically do not care anymore about 3.19 at all. What you currently use, is=
 a
piecemeal of unknown quality, cobbled together by Ubuntu developers from
patches lifted either from 3.18 or 4.1 series -- by taking fixes they deem
important and frankensteining them together until they somehow seem to appl=
y.

And do they back/forward-port Btrfs-related bugfixes?... all of them?... are
they doing that well enough? Just nobody knows.

So my suggestion would be to try a newer kernel from www.kernel.org: if the
problem disappears at 4.1 then just keep on using that, or 4.3 if you have =
to,
but otherwise that one might be a bit too new to start using right away.

--=20
With respect,
Roman

--Sig_/pfpES.sIAO6VwFzu=h_r5+z
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlZNZQYACgkQTLKSvz+PZwh30QCgj4Cx+AKTsoKqRReRlc0Y7JQ+
idAAmwarcoG9J+BKBmJKxEejkQ4ffoyt
=6WJq
-----END PGP SIGNATURE-----

--Sig_/pfpES.sIAO6VwFzu=h_r5+z--
