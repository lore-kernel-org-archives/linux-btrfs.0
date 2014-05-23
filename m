Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mari.romanrm.net ([157.7.203.202]:39082 "EHLO mari.romanrm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751427AbaEWM6G (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 23 May 2014 08:58:06 -0400
Date: Fri, 23 May 2014 18:57:53 +0600
From: Roman Mamedov <rm@romanrm.net>
To: Austin S Hemmelgarn <ahferroin7@gmail.com>
Cc: Tomasz Chmielewski <tch@virtall.com>,
        Calvin Walton <calvin.walton@kepstin.ca>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: RAID-1 - suboptimal write performance?
Message-ID: <20140523185753.65c96c16@natsu>
In-Reply-To: <537684F9.6060909@gmail.com>
References: <20140516164815.1c33149b@s9>
	<1400263584.979.17.camel@sasami.ottawa.blindsidenetworks.com>
	<20140516214135.23fefc39@s9>
	<537684F9.6060909@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/_bBUS6E.Kj/+qS9UBMtHw5E"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/_bBUS6E.Kj/+qS9UBMtHw5E
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 16 May 2014 17:36:57 -0400
Austin S Hemmelgarn <ahferroin7@gmail.com> wrote:

> > It's similar (writes to just one drive, while the other is idle) when
> > removing (many) snapshots.=20
> >=20
> > Not sure if that's optimal behaviour.
> >=20
> I think, after having looked at some of the code, that I know what is
> causing this (although my interpretation of the code may be completely
> off target).  As far as I can make out, BTRFS only dispatches writes to
> one device at a time

Yes, I can confirm this... yesterday I was writing large files to my Btrfs
RAID1 of two devices, and remembering this thread, decided to take a look at
how the writes are performed. And indeed in 'iostat' it was clear that only
one device works at a time. In my case, first one drive was writing at 80-1=
00
MB/sec for 5-10 seconds, then activity on that once ceased entirely, and the
second drive started writing for the same period at similar speeds.

In effect this is causing the whole operation take about 2x longer than ide=
al
(or in case of just a single device Btrfs). Surprising that this performance
drawback of Btrfs RAID1 is not more widely known or discussed.

--=20
With respect,
Roman

--Sig_/_bBUS6E.Kj/+qS9UBMtHw5E
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlN/RdEACgkQTLKSvz+PZwgG3wCgmHfHlNkzg2LMKMi7QVXq05r/
QGUAn3wOQ4QoZ95/xmEUfZLq6vNNlfAs
=R4aB
-----END PGP SIGNATURE-----

--Sig_/_bBUS6E.Kj/+qS9UBMtHw5E--
