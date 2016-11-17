Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:33764 "EHLO
        james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751688AbcKQDCZ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 16 Nov 2016 22:02:25 -0500
Date: Wed, 16 Nov 2016 22:01:52 -0500
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: =?iso-8859-1?Q?Niccol=F2?= Belli <darkbasic@linuxsystems.it>
Cc: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        James Pharaoh <james@wellbehavedsoftware.com>,
        Mark Fasheh <mfasheh@versity.com>, linux-btrfs@vger.kernel.org
Subject: Re: Announcing btrfs-dedupe
Message-ID: <20161117030150.GM21290@hungrycats.org>
References: <345b3aa4-6644-6730-09dd-549d320f58cb@wellbehavedsoftware.com>
 <20161114180714.GF21290@hungrycats.org>
 <a4e42724-d84a-e4f9-a3ea-d1fec31a5629@wellbehavedsoftware.com>
 <dfb1372d-8bff-93ff-1ba7-d636e6c7fe4d@gmail.com>
 <20161114195102.GI21290@hungrycats.org>
 <4389716b-8082-ef89-7efc-60c2ae6b7db6@gmail.com>
 <20161114211013.GJ21290@hungrycats.org>
 <0b8cd1f0-fca4-b7df-2f41-13c40aee493d@gmail.com>
 <20161115175201.GL21290@hungrycats.org>
 <138b6c00-fb34-492b-92ae-d13630e0bb04@linuxsystems.it>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="z8Ydz/NZAVzoOg+6"
In-Reply-To: <138b6c00-fb34-492b-92ae-d13630e0bb04@linuxsystems.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--z8Ydz/NZAVzoOg+6
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 16, 2016 at 11:24:33PM +0100, Niccol=F2 Belli wrote:
> On marted=EC 15 novembre 2016 18:52:01 CET, Zygo Blaxell wrote:
> >Like I said, millions of extents per week...
> >
> >64K is an enormous dedup block size, especially if it comes with a 64K
> >alignment constraint as well.
> >
> >These are the top ten duplicate block sizes from a sample of 95251
> >dedup ops on a medium-sized production server with 4TB of filesystem
> >(about one machine-day of data):
>=20
> Which software do you use to dedupe your data? I tried duperemove but it
> gets killed by the OOM killer because it triggers some kind of memory lea=
k:
> https://github.com/markfasheh/duperemove/issues/163

Duperemove does use a lot of memory, but the logs at that URL only show
2G of RAM in duperemove--not nearly enough to trigger OOM under normal
conditions on an 8G machine.  There's another process with 6G of virtual
address space (although much less than that resident) that looks more
interesting (i.e. duperemove might just be the victim of some interaction
between baloo_file and the OOM killer).

On the other hand, the logs also show kernel 4.8.  100% of my test
machines failed to finish booting before they were cut down by OOM on
4.7.x kernels.  The same problem occurs on early kernels in the 4.8.x
series.  I am having good results with 4.8.6 and later, but you should
be aware that significant changes have been made to the way OOM works
in these kernel versions, and maybe you're hitting a regression for your
use case.

> Niccol=F2 Belli
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--z8Ydz/NZAVzoOg+6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlgtHZsACgkQgfmLGlazG5xazQCgqLQkxwwTxX4SUOhjjEl6Ufbj
DTcAoJzH5GVs1jKJ2B2JsnBpr4Z+ajzy
=YUa/
-----END PGP SIGNATURE-----

--z8Ydz/NZAVzoOg+6--
