Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:47845 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755699AbcECJzU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 3 May 2016 05:55:20 -0400
Date: Tue, 3 May 2016 09:55:15 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Hasse Hagen Johansen <hasse@hagenjohansen.dk>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Subvolumes cannot be mounted after raid1 conversion
Message-ID: <20160503095515.GM7228@carfax.org.uk>
References: <983F0471-51E8-47EC-B5A0-FBA9040F634B@hagenjohansen.dk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qySB1iFW++5nzUxH"
In-Reply-To: <983F0471-51E8-47EC-B5A0-FBA9040F634B@hagenjohansen.dk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--qySB1iFW++5nzUxH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, May 03, 2016 at 10:52:36AM +0200, Hasse Hagen Johansen wrote:
> Hi
> 
> I have made a btrfs on a single physical disk and made 3 subvolumes which I manually mounted and copied data to. Yesterday I added another disk to the filesystem and ran btrfs balance start -mconvert=raid1 -dconvert=raid1 /mnt/temp where /mnt/temp is top-level fimesystem(not the subvolumes). After that have finished I cannot mount the individual subvolumes
> 
> can anyone explain how it is supposed to work. I can still see the files in the top-level filesystem but it seems subvolumes doesn't work after raid1 conversion

   The balance should have made no difference.

   How are you trying to mount the subvols? (What commands/fstab config?)

   What errors do you get when trying to mount?

   Hugo.

-- 
Hugo Mills             | The Creature from the Black Logon
hugo@... carfax.org.uk |
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--qySB1iFW++5nzUxH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJXKHWDAAoJEFheFHXiqx3kHBUQAJOLhoXqI+bJSk2bOqds1D5g
7BKlofeH7ka32ol2gjUOoDK9j8r6QKJ9lukpu13t5yTr+03iQzuvSlSgLuWY1dus
lDcH8bYzu/uvHWzeEUuzs7n7xqncHbb5J8LaxwPZ41Qis38c23+JBCXzatAFnQv1
IyvazNEc+GiWo02UE/pmd3Nn10iNC/FLyhpcs3XXffgG85dRG6sM9uiSKMIYC/rR
tUAyOHP/HqnBxFkEbshdcn0HXK/wKZg+dEBoGFKSLm8AvZtSo3b1AExso2utNL7T
E/2tAh6O+oiu6A9Q5chWAHCSgOJOM0eD4OYDjzJg4NthTsA+xtyunEUoaznr/9xs
L6Y1wyj3aO+7LSVaiuKXAyGUcgOSEYIhe/cELEWuCK8c8fYwBNw8q52WNxFVzOYS
g3ZZl1hdDbAsEm6/Dfq4DQZFP9+PEbQ8ufEVNFoLz9nezzysanq2wwcJnBcMzpEp
3nnIafH9hdc9OLgLSvD+xHRMKK6sK7T1RbZICRJYPsr0pGN7CO8GOrxcxtbmebwW
KvV3OcYPQ4nWzHhZ0yvgyBoINTXM8fPoMAmtoWgkyvecWuBDHOY9Y9JqugZgWIRb
a0q3ONdIGB6Qc6/Q4+I4Vncs5Oq2moc+GTVHiB1nWzCx/XbwYcHZpGWJk8t1jYXp
2ZvIXQpL9D8/l+uKdFSu
=VOrN
-----END PGP SIGNATURE-----

--qySB1iFW++5nzUxH--
