Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from asuka.romanrm.net ([128.199.93.76]:57054 "EHLO
	asuka.romanrm.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751915AbbCXXD3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 24 Mar 2015 19:03:29 -0400
Date: Wed, 25 Mar 2015 04:03:21 +0500
From: Roman Mamedov <rm@romanrm.net>
To: "Kline, Matthew" <matthew.kline@flukenetworks.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs balance fails with no space errors (despite having
 plenty)
Message-ID: <20150325040321.361abf2f@natsu>
In-Reply-To: <E8C63C11EA3FB04DBDFEDECEFD927FD1140C1E31@US-EVT-EXM04-P.global.tektronix.net>
References: <E8C63C11EA3FB04DBDFEDECEFD927FD1140C1E31@US-EVT-EXM04-P.global.tektronix.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/fEvRgWl_i==94LXclN8MgKs"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/fEvRgWl_i==94LXclN8MgKs
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 24 Mar 2015 22:25:30 +0000
"Kline, Matthew" <matthew.kline@flukenetworks.com> wrote:

> Sorry to necrobump this, but the issue came up again.
> I'm now on Linux 3.19.2 with btrfs-progs 3.19, and I converted my work la=
ptop
> from ext4 to btrfs. Same issue - the conversion goes well,
> removing the ext* subvolume is fine, defragging is works,
> and then when I balance, it claims there is no space left on the device
> when the drive is 35% full. Dmesg is useless once again,
> giving only "1 enospc errors during balance".
>=20
> The last time this was an issue (the original post in this thread),
> I ended up just copying everything to an external drive,
> reformatting the btrfs partition, and copying things back.
>=20
> This time I did what was suggested below (moving all +1GB files off-drive
> to tmpfs and then back on) in case defrag missed something, and balance
> still fails. I was sure to rename the files and sync as suggested.
>=20
> Is there a known bug still lurking in ext4 conversion?

Post your "btrfs fi df" for the filesystem.

In my experience it looks like the conversion may designate large
portions of data as "metadata" for whatever reason.

A way to clean this up is to run

  btrfs fi balance start -musage=3D5 -dusage=3D5 /path

try repeating this again and again increasing the value gradually from 5 to
50-70 in steps of 5 or 10.

--=20
With respect,
Roman

--Sig_/fEvRgWl_i==94LXclN8MgKs
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlUR7TkACgkQTLKSvz+PZwhUVQCglchqH4uwMoWimTTrQOqeD/ta
7UMAnRe31HeLZgYjDPeCrCltgKvrFduF
=DiFe
-----END PGP SIGNATURE-----

--Sig_/fEvRgWl_i==94LXclN8MgKs--
