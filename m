Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:41710 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932113AbcBHXFG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 8 Feb 2016 18:05:06 -0500
Date: Mon, 8 Feb 2016 23:05:02 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: boli <btrfs@bueechi.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: "layout" of a six drive raid10
Message-ID: <20160208230502.GG30635@carfax.org.uk>
References: <1E2010FD-CBFD-44BD-B5DB-9ECD5C009391@bueechi.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+1TulI7fc0PCHNy3"
In-Reply-To: <1E2010FD-CBFD-44BD-B5DB-9ECD5C009391@bueechi.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--+1TulI7fc0PCHNy3
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 08, 2016 at 11:19:52PM +0100, boli wrote:
> Hi
>=20
> I'm trying to figure out what a six drive btrfs raid10 would look like. T=
he example at <https://btrfs.wiki.kernel.org/index.php/FAQ#What_are_the_dif=
ferences_among_MD-RAID_.2F_device_mapper_.2F_btrfs_raid.3F> seems ambiguous=
 to me.
>=20
> It could mean that stripes are split over two raid1 sets of three devices=
 each. The sentence "Every stripe is split across to exactly 2 RAID-1 sets"=
 would lead me to believe this.
>=20
> However, earlier it says for raid0 that "stripe[s are] split across as ma=
ny devices as possible". Which for six drives would be: stripes are split o=
ver three raid1 sets of two devices each.
>=20
> Can anyone enlighten me as to which is correct?

   Both? :)

   You'll find that on six devices, you'll have six chunks allocated
at the same time: A1, B1, C1, A2, B2, C2. The "2" chunks are
duplicates of the corresponding "1" chunks. The "A", "B", "C" chunks
are the alternate stripes. There's no hierarchy of RAID-0-then-RAID-1
or RAID-1-then-RAID-0.

> Reason I'm asking is that I'm deciding on a suitable raid level for a new=
 DIY NAS box. I'd rather not use btrfs raid6 (for now). The first alternati=
ve I thought of was raid10. Later I learned how btrfs raid1 works and figur=
ed it might be better suited for my use case: Striping the data over multip=
le raid1 sets doesn't really help, as transfer from/to my box will be limit=
ed by gigabit ethernet anyway, and a single drive can saturate that.
>=20
> Thoughts on this would also be appreciated.

> As a bonus I was wondering how btrfs raid1 are layed out in general,
> in particular with even and odd numbers of drives. A pair is
> trivial. For three drives I think a "ring setup" with each drive
> sharing half of its data with another drive. But how is it with four
> drives =E2=80=93 are they organized as two pairs, or four-way, or =E2=80=
=A6

   The fundamental unit of space allocation at this level is the chunk
-- a 1 GiB unit of storage on one device. (Or 256 MiB for metadata).
Chunks are allocated in block groups to form the RAID behaviour of the
FS.

   So, single mode will allocate one chunk in a block group. RAID-1
and -0 will allocate two chunks in a block group. RAID-10 will
allocate N chunks in a block group, where N is the largest even number
equal to or smaller than the number of devices [with space on]. RAID-5
and -6 will allocate N chunks, where N is the number of devices [with
space on].

   When chunks are to be allocated, they devices are ordered by the
amount of free space on them. The chunks are allocated to devices in
that order.

   So, if you have three equal devices, 1, 2, 3, RAID-1 chunks will be
allocated to them as: 1+2, 3+1, 2+3, repeat.

   With one device larger than the others (say, device 3), it'll start
as: 3+1, 3+2, 3+1, 3+2, repeating until all three devices have equal
free space, and then going back to the pattern above.

   Hugo.

--=20
Hugo Mills             | Well, you don't get to be a kernel hacker simply by
hugo@... carfax.org.uk | looking good in Speedos.
http://carfax.org.uk/  |
PGP: E2AB1DE4          |                                         Rusty Russ=
ell

--+1TulI7fc0PCHNy3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJWuR8eAAoJEFheFHXiqx3kzuYP+QHG5UHAUBuDzISoC44Kq6tO
7U15xOJphB5tXpfaOkVXFhbxQf9L+Y24MBmLV0wBaJZIGHhnJ3aV+Bjbdmf2VDwV
Amnuw3IjCeARK2rU9wXaQh8Arnwza6qeR7lIgf1tFAyeb5KF0O02Cr/OllJK5Gz6
znOUuV0PHPjhxvonr5YzsEhxBwahPvQVIXQsJ9S8QPOIhEXGOg7P8i3teLbU4NO9
vQvt8HhEJ322EqWFAJGXMVDfWkfgc+sAF7n3OVxqOlYR1dg//Y7S13T/hZ05QZLl
TFau8HMiWZpeJYIpeqlPet9E6NSTIrjB3HTYUu5yz3lNwJHJesGdVti4bbH8cuCN
BHSn9b76AxNQei+zm/ARhGbHhYZIaTJoPL/yDBgqYSa8CPQ9UNmq1P+2BhSXziao
8AAVd0uOGshreHtGSHtMTWcRcvmmiicVl7EfDMTT7kZo2B8IVt6kf2iMmkC0xoPF
ibh2aLFyoLOuACNQOOfkCgy69t08x1+1h+E8CRK8fyoklFAMjlf30kRDWspWlhfE
R61Yb2DDIvdXqEUEGZZwk7XUF0AQVRx7QxPcYqQnmgqdGEYHXeAYmaodNUd7QHhM
LGB0x/VCujbJSZiFR/tlc7ycM1M5O1C43o6Q/xklQ5xGhDI6UI5JMDlLF2cxXicB
ppP7Ku6asaUb7MvvfuY7
=kg8M
-----END PGP SIGNATURE-----

--+1TulI7fc0PCHNy3--
