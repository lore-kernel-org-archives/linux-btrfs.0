Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from luka.romanrm.net ([213.163.64.74]:52668 "EHLO luka.romanrm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751728AbaBGEkI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 6 Feb 2014 23:40:08 -0500
Date: Fri, 7 Feb 2014 10:40:05 +0600
From: Roman Mamedov <rm@romanrm.net>
To: kreijack@inwind.it
Cc: kreijack@libero.it, Brendan Hide <brendan@swiftspirit.co.za>,
        linux-btrfs@vger.kernel.org
Subject: Re: Provide a better free space estimate on RAID1
Message-ID: <20140207104005.7bd1438a@natsu>
In-Reply-To: <52F3E86B.4030805@libero.it>
References: <20140206021516.304732cd@natsu>
	<52F33BE7.4020708@swiftspirit.co.za>
	<20140206184502.128b7dbe@natsu>
	<52F3E86B.4030805@libero.it>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/anWG+1i.7wLZOia7hKBX5w_"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/anWG+1i.7wLZOia7hKBX5w_
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 06 Feb 2014 20:54:19 +0100
Goffredo Baroncelli <kreijack@libero.it> wrote:

> I agree with you about the needing of a solution. However your patch to m=
e seems even worse than the actual code.
>=20
> For example you cannot take in account the mix of data/linear and metadat=
a/dup (with the pathological case of small files stored in the metadata chu=
nks ), nor different profile level like raid5/6 (or the future raidNxM)
> And do not forget the compression...

Every estimate first and foremost should be measured by how precise it is, =
or
in this case "wrong by how many gigabytes". The actual code returns a result
that is pretty much always wrong by 2x, after the patch it will be close
within gigabytes to the correct value in the most common use case (data rai=
d1,
metadata raid1 and that's it). Of course that PoC is nowhere near the final
solution, what I can't agree with is "if another option is somewhat better,
but not ideally perfect, then it's worse than the current one", even
considering the current one is absolutely broken.

> The situation is very complex. I am inclined to use a different approach.
>=20
> As you know, btrfs allocate space in chunk. Each chunk has an own ration =
between the data occupied on the disk, and the data available to the filesy=
stem. For SINGLE the ratio is 1, for DUP/RAID1/RAID10 the ratio is 2, for r=
aid 5 the ratio is n/(n-1) (where n is the stripes count), for raid 6 the r=
atio is n/(n-2)....
>=20
> Because a filesystem could have chunks with different ratios, we can comp=
ute a global ratio as the composition of the each chunk ratio

> We could further enhance this estimation, taking in account also the tota=
l files sizes and their space consumed in the chunks (this could be differe=
nt due to the compression)

I wonder what would be performance implications of all that. I feel a simpl=
er
approach could work.

--=20
With respect,
Roman

--Sig_/anWG+1i.7wLZOia7hKBX5w_
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlL0Y6UACgkQTLKSvz+PZwgS9wCeNsaaDZ7LlRLcma5ZeG1AYfJP
rgsAmwbv2d+aZvOoM5DRjZohGisOwFE4
=vRqv
-----END PGP SIGNATURE-----

--Sig_/anWG+1i.7wLZOia7hKBX5w_--
