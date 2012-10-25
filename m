Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:60111 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752803Ab2JYN22 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 25 Oct 2012 09:28:28 -0400
Date: Thu, 25 Oct 2012 14:28:25 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: Richard Hughes <hughsient@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Naming of subvolumes
Message-ID: <20121025132825.GD25498@carfax.org.uk>
References: <1351168220.1923.6.camel@hughsie-work.lan>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UhXv5VeBZ/Y8lRnC"
In-Reply-To: <1351168220.1923.6.camel@hughsie-work.lan>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--UhXv5VeBZ/Y8lRnC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Oct 25, 2012 at 01:30:20PM +0100, Richard Hughes wrote:
> I'm planning to use "btrfs subvolume snapshot -r <name>" in the system
> upgrade functionality[1] if the user is using btrfs for their root file
> system. We've got most of the bits in place already for Fedora 18.
> 
> One think that confuses me is the convention for the naming of
> snapshots. Is there any conventions or prior art there? Can I add
> metadata to the snapshot so that I don't have encode everything in the
> snapshot name itself?

   How about user xattrs? IIRC, that's the user.* namespace.

   The only convention I'm aware of is Ubuntu's use of an @
substitution, where the subvolume to be mounted at / is called @, and
the subvolume to be mounted at /home becomes @home. Both of those
subvolumes are stored in the (otherwise empty) top-level of the
filesystem, which is not mounted in normal operation.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
      --- This chap Anon is writing some perfectly lovely stuff ---      
                             at the moment.                              

--UhXv5VeBZ/Y8lRnC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUBUIk+eb9z9OVl50rAAQLf0g//dTnGORTuZYGCalQaXlmJqtMR8+kD/3vo
yUgfutLi+DMzMyxSjc3jacSJxKlrHyApiOQE6c20/+41TEK/s3kY6PafD7uNOhGu
7ceHuO9/HZzKnRZQEIX1n/HZAT56z02/WRCuU2BQpRux4hNucXpMaQyxF+vUuu0o
AcfRMS7wMEErhWVZnLctjab/sVg4lwVHl7MZHlZIP+rZA+0HF12wMfilneXCjiwD
TaZOyk3ZDr+W1lp4KDedG0YXoRhj6kotdjz04Q6XMspfYr/c9oglYWtbM83nnWY7
KQr53f3bE0fPA+HCEV/cIuPu/Ej4cV+Wtnh2UAQ9h/jqaes0mTX8SwWq3q8nTRLE
z5IpzOeTpm0prYg14cILr5MKjdkKvrJY9MK1AQg6L3ZRBsjNeJ+VCG5I/Qb0S8F0
Zv2f5DioDjMyNC9WiP3wVu8XaZRy134oCqLuIQrIHJcaZRqFRfdg5teGUft2y3Jt
w+sH+CIuoPYSh5H1N+wKHOFjnh7M6bP7DMtNJwZjlDKULRvS+5i/Onbj+pTvWivf
EH7FqDkfA0SpgB+VRBXBfFNAUH/Cpzy6DCmUr4eVBvo5k5jskCrtfdpyO1bmrlLN
0b+A6lXfGWMpaBORZQa9m8GiWi9KRW6LJJhNy8gLm8uYy+SriihjEAJ2hxgDoGwY
XrXqWn/wlQw=
=DfFc
-----END PGP SIGNATURE-----

--UhXv5VeBZ/Y8lRnC--
