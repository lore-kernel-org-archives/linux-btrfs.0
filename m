Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:44503 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750942Ab3KPMXp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 16 Nov 2013 07:23:45 -0500
Date: Sat, 16 Nov 2013 12:23:42 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Anatol Pomozov <anatol.pomozov@gmail.com>
Cc: linux-btrfs@vger.kernel.org, Frank Holton <fholton@gmail.com>
Subject: Re: How to fix/remove "csum failed ino" error
Message-ID: <20131116122342.GT4315@carfax.org.uk>
References: <CAOMFOmUDd0jS=R+MAVwfwmNj7Bt9VUM46b8zYmC59BA65qhUfA@mail.gmail.com>
 <CAC4gV=7FgL=wixYf6w-yfuZNbz8QCt5t9T8_jStjpkKgTBc+Vw@mail.gmail.com>
 <CAOMFOmXj=-8g6hYs_qcj417OUmgLEGdms2kMzUdorCuxJ7292w@mail.gmail.com>
 <CAOMFOmWee0NX=ZmcdG2FpkKyu-XLC5druy-Cn5+6ZAZa34WdZg@mail.gmail.com>
 <CAC4gV=6yDhYHfWHOer_uVYZ8dgCQ5C=7JXkN3rpkXs=tH_jPZQ@mail.gmail.com>
 <CAOMFOmWB0ojMDAFF=AJti6Nit+3UUutYDYaAVgnfM113aVRVGg@mail.gmail.com>
 <CAOMFOmUXKntgXnOTV=ZVPs==1Tun4KZg-_oGxaiM5Xc5NpP2zA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3ig5MTpp3LwprTX9"
In-Reply-To: <CAOMFOmUXKntgXnOTV=ZVPs==1Tun4KZg-_oGxaiM5Xc5NpP2zA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--3ig5MTpp3LwprTX9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Nov 16, 2013 at 04:06:10AM -0800, Anatol Pomozov wrote:
> Hi
> 
> Follow-up for the issue. I stuck with this "invalid csum for free
> space extent" error. Could anyone explain what does it mean? If this
> is not data and just a free space, why do we care about its checksum?
> And if we do really care then btrfs should have a way to fix this
> error. I can "fix" a file checksum error by removing the file, but how
> to "fix" free space extent checksum error?

   Probably drop the free space cache and rebuild it.

> I decided to run --init-csum-tree to see if it fixes the issue with
> free space csum. I expected that it will recalculate csum for data.
> And found that it cleared csum tree completely and made my fs became
> unusable. Any read returns csum error. The data is still on disk - I
> can read it with filefrag+btrfs-map-logic+dd - it is just csum
> information that got dropped. So I want to echo the request from Robin
> http://www.spinics.net/lists/linux-btrfs/msg25271.html
> Information about --init-csum-tree should be documented. What is the
> use-case for this feature? In fact I expected that it will recalculate
> the csum tree based on the data, not clear the tree.

   There's a patch in the pipeline that makes --init-csum-tree rebuild
the csums as well.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
    --- I write in C because using pointer arithmetic lets people ---    
               know that you're virile. -- Matthew Garrett               

--3ig5MTpp3LwprTX9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIVAwUBUodjzVheFHXiqx3kAQKdjRAAu2lSOWPkVAsXSE1EGvBaBzTiFq22GNRm
rke6uN0siVCdagX5VvTiCoe+//p4djywmuMnk7hiL2Ho88/cYbBARNngKhKUvwUg
d0ED15GAl4ufwPRmQ6gwqPBeNkUZF3JW9Gu6pfKCpbWpfraRh4OPlY5gfqzHlSUB
hs7Z7RobrnZveQYbh9JPkLZO2rXD04l5UmLN3mah95HMEY+Q9NADevb10ISaaCYg
7XfgmnPNjBr/96anEcwunY3pe/CFeM7kXWGILjl416K+Z5CfrfW3lpqkPhqPdurY
ldi9zgfFTZ/LhMLBJJ/g49+x8BQjgl3+fv8KX2zM0Nda0xJoXi0KPrmkYjFtK58n
3bSQRMo3ZmSCdciV3ZVUK4OKaW+XnaazwUVHrM/bcUDT2xAYzaU5SJdOVkJW6p+l
tkbehHoB82xDvRYvPiylr5TMGjT7WLGxwPbMiEJ2TpoDNeYQtKz2Ku2sLaeqVvCf
rxwQ98Qp53yQMPVv7NhD1LrG6rQgQOsh7l0xGVMWScMzPpq2qeLWX12Xdja802w1
zv/XG0E7SUhkpMdipUWXGR6L4LogHsClsvRG7w7dCFEWgPrKa9fWCfYbRjCU8zU+
4bI/QyL2Gn9oZdYmedf4xBJTdq1g2BsyrtjNaf/27gnc2KX1MVnsCADHSDPRCc+6
HbN8GvvKmpA=
=qi36
-----END PGP SIGNATURE-----

--3ig5MTpp3LwprTX9--
