Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from luka.romanrm.net ([213.163.64.74]:36350 "EHLO luka.romanrm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752422AbaBYSBI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Feb 2014 13:01:08 -0500
Date: Wed, 26 Feb 2014 00:01:05 +0600
From: Roman Mamedov <rm@romanrm.net>
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: VM nocow, should VM software set +C by default?
Message-ID: <20140226000105.44b842e2@natsu>
In-Reply-To: <4C05BCCD-ED77-4D8D-B9C7-47CB6D1B4ACC@colorremedies.com>
References: <A2EE3F12-97D9-46CD-8360-ACCFF71F149B@colorremedies.com>
	<530C5F65.6020607@internetionals.nl>
	<4C05BCCD-ED77-4D8D-B9C7-47CB6D1B4ACC@colorremedies.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/Pf=ycr+AyHwKXxyQOb+0Obw"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/Pf=ycr+AyHwKXxyQOb+0Obw
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 25 Feb 2014 10:44:36 -0700
Chris Murphy <lists@colorremedies.com> wrote:

> the VM managing application needs to set +C on image files

It's a slippery slope, why not instigate that every program from now on has
to set +C on its user files? Or where do we stop, probably the browser shou=
ld
also set +C on its user profile and cache files? How about the mail client =
for
the mail index? The torrent program on all temporary downloads?.. MySQL and
Postgres on all their databases?...

Insisting that every program now has to include a workaround for a
filesystem-specific gimmick does not seem to be a nice design decision
long-term.

--=20
With respect,
Roman

--Sig_/Pf=ycr+AyHwKXxyQOb+0Obw
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlMM2mEACgkQTLKSvz+PZwhLXACffQP1vLeh94WxKgtVMcB1U9EM
G+4An2keIptxZ7ulXowrcKF/W97f/LU0
=bekQ
-----END PGP SIGNATURE-----

--Sig_/Pf=ycr+AyHwKXxyQOb+0Obw--
