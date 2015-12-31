Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:51231 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750876AbbLaL7e (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 31 Dec 2015 06:59:34 -0500
Date: Thu, 31 Dec 2015 11:59:32 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Ahtisham wani <ahtishamwani@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: BTRFS File trace from superblock using memory dumps
Message-ID: <20151231115932.GX1586@carfax.org.uk>
References: <loom.20151231T111455-536@post.gmane.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wwU9tsYnHnYeRAKj"
In-Reply-To: <loom.20151231T111455-536@post.gmane.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--wwU9tsYnHnYeRAKj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Dec 31, 2015 at 10:20:17AM +0000, Ahtisham wani wrote:
> Respected sir,
> I have been researching on how btrfs works and manages files for a long 
> time. What I want to achieve here is to trace a path of a file starting 
> from superblock, then to root and so on. The problem is I dont know how to 
> do it. I have been using dd and hexdump but I dont know what to look for 
> and where to look for. I have been able to see some fragments of 
> superblock at 64K but I dont know how to use it to trace the tree of tree 
> roots node or its object_id. Any help is appreciated. Thanks

   Start here:

   https://btrfs.wiki.kernel.org/index.php/Data_Structures

   This will give you the basic high-level data structures. You can
explore those data structures fairly easily using btrfs-debug-tree.

   After that, you'll mostly have to start reading the code a little.
fs/btrfs/ctree.h in the kernel sources is the place to get all of the
data structures you'll need. Those will tell you the layout of the
data items.

   To get from the superblock to the diagram on the data structures
page, the first thing you'll need to do is read the list of system
chunks at the end of the superblock. Those chunks contain the chunk
tree, which contains the mapping from physical device addresses to
internal (virtual) addresses. Everything else is done in terms of
those virtual addresses. Once you have the chunk tree, you can start
using the other addresses in the superblock to find the tree of tree
roots, and then follow that into the other trees (at which point, you
can start using the data structures page).

   Hugo.

-- 
Hugo Mills             | Comic Sans goes into a bar, and the barman says, "We
hugo@... carfax.org.uk | don't serve your type here."
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--wwU9tsYnHnYeRAKj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJWhRikAAoJEFheFHXiqx3ku0UP/jh9eiMXb7FVupTkOC1LqMdY
ilaGPOg3xV3YD2RIFTIDbGRKGIXwvFiUmh+WS8Hr+EqQC/wU7pV0tY5pnT0EhzB4
7zoeFdendHIAEsF6rkEXaFWSR5/Ga74haJQqCdBXULDjOLrwolvgJLDvgQcROjLP
DaUPuI5+LJRER1+QH2ciRt0PBKm7AKikAhxaZprn2Mp8jcWNNiXZnwcciG29z3NI
BlO7A7ZiLTUnIhMXTQWEkQKuDGfd2QSqph3V5OdYHNYscDjSHE3N6vJzNwUGjQEt
WHOD0+YpGckoDcqsjYt7cQjyrfkDSssvzZU4RLqdheZZyknygQDDwSuO8tfJKrcA
2b2dHLtq9rQ5EL+KrB5mk9FQTvsGbgB7PIChiy5FJnZunFwK7sulB2crS5gTXU4E
Mgj9OSUpMkUIQYrjlhuyvEPgA2L+vir6+K/Hm1N9RdiNBwzwRIO998N+96LVp4GC
Lp8eDDDSzhc1c1DyQD1hz0QysVnwLX3qJCsLq4K8oKkIioCk5AxpUsJ2IyoCuL2x
/dfwkgfZW5h+RAN1eyRdp/AlQUW9a3kzitlyKF58DMV8tNqANqc23INWdFYkcF2a
Yd3iC++OJcYA9Vv1aEAKqP6npI7Wr4SmJ+BuSOaRDwfnTHWcNs8yxGFkBBKI+Zy2
3QeAKst+dxZgZkxDIayt
=qfS1
-----END PGP SIGNATURE-----

--wwU9tsYnHnYeRAKj--
