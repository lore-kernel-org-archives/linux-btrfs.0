Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:46903 "EHLO
	james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751391AbaJXPSJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 24 Oct 2014 11:18:09 -0400
Date: Fri, 24 Oct 2014 11:18:07 -0400
From: Zygo Blaxell <zblaxell@furryterror.org>
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: device balance times
Message-ID: <20141024151807.GF17395@hungrycats.org>
References: <845c0ca8cc78ed97da487bf7f4b7b122@admin.virtall.com>
 <5446BEC0.8070009@siedziba.pl>
 <02A17DFE-290C-4447-99E9-D39480D7A26A@colorremedies.com>
 <5447A5CF.9060405@siedziba.pl>
 <5448C81E.4060701@cn.fujitsu.com>
 <5448E8F0.7070004@gmail.com>
 <pan$d3176$38668d14$9f498698$7cd4113f@cox.net>
 <20141024023529.GD17395@hungrycats.org>
 <pan$e118d$d880428d$ebc41b4b$dabf1c21@cox.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7cm2iqirTL37Ot+N"
In-Reply-To: <pan$e118d$d880428d$ebc41b4b$dabf1c21@cox.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--7cm2iqirTL37Ot+N
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 24, 2014 at 05:13:27AM +0000, Duncan wrote:
> Zygo Blaxell posted on Thu, 23 Oct 2014 22:35:29 -0400 as excerpted:
>=20
> > My pet peeve:  if balance is converting profiles from RAID1 to single,
> > the conversion should be *instantaneous* (or at least small_constant *
> > number_of_block_groups).  Pick one mirror, keep all the chunks on that
> > mirror, delete all the corresponding chunks on the other mirror.
>=20
> That would argue for either a third balance mode, --convert-only, or a=20
> different tool, avoiding a rewrite of existing chunks entirely, simply=20
> replicating them if adding redundancy or deleting a copy if reducing it,=
=20
> as necessary.

Isn't that what soft does?  [reading noises]  OK, maybe not.
'soft' leaves a chunk alone if it already fits all the target profile
requirements; however, in this case the profile (and only the profile,
no data) is changing.

I think just two modes are sufficient:  one that does everything the most
thorough way (throw scrub and defrag in there too, so we can do a single
pass over the filesystem that does all the maintenance tasks at once),
and one that takes advantage of every special-case shortcut available
to achieve specific goals in the shortest time.

I also think it's a little odd that conversion and balance are the
same tool.  Traditional RAID conversions don't care about filesystem
layout, because they work on a completely separate layer (i.e. at the
block level).  It's certainly possible to perform a RAID conversion
by reallocating all the filesystem-level objects, but just because
you can doesn't mean you should.  ;)


--7cm2iqirTL37Ot+N
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlRKba8ACgkQgfmLGlazG5wXYACdE4FDu37x1mxTu2AHwDzlyavW
FMkAnRho0nnYIxygti0qgBQe+M7gmhPL
=W5Jt
-----END PGP SIGNATURE-----

--7cm2iqirTL37Ot+N--
