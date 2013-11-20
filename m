Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:34675 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753953Ab3KTQwt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 Nov 2013 11:52:49 -0500
Date: Wed, 20 Nov 2013 16:52:47 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Actual effect of mkfs.btrfs -m raid10 </dev/sdX> ... -d raid10
 </dev/sdX> ...
Message-ID: <20131120165247.GB28883@carfax.org.uk>
References: <CAEWPe=pwpxdYUDk7BzfjR8h-Jq9wtQE+gxxQChjOZzsXJO4vHQ@mail.gmail.com>
 <20131119090602.GV4315@carfax.org.uk>
 <pan$cd41e$ced598aa$e5d2ed3a$3c71af6f@cox.net>
 <20131120080958.GA28883@carfax.org.uk>
 <pan$448fc$ee29c6cf$df5ffdae$4f88c4b5@cox.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="JP+T4n/bALQSJXh8"
In-Reply-To: <pan$448fc$ee29c6cf$df5ffdae$4f88c4b5@cox.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--JP+T4n/bALQSJXh8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Nov 20, 2013 at 04:43:57PM +0000, Duncan wrote:
> Hugo Mills posted on Wed, 20 Nov 2013 08:09:58 +0000 as excerpted:
> 
> > RAID-0:  min 2 devices
> > RAID-10: min 4 devices
> > RAID-5:  min 2 devices (I think)
> > RAID-6:  min 3 devices (I think)
> 
> RAID-5 should be 3-device minimum (each stripe consisting of two data 
> segments and one parity segment, each on a different device).

   You can successfully run RAID-5 on two devices: one data device(*),
plus its parity. The parity check of a single piece of data is that
data, so it's equivalent to RAID-1 in that configuration. IIRC, the
MD-RAID code allows this; I can't remember if the btrfs RAID code does
or not, but it probably should do if it doesn't.

> And RAID-6 similarly four devices (two data and two parity).

   Similarly for RAID-6: it's a single data device(*), plus an
XOR-based parity (effectively a mirror), plus a more complex parity
calculation.

> Perhaps it's time I get that wiki account and edit some of this stuff 
> myself...

   Do check the assumptions first. :)

   Hugo.

(*) Yeah, OK, rotate the data/parity position as you move through the
stripes because it's not RAID-4.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
  --- In my day, we didn't have fancy high numbers.  We had "nowt", ---  
                    "one",  "twain" and "multitudes".                    

--JP+T4n/bALQSJXh8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIVAwUBUozo31heFHXiqx3kAQJHvw/8DAK6nq108o5Y6DmbMevW2piEqqDWfXsN
6HDuEgbhmzgHgO+/w6vzZGROQa7uq/UQrl+HhoTbq4bAuEgwmEsjqOE5KbzrTYCj
rkqDQtkbmDmailsCxIX7NfSAB6Lk9G0yPW8eWE3fvw/KFiRy3yNuC/igS4hKFD0y
uum3w1RTDIqqSkEI1+MosIFYIlb0AXbHNITC/bSVIVjcttx1/SRXNBVpszokVUdg
oaKEgb7EmzD0M3npV8XU1ThOxgCoVxu/EkSkVJ54kaAZ0TcqekEB87yBjq/Rnlsh
5VXuoEYWBh2AUkuAzeO7EFZsTXVQtwXkdrA3jx5KaRdNqxgFF2o8gp5W7AXPK6a5
QI9LIAL4txfM/XbIxkK/FkjTNrgwZJrejO7lblbzdH6mtFgjQkAo/IszAmCBbNGW
wh4USWwAOuiOQmLppvEdXYjXhJrsOZNbHxLBjWojJOtXsmoMwc5enwYbYTr7AG38
AUEn2mqhCq683jzOwQGBSpD7o+RDx2oCRnJqxNPfYkF2g46IP3rjvdx/CUwXz8OM
SGcWaYNIVIwXgrzMRA+FJdcLFlOf7EVHHkFWs5ygztTaDjUHBBn3HPJNNC29WTcN
WHKXNLORz+q5ILG6c8OnH6F3+58IBGs2j7gg8LTY4vbeSXMDlVx5ZRH91pljeKuV
Rom/ddE9RnQ=
=gOys
-----END PGP SIGNATURE-----

--JP+T4n/bALQSJXh8--
