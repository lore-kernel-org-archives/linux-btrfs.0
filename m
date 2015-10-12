Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:33906 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751329AbbJLIKO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 12 Oct 2015 04:10:14 -0400
Date: Mon, 12 Oct 2015 08:10:12 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: "Wang, Zhiye" <Zhiye.Wang@Arcserve.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Questions about FIEMAP
Message-ID: <20151012081012.GF25907@carfax.org.uk>
References: <CY1PR10MB04283CC6BA7D9AE8F3F0B984E4310@CY1PR10MB0428.namprd10.prod.outlook.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yBd94+RIx/Fx7UDH"
In-Reply-To: <CY1PR10MB04283CC6BA7D9AE8F3F0B984E4310@CY1PR10MB0428.namprd10.prod.outlook.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--yBd94+RIx/Fx7UDH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Oct 12, 2015 at 04:37:55AM +0000, Wang, Zhiye wrote:
> Hello everyone,
> 
> After googled a bit, I got information that btrfs supports FIEMAP (as "cp" needs it), but it's not valid for "write" operation.
> 
> I guess we cannot write to block device directly after get block list using FIEMAP. This is because:
> 
> 1. COW feature of btrfs (but this can be disabled using NOCOW)
> 2. File system rebalance
> 3. Defragmentation
> 
> Aren't item #2 and #3 also a problem for "read" operation? For example, after "cp" get block list using FIEMAP, file system rebalance occurs, So, previous result of FIEMAP is not valid anymore.

   That's correct. If you use FIEMAP to get the blocks of a file, and
then balance the FS or defrag the file, then even without an explicit
write to the file, the file's location will have changed. This is the
same reason that btrfs doesn't support swap files (although I don't
know if swapon uses FIEMAP directly, or if there's just some
equivalent mechanism to get the blocks).

   Hugo.

-- 
Hugo Mills             | Have found Lost City of Atlantis. High Priest is
hugo@... carfax.org.uk | winning at quoits
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--yBd94+RIx/Fx7UDH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJWG2rkAAoJEFheFHXiqx3k3M8QAKRrmzwZ53aSL+vlZTMNTeLt
x7Xm5dnVi1TfGf7o5tUOrkTzeuV32KXtpwwzrTUvw/S3COk7xTuZTqDPMhf9o10S
Dmsd87QkkeBEUTYEc4rrr7IhNKTtsqcrXTHXno+21K05XOnC4XnG5yUjWwJkf9ua
aQdrr5NHznnQ5Dfu8mrgYAycC9YTgrK1bOgTF6sPfJDoVlximP06EcveBXPCpJDN
YuIOR7v1lhWK2SNWr075Q45N6v28IzBSB88iL0nTa3JZi53eX0WOhWAjglivXELl
ldisLGks7gfRTPbSCjoeweXXaJf0BC1t0QNsP1EiGvUczxffR8rnYpsPRL+MZTrp
Tb7TU492bYbJ/1A2FrJ1bfCFwV4xtCiqUEORn3D+Pou/DIEfIhq8M7NV1irDCO9R
lRr93h7+JCR3wAVv45v1Io3yE1QYzZb3rj96/VZ+aK9xAkNymCgJExHZq96DzCGQ
7zrZrZuqDd4WVfZJT5O1zZOkp6HAd6g520iFRfJJBDtxOL1Aix2KnOYuNpVeQo2k
l1y8DCSuk3tvkUiOWMV7co6HImOQKglZQl1k5Jf6p2azxjg8E/NUa57cvhZs61Oe
MxzcWtnmE/O4mBBE7USPpmJR63qbqD1Fy7FiF7uNH7Oun9kgKFwTzH0raEmG5fvi
ZTJfc/FiQbqAAw5QGIQL
=yDkc
-----END PGP SIGNATURE-----

--yBd94+RIx/Fx7UDH--
