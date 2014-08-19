Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from len.romanrm.net ([5.39.87.147]:34929 "EHLO len.romanrm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750880AbaHSVul (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 19 Aug 2014 17:50:41 -0400
Date: Wed, 20 Aug 2014 03:50:38 +0600
From: Roman Mamedov <rm@romanrm.net>
To: M G Berberich <btrfs@oss.m-berberich.de>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Questions on using BtrFS for fileserver
Message-ID: <20140820035038.40d09071@natsu>
In-Reply-To: <20140819162151.GA15166@forwiss.uni-passau.de>
References: <20140819162151.GA15166@forwiss.uni-passau.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/cW6mYx1jHgd0V1/kM2Uys1q"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/cW6mYx1jHgd0V1/kM2Uys1q
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Tue, 19 Aug 2014 18:21:52 +0200
M G Berberich <btrfs@oss.m-berberich.de> wrote:

> =C2=B7 BtrFS with RAID1 is fairly stable.

Maybe, but it's not optimized for performance: reads are not balanced in the
most optimal way, and writes may end up being submitted sequentially rather
than in parallel to two devices, resulting in write performance that's way
less than that of a single device.

> =C2=B7 RAID 5/6 spreads all data over all devices, leading to performance
>   problems on large diskarrays, and there is no option to limit the
>   numbers of disk per stripe so far.

AFAIK Btrfs RAID 5/6 is not yet ready to be used in a production environmen=
t;

In your case I would recommend considering Btrfs on top of two 12-disk mdadm
RAID6 arrays, or three 8-disk ones, leaving one HDD as a shared hot spare.

To join the mdadm arrays into a larger block device you can use either LVM,=
 or
Btrfs itself, with the "single" profile for data.

--=20
With respect,
Roman

--Sig_/cW6mYx1jHgd0V1/kM2Uys1q
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlPzxq4ACgkQTLKSvz+PZwgcTACfWc4xyYyi+lNk5uheG1u5g1dm
oxkAnRDhNKw0Yx1VARfJv+R4sPqs5+TC
=IWMs
-----END PGP SIGNATURE-----

--Sig_/cW6mYx1jHgd0V1/kM2Uys1q--
