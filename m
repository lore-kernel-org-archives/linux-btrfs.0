From: =?iso-8859-1?Q?Jo=E3o_Eduardo_Lu=EDs?= <jecluis@gmail.com>
Subject: Fwd: Backref walking utilities
Date: Mon, 23 May 2011 12:42:47 +0100
Message-ID: <C10E871D-B532-4521-8D10-237F6B6974B3@gmail.com>
References: <29C9FCE8-F9FB-425A-B346-09939CC0A9FE@gmail.com>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=pgp-sha1; boundary="Apple-Mail-23--721230700"
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--Apple-Mail-23--721230700
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=iso-8859-1

My apologies. Sent this from my mobile and forgot to send it to the =
list.

---
Jo=E3o Eduardo Lu=EDs
gpg key: 477C26E5 from pool.keyserver.eu=20


Begin forwarded message:

> From: Jo=E3o Eduardo Lu=EDs <jecluis@gmail.com>
> Date: May 23, 2011 11:22:51 AM GMT+01:00
> To: Hugo Mills <hugo@carfax.org.uk>
> Subject: Re: Backref walking utilities
>=20
>=20
> On May 23, 2011, at 11:15 AM, Hugo Mills wrote:
>=20
>> On Mon, May 23, 2011 at 12:02:21PM +0200, Arne Jansen wrote:
>>> Hi liubo,
>>>=20
>>> On 23.05.2011 11:53, liubo wrote:
>>>> As one of my plans, I'm going to take this project over unless =
someone has been working on it.
>>>=20
>>> Jan Schmidt has a patch for scrub nearly ready, that does some
>>> ref-walking to report affected files to the user. While this is
>>> kernel code and you're planning to add user-space code, it might
>>> still be possible to share some of it. Maybe the efforts can be
>>> coordinated.
>>=20
>>  Another use for walking backrefs for a block (or an extent) is to
>> work out the differential size of a snapshot -- i.e. how much space
>> will be freed up if the snapshot is deleted. (You need to look at
>> every extent of every file in the snapshot, and work out whether =
those
>> extents are used anywhere outside the subvolume).
>=20
> Which, I believe, would be useful if one wanted to merge two diverging =
snapshots into one.
>=20
> As I'm doing some research on this topic, I would be thankful if =
anyone pointed me to Jan Schmidt's patch.=20
>=20
>=20
> - J
>=20
> ---
> Jo=E3o Eduardo Lu=EDs
> gpg key: 477C26E5 from pool.keyserver.eu=20
>=20
>=20
>=20
>=20
>=20


--Apple-Mail-23--721230700
content-type: application/pgp-signature; x-mac-type=70674453;
	name=PGP.sig
content-description: This is a digitally signed message part
content-disposition: inline; filename=PGP.sig
content-transfer-encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.16 (Darwin)

iQEcBAEBAgAGBQJN2kg7AAoJEJ9vvxhHfCbl6GwH/3PLUqNa2RvfE/ZBWWOJsqC1
fDFa2GbgLsarPNEGWyQBwepJ3L9yBl6syWqWGuufLWcfGAYHYOXewh0B/CqbHPZD
e7PTjr0oZxE27dddmRbQuUjkYh+GjFgKrkBBpPauMyPa8/zY0zOjadUC1oDOHWZi
XLwq+bt47yD40MaQSxfUpbUdZuScsQsLln/+bt48JGKKBTHhbnpecTcunVadfG6z
8KnlyHKiLti+DmJlgHYWPgVVkJo0rK0KYD+lZvxa+hOarDs/1PP0RRS+KK5hBae3
zMCkxfMpOw8qhKU8vDjzVzo2pi27xsUOYSnebeDRxuFSTAx3IyUMOYHGDsOF2fc=
=LzH1
-----END PGP SIGNATURE-----

--Apple-Mail-23--721230700--
