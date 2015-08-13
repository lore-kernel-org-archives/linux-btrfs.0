Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:37520 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753957AbbHMWyK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 13 Aug 2015 18:54:10 -0400
Date: Thu, 13 Aug 2015 22:54:06 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Gareth Pye <gareth@cerberos.id.au>
Cc: Austin S Hemmelgarn <ahferroin7@gmail.com>,
        Ulli Horlacher <framstag@rus.uni-stuttgart.de>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: RAID0 wrong (raw) device?
Message-ID: <20150813225406.GQ12976@carfax.org.uk>
References: <20150812130758.GA26529@rus.uni-stuttgart.de>
 <55CC830D.2070304@gmail.com>
 <CA+WRLO9ZbjZyNnMM951xrkE5OqymO3E8gMeebOpkX1a4qCS+6g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FhxWStFQ84VXWhXs"
In-Reply-To: <CA+WRLO9ZbjZyNnMM951xrkE5OqymO3E8gMeebOpkX1a4qCS+6g@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--FhxWStFQ84VXWhXs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Aug 14, 2015 at 08:32:46AM +1000, Gareth Pye wrote:
> On Thu, Aug 13, 2015 at 9:44 PM, Austin S Hemmelgarn
> <ahferroin7@gmail.com> wrote:
> > 3. See the warnings about doing block level copies and LVM snapshots of
> > BTRFS volumes, the same applies to using it on DRBD currently as well (with
> > the possible exception of remote DRBD nodes (ie, ones without a local copy
> > of the backing store) (in this case, we need to blacklist backing devices
> > for stacked storage (I think the same issue may be present with BTRFS on a
> > MD based RAID1 set).
> 
> 
> I've been using BTRFS on top of DRBD for several years now, what
> specifically am I meant to avoid?
> 
> I have 6 drives mirrored across a local network, this is done with DRBD.
> At any one time only a single server has the 6 drives mounted with btrfs.
> Is this a ticking time bomb?

   There are two things which are potentially worrisome here:

 - Having the same filesystem mounted on more than one machine at a
   time (which you're not doing).

 - Having one or more of the DRBD backing store devices present on the
   same machine that the DRBD filesystem is mounted on (which you may
   be doing).

   Of these, the first is definitely going to be dangerous. The second
may or may not be, depending on how well DRBD copes with direct writes
to its backing store, and how lucky you are about the kernel
identifying the right devices to use for the FS.

   Hugo.

-- 
Hugo Mills             | "Big data" doesn't just mean increasing the font
hugo@... carfax.org.uk | size.
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--FhxWStFQ84VXWhXs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJVzSANAAoJEFheFHXiqx3k2DMP/3g7avCECNlMVzIGj/+ehhgd
ulJrzT3CPBLaT2vdw+FKKZqwZj04vT4yusctPsLX8JEh7HjbDmtjBWpJUDs3LItA
5uzj0Vb5YScJTRSlYYOvXKYCpWSvKAi5z6+pgk2eTwifDsD9NH3VH5/iRrxEUtmR
wjoDNzP/35fGYGMGdMnJn0191Ky3Sd+CBYy2TG2lzKM57MSGctySz44xUF69ll+2
vL+FYGFLJ2h6m9w9Mogo5i8g8H+o4o5vo1usr7UcRe6pEvYlhFkZqHCoBkJJU26F
0JiBrlOKpGy9jmEOJE4vcqe4+XhH2wH8mpzWVe/sdETzKx4gFcyL9Bi4TkJqcVtz
icKd++8OTy4jdSwLU3eXRiy4MNiACTljQBGzSElznUG5PzyuDQGDPXxve+8YA7ER
BK5QMQ7ZNBTDoeAoNM9bL8mHR50rdAdJFvcgChm8e6Z/wZqSKQdOsqRGxiWbHLYj
k/tnxndByEUqoCO0x3J//zxpZCPvWSXc0j/PV0MDC+h8CxBnf9S8BVUXq1oAE3Vo
sX1ncvdvP2Ym3fH7yrpMbX0o+/w9G9U/fW6+ogtX35+5a1v4nuJvJ59hrJ36veKN
tehca49xYkVJfZk/TxURs4MMQYtTsW8RmiSDD1D0MuuTsooP2i0E6T63Dthmopc0
QtsC9eZmIkQDEK94IvaN
=t22j
-----END PGP SIGNATURE-----

--FhxWStFQ84VXWhXs--
