Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:52905 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752451Ab3KXOSh (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 24 Nov 2013 09:18:37 -0500
Date: Sun, 24 Nov 2013 14:18:35 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Hans-Kristian Bakke <hkbakke@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: The state of btrfs RAID6 as of kernel 3.13-rc1
Message-ID: <20131124141835.GF28883@carfax.org.uk>
References: <CAD_cGvHFg11+RhqYDcu=zcUWpRAi85WqW7Wm5K040J_+h_mcGw@mail.gmail.com>
 <20131124135032.GE28883@carfax.org.uk>
 <CAD_cGvEXj2cLjzifw1WHc3dPBqnr-F32B=T4h2y0qn+bbYY04A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="TU+u6i6jrDPzmlWF"
In-Reply-To: <CAD_cGvEXj2cLjzifw1WHc3dPBqnr-F32B=T4h2y0qn+bbYY04A@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--TU+u6i6jrDPzmlWF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Nov 24, 2013 at 03:13:44PM +0100, Hans-Kristian Bakke wrote:
> Thank you.
> 
> Are the missing RAID5/6 standard features beeing worked on at the
> moment or could it just as well take several years until the basic
> features are in place and working?

   They're being worked on by Chris. He's been largely silent about
timescales and progress, though.

   Hugo.

> Mvh
> 
> Hans-Kristian Bakke
> 
> 
> On 24 November 2013 14:50, Hugo Mills <hugo@carfax.org.uk> wrote:
> > On Sun, Nov 24, 2013 at 02:47:56PM +0100, Hans-Kristian Bakke wrote:
> >> Hi
> >>
> >> What is the general state of btrfs RAID6 as of kernel 3.13-rc1 and the
> >> latest btrfs tools?
> >>
> >> More specifically:
> >> - Is it able to correct errors during scrubs?
> >
> >    Not yet, I believe.
> >
> >> - Is it able to transparently handle disk failures without downtime?
> >
> >    Not yet.
> >
> >> - Is it possible to convert btrfs RAID10 to RAID6 without recreating the fs?
> >
> >    Yes.
> >
> >> - Is it possible to add/remove drives to a RAID6 array?
> >
> >    Yes.
> >
> >    HTH,
> >    Hugo.
> >
> >> Regards,
> >>
> >> Hans-Kristian
> >

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
    --- We demand rigidly defined areas of doubt and uncertainty! ---    

--TU+u6i6jrDPzmlWF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIVAwUBUpIKu1heFHXiqx3kAQJs3g/8CZhGvFszArWgoNB1dOtpmecmDTpU66aF
Lzn+qY45Xb4Zva/9eOeYXngu7WX30Ku7qp6fV4BTBMRyU+tRjmwP9XkeQhg3UVNH
hx9FrKeJzLIuL90t/XD6JOMYmo370/8sw1yJi9WfyntRlXj9dFUDsBUllpHmc5dS
+GRblxACFFHH77v6JBP2TA3r+Qf3hwUwrToZO+egZ7ag3dPuhPprRUO6ezRiLIsv
bnTXcaAIWExP4Ojyv/c4E8/9Rp6zfGq8o7lFp8Q1m3k/ATidqHUOJMDi08SWS6W1
5CJIPQnqtQ2k/O4ITvRNpwompRlU0f1BTabeAsBljKg+sx8E/SbiUCkPIcI11iUC
MxrUkSxzZRsR95xaHTaB6EjIB7tDxPffTEMw1TzSQ5cEvkJoncJujg13vL8BuQWR
kGMd+FfFaTRnxFgvxbg1sTonZK3uJmHV23cRIiRHVf9KrnkuHNl7P7M/bfV79ob5
HQpLHFgtLIiqPr4V48wdg9tFZKzeaSoU14BNpc6uS96uxIbziaNPk5yhp9P5z5n5
5xREbcFHEdDuByy05G0v/YlJXX23WwguGlw6S6swCNSn0gAuvH5ESwIRsgk319DU
0yqkRu/+Hj6KpxrUz67kDydgPzB5QbAYBIiafThBliDFkNRh4pn9AqPfdOfQxIVt
7aluT961/Es=
=6Nr9
-----END PGP SIGNATURE-----

--TU+u6i6jrDPzmlWF--
