Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tulsa-1.icequake.net ([65.38.17.15]:48666 "EHLO
	mail.icequake.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751374Ab2FDSUG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Jun 2012 14:20:06 -0400
Date: Mon, 4 Jun 2012 13:15:47 -0500
From: "Ryan C. Underwood" <nemesis-lists@icequake.net>
To: Stefan Behrens <sbehrens@giantdisaster.de>
Cc: Maxim Mikheev <mikhmv@gmail.com>, linux-btrfs@vger.kernel.org
Subject: Re: Help with recover data
Message-ID: <20120604181547.GJ25227@localhost.localdomain>
Reply-To: nemesis@icequake.net
References: <4FC54A5D.8000600@gmail.com>
 <4FCCA8E3.7080209@giantdisaster.de>
 <4FCCA983.50400@gmail.com>
 <4FCCB20A.7010300@giantdisaster.de>
 <4FCCC176.1020007@gmail.com>
 <4FCCCE02.3010506@giantdisaster.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ed/6oDxOLijJh8b0"
In-Reply-To: <4FCCCE02.3010506@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--ed/6oDxOLijJh8b0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 04, 2012 at 05:02:26PM +0200, Stefan Behrens wrote:
>=20
> According to the kern.1.log file that you have sent (which is not
> visible on the mailing list because it exceeded the 100,000 chars limit
> of vger.kernel.org), a rebalance operation was active when the disks or
> the RAID controller started to cause IO errors.
>=20
> There seems to be a bug! Like that a write failure is ignored in btrfs.
> For instance, the result of barrier_all_devices() is ignored. Afterwards
> the superblocks are written referencing trees which have not been
> completely written to disk.

This may be also what happened when my hardware RAID blew up.  I was
left with two completely inconsistent/unusable btrfs which I am still
attempting to recover.

Assuming that the general mount options to remount read-only on errors
are correctly handled by btrfs, that would seem to be the wise thing
to do.  IMO it seems a volume which experiences a metadata write error
to the underlying medium should be made immediately read-only anyway.

--=20
Ryan C. Underwood, <nemesis@icequake.net>

--ed/6oDxOLijJh8b0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFPzPtTIonHnh+67jkRAm9GAJ9TtLaJx7lHzNjCON4dnxUdJ7QdmwCff2Rn
fKsJT6qL1BfL36RvjVUPGlk=
=oY/R
-----END PGP SIGNATURE-----

--ed/6oDxOLijJh8b0--
