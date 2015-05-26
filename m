Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:43478 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750845AbbEZIwt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 May 2015 04:52:49 -0400
Date: Tue, 26 May 2015 08:52:46 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: sri <toyours_sridhar@yahoo.co.in>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: btrfs on disk stability
Message-ID: <20150526085246.GC16826@carfax.org.uk>
References: <loom.20150526T103943-385@post.gmane.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="V88s5gaDVPzZ0KCq"
In-Reply-To: <loom.20150526T103943-385@post.gmane.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--V88s5gaDVPzZ0KCq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, May 26, 2015 at 08:45:06AM +0000, sri wrote:
> Hi,
> 
> According to btrfs wiki page, under "Stability status" it is written that
> 
> "The filesystem disk format is no longer unstable".
> 
> Does this mean if there are more I/Os are going on a btrfs file system, 
> copy of entire disk (all disk blocks) gives a stable disk?

   No, it means that the format isn't changing in incompatible ways
any more. You're guaranteed that if you upgrade your kernel, the FS
will still be readable on the new kernel. (And, if you don't enable
any extra features with btrfstune, that the kernel will still be
readable if you downgrade to the earlier kernel you were using).

> Just to elaborate more, if btrfs file system is created on 2 disks 
> /dev/sda and /dev/sdb and if I start copying blocks of sda and sdb to sdc 
> and sdc respectively by just opening file handlers of sda and sdb and 
> mounting the new copy via /dev/sdc and /dev/sdd will give consistent file 
> system??

   That's always the case, with the very large caveat that you remove
/dev/sdc and /dev/sdd from the system before you try mounting anything
related to that FS. Making block level copies of btrfs filesystems and
leaving them visible to the same kernel as the originals is a very bad
idea, and can cause massive FS corruption.

   It's OK to make the copy, but not to try mounting the FS with both
copies present, as the kernel will see both copies as the same
filesystem (because they have the same UUID), and it will get very
confused about which device(s) it's meant to be writing to.

   Hugo.

-- 
Hugo Mills             | Q: What goes, "Pieces of seven! Pieces of seven!"?
hugo@... carfax.org.uk | A: A parroty error.
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--V88s5gaDVPzZ0KCq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJVZDRdAAoJEFheFHXiqx3kkAsQAJhbcgf3kGJ6U3AFzDJ+CaA+
i64cN1cVAjzMxeuA9O9wVDLuGT24LtPg6hTQmAPhcxhLg5fSYmDbid5reC5SV6Ke
u1xbk+Y5EwHYrKYIAwVOyCV6iPyrP09/PHNZohI4bl1QKE/l6HgzKBR6QueGr3/n
HQO4lxs/7nQHepfpoFGzJM7/SaiggPffyF/BoY6FaTv8bs5hMALKQw8uBc0d8tvd
WODsOgHK0RfSoyHw9c8Sp0uLUX/9Axu2AlgZ7BteUIMeEl4lkY+A2uZ24el1Rh+w
L9w7nF5qguw4yhUFAzwJqouk//cL6D1pMUdS/AKFhtKN3qt7MjoOxdVNYglsta4c
6Up2b9bIS3ydMNDXeyU2gxxLKSRfyMBd/JHrjvxuHQkjP9ChBKLIguPHYdE6qDQz
wkjR+rq75eVM35J3KRbCRAKpaK6R9lnXxRptvLAXNMDilTXn1ybeRLx3jfaH46nM
Tiq5Lkxb9ajDwjdNo2yjtKaJUffzRxwgf2iwyYv6UuiEEBE25Pizd3Ju+w/Rn8td
a7S6yA8DBN+TqbAQwqNhqsU32akYwt5qlQl8huM4EVrOreNkDCGx1Jnhx9wfRZFn
HGlfapo/dWhc2pMQ4MNxBtxIc5Hgf8Pri+WSypERPMI8dT18se+4e/6dVR1nErzA
QSFqm+OFleW7AVVEJiN6
=pqmU
-----END PGP SIGNATURE-----

--V88s5gaDVPzZ0KCq--
