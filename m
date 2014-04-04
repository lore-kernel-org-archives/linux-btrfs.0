Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:42071 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752502AbaDDPJI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 4 Apr 2014 11:09:08 -0400
Date: Fri, 4 Apr 2014 16:09:06 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: =?iso-8859-1?Q?Sw=E2mi?= Petaramesh <swami@petaramesh.org>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: BTRFS setup advice for laptop performance ?
Message-ID: <20140404150906.GR7442@carfax.org.uk>
References: <2692878.dRG1K49eOP@fnix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ivHc2SZskddb40s2"
In-Reply-To: <2692878.dRG1K49eOP@fnix>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--ivHc2SZskddb40s2
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 04, 2014 at 10:02:27AM +0200, Sw=E2mi Petaramesh wrote:
> Hi,
>=20
> I'm going to receive a new small laptop with a 500 GB 5400 RPM mechanical=
=20
> "ole' rust"  HD, and I plan ton install BTRFS on it.
>=20
> It will have a kernel 3.13 for now, until 3.14 gets released.
>=20
> However I'm still concerned with chronic BTRFS dreadful performance and s=
till=20
> find that BRTFS degrades much over time even with periodic defrag and "be=
st=20
> practices" etc.

   There's something funny going on here. There are, apparently, a
reasonable number of people using btrfs in daily use, with things like
snapper (regular and frequent snapshots). I'm one of them, although I
don't use snapper. We don't have lots of reports of massive slowdowns
after a long period of use, so whatever you're doing, there seems to
be something unusual involved.

   It's almost certainly not your fault, but there would appear to be
something in your configuration or your use-case which is leading to
these problems, and without knowing what's different, it's hard to set
about identifying the problem.

   What software do you run on the machine? Browser? Any databases?
Anything that contains a database? Torrents or other filesharing
software? Bitcoin mining? Bitcoin wallet? Anything else beyond the
ordinary boring desktop/office type applications? Are you compiling
lots of things (e.g. Gentoo)? Creating and deleting lots of files? If
so, large ones or small ones? Are you running very close to a full
filesystem? How are you measuring the slowdown -- do you have a
specific piece of benchmarking software, or just anecdotal evidence?

> So I'd like to start with the best possible options and have a few questi=
ons :
>=20
> - Is it still recommended to mkfs with a nodesize or leafsize different=
=20
> (bigger) than the default ? I wouldn't like to lose too much disk space a=
nyway=20
> (1/2 nodesize per file on average ?), as it will be limited...

   No, nodes are used for the metadata trees, not for file storage.
I'd suggest nodesize=3Dleafsize=3D16k or 32k. I don't think you can change
the block size at the moment.

> - Is it recommended to alter the FS to have "skinny extents" ? I've
> done this on all of my BTRFS machines without problem, still the
> kernel spits a notice at mount time, and I'm worrying kind of "Why
> is the kernel warning me I have skinny extents ? Is it bad ? Is it
> something I should avoid ?"

   As far as I know, they're considered safe and stable. I suspect
that the message is just a developer info thing that hasn't been taken
out yet.

> - Are there other optimization tricks I should perform at mkfs time becau=
se=20
> thay can't be changed later on ?

   Nodesize/leafsize are the only things you should probably change at
mkfs time. The other thing would be --mixed, but you probably don't
want that on a 500 GiB drive.

> - Are there other btrfstune or mount options I should pass before
> starting to populate the FS with a system and data ?

   I think everything else other than the above can be done after the
fact with btrfstune. I'd definitely suggest extended inode refs simply
because it fixes a known limitation.

> - Generally speaking, does LZO compression improve or degrade performance=
 ?=20
> I'm not able to figure it out clearly.

   Yes, it improves or degrades performance. :)

   It'll depend entirely on what you're doing with it. If you're
storing lots of zeroes (Phoronix, I'm looking at you), then you'll get
huge speedups. If you're storing video data, you'll get a (very)
slight performance drop as it scompresses the first few blocks of the
file and then gives up. I suspect that in general, the performance
differences won't be noticable unless you have highly compressible
large files, but if you _really_ care about it, benchmark it(*).

   Hugo.

(*) If you don't want to go through the effort of benchmarking, you
don't care enough about it, and should just pick something at random.

--=20
=3D=3D=3D Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk=
 =3D=3D=3D
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
  --- And what rough beast,  its hour come round at last / slouches --- =20
                     towards Bethlehem,  to be born?                    =20

--ivHc2SZskddb40s2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUBUz7LEVheFHXiqx3kAQKRfg//c0VmvKW0KdidxWa1VhhlJt0ZWimdMfRb
POsdP7qKcK8c54uT2055rZMIWJqBmKwTaiDL0mE0rLiBv+zXNn5FD8vKPKYrmYiS
x2vsEDTA+X0O/IRDqygL86ID5lzLlq1yV91d07ZxCiNakWxnCdxWDuLbz9JoqqYT
wimDGGFLnV1oYLPIgXSGXJYjKDqmKdwraf1j4aGmdVZN2RXgS5SedCxXFlNQcu7R
Dc2BHJNxdDwDLA089n8rGwN1httDSM+RKvBcHN4hCS1VcQSsn62XrhAzYyeWGSqP
4YLErNF4JsQjvkvmLBI7DGCugxEFHc8BDp5QdGXQAmwotYYyfE/OI2q3+acCyhLW
Ff1lPh4BfrP5/7mU1TTMZZWhBhYk44MrDcmu5ba9W1YrSGelLgwkeNOyg/oy2Nhp
bu9locgIXIGolt6zNTrNSz/Vjx6EEMwieZt7hky63vaA19SHY19i4dyObnLLUvOY
5fqZwzr54wdyFvErItdiy+jZFIIw8Fa/YZUZz4QgwQWQ+mk9809WYtx5prt7Pqxt
uwoBTtCHXyqCncohZpYFxNavaYCeC6QHBFj3gotSXJXCQBjr415lqHDg6yCd47+S
p3digCiwI/WYbZ43jUioP0R76niunoedpTLP/s+8qIyV/nG543IkGwsyhKqZdMFD
ypD8BZdF70U=
=jif3
-----END PGP SIGNATURE-----

--ivHc2SZskddb40s2--
