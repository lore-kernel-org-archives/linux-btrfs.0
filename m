Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:44638 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752824AbbDANEc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 1 Apr 2015 09:04:32 -0400
Date: Wed, 1 Apr 2015 13:04:31 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: "Wang, Zhiye" <Zhiye.Wang@arcserve.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: How to avoid certain file being defragmented?
Message-ID: <20150401130431.GC32078@carfax.org.uk>
References: <6ba9e4a537f64758b41f356d0b2dd387@uslims211.ca.com>
 <f8e2691656584a619920a36fdd47ffbf@uslims211.ca.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bAmEntskrkuBymla"
In-Reply-To: <f8e2691656584a619920a36fdd47ffbf@uslims211.ca.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--bAmEntskrkuBymla
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 01, 2015 at 12:42:04PM +0000, Wang, Zhiye wrote:
> Hello,

> I have some files which I hope their on-disk data can be on fixed
> location of disk. My understanding is that defragmentation operation
> can potentially move data blocks of a file.

> So, can I avoid certain file being defragmented in btrfs?=A0

   Simple: Don't defragment it.

   Also, set the file to nodatacow if you're planning on writing to it
at any point; don't take snapshots or reflink copies of it if that's
the case. Finally, don't ever run a balance on the FS.

   Alternatively, have a hard think about why you want to bypass the
filesystem, because it's probably a fairly bad idea. Even most
bootloaders these days put the data they can't move in the 64k before
the FS starts, and then have enough code to read the FS through its
normal data structures.

   If you need some kind of raw(ish) block interface, using a file and
a loopback device may be more useful.

   Hugo.

--=20
Hugo Mills             | I get nervous when I see words like 'mayhaps' in a
hugo@... carfax.org.uk | novel, because I fear that just round the corner is
http://carfax.org.uk/  | lurking 'forsooth'
PGP: 65E74AC0          |                                      GRRM's UK edi=
tor

--bAmEntskrkuBymla
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJVG+zfAAoJEFheFHXiqx3kuL0P/RrcPZst+q8usp6xY85ZBB3t
B3cztD3EzkVds502+mRUvNsTxJKZ6+sys4inO+z0PmIgt3DCV3mfhYTQ92o9Xe/z
WLBmeUd111qievcqNL7P5q+EgygrpKyVGHFL5BJXcLG9SbIDK0MuB/oyca+s0ar3
8WShwkgxg40ZZnUlRlt9RMBiQGoS9XOy9dRmUaSZyDJAKFT62DJ8ZSR1EA80CiFU
CMZkKYbW4NZMv7Y56LPAaHCSgM70Kfkw6OQ2+zLe4zQtd6d5EEfSpabNxXz/ifCJ
LkDBb0mp79HEs+k+QzGCRekBJTNg8VVomaURE6TSRi2Xb9+UKcGu6Atu44UGXxK2
JvMRO5GOKvDIc/0G1r7s8w2L4WAw2hjs6DcDSkMaRoHJrWUMWOUwqYXbaoiaMz62
fDbxneDqgzfzApo5/NXD7tgackBUowLe4oo95GYxnKP3OFF+kYIt6dEIhWSwzKTD
oR8obRJHe7iWXr/03/VCNmAxakyDkaj9uHtnvIFgREu1ms5rRZqEYR9NIf2gr5qq
AWpR/w1UWOObxHLkfNtJNVuzDAGdDCgMakkYTtvmhXBRid4dLElDR78OjivyDduc
Ca3gfdIYR3vuh09BROzI8dh8TNjwYSGhDLeSCuaHUXlICsj7hFOe6ACYP+JTkKv8
qOOUgPks16NqAqrPufGc
=pOp5
-----END PGP SIGNATURE-----

--bAmEntskrkuBymla--
