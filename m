Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:37283 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753300Ab3A3KCE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Jan 2013 05:02:04 -0500
Date: Wed, 30 Jan 2013 10:02:01 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Roger Binns <rogerb@rogerbinns.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: RAID 0 across SSD and HDD
Message-ID: <20130130100201.GN16285@carfax.org.uk>
References: <keap27$oqb$1@ger.gmane.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="nRwNdQxTdQ7rZk9A"
In-Reply-To: <keap27$oqb$1@ger.gmane.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--nRwNdQxTdQ7rZk9A
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jan 30, 2013 at 01:27:37AM -0800, Roger Binns wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> I've been unable to find anything definitive about what happens if I use
> RAID0 to join an SSD and HDD together with respect to performance
> (latency, throughput).  The future is obvious (hot data tracking, using
> most appropriate device for the data, data migration).
> 
> In my specific case I have a 250GB SSD and a 500GB HDD, and about 250GB of
> files (constantly growing).  One message I saw said that new blocks are
> allocated on the device with the most free space which implies the SSD
> would be virtually unused in my case, except for metadata which would only
> be used half the time.

   That would be the case with "single" mode, not with RAID-0.

   With RAID-0, you'd get data striped equally across all (in this
case, both) the devices, up to the size of the second-largest one, at
which point it'll stop allocating space.

> At the moment I have two independent filesystems (one per device) and
> manually move data files between them using symlinks to keep pathnames the
> same.  This requires keeping lots of slop free space on the SSD as well as
> administration whenever it runs out of space.
> 
> My hope would be overall performance between that of the two devices, and
> closer to that of the SSD.

   We don't have any kind of hot-data management yet, but it's on the
list of things we'd like to have at some point.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
   --- Some days,  it's just not worth gnawing through the straps. ---   

--nRwNdQxTdQ7rZk9A
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUBUQjvmb9z9OVl50rAAQLNUhAAnA96XGL75BQ7UkCLFqrjI9IlxciQ9UNG
psm5IWaiBdgFaOT/ygOfT6VJjH8RbYNU93P1NUyQO4e/rSyEjHqZkxjkUUtLCTZq
nd3u9+btwvTeP8mZtNLiqb4ISUq7/O1rGeqZy/0l/xminOLMDfpZmJ1vRRgAFwBj
CUTDM2QimPejunI2du/s4dHLmcIrFe3u9A6TqkKDV6t//xm0tb3MAMVfpWbPlKnI
b0IILPfM57/gb/piT7DYp81k6nF+j/OKkoMrUBUfcZrmE5cBq6CiZF1dXFOSfTd2
zv0EN5M7zA5SVMDtA5Jiz4tAzlIGSvsVwXu9rgZ7FQDy6ol7Dqk72qyLKft+DIdI
TojudMtykLipenWFYangnYoAQH1idcdrQuaC2kbsZ0ism+XSWWOuQuyz2R8oICsc
Cxx/7fEKYhoLVXE7N/7xUIP66Td4qdfW0Q0D6ZWdDtXTGDsTs/P77uA73/Ur+ZkQ
2luqQplaC5ghezDMbWzVHGUxBnUqch/Wr2tx78ZJQ6Eq3QRQ9pqPTP0VbV890MCM
B1SKTO1QsGiVzl1Ktq7ckyNdYNWVEcFX00Fe9r2kLcaDSDl7mptybymgKYQx0m8j
V9qGXcRuoRjFC8QlpWuOK5hJ51jCs0ipRqcvQ0zOqvGFuUCf/0v/Xlq/yh9qZolc
L4HqlvOfGEg=
=xSHw
-----END PGP SIGNATURE-----

--nRwNdQxTdQ7rZk9A--
