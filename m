Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34478 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750787AbcEPMqk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 16 May 2016 08:46:40 -0400
From: Pino Toscano <ptoscano@redhat.com>
To: Martin Steigerwald <martin@lichtvoll.de>
Cc: "Richard W.M. Jones" <rjones@redhat.com>, linux-btrfs@vger.kernel.org
Subject: Re: RFE: 'btrfs' tools machine readable output
Date: Mon, 16 May 2016 14:46:30 +0200
Message-ID: <1813228.1JtXuEvnc4@pendragon.usersys.redhat.com>
In-Reply-To: <3271754.bqNJ5v1fWK@merkaba>
References: <20160516121456.GA16970@redhat.com> <3271754.bqNJ5v1fWK@merkaba>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart5230763.zYmKH3r3t6"; micalg="pgp-sha256"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--nextPart5230763.zYmKH3r3t6
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="us-ascii"

On Monday 16 May 2016 14:21:07 Martin Steigerwald wrote:
> Hello Richard,
>=20
> On Montag, 16. Mai 2016 13:14:56 CEST Richard W.M. Jones wrote:
> > I don't have time to implement this right now, so I'm just posting
> > this as a suggestion/request ...
> >=20
> > It would be really helpful if the btrfs tools had a machine-readabl=
e
> > output.
> >=20
> > Libguestfs parses btrfs tools output in a number of places, eg:
> > https://github.com/libguestfs/libguestfs/blob/master/daemon/btrfs.c=

> > This is a massive PITA because each time a new release of btrfs-pro=
gs
> > comes along it changes the output slightly, and we end up having
> > to add all sorts of hacks.
> >=20
> > With machine-readable output, there'd be a flag which would
> > change the output.  eg:
>=20
> I wonder whether parsing a text based output is really the most elega=
nt method=20
> here.
>=20
> How about a libbtrfs so that other tools can benefit from btrfs tools=
=20
> functionality?

btrfs-progs is GPL v2 only, and that may be an issue for consumers
(the libguestfs daemon, the component interacting with devices and
filesystems inside the libguestfs appliance, is GPL v2+ for example).

> Of course it would likely me more effort than to implement structured=
 output.

There's this of course, which is not entirely negligible.

=2D-=20
Pino Toscano
--nextPart5230763.zYmKH3r3t6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJXOcEmAAoJEMPRTC2YZDfNB2sP/isw/P2MD0BjGEwbKhaJKPFC
19fwsxbGowv6krEi9MUEgTawKQRDyZSa3uKZpjEm6RBev+/6yfo66wY5lzHaBwhv
tN+nuOsRhfFNNTc5+Dx9bHTYXzed0ZSBx8r9jFYLW7vZ07D+CaE8zzcouo8x1KsP
yjRODi2qnszgzXfBEkTThDJLdScPwqt4MkhGJSpb3dbmbbPvgyY8yiWWHJ0lappM
0qYk2hLCA4tjW4RkSRSJtIOcQojxLY57InvZk3EQIO5t237rxmYjdSxzR824m8ww
0G71zqpV4rdZYBTyHTNNM7oX7EdgVAnV+TRUD9nVfReZD+hR9FuReNNe5MAry6vv
2Kfz7vWRiOjS067SFkAcFgFZTwJM1P13pBWvF7t35h/6KusA1sEBx/I3f1Y5h65i
yhuImcsar67c+oQZIpsIgDGvF3Kw5lhWvrLfrGf26UwCLTQjFjQ7Opcaej2AwWgw
fnsgjr3Hm4RVnoMHDdzN5E8yuoreKkxaPbnXgIkeHoLdz5QNss5r0mzTn466Xul4
Q+BHgzJsf6+2qwG30FLXHVnNjjHsmRnikXX/fI+o3qp/ChqJhzO/H41cD8+4EKQP
3RkgvhYM88Rm701Hm3jS35STTVyXZ5NLGQpbnOoviI31v2WTNAG7kNZZ+6jvuLPz
OQtiC8AucHrFFfFqY+25
=P574
-----END PGP SIGNATURE-----

--nextPart5230763.zYmKH3r3t6--

