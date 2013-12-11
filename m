Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:45363 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751351Ab3LKTBG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 11 Dec 2013 14:01:06 -0500
Date: Wed, 11 Dec 2013 19:01:04 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Martin <m_btrfs@ml1.co.uk>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: BTRFS extended attributes mounted on a non-extended-attributes
 compiled kernel
Message-ID: <20131211190104.GM9738@carfax.org.uk>
References: <l8a8lv$mk7$1@ger.gmane.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7fwXp2o0gOrkU5lS"
In-Reply-To: <l8a8lv$mk7$1@ger.gmane.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--7fwXp2o0gOrkU5lS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Dec 11, 2013 at 05:51:06PM +0000, Martin wrote:
> What happens if...
> 
> I have a btrfs that has utilised posix ACLs / extended attributes and I
> then subsequently mount that onto a system that does not have the kernel
> modules compiled for those features?
> 
> 
> Crash and burn?
> 
> Or are the extra filesystem features benignly ignored until remounted on
> the original system with all the kernel modules?

   Thinking about it, it's probably going to be OK. btrfs itself
doesn't have any way of turning off EA support, so you'll always have
the EAs managed correctly. The ACL support (which is implemented
through EAs, if I remember correctly) can be turned off, so the
meaning of the ACL EAs will be ignored, but the EA content should
still be there for when you move to an ACL-enabled system again. Note
that this gives you a "convenient" way of bypassing POSIX ACLs, by
switching to a kernel that doesn't enforce them.

   I've not actually tried this, so I'm willing to be proved wrong,
but I'll be surprised if that's the case. :)

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
    --- Jazz is the sort of music where no-one plays anything the ---    
                             same way once.                              

--7fwXp2o0gOrkU5lS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIVAwUBUqi2cFheFHXiqx3kAQJOoQ/5AbDg61SN8zbS6mahZathPcVfB47rKLe2
8n4m4XwU6LfwLurDALvNOCGN8p64kNOyYPGCJozzTcjBGJyk0vzSJdz9CIzg314c
eKOUuzmAWDje1m8H4Dyf5n9UvRdiJukqRBRp9stQHnY6d+6yLXgDoVv7EvZFT0HF
mGc3ksQEXUlzDbEdT1NM9gz7r5j18kzwO/Gd3ngkgSiR0mG6kRwkvyT+UCvb0QGR
B3jhVQyaBxF14ZaChUbXJ/sHPUxtkItYAQwZH+FFyDNeZsQoTLQkgsFqCOZRW1Xt
8ppmWPHx8Skt63BzqqFHOr98nUz+Crx6jN1Z0Nw8SWfzdSxQZ65cRXcg88h7qQth
AUCNLjq3SyJmDxNofMB/2ma24IgE/+G9WoFm7IH/oap0GRVFRIe44zUeRXyJiode
KZUwCj4iwJKO+N+xAx7c8IUoiPfF6FoIs/kT+RGByTEDS0o4fy7fTnKb21FcYOEa
EiswuhGFCQIk6JD5AMTZ6mulxO4QINkAw2lOF2+xaXLeTsHR8CYIyMTFk7mftXb7
O+bBJj6uZB/fA/5m7zqgaS0EOTJ1n/un9dk/igXI8i1rpcZGYKQSvP3HS1x8c7vN
O6Gbo8WS9B5TkVmEr4Qb6PvtA7H55d3K/yonnQZor1NBOQx+3Tem1iDbwDsIL9ow
goECIAwO87o=
=bHbH
-----END PGP SIGNATURE-----

--7fwXp2o0gOrkU5lS--
