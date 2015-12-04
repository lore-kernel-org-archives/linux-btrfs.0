Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:59127 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756172AbbLDNH7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 4 Dec 2015 08:07:59 -0500
Date: Fri, 4 Dec 2015 13:07:58 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: "S.J" <sorry@anonym.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Subvolume UUID, data corruption?
Message-ID: <20151204130758.GR8775@carfax.org.uk>
References: <20151204120529.37E47D5A28@emkei.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZgGN478A9hzzvyZc"
In-Reply-To: <20151204120529.37E47D5A28@emkei.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--ZgGN478A9hzzvyZc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Dec 04, 2015 at 01:05:28PM +0100, S.J wrote:
> Hello
> 
> As we know, two file systems with the same UUID (like reported by eg. "blkid") are problematic, especially if both are mounted at the same time it leads to data corruption. So, copying a BTRFS partition with eg. dd to another and use it immediately is bad. To prevent this, "btrfstune -u /dev/sdaX" changes the UUID of the given partition.
> 
> However, BTRFS subvolumes have their own UUID, which can be viewed eg. with "btrfs sub list -u /mountpoint". This UUIDs are not changed by the command above, and apparently there is no other way to do this.
> 
> My question is: Is this a problem similar to the main UUID? Can mounting two BTRFS partitions with equal subvolume UUIDs (but different main UUID) can cause data corruption?

   I don't think it'll cause problems. The UUIDs on subvols are only
really used internally to that filesystem, so the kernel doesn't have
a chance to get confused. The main thing that could be confused is
send/receive, but that's a matter of possibly losing some validation
(thus allowing you to do something that will fail) rather than causing
active damage, as in the duplicate-FS-UUID case.

> (...well, and maybe someone could explain me what these subvol UUIDs are for in the first place. Subvolumes already have an unique number, and from user p.o.v, there isn't anything where the subvol UUIDs can be used at all (?))

   The subvol UUIDs are used to identify them through send/receive
operations. There are three main UUID fields on a subvol: the actual
UUID (u), the Received_UUID (r) and the Parent_UUID (p), and these are
used to identify whether an incremental send could function correctly
when received. (I can give you chapter and verse on how they're used
if you like, but that's a bit excessive just for answering your
question here).

   Hugo.

> Thank you
> 
> PS: Apologies for sending a second mail, somehow my first try didn't contain any text

-- 
Hugo Mills             | Do not meddle in the affairs of system
hugo@... carfax.org.uk | administrators, for they are subtle, and quick to
http://carfax.org.uk/  | anger.
PGP: E2AB1DE4          |

--ZgGN478A9hzzvyZc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJWYZAtAAoJEFheFHXiqx3kAEcP/3MmjwptMXbQi7aaQ5B/1CS2
desdkmZMOaSQttzaQvAAAuF9hXotgm+0+kjrlvLyGUUT+EQoIBc9LzkoTy+ZFQw3
FErJmK32+XZeM53Pu7YtnJcbDD1CmZOW1KINCfH+ESzfpotRLUHFyhWGQSGAEpIV
wKOSe2SeeNPDgf4P72Pnm1xmS9gOtUtYjK5dUxrxKhoFmmeZl3I0avEzG7TpC67m
Zar2osy7vFNMfwqGG2V88304HInHwZ8neLmB6pYTpsYTJfMLrTE/4tQjojHH4F4K
fgGfAH9lj8n8NxTS4sjR+v0oljKpzSukQ01NB2d8mJ/EW29EQbZmkj5/D8clspkk
8l8mPLHrOPiGhZEyCa0ICvAIElOrKi3BnAKa6d5nPDvJGxzYjfMOxxk0B492vO03
ME+tYuhs94sjMHH+5nATG28k92SIKoF74Z54qAxz5jhsMixbitgmLYnWjN/Q1Gp6
RlFSby/ZOb8fUsODSWFviV7ugHe4vkqMMz1s4Cv7ir8IrRfQTcYDkL/a68AMgquV
NgUbTswQ4q3erIPXVrdOiXCzIBhloK1u3yr5tDV3D6bpAMMyQboX4p3G9K2w5IIB
T/faZjKB+FW7W1rWBodbkHGRLe5y3qfHnKogqHEFHPg1vPRvqZRFJMANmgoyfUoV
/6z7CuZhVjgMx/9y1Ri4
=0Im3
-----END PGP SIGNATURE-----

--ZgGN478A9hzzvyZc--
