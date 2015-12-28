Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from meiko.romanrm.net ([195.154.92.155]:51025 "EHLO
	meiko.romanrm.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750975AbbL1J3q (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 28 Dec 2015 04:29:46 -0500
Date: Mon, 28 Dec 2015 14:29:43 +0500
From: Roman Mamedov <rm@romanrm.net>
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: https://btrfs.wiki.kernel.org having OCSP issues?
Message-ID: <20151228142943.3ea78db6@natsu>
In-Reply-To: <pan$d5d71$dbb2da33$97fb9c4d$f6fd4df8@cox.net>
References: <pan$d5d71$dbb2da33$97fb9c4d$f6fd4df8@cox.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/HgqigSxRC/tlJczAgHTbWUp"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/HgqigSxRC/tlJczAgHTbWUp
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 28 Dec 2015 09:20:09 +0000 (UTC)
Duncan <1i5t5.duncan@cox.net> wrote:

> Firefox is currently giving me OCSP errors for the wiki.  Links has no=20
> problem, presumably because it doesn't validate the cert or ignores OCSP=
=20
> timeouts, but lynx is throwing errors as well, so it's not just firefox.

Do you get the same problem with https://www.kernel.org/ ?

Or any other wiki listed at https://wiki.kernel.org/ ?

Can you download http://crl.startssl.com/crt2-crl.crl at your machine?

In general this seems to be a kernel.org webmasters concern, not for Btrfs
developers to do anything about.

--=20
With respect,
Roman

--Sig_/HgqigSxRC/tlJczAgHTbWUp
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlaBAQcACgkQTLKSvz+PZwioUQCgjMRvD7LafCKTVQDYpZibhfmD
VGkAniPz3hHZvSsFw6d63j43Pk57m9sg
=TW5f
-----END PGP SIGNATURE-----

--Sig_/HgqigSxRC/tlJczAgHTbWUp--
