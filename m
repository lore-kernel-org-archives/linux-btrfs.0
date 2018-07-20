Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:46913 "EHLO
        frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731939AbeGTTbd (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 20 Jul 2018 15:31:33 -0400
Date: Fri, 20 Jul 2018 18:41:59 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Andrei Borzenkov <arvidjaar@gmail.com>
Cc: kreijack@inwind.it, Duncan <1i5t5.duncan@cox.net>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/4] 3- and 4- copy RAID1
Message-ID: <20180720184159.GD21293@carfax.org.uk>
References: <cover.1531503452.git.dsterba@suse.com>
 <9945d460-99b5-a927-a614-c797bbc7862d@dirtcellar.net>
 <d340ce28-6c93-22d4-0f56-73de8e55f1f6@libero.it>
 <pan$b5258$f3ecc84$8e06948b$54511335@cox.net>
 <793d8ec3-7934-ea60-521d-7a039c9f1ce9@libero.it>
 <pan$98af2$39851f53$ef9fd141$bfd51f5b@cox.net>
 <89d20da9-0e80-51d1-3a4f-4cccb44d31ef@libero.it>
 <2f1b19da-f2a2-077b-eee1-1106f40679ac@gmail.com>
 <b9ccc6fa-da45-4038-7911-ba012371f223@inwind.it>
 <1066d34f-2703-19e3-62ea-c4178640b8c3@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="xB0nW4MQa6jZONgY"
In-Reply-To: <1066d34f-2703-19e3-62ea-c4178640b8c3@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--xB0nW4MQa6jZONgY
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 20, 2018 at 09:38:14PM +0300, Andrei Borzenkov wrote:
> 20.07.2018 20:16, Goffredo Baroncelli =D0=BF=D0=B8=D1=88=D0=B5=D1=82:
[snip]
> > Limiting the number of disk per raid, in BTRFS would be quite simple to=
 implement in the "chunk allocator"
> >=20
>=20
> You mean that currently RAID5 stripe size is equal to number of disks?
> Well, I suppose nobody is using btrfs with disk pools of two or three
> digits size.

   But they are (even if not very many of them) -- we've seen at least
one person with something like 40 or 50 devices in the array. They'd
definitely got into /dev/sdac territory. I don't recall what RAID level
they were using. I think it was either RAID-1 or -10.

   That's the largest I can recall seeing mention of, though.

   Hugo.

--=20
Hugo Mills             | Have found Lost City of Atlantis. High Priest is
hugo@... carfax.org.uk | winning at quoits.
http://carfax.org.uk/  |
PGP: E2AB1DE4          |                                       Terry Pratch=
ett

--xB0nW4MQa6jZONgY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJbUiz3AAoJEFheFHXiqx3k15wP/RCCudkDP4UW1KwQi99MiBBe
bDJzGAZJBCwZbP7ISgn6xaDFFyqk3FoxXocpbMG9b+5RVj7/Fm6rsZuIk/Z3AVJM
//jW2NHR3RvdtqJUY7L7JDmzSnt924mxdj+NhtS0JXVm5RRknFz//Xq2Dozr2Wo3
d5k5EzNM7r2o5nnMgXddtYV2IHJ8+PsoXHwJVcFuCnsHx3hw/oDS3VKnwTCKMjq2
GNRPGfYi6e85M5s5Rtd/ttima34gO1+zlf3kpoLw/SaKCW+QX8KGbPl9mSQV83Er
Uf32skE6N+CGJ8L0kTIPYKizmGynmHGs658wDa2X10flVcfp9H5L5bwtTIYfLr5N
lD6Yjf/CFgkjln3vSIjMvECCERnhfNTnQO9q6J+3njqv/4sL1XiS2EzuZkAX+6RR
1+vws31qIyrZ4m1BEhFpK9fgZK0RPI0E/YATFxpGtvrfql3HQTpB6FWPQsPU7TLO
WC6Qz1CeKPjp+2cLmvc5xxCnIj02b1WwJu8KMjv8CGSSMNCHkbKPTmkayB+XFa59
FhAcmpTH3T73opM/sbA8vu6fau7kwI+W8sD/xNItbIsW++4kb6AJtnUG2xXCjlF/
7ZDyP4Q0j9K6hM5t3BB7ST8Ru6Mea85cpW84+OUCM0akdGNBlsmdPGkDc6SPURIb
ka7DeIMynQGgIUrixKGO
=/vim
-----END PGP SIGNATURE-----

--xB0nW4MQa6jZONgY--
