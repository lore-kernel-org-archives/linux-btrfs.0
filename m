Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:60656 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752427Ab3ALBuZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 11 Jan 2013 20:50:25 -0500
Date: Sat, 12 Jan 2013 01:50:21 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Rick Liu <rickliu@broadcom.com>
Cc: Joshua =?iso-8859-1?Q?Sch=FCler?= <joshua.schueler@gmail.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: how to resize (grow) device partition of a multi-device BTRFS
 filesystem?
Message-ID: <20130112015021.GW19051@carfax.org.uk>
References: <7D0754FFADBD2D4785C1D233C497C47B1BCD8161@SJEXCHMB06.corp.ad.broadcom.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Vs1U1/ga4WSC1iHQ"
In-Reply-To: <7D0754FFADBD2D4785C1D233C497C47B1BCD8161@SJEXCHMB06.corp.ad.broadcom.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--Vs1U1/ga4WSC1iHQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Jan 12, 2013 at 12:29:47AM +0000, Rick Liu wrote:
> > 
> > Hi Rick,
> > 
> > use
> > btrfs fi resize <devid>:max
> > to make btrfs use all space of disk <devid>
> > 
> [Rick Liu] 
> Hi,
> 
> I tried, but it seems no effect.
> (dev/sdc was 300GB and now is 500GB, )
> After resize,
> /dev/sdc1 is still 300GB.

   You'll need to use something like fdisk or cfdisk to resize the
partition first. With (c)fdisk, that involves deleting and recreating
the partition with the same starting point. (fdisk gives you more
control here). As with most low-level FS-resizing tools, btrfs fi
resize doesn't attempt to change the size of the underlying device.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
       --- Great oxymorons of the world, no. 6: Mature Student ---       

--Vs1U1/ga4WSC1iHQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUBUPDBXb9z9OVl50rAAQLJJw/8Dp5HNEcz1VhuQG0yoghWqgeRPBN0GTmV
ClrA60bg/FGNANO99wGVg20iISZ3rbJiNr0axprYrizgWxCGGOp0OpW0crqauXXF
JjxtaCwC81epRhMiqTfhh9C26op64l8g/UGDbe/E7uxa8gkPH3/NXcemVAG/U6zq
QnXa8rr29uNPWqn2inw6i/L6PUR1iSVsSJCkRtDW2weNokQTouu/7sUv6r18z88U
Gd7DNx4Rksc5v6EGcnUSAsfal4OXI5IN8ejJt6fwWaw6q4vKrTpRSzeP0J2U1K5s
aH7k/Q5qLru99yFviVXwQH7RhqvogZHDPHUl9NSJJTygv51b9y04oq4hOndVsfo9
oV087G6C4bO3eMDpBr0mt5NNogRKVWIYAFUgFK5MqotArj2uqkqPh5IewGK7fLRt
bKg5zCzun9svCvr1HHiQaparJQA7qMbKkWA82YtxIcwb9ZGMbFYn+Ge33PT9NbQP
/d7SBcKctDOnZVZ5cg78f0eq1m+zFkbLKOOEZKgJmqi4S7Nlo9DroSKz7LZamCVV
0/56nY6xioJTTbl4yy0qrtBUS//rd77V3Nz1RJm38nbfzHk6MXn6K4EXI3IlCb+y
/dkjdutYvmL7LjbPRQxe1y7EiBuM/ia19hhhhGyhZPdGx1spFiBCNS+qAx5t04Iz
JvdNXIBJ5tU=
=cBPT
-----END PGP SIGNATURE-----

--Vs1U1/ga4WSC1iHQ--
