Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:48994 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754317AbaIKLih (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 11 Sep 2014 07:38:37 -0400
Date: Thu, 11 Sep 2014 12:38:33 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: Austin S Hemmelgarn <ahferroin7@gmail.com>
Cc: russell@coker.com.au, linux-btrfs@vger.kernel.org
Subject: Re: No space on empty, degraded raid10
Message-ID: <20140911113833.GL5783@carfax.org.uk>
References: <CAL-Saa_3uU936baHYjVOHXMVkNtP4mgLD6WuPUu2Wxw4SaPrzQ@mail.gmail.com>
 <540D8C7A.4030700@gmail.com>
 <201409111640.23845.russell@coker.com.au>
 <54118524.1010006@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="T4Djgzn3z2HSNnx0"
In-Reply-To: <54118524.1010006@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--T4Djgzn3z2HSNnx0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Sep 11, 2014 at 07:19:00AM -0400, Austin S Hemmelgarn wrote:
> On 2014-09-11 02:40, Russell Coker wrote:
> > Also it would be nice if there was a N-way mirror option for system data.  As 
> > such data is tiny (32MB on the 120G filesystem in my workstation) the space 
> > used by having a copy on every disk in the array shouldn't matter.
> 
> N-way mirroring is in the queue for after RAID5/6 work; ideally, once it
> is ready, mkfs should default to one copy per disk in the filesystem.

   Why change the default from 2-copies, which it's been for years?

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
             --- Ceci est un travail pour l'Australien. ---              

--T4Djgzn3z2HSNnx0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUBVBGJuVheFHXiqx3kAQLRuA//SZXzUd049G2ksderTiWOBb4hqE19shK9
fvnrOFcSCBYgJlZGNBb8IWl/2HlvnRX/56TyP0pdtz4omA6f8RFKoPUWzgJw2aEp
fm16DdxJHDPXYoi4ORb25SHzJ9mNA/l4vmF90e6yW+9tuIts/UF3Pr0h/CHUGpkS
ape6+5Q63uyMM9wVDRAF8jNGiBxyqcEWYUweInu81HO3Xrq/IJM7NPl8KfzfgOij
K7thFGIcIXpOyYVtlcOqhUYNygF+O4g/sMOoG999eSI3seG+Ffhl2ePpq33uvJaD
keahyFzwbbJTSxe2bHCBvkyjdoiw3HzNeJeP2Tur9XFkYgcxY+92V6r7TgvR+GrM
FMmnIc41sSIEHbv+FS72NgWwtoby7uyYUH2cg4BlfM69WE3a1JNiaFpFRYfv02F7
emQClOdFbdnVivG+5pnxySP2ACeoKajZzNFuHiGdWN9HZLoUpMfCbt+RgcQH0nZt
B0p2RKxCK5RKSUWqVmep6i0gSSJow269/17Fuko8ClBnhD6vzUw1n0z0t+ariSCy
MIo7zJOHrrt82J0uQj85xGLVyu0JZtchyBwW+aiiSRMl8XHXOmTvBqW99dGo0GAf
bWWxBgjLWl4yUlLMTLsWW4nFAwZWEBPeuMpILyPC860T7V2WOSYGERpfsLpxmgDL
F4xx39RtVTk=
=eP3A
-----END PGP SIGNATURE-----

--T4Djgzn3z2HSNnx0--
