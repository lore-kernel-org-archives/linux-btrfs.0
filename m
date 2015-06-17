Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:60610 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755537AbbFQTlM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 17 Jun 2015 15:41:12 -0400
Received: from thetick ([93.181.44.4]) by mail.gmx.com (mrgmx102) with ESMTPSA
 (Nemesis) id 0MJFBe-1Z83Ia2iE6-002leg for <linux-btrfs@vger.kernel.org>; Wed,
 17 Jun 2015 21:41:10 +0200
Date: Wed, 17 Jun 2015 21:41:00 +0200
From: Marc Joliet <marcec@gmx.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: btrfs partition converted from ext4 becomes read-only minutes
 after booting: WARNING: CPU: 2 PID: 2777 at ../fs/btrfs/super.c:260
 __btrfs_abort_transaction+0x4b/0x120
Message-ID: <20150617214100.467a0cd7@thetick>
In-Reply-To: <20150617174630.GM16468@merlins.org>
References: <CAC8ULPYHuqsZN1Lm_2TxGMw7z6n=4zAprqYr9uoi=3kjoiSxQw@mail.gmail.com>
	<20150617174630.GM16468@merlins.org>
Reply-To: linux-btrfs@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/pu.8JGI8C6AC8izauQ.B3Pf"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/pu.8JGI8C6AC8izauQ.B3Pf
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Am Wed, 17 Jun 2015 10:46:30 -0700
schrieb Marc MERLIN <marc@merlins.org>:

> I tried ext4 to btrfs once a year ago and it severely mangled my
> filesystem.
> I looked at it as a cool feature/hack that may have worked some time ago,=
 but
> that no one really uses anymore, and that may not work right at this
> point.

Just another data point: when I switched to btrfs in the middle of last yea=
r I
used btrfs-convert on two file systems (an SSD and my backup partition on a
USB 3.0 HDD), and it worked in both cases (i.e., no data loss). I did see s=
ome
strange balance issues (see the ML archives), but IIRC nothing really serio=
us.

--=20
Marc Joliet
--
"People who think they know everything really annoy those of us who know we
don't" - Bjarne Stroustrup

--Sig_/pu.8JGI8C6AC8izauQ.B3Pf
Content-Type: application/pgp-signature
Content-Description: Digitale Signatur von OpenPGP

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJVgc1UAAoJEL/Q5oYsiHj0OBsQAI9UIL9F/KB6WyeBaHPfq4LU
9lhPmsofBZ6JkHN7LO+21h5UmaMHhPKEuCYcYeZbzyhLsfna7x1BEctIZs22sD3T
AwNzeFRSpp5772RndWU9pSjXrzMUY7w41lHWS2DhR4p7NWrQu4Y+DWdw/lFk+yR3
dyb8OUwt/tbegWT1NAr1N+BeqDHMAQ5k3EgzRoGssvUi3uG8Nwq2u7sqtJD9ZHad
Cg2wN7oIVarqnMgXh/PIq2pyaxdD1HS+D9f91CdU+zqn6leoZu9niE+StMXyMIj+
LqBfRewBehJ7mDtj+fTIkbEPLo+YQmRQ56QrZb/Rh2ib0v2RhgSaCcKBMdkgJ5xV
iK0u9E2ohptHlIxruiwHHMkad2RrAMXonY58D25tBrfZ+wyfcPr+FPbktcVgvDj8
zz2cZFsCpRPGxE23JzKL4KWboHftHyWoAMN4fiSm/cLi1LdvIa5qVarQhs/CpqlI
dAnAzjW010KsZ/oZpta2jQINuaR2HAlBRNXsJpFzKUnOBS5V0fIvTkEC2NclI2fs
0gmBmoqecPqvLxX4flZQ2Q7xZx2tV5pG4O17d/Xn87KNYfjCdrDSMKvd1ed215Up
H3sze/SsYq8QhfB8xKgKXiZaQNWgNsaxVpuOOqmoPsL07NFQvlH49Y4a7KCcccec
ToPICIS1juS4UftK1a3J
=+Ch/
-----END PGP SIGNATURE-----

--Sig_/pu.8JGI8C6AC8izauQ.B3Pf--
