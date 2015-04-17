Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:36752 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753631AbbDQJTM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 17 Apr 2015 05:19:12 -0400
Date: Fri, 17 Apr 2015 09:19:11 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: sri <toyours_sridhar@yahoo.co.in>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: how many chunk trees and extent trees present
Message-ID: <20150417091911.GK22084@carfax.org.uk>
References: <loom.20150417T081705-332@post.gmane.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="TXIPBuAs4GDcsx9K"
In-Reply-To: <loom.20150417T081705-332@post.gmane.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--TXIPBuAs4GDcsx9K
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Apr 17, 2015 at 06:24:05AM +0000, sri wrote:
> Hi,
> I have below queries. Could somebody help me in understanding.
> 
> 1)
> As per my understanding btrfs file system uses one chunk tree and one 
> extent tree for entire btrfs disk allocation.
> 
> Is this correct?

   Yes.

> In, some article i read that future there will be more chunk tree/ extent 
> tree for single btrfs. Is this true.

   I recall, many moons ago, Chris saying that there probably wouldn't
be.

> If yes, I would like to know why more than one chunk / extent tree is 
> required to represent one btrfs file system.

   I think the original idea was that it would reduce lock contention
on the tree root.

> 2)
> 
> Also I would like to know for a subvolume / snapshot , is there a 
> provision to ask btrfs , represent all blocks belongs to that 
> subvolume/snapshot should handle with a separate chunk tree and extent 
> tree?

   No.

> I am looking for a way to traverse a subvolume preferably a snapshot and 
> identify all disk blocks (extents) allocated for that particular subvolume 
> / snapshot.

   Do you mean allocated to any file in the subvolume, or do you mean
*exclusively* allocated to that subvolume and not shared with any
other?

   The former is easy -- just walk the file tree, and read the extents
for each file. The latter is harder, because you have to look for
extents that are not shared, and extents that are only shared within
the current subvolume (think reflink copies within a subvol). I think
you can do that by counting backrefs, but there may be big race
conditions involved on a filesystem that's being written to (because
the backrefs aren't created immediately, but delayed for performance
reasons).

   Note that if all you want is the count of those blocks (rather than
the block numbers themselves), then it's already been done with
qgroups, and you don't need to write any btrfs code at all.

   What exactly are you going to be doing with this information?

   Hugo.

-- 
Hugo Mills             | O tempura! O moresushi!
hugo@... carfax.org.uk |
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--TXIPBuAs4GDcsx9K
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJVMNAOAAoJEFheFHXiqx3kwEsP/0RcHdqfHPRmjW3TZg5CSxpO
A0FOZlNX9XAO1L1OhE61aX/HdiH+nfILzHFAiIB0JI74+3isi1wLJwpGea0UUmU9
ScfZc/AveoqTPZCNY+Zk5fEyJfM7S3epc34x2yQ6SInDdssPBs0eAsjaxQh24h0e
WojIsXBbsb+LCpn8w8BybFbb0T0rVa7QSgU+Q2W3SrK9sGtXqmnz9JZcIZIzqbZK
2Pr1YDn/yV4r4N4K+/e/JJ9TZ13xKObnQ0hKTjqscwPwYneNwZRrhSZnSqHBgKgl
zvVnur+jdSvAXO5PQ7rC8XHrPy5OuiTc+w+/PDi+PZ1qMcL6o5Ksrdq4UbZ8sRJl
srcyGTuGPMg7zdD8L2iiRsRW8ZB3bKnNMt+Wj/VNIUfLtjZ24H+C3MhbRvBZ2Qwd
cKrUCCih/RLniVxncxyNPuILfjHMlLnGAcNrZe3w8SKfzARC8BzXYIQeXXneVZt7
2tDiSMLK83MreVo9L/Hytb3WRt2aVwqYDz51+/BwvhlB87qk9V3YYPRURZrAgaUf
zmeS8s5+4tCZTPjgz2JLeG02C9JfomzJ4BtzgJp6h1Wlod9G5Qf5HlscnLNot9Fw
9etKdTksx65Q09IkptZ6W6U8Y+ZX3BMYET7kb+4Ej+wIl9T97xXDzJwuvCdn/jtl
zPN2UtZEZO+cWKCXkLQY
=nur6
-----END PGP SIGNATURE-----

--TXIPBuAs4GDcsx9K--
