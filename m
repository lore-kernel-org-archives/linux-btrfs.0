Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:56532 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751434AbcGPKZI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 16 Jul 2016 06:25:08 -0400
Date: Sat, 16 Jul 2016 10:25:05 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Kai Krakow <hurikhan77@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Btrfs uuid snapshots: orphaned parent_uuid after deleting
 intermediate subvol
Message-ID: <20160716102505.GO3041@carfax.org.uk>
References: <alpine.LRH.2.11.1607151611410.16154@mail.ewheeler.net>
 <20160716121818.34457a8e@jupiter.sol.kaishome.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="kvUQC+jR9YzypDnK"
In-Reply-To: <20160716121818.34457a8e@jupiter.sol.kaishome.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--kvUQC+jR9YzypDnK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Jul 16, 2016 at 12:18:18PM +0200, Kai Krakow wrote:
> Am Fri, 15 Jul 2016 16:12:51 -0700 (PDT)
> schrieb Eric Wheeler <btrfs@lists.ewheeler.net>:
>=20
> > Hello all,
> >=20
> > If I create three subvolumes like so:
> >=20
> > # btrfs subvolume create a
> > # btrfs subvolume snapshot a b
> > # btrfs subvolume snapshot b c
> >=20
> > I get a parent-child relationship which can be determined like so:
> >=20
> > # btrfs subvolume list -uq /home/ |grep [abc]$
> > parent_uuid - uuid 0e5f473a-d9e5-144a-8f49-1899af7320ad path a
> > parent_uuid 0e5f473a-d9e5-144a-8f49-1899af7320ad uuid
> > cb4768eb-98e3-5e4c-935d-14f1b97b0de2 path b parent_uuid
> > cb4768eb-98e3-5e4c-935d-14f1b97b0de2 uuid
> > 5ee8de35-2bab-d642-b5c2-f619e46f65c2 path c
> >=20
> > Now if I delete 'b', the parent_uuid of 'c' doesn't change to point
> > at 'a':

   Correct -- the parent is the subvol that the snapshot was made
=66rom. After you make a snapshot, the snapshot and its original
subvolume are entirely equal partners, so there's no parent-child
relationship between them for purposes of data storage or anything
like that. The parent_uuid field is only used by send -p to ensure
correctness, and for nothing else.

> > # btrfs subvolume delete b
> > # btrfs subvolume list -uq /home/ |grep [abc]$
> > parent_uuid - uuid 0e5f473a-d9e5-144a-8f49-1899af7320ad path a
> > parent_uuid cb4768eb-98e3-5e4c-935d-14f1b97b0de2 uuid
> > 5ee8de35-2bab-d642-b5c2-f619e46f65c2 path c
>=20
> It cannot do that because b may have diverged from a.
>=20
> > Notice that 'c' still points at b's UUID, but 'b' is missing and the=20
> > parent_uuid for 'c' wasn't set to '-' as if it were a root node (like
> > 'a').
> >=20
> > Is this an inconsistency?  Child parent_uuid's it be updated on
> > delete?

   It's not inconsistent. I think it just doesn't mean what you
thought it did. :)

> I think this is by design. This "missing" UUID is now no longer a file
> system tree, it's just referencing blocks different between a and c at
> the time of deleting b.

> > It would be nice to know that 'c' is actually a descendent of 'a',
> > even after having deleted 'b'.  Is a way to look that up somehow?
>=20
> Actually it would also be interesting what happens with blocks in
> deleted b after the blocks in c are unshared? Are they garbage
> collected or do we have some orphan subvolume lying around which you
> cannot get rid of?

   They're GCed. Extents are simply reference counted -- it doesn't
matter how those references got there, or in what order. When the
reference count drops to zero, the extent is cleaned up.

   Hugo.

--=20
Hugo Mills             | Great oxymorons of the world, no. 9:
hugo@... carfax.org.uk | Standard Deviation
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--kvUQC+jR9YzypDnK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJXiguBAAoJEFheFHXiqx3kracP/A3EfPvhkZFxZdo2iUt9dOFA
bA/+KeW1NxRUIrJxgVa7SU/QgRCkCheO+YtD/r8tSkdWlAKpLpHk9wed4SaHSsoT
ErRNw4IrhihW2zdADVmzx2q+S9RbK7Bzu2GMTKPPGKyOOIfIt09odqCIFiV2N8i8
dEMcfFv2qiiM/fQfGNDmAyfSLv2jWKfeMCMO0xHCZ+0ePRbIjKgwZpmKubOoQNnL
qyTRfR6MBbR4ssdmnevzwtYgNkgDNnfovCl6k9mAluRzj5pCShSBqL/DR/noBzZQ
eb8No3W3re/U22gGKP3+ohDh1XkHMAwMvl4UflrK/lS+FBAOT+WMDP/+WxzJXdis
Tdks+t4BsvxQ8gVyP909dj79SPFd1JsacoZL/KVarkcRbaaQ4NTY3mOQl3CL8O8f
yt011py6wXOFu22+kOrEIRkjaxJJlEWySEMZxfrcbsfgERQDwtI296Vozf1LTtyk
bBK3MyCHQ/kFFmEoxUzhC32NyaW8wCU+wzEoSEn9tJO73jwpnESZTVhZjoeJpbdk
nuHO732xpoT8eL7zY4Z99dUtFKjXiQ5DYzidTRnS7J3WgN6QxLzYMJ9laPlZHiDO
ohzKnFvUHEsRgLj8UfyBOUuDuF4wB0e+PD9GvqFVJx+0t1x6LwZ3pVu57saVn5Vi
vYWkoF3Wo1xl9qgxrLvg
=8bob
-----END PGP SIGNATURE-----

--kvUQC+jR9YzypDnK--
