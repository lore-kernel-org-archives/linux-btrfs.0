Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:44579 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751839AbbALRtR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 12 Jan 2015 12:49:17 -0500
Date: Mon, 12 Jan 2015 17:49:16 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Holger =?iso-8859-1?Q?Hoffst=E4tte?=
	<holger.hoffstaette@googlemail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Stuck balance, 3.18.0
Message-ID: <20150112174916.GP32182@carfax.org.uk>
References: <20150112112158.GM32182@carfax.org.uk>
 <20150112122710.GO32182@carfax.org.uk>
 <pan.2015.01.12.13.36.27@googlemail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rQ7Ovc9/RBrrr0/1"
In-Reply-To: <pan.2015.01.12.13.36.27@googlemail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--rQ7Ovc9/RBrrr0/1
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 12, 2015 at 01:36:27PM +0000, Holger Hoffst=E4tte wrote:
> On Mon, 12 Jan 2015 12:27:12 +0000, Hugo Mills wrote:
>=20
> > On Mon, Jan 12, 2015 at 11:21:58AM +0000, Hugo Mills wrote:
> >>    I've just added a new disk to my main storage filesystem. Running
> >> the obligatory balance to spread the data out, it's managed about 14%
> >> of the job, and then has gone into some kind of tight loop. No chunks
> >> have been found or balanced in the last 2 hours, and one kworker thread
> >> is pegged at 100%. There were no unusual or unexpected messages in the
> >> logs. Balance cancel has been waiting for the last 10 minutes without
> >> effect (as would be expected with the other symptoms).
> >=20
> >    OK, an hour after I executed the cancel, and three hours after it
> > apparently jammed up, the cancel completed. I have restarted the balance
> > from the point it left off, and I'll see if it does something similar
> > again.

   I think it's having problems with metadata chunks -- either
directly with the fact that it's metadata, or with the fact that
there's tens of thousands of extents in the block group. The last
thing in my dmesg at the moment is:

[161779.883848] BTRFS info (device sdg2): relocating block group 1228584622=
4896 flags 20

after 29 other successful block group relocations of type 17
(data/RAID-1). It's been on this one (type 20; metadata/RAID-1) for a
couple of hours at least. I'm going to let it run and see when (if) it
gets off this block group and moves on to a new one.

> I've looked through the patches I use since 3.18.0 and nothing too=20
> obvious stood out (to me), except for several patches from Filipe for=20
> fixes that revolve around the chunk reaper, which sound like they might=
=20
> result in confused threads. Also moving to 3.18.2 probably won't hurt,=20
> it's not like there are no bugs in the kernel itself -  I recently=20
> managed to find a really wrong corner case in NFS that has gone unnoticed=
=20
> since 3.16.

   I'll have a go with that when I next get the chance to reboot that
machine.

> Finally: instead of balancing everything at once maybe try a piecemeal=20
> approach with the limit filter? Wrap it in a script, spread out the work=
=20
> of balancing 3-5 chunks a time..

   Not sure that'll help. It's just hitting these occasional block
groups and coming to a grinding halt for hours before continuing.

   Hugo.

--=20
Hugo Mills             | You are not stuck in traffic: you are traffic
hugo@... carfax.org.uk |
http://carfax.org.uk/  |
PGP: 65E74AC0          |                                    German ad campa=
ign

--rQ7Ovc9/RBrrr0/1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJUtAkbAAoJEFheFHXiqx3kRtgQALz03eXwXu1gmvuLnjUIeprE
lxMMd4kzbf7mxdL+QM6ZK6XrXIbzdL9S3W6ZyN8htWTk5+eG3ymBQg9bXZEtq4/u
5CSBo1hNOXRwra9Mv9/vKlaaUOj8AolNucB+VjQQJVa/lj0K1s1a4YXvMt1H1BZu
tB7p8jwpokCqOG5GkQFLEooSxGrthYev2EWcM66yUv1JqySt1KBNLAHrHjUrpQmg
AE8Cf9Sciduz2v2a3QGs9aOzo4EiEn8+saAyu49kOW3Uv7pFB4iK0jnbYy1JlTZj
nSW7UdijCz6XYHowUCi3UoXQj8mUFjP1qoWESuPLLRujzY/HT2Rwu6+g3qLffqys
eehHta0DmI9cgOUwuucLytzkjhc4tzdiLI7yBAKpSTq95RwudkCO0gQyKDh/ERY3
mvHQZgMaKXLdydy7YvFjFmFsP+Wq8ZTtCR5SXfbMFtp26ShIC7jbr5+FKPigxoE1
38Ol5ew3xK2cGj/6NsG81ouSmBR6cqIHnQtfn+V5AOLOtLSoz/rdY5D8k1L1ZN/P
2usnfsWbMYje9o3br9GJm8paY+Tu7SRFuLX8iXJTf8qm4/gcL9TGv4zbPbGaJM3o
ULpqI8YgDOpOVE4NsiTQtMca93GplSJ181xeuCN4Xl1QyySEy5DjDoZKYsw72z4z
Yn1d3Inyw9jWfThwyvNK
=UVR+
-----END PGP SIGNATURE-----

--rQ7Ovc9/RBrrr0/1--
