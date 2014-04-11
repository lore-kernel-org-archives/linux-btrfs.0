Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mari.romanrm.net ([157.7.203.202]:60469 "EHLO mari.romanrm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754354AbaDKTVo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 11 Apr 2014 15:21:44 -0400
Date: Sat, 12 Apr 2014 01:15:36 +0600
From: Roman Mamedov <rm@romanrm.net>
To: Marc MERLIN <marc@merlins.org>
Cc: Chris Samuel <chris@csamuel.org>, Martin <m_btrfs@ml1.co.uk>,
        linux-btrfs@vger.kernel.org
Subject: Re: How to debug very very slow file delete? (btrfs on md-raid5)
Message-ID: <20140412011536.5805a0a5@natsu>
In-Reply-To: <20140411172346.GK7322@merlins.org>
References: <20140325164142.GN12833@merlins.org>
	<2708828.vpfalmJ0Wi@quad>
	<20140411172346.GK7322@merlins.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/iG3L1c7ntMcIWSHVzB030Ag"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/iG3L1c7ntMcIWSHVzB030Ag
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 11 Apr 2014 10:23:46 -0700
Marc MERLIN <marc@merlins.org> wrote:

> Is anyone else using btrfs on top of dmcrypt and software raid 5?

I use Btrfs accessed via NBD over a LAN, physically stored on mdadm RAID5, a
setup which is similar to yours in that the block device used for Btrfs has=
 a
somewhat limited throughput. But there were no problems with this whatsoever
for the past couple of years (other than caused by unrelated h/w issues).

> gargamel:/mnt/dshelf2/backup/polgara# time rm -rf current.todel/
> real    1087m26.491s
> user    0m2.448s
> sys     4m42.012s

You could check if this slowness is caused by excessive fsync'ing, try runn=
ing
"time eatmydata rm -rf ....." next time. ( https://launchpad.net/libeatmyda=
ta )

--=20
With respect,
Roman

--Sig_/iG3L1c7ntMcIWSHVzB030Ag
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlNIP1gACgkQTLKSvz+PZwiDPACeMSUa30vN4VTzJkaIaV9DuqmR
Eg0An0hnqggZSOYjctNzyAbvTANUcFHs
=2sLj
-----END PGP SIGNATURE-----

--Sig_/iG3L1c7ntMcIWSHVzB030Ag--
