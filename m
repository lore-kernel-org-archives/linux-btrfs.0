Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:59339 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753311AbbKGTIl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 7 Nov 2015 14:08:41 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1Zv8qp-00039w-Rh
	for linux-btrfs@vger.kernel.org; Sat, 07 Nov 2015 20:08:35 +0100
Received: from chello213047196183.tirol.surfer.at ([213.47.196.183])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 07 Nov 2015 20:08:35 +0100
Received: from wertstoffe by chello213047196183.tirol.surfer.at with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 07 Nov 2015 20:08:35 +0100
To: linux-btrfs@vger.kernel.org
From: =?UTF-8?Q?Jakob_Sch=c3=bcrz?= <wertstoffe@nurfuerspam.de>
Subject: boot from snapshot and take snapshot from here.
Date: Sat, 7 Nov 2015 20:04:01 +0100
Message-ID: <4iu1hc-23v.ln1@aldebaran.xundeenergie.at>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="33QrAwNQrdr69cvHKJ1M9CbTn673k7od7"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--33QrAwNQrdr69cvHKJ1M9CbTn673k7od7
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi there!

I can't find any Information for my Problem. And I try to explain, what
I want.

There is a btrfs-partition on my laptop.
I take snapshots every hour from the subvolume @debian.

btrfs subvol snapshot @debian @debian-snap1

Then I transfer this snapshot to my external HD

btrfs send @debian-snap1 | btrfs receive /backupmountpoint

The next snapshot

btrfs subvol snapshot @debian @debian-snap2

Transfer is

btrfs send -p @debian-snap1 @debian-snap2|btrfs receive /backupmountpoint=


No magic here, works fine.

BUT

When i boot from f.e. @debian-snap2, the mechanics doesn't work any longe=
r.

btrfs subvol snapshot @debian-snap2 @debian-snap3

this works.

btrfs send -p @debian-snap2 debian-snap3 | btrfs receive /backupmountpoin=
t

gives me an error, that btrfs can't find a subvol with a proper ID.

Ho to do this, if i want to boot from a former snapshot (in case of a
mistaken system-upgrade) and i want to transfer the later snapshots to
the external HD - only the differences?

There is nothing on the internet on this problem (I've found). But i
think this is a usecase, which I'm not alone needing it...

jakob

--=20
http://xundeenergie.at
http://verkehrsloesungen.wordpress.com/
http://cogitationum.wordpress.com/


--33QrAwNQrdr69cvHKJ1M9CbTn673k7od7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJWPkskAAoJEF2YPOCqoD05+8YH/jnBW0aLb52zL9i0Ceft6XxD
IkEpAK9gw8N7IlH7LRK6hcXVUsnpDBJvxQFcaXkPe7V1HSe0i6DZCeiUe3uUeVee
KtDIiaKb2Z0vTJ61rkUZ4kAoD1iM9BOQ4Jgvt1Ywj1uc5s15OxuQ/FN+lirPqN5C
tnwpOuAEC0vO2dpCR42xTj40qWaZ9dNZ+xQjmqG9UpglHoJ6VaNyBwmS+0O8fB72
Wq6yYQYNWDW//a1kSAlDftCdRw9nJHnXnvM738ycsr6aJjOtP3Z9iThYKHTPZ3kC
HNOJ4bzxJOcn7Q2AmhUTiTabC3KyULoW+oPtc3znWNuEkaCCIr3TShkQT81SgjQ=
=uqs5
-----END PGP SIGNATURE-----

--33QrAwNQrdr69cvHKJ1M9CbTn673k7od7--

