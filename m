Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:47275 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751864AbcC1SvF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 28 Mar 2016 14:51:05 -0400
Date: Mon, 28 Mar 2016 18:51:02 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Marc Haber <mh+linux-btrfs@zugschlus.de>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: "bad metadata" not fixed by btrfs repair
Message-ID: <20160328185102.GM29474@carfax.org.uk>
References: <20160328143714.GZ10135@torres.zugschlus.de>
 <20160328184237.GA10135@torres.zugschlus.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GeONROBiaq1zPAtT"
In-Reply-To: <20160328184237.GA10135@torres.zugschlus.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--GeONROBiaq1zPAtT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Mar 28, 2016 at 08:42:37PM +0200, Marc Haber wrote:
> On Mon, Mar 28, 2016 at 04:37:14PM +0200, Marc Haber wrote:
> > I have a btrfs which btrfs check --repair doesn't fix:
> > 
> > # btrfs check --repair /dev/mapper/fanbtr
> > bad metadata [4425377054720, 4425377071104) crossing stripe boundary
> > bad metadata [4425380134912, 4425380151296) crossing stripe boundary
> > bad metadata [4427532795904, 4427532812288) crossing stripe boundary
> > bad metadata [4568321753088, 4568321769472) crossing stripe boundary
> > bad metadata [4568489656320, 4568489672704) crossing stripe boundary
> > bad metadata [4571474493440, 4571474509824) crossing stripe boundary
> > bad metadata [4571946811392, 4571946827776) crossing stripe boundary
> > bad metadata [4572782919680, 4572782936064) crossing stripe boundary
> > bad metadata [4573086351360, 4573086367744) crossing stripe boundary
> > bad metadata [4574221041664, 4574221058048) crossing stripe boundary
> > bad metadata [4574373412864, 4574373429248) crossing stripe boundary
> > bad metadata [4574958649344, 4574958665728) crossing stripe boundary
> > bad metadata [4575996018688, 4575996035072) crossing stripe boundary
> > bad metadata [4580376772608, 4580376788992) crossing stripe boundary
> > repaired damaged extent references
> > Fixed 0 roots.
> > checking free space cache
> > checking fs roots
> > checking csums
> > checking root refs
> > enabling repair mode
> > Checking filesystem on /dev/mapper/fanbtr
> > UUID: 90f8d728-6bae-4fca-8cda-b368ba2c008e
> > cache and super generation don't match, space cache will be invalidated
> > found 97171628230 bytes used err is 0
> > total csum bytes: 91734220
> > total tree bytes: 3021848576
> > total fs tree bytes: 2762784768
> > total extent tree bytes: 148570112
> > btree space waste bytes: 545440822
> > file data blocks allocated: 308328280064
> >  referenced 177314340864
> 
> Mounting this filesystem gives:
> Mar 28 20:25:18 fan kernel: [   20.979673] BTRFS error (device dm-16): could not find root 8
> Mar 28 20:25:18 fan kernel: [   20.979739] BTRFS error (device dm-16): could not find root 8
> Mar 28 20:25:18 fan kernel: [   20.980900] BTRFS error (device dm-16): could not find root 8
> Mar 28 20:25:18 fan kernel: [   20.980948] BTRFS error (device dm-16): could not find root 8
> Mar 28 20:25:18 fan kernel: [   20.981428] BTRFS error (device dm-16): could not find root 8
> Mar 28 20:25:18 fan kernel: [   20.981472] BTRFS error (device dm-16): could not find root 8
> 
> which is not detected by btrfs check.
> 
> What is going on here?

   "Could not find root 8" is harmless (and will be going away as a
message soon). It just means that systemd is probing the FS for
quotas, and you don't have quotas enabled.

   Hugo.

-- 
Hugo Mills             | Hey, Virtual Memory! Now I can have a *really big*
hugo@... carfax.org.uk | ramdisk!
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--GeONROBiaq1zPAtT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJW+X0WAAoJEFheFHXiqx3kvJUP/0+LCqclWVZxUSRYV6bfCn4q
xsyXh8VZX/WNGymKeGrtqukAWtpKM4Y/XGETUwj6xMj/Q13x3WCC+tjSZIe160BL
pKY963PSbwEqLAUeOX9wRFvk5F3fx+6yjujY+p9mtbnegkMOGQlaTpfSX8z/v8r7
Cy8xEJGperXWWZKzMh37tl2CDNbj7/B7WwU6iWhjyeph5rOYb0X33YENJhcTc0gQ
GfU7E2cWk7tbgW+OqSYtooPPGE/kYVomI4w/gKbrM16Qx6OcRuLUQAWRgWmh3h7p
0BsoOWKUhYHBHrDv2x5+MEmemO3x/2sJuS+4d8teSi6HNu4gq4fiCJcMWqh4S+QE
zhGYB2/IfOxPd+oy9ttjo2XvK4HY2XJ0eG/5dFJlWbG/9uWlJ7x3vWWSTeFag/kJ
4IYKmSCu0Mj+iRZYmc2idthiEWmkyE0uArCwXiYqWpZoq5I7NQsPcQwvfZ8TACAZ
Xh71epkc7Tm5HbiYFlMeCiJ4uCnpZe57xSpwjizeb/LUkVFlDgFO7Sy22s56VCrp
NHL1wIN5KmkABEVYU3R+SI7TqBkvwFOUARflPfuVgqBkre3P3fiVsgD5mbwDOFkf
slpSxJQCpBW4P5F5DEDLKtJtOPDHK6lbui+HUvRMqZ0L3KqFb8QnztjgHbY59DJb
QS0mU45YIn3JrrU7OLqh
=AVHx
-----END PGP SIGNATURE-----

--GeONROBiaq1zPAtT--
