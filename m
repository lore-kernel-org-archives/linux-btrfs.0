Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from len.romanrm.net ([91.229.20.24]:39658 "EHLO len.romanrm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751693AbaANThH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 Jan 2014 14:37:07 -0500
Date: Wed, 15 Jan 2014 01:37:03 +0600
From: Roman Mamedov <rm@romanrm.net>
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: How does btrfs handle bad blocks in raid1?
Message-ID: <20140115013703.33bb2799@natsu>
In-Reply-To: <486C0640-409D-4636-858C-84A679C0AF4E@colorremedies.com>
References: <201401100106.s0A16CNd016476@atl4mhib27.myregisteredsite.com>
	<52CF4D5D.2010709@chinilu.com>
	<486C0640-409D-4636-858C-84A679C0AF4E@colorremedies.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/P6F/Wb.BPaJsOPLiL7pt.oQ"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/P6F/Wb.BPaJsOPLiL7pt.oQ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 14 Jan 2014 12:13:09 -0700
Chris Murphy <lists@colorremedies.com> wrote:

>=20
> On Jan 9, 2014, at 6:31 PM, George Mitchell <george@chinilu.com> wrote:
> >>=20
> > Jim, my point was that IF the drive does not successfully resolve the b=
ad block issue and btrfs takes a write failure every time it attempts to ov=
erwrite the bad data, it is not going to remap that data, but rather it is =
going to fail the drive.
>=20
> If the drive doesn't resolve a bad block on write, then the drive is toas=
t.

I vaguely remember having some drives that were not able to remap a single
block on write, but doing that successfully if I overwrote a sizable area
around (and including) that block, or overwrite the whole drive. And after
that they worked without issue not exhibiting further bad blocks.

Or for example consider the 4k sector drives. If even any portion of the
physical 4k sector is corrupt, some of the eight 512 virtual blocks will be
unreadable; but the thing is, writing to ANY of them individually will fail,
because the drive's internal r-m-w will fail to obtain all the pieces of the
4k sector from disk to overwrite it.

So in my opinion one (and perhaps one of the easier) things to consider her=
e,
would be to try being "generous" in recovery-overwrite, say, rewrite a
whole 1MB-sized region centered at the unreadable sector.

--=20
With respect,
Roman

--Sig_/P6F/Wb.BPaJsOPLiL7pt.oQ
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlLVkd8ACgkQTLKSvz+PZwgSmQCeMLQhIxJySaLQUQ0Elya8qRJW
NXwAn3CXk/wW1X4JF3kiMmPJMPlQLkcv
=68R9
-----END PGP SIGNATURE-----

--Sig_/P6F/Wb.BPaJsOPLiL7pt.oQ--
