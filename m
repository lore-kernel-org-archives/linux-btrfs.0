Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mari.romanrm.net ([157.7.203.202]:37139 "EHLO mari.romanrm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756797AbaFSK47 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 19 Jun 2014 06:56:59 -0400
Date: Thu, 19 Jun 2014 16:56:52 +0600
From: Roman Mamedov <rm@romanrm.net>
To: Zack Coffey <clickwir@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Made a RAID1, now Fail to recover the chunk tree.
Message-ID: <20140619165652.52208886@natsu>
In-Reply-To: <CAA8KC9+qMhSw9dLPZDpr=RtkodCTgh8c31Uj20mSUegCum_LwA@mail.gmail.com>
References: <CAA8KC9+qMhSw9dLPZDpr=RtkodCTgh8c31Uj20mSUegCum_LwA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/TvPH3us.qaM.ZhihOCsKvus"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/TvPH3us.qaM.ZhihOCsKvus
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 19 Jun 2014 06:47:27 -0400
Zack Coffey <clickwir@gmail.com> wrote:

> I tried to create a simple RAID1 for metadata and somehow lost access
> to everything on the drive. The RAID1 for just metadata created just
> fine, everything was fine for a day, so I turned off the drive that
> was just holding the RAID1 of the metadata

Can you quote which exact commands you used to set up "RAID1 for metadata"?

I feel you may have some misunderstanding about how Btrfs is supposed to wo=
rk
in this aspect and what it was doing in your setup.

E.g. if you added a new drive and then rebalanced metadata to RAID1 profile,
that still means Btrfs was going to use the new drive for new allocations
of data extents too, not just metadata.

--=20
With respect,
Roman

--Sig_/TvPH3us.qaM.ZhihOCsKvus
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlOiwfQACgkQTLKSvz+PZwjFTgCcCj95/zsQwaVCmaZsBOox2GVK
f3wAniojlRmY3gkQPTH0549W/Q+8acL1
=wKXr
-----END PGP SIGNATURE-----

--Sig_/TvPH3us.qaM.ZhihOCsKvus--
