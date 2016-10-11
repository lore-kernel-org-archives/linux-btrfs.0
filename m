Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:56136 "EHLO
        frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754044AbcJKRNa (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 11 Oct 2016 13:13:30 -0400
Date: Tue, 11 Oct 2016 16:06:01 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Philip Louis Moetteli <Philip.Moetteli@unige.ch>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: RAID system with adaption to changed number of disks
Message-ID: <20161011160601.GI7683@carfax.org.uk>
References: <D379E551-1272-4548-9601-0CE4C1A8C012@unige.ch>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="FUFe+yI/t+r3nyH4"
In-Reply-To: <D379E551-1272-4548-9601-0CE4C1A8C012@unige.ch>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--FUFe+yI/t+r3nyH4
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 11, 2016 at 03:14:30PM +0000, Philip Louis Moetteli wrote:
> Hello,
>=20
>=20
> I have to build a RAID 6 with the following 3 requirements:
>=20
> 	=E2=80=A2 Use different kinds of disks with different sizes.
> 	=E2=80=A2 When a disk fails and there's enough space, the RAID should be=
 able to reconstruct itself out of the degraded state. Meaning, if I have e=
=2E g. a RAID with 8 disks and 1 fails, I should be able to chose to transf=
orm this in a non-degraded (!) RAID with 7 disks.
> 	=E2=80=A2 Also the other way round: If I add a disk of what size ever, i=
t should redistribute the data, so that it becomes a RAID with 9 disks.
>=20
> I don=E2=80=99t care, if I have to do it manually.
> I don=E2=80=99t care so much about speed either.
>=20
> Is BTrFS capable of doing that?

1) Take a look at http://carfax.org.uk/btrfs-usage/ which will tell
   you how much space you can get out of a btrfs array with different
   sized devices.

2) Btrfs's parity RAID implementation is not in good shape right
   now. It has known data corruption issues, and should not be used in
   production.

3) The redistribution of space is something that btrfs can do. It
   needs to be triggered manually at the moment, but it definitely
   works.

   Hugo.

--=20
Hugo Mills             | We are all lying in the gutter, but some of us are
hugo@... carfax.org.uk | looking at the stars.
http://carfax.org.uk/  |
PGP: E2AB1DE4          |                                           Oscar Wi=
lde

--FUFe+yI/t+r3nyH4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJX/Q3pAAoJEFheFHXiqx3kJ5IQALnwIC3BwYy+OvfQgGnz/Lur
dsEkkUAZ8o2XjX9XWFaxc+g4JDVU91FjS3sGTU6bKo2HavL2hiQdTF8gW+TM8zQC
M8o1spDfeICaf9sZgT+xZB5CVsuY3LLhhKkZYTBuzmaLyTE+mw8qb77wT9eNWxNM
0BS+2bC9DRKDTDT3mdxra0Jpo5kVdUqsB2mTzA34O12XOGUf4fxeNwlpShr7eRbM
GxQswWCLcMfwxoH5LovV57ZzI4s2FlGo9wY3qHZVTaFn03zifEvfMnip8GWXmuGA
JRyEnPD2lt6RoTS1rQXjx538PZHzpWzbLXClfnbvJGkS7efhuygu+RXNjVsvW0Ou
57W56ri1RzIEbI/+3XDS7I/wMhgp7cR4R0iyvplOD1/4/e4i71Om8idPXTfey6Jq
vtOGj62e4YUoS2/rNE66kaOkiCYJPXr+nGmm+yVR8KA3EI6l0iG6vJmAtYkSsyFJ
/deAU9YERdm88UQj9rQRjof6NCL68wXYZpbgHNWRPDWTO8SVN0y3XnCLRzmrZScL
N1jNZkTUBiljKAgLg546nZzGQ94T2HLoC+uPR0NjJH/s4wM6Vo4g1xFUkRQMAaYP
TDNhLo3yrj2CHkquEd4V4pIAN6rHwO4biiGqAvQplsjIjUhM5RMm3XPs/Bx8n+pJ
kVV16jEjXCe7iPi6+5dD
=5qDE
-----END PGP SIGNATURE-----

--FUFe+yI/t+r3nyH4--
