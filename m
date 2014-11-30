Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:54693 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751614AbaK3Nxa (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 30 Nov 2014 08:53:30 -0500
Date: Sun, 30 Nov 2014 13:53:28 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Shriramana Sharma <samjnaa@gmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: root subvol id is 0 or 5?
Message-ID: <20141130135328.GG32735@carfax.org.uk>
References: <CAH-HCWWVR=g6mZFZyu6wYRfP7Harr5bxokJi+_qW8QHsniFPFg@mail.gmail.com>
 <20141130115908.GF32735@carfax.org.uk>
 <CAH-HCWWk7J6N0M1z=2N__T0TQ1qffORnxdVNrpjGHh1gtQx3dg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="n7zTieg8iIQ1Wja9"
In-Reply-To: <CAH-HCWWk7J6N0M1z=2N__T0TQ1qffORnxdVNrpjGHh1gtQx3dg@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--n7zTieg8iIQ1Wja9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Nov 30, 2014 at 07:08:51PM +0530, Shriramana Sharma wrote:
> On Sun, Nov 30, 2014 at 5:29 PM, Hugo Mills <hugo@carfax.org.uk> wrote:
> >
> >    In the data structures on disk, it's 5. The kernel aliases 0 to
> > mean subvolid 5.
> 
> So why 5 and not just 0 which seems a logical choice? On top of this,
> one needs to alias 0 to 5!

   All of the trees used in the FS metadata have an ID number. The
"well-known" trees have small, fixed IDs:

#define BTRFS_ROOT_TREE_OBJECTID 1ULL
#define BTRFS_EXTENT_TREE_OBJECTID 2ULL
#define BTRFS_CHUNK_TREE_OBJECTID 3ULL
#define BTRFS_DEV_TREE_OBJECTID 4ULL
#define BTRFS_FS_TREE_OBJECTID 5ULL
#define BTRFS_ROOT_TREE_DIR_OBJECTID 6ULL
#define BTRFS_CSUM_TREE_OBJECTID 7ULL
#define BTRFS_QUOTA_TREE_OBJECTID 8ULL
#define BTRFS_UUID_TREE_OBJECTID 9ULL

   Note that "the" FS tree has ID 5. A subvolume is basically another
FS tree. Subvolumes other than the top level are given dynamically-
allocated IDs starting from 256. Note also that the root, chunk,
device and extent trees are all more important, lower level
information than any FS tree, so they logically have lower numbers
(and were probably implemented earlier).

   There's no particular reason that it couldn't have been designed
with the initial FS tree as ID 0, but it simply wasn't. However,
changing this value now would result in two incompatible versions of
btrfs -- neither one would be able to deal with the other's
filesystems, because the FS tree has a different ID. (And writing code
to cope with both would be painful, disruptive and error-prone.)

   The cost of fixing this minor nit would, I think, far outweigh any
benefits you'd get from it. Hence the "alias" for 0, which is (IIRC)
done up-front in the ioctl interface, and therefore has few places
that it could go wrong or affect the main code of the FS.

   Hugo.

-- 
Hugo Mills             | "How deep will this sub go?"
hugo@... carfax.org.uk | "Oh, she'll go all the way to the bottom if we don't
http://carfax.org.uk/  | stop her."
PGP: 65E74AC0          |                                                  U571

--n7zTieg8iIQ1Wja9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJUeyFYAAoJEFheFHXiqx3k56IP/R1IXjMibR1c2e0gQbIatmFm
eLasLA4bpWZv24B01LOeKsjVjkFLNMO31eI3VcC5KoKKxLTfzeGBn/+rsFTL8oTY
JBF38kv7dO4B6ZoZRzThy1vLzhGw1ZvPNQ+SstzE1nUA0Nng3qQDWtJVbXwFWQaD
sUb25RSkBub6CdBiLznAYyylvRVcHSr1OKRVTNxq6TmulZWJU446WlovyUSk7cHF
4WsTLE9SRs5wAauH5feuE9eYRdBr40sGoc5rUQzGl5+4cyiXDh9Xo5lcNFUFyWbO
+l+MOAwq3bzkc74tfQZW3J5uP6HoOQii1Q11T0hAiX0BKMvTPe9qXketPZcNoWrt
eBi5eTFLr58jWqRRo4qit5e3s5rpIuZ2YlyEJ1VlXJNgJSjFudT3JoYgviVB3tVn
GDrLKjXMdJaQExsmF9UX1tMEsxugis09hg9AXEwJKe6L1yNzXsDIEDeZY3uhvMGQ
V01373KU1CzNIv6KmkqcJARKsZYlr1RDZ3BQw1Dnm/dn31+m7WPJSBKfEcgw9bIh
WIbEcr2VHBFVhMApCtmf56AoHBY2aoDqsdvcXJG6D9GyH+OjtVPemtxEmaZ+NMRC
jgBZVQ2Lq/zDTIp2DV8cTC9SBVDXwqKFb4VLKv9fRrBpb7CpZYf9z+lvqGf+KXvh
zzuR23oplyFMizTitae7
=bVzr
-----END PGP SIGNATURE-----

--n7zTieg8iIQ1Wja9--
