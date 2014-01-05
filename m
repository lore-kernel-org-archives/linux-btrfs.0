Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from csamuel.org ([74.50.50.137]:46052 "EHLO csamuel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750831AbaAEJUj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 5 Jan 2014 04:20:39 -0500
From: Chris Samuel <chris@csamuel.org>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Cc: Chris Mason <clm@fb.com>
Subject: Re: btrfs raid1 and btrfs raid10 arrays NOT REDUNDANT
Date: Sun, 05 Jan 2014 20:20:26 +1100
Message-ID: <2354723.OENPHvUuC6@quad>
In-Reply-To: <1388847436.23513.26.camel@ret.masoncoding.com>
References: <52C73987.7000106@jrs-s.net> <1422900.iO9oO96QZb@quad> <1388847436.23513.26.camel@ret.masoncoding.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart3202624.fjaAQ2ofvO"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--nextPart3202624.fjaAQ2ofvO
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="us-ascii"

On Sat, 4 Jan 2014 02:56:39 PM Chris Mason wrote:

> Seconded +ADs-)  We're really focused on nailing down these problems =
instead
> of hiding behind the experimental flag.  I know we won't be perfect
> overnight, but it's time to focus on production workloads.

Perhaps an option here is to remove the need to specify the degraded fl=
ag but=20
if the filesystem notice that it is mounting a RAID array and would oth=
erwise=20
fail it then sets the degraded flag itself and carries on?

That way the fact it was degraded would be visible in /proc/mounts and =
could=20
be detected with health check scripts like NRPE for icinga/nagios.

Looking at the code this would be in read_one_dev() in fs/btrfs/volumes=
.c ?

All the best,
Chris
=2D-=20
 Chris Samuel  :  http://www.csamuel.org/  :  Melbourne, VIC

This email may come with a PGP signature as a file. Do not panic.
For more info see: http://en.wikipedia.org/wiki/OpenPGP

--nextPart3202624.fjaAQ2ofvO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQEVAwUAUskj2o1yjaOTJg85AQJ2zwf/fTdetOAlf2g2Q2R8ZkdV6sCgKn5YWfpz
DiaA6zJtJwb+WB6xv2cyVV8xcfFMu4FH1+mEnANTc+1p2qOPFoJ8IuLIbVxN22UI
Ry6mq/ygW2zDbkYRTL9oddF6Xwukh8Khr7aqNOKfGF06Ej4V7i96V+/rMUPIGmGG
c8SZPwZKnWzSz6WaWGuApiWDz2h2D/1n0mtwt5IKQAgOE4/ai0A198Zb8XoSFL/4
cE8Mwce/Qpp4wUA4RcsfLPLYDSSOTjzdtR1vv32V+3P9W1Yn1elrpheQlLVNY+Yi
ObpdBNxlL2egPUHPtTeCUHw6yREqrzC8rRy4vElWo/TTfaQJW+9CsA==
=TeHv
-----END PGP SIGNATURE-----

--nextPart3202624.fjaAQ2ofvO--

