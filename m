From: "Brian J. Murrell" <brian@interlinx.bc.ca>
Subject: interesting use case for multiple devices and delayed raid?
Date: Wed, 01 Apr 2009 05:17:27 -0400
Message-ID: <1238577447.9099.150.camel@pc.interlinx.bc.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-pQgu4EMzTGMpM3r+rkhZ"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


--=-pQgu4EMzTGMpM3r+rkhZ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

I have a use case that I wonder if anyone might find interesting
involving multiple device support and delayed raid.

Let's say I have a system with two disks of equal size (to make it easy)
which has sporadic, heavy, write requirements.  At some points in time
there will be multiple files being appended to simultaneously and at
other times, there will be no activity at all.

The write activity is time sensitive, however, so the filesystem must be
able to provide guaranteed (only in a loose sense -- not looking for
real QoS reservation semantics) bandwidths at times.  Let's say slightly
(but within the realm of reality) less than the bandwidth of the two
disks combined.

I also want both the metadata and file data mirrored between the two
disks so that I can afford to lose one of the disks and not lose (most
of) my data.  It is not a strict requirement that all data be
immediately mirrored however.

So it seems that given these requirements that a filesystem should be
able to keep the disks mirrored in a "loose timeframe" so as to provide
redundancy (for all but the currently writing data) but also be able to
provide the full bandwidth of the two disks, yes?

Is this sort of idea on the btrfs roadmap at all?

b.


--=-pQgu4EMzTGMpM3r+rkhZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAknTMScACgkQl3EQlGLyuXDjiwCeKnvLUY3fdoE08OH1rNLx7HZ5
wdsAn1ks/A0fuIlVoiAmmWyDSuM73WyE
=plFm
-----END PGP SIGNATURE-----

--=-pQgu4EMzTGMpM3r+rkhZ--


