Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:56268 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752236AbcC3Sn3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Mar 2016 14:43:29 -0400
Date: Wed, 30 Mar 2016 18:43:27 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: sri <toyours_sridhar@yahoo.co.in>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: good documentation on btrfs internals and on disk layout
Message-ID: <20160330184327.GO29474@carfax.org.uk>
References: <loom.20160330T155403-473@post.gmane.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mvuFargmsA+C2jC8"
In-Reply-To: <loom.20160330T155403-473@post.gmane.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--mvuFargmsA+C2jC8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Mar 30, 2016 at 01:58:03PM +0000, sri wrote:
> I could find very limited documentation related to on disk layout of btrfs 
> and how all trees are related to each other. Except wiki which has very 
> specific top level details I couldn't able to find more details on btrfs.
> 
> FSs such as zfs, ext3/4 and XFS there are documents which explains ondisk 
> layout of the file systems.
> 
> Could anybody please provide pointers for the same for better 
> understanding of btrfs on disk layout and how each tree interacts provided 
> multiple disks are configured for btrfs.

   What are you intending to do? You'll need different things
depending on whether you are, for example, using the BTRFS_TREE_SEARCH
ioctl online to gather high-level information, or working your way
through the datapaths from the superblock right down to individual
bytes of a file for offline access.

   If you're using BTRFS_TREE_SEARCH, for example, you won't need to
know anything about the superblocks or the way that trees are
implemented. In fact, it's a good idea if you can avoid getting into
those details at all.

   The high-level view of how the data model fits together is at
[1]. Individual structures referenced in there are best examined in
ctree.h for the details, although there's a little more detailed
description at [2]. There's some documentation on the basic APIs used
for reading the btrees at [3]. If you really _have_ to access trees
yourself, the tree structure is at [4], but see my comment above about
that. The way that the FS-tree metadata is put together to make up
POSIX directory structures is at [5].

   After all that, you're down to looking at the data structures in
ctree.h, and grepping through the source code to see how they're used
(which is how [1] was written in the first place).

   Hugo.

[1] https://btrfs.wiki.kernel.org/index.php/Data_Structures
[2] https://btrfs.wiki.kernel.org/index.php/On-disk_Format
[3] https://btrfs.wiki.kernel.org/index.php/Code_documentation
[4] https://btrfs.wiki.kernel.org/index.php/Btrfs_design
[5] https://btrfs.wiki.kernel.org/index.php/Trees

-- 
Hugo Mills             | "There's more than one way to do it" is not a
hugo@... carfax.org.uk | commandment. It is a dire warning.
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--mvuFargmsA+C2jC8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJW/B5PAAoJEFheFHXiqx3kjSgP/A0Na8FkgQuxwwYLL8+q/7Q/
2y2aR1N6B1YWSl+8Zoe+m1gzQRmU51B9TXDzEAhFOrRgXRR3hwACBhKnnLn0IEWd
G0nn6CbO/zyjj9DjVkFcJEiZsQZINvUBVLpeFEW+Pwn4iGSxX9+wgn9R6ZQE5tr0
xFjM5kEEusAvcKNTlHboBwXLjMS9540Ce+WGphzh6htF//Wij4NZBGj+aW42EGKF
4o/SPxq1pAMA8K4v9lq93UcrE6sBSxUP4YXEfP2q04tw6stAQBLn0YwL+FVV1psT
PViTjnkPkzmfFyGT8+AnRoWPQtnqWGiEUD+H4sCeMGgo87ZWnD1tJ9dXtoFlAts4
IGOY/MzHD7FgQ92BL8StG4+DVcc970Ff4A0TYE7YZK7y7pw3KdFNCpVR3tNMqMID
Td6/skkdwmnNQz6YpTaBpaYTGG8Y1toPahJhJqbL2PbioQMF6jRC0bLZhTJVTlAQ
HDByMzg2xsptaivFC+7pnbZzYLS4IzrJGpk+lNiN2F7uMF4q9KxayoS1Hvjnx3qO
Y7Yh+oStxrAxq0n3QsOlkUkEUECRpCSx9p4Zg9SNbOTygIwJF9uyCOAXWbY/45R2
atMQqY8dvaBqpiYcqLo2WNhcluhKZAyGPZP/2tuIU+QSkZdq5gwUpx+8Avi5lLYQ
zbkf7uySzFaP6fi2xAHv
=sbfD
-----END PGP SIGNATURE-----

--mvuFargmsA+C2jC8--
