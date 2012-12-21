Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:45051 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751260Ab2LUSgp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 21 Dec 2012 13:36:45 -0500
Date: Fri, 21 Dec 2012 18:36:39 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Gene Czarcinski <gene@czarc.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: add, remove; how about merge?
Message-ID: <20121221183639.GQ19051@carfax.org.uk>
References: <50D4A79B.6010008@czarc.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hSZb4FHl1C2xfsUy"
In-Reply-To: <50D4A79B.6010008@czarc.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--hSZb4FHl1C2xfsUy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Dec 21, 2012 at 01:16:59PM -0500, Gene Czarcinski wrote:
> I am new at this btrfs stuff!
> 
> As I understand it, you can add a physical disk or partition and
> have data spread into the new space.  You can also move data off a
> disk or partition and then remove it.
> 
> Has any though  been given to being able merge to existing
> (separate) btrfs "volumes" into a single volume?

   This would be difficult to do in kernel space -- you'd have to
change the UUIDs on all the metadata on at least one of the
filesystems, plus handle (correctly) all of the numberspace clashes
correctly -- subvolume trees, virtual address space, and probably a
load that I've forgotten as well. Given what I'm about to say, I can't
see this happening any time soon.

> Alternatively, how about at tool for transfering a subvolume from
> one pool to another?  I tried using fsarchiver but that did not work
> out too well.

   You want send/receive. It's in the mainline kernel, and you'll need
a recent userspace, but it allows you to transfer subvolumes cleanly
and losslessly between filesystems.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
        --- "You are not stuck in traffic:  you are traffic." ---        

--hSZb4FHl1C2xfsUy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUBUNSsNr9z9OVl50rAAQLVAg//c80kujBdUaTc46weAAY7wwhF4KgEzcmR
QxuycprkXnhfcRsJGh9dIVfOVz8CiBeCJJ37a4l7YTsYiiBJL83hhFMFbZG8U0KJ
PDfX8Fl1vCJjDjKRkVIBmbFJeQDZKNBTqVywjYis3fZzMEzpFzHcXzM7cKZW0tBe
oxdqzpbhX8AkHwDqYFDULfcEbrkkR4dFKyRqu9F2Si0Xif7xGsNiFbJlZoIEI4a1
+cq3D/rs/RrMzHrwLruIJb8BHpS0bj93hQQwOrOGmkB72gJ34N5Yh8pD2UurVYf1
29ufkU6a5COMXRBSk8SjNWc1p1aiODB4k3QpL5OUFaDdttCx86FXiYWhtd6m1JpD
4DTaVHbOUfrOpF/Y9zY5AxZQgSJojvvoneZtXrW2jblpTgpvImZ7nY19DAODu3sx
kOxxhaHj/E8xAsEbctg5Ou8/WvKYJ37txGbhSOTaOOgxVnn5BbslXZOX1q+CmPRI
2SroDrD5ew7AegepxGA4M1pHKywi5FhqTJ9CKkfkilRQ0KK0ai5bVcNw6X033Lik
oQGIHBhcYcHfOGw3dXELujGd/ZlUEhfi/VL9Y11tS+8nEzwR7F53QX5NTPLJX+8H
RZA5zaEFUNTykE5wriTzy2t2ddSF6ILs9Xid/hW4FyvZYMXGS95g8L0YWonn+9ix
0xsUTCsWOqg=
=CM3c
-----END PGP SIGNATURE-----

--hSZb4FHl1C2xfsUy--
