From: Maciej Marcin Piechotka <uzytkownik2@gmail.com>
Subject: BTRFS corruption - the filesystem grows and the new files appears
 (at least)
Date: Mon, 22 Aug 2011 14:06:45 +0100
Message-ID: <1314018424.11180.7.camel@picard>
Reply-To: uzytkownik2@gmail.com
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-ripemd160";
	protocol="application/pgp-signature"; boundary="=-A8X1ybIfUoL6idYeTcKp"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


--=-A8X1ybIfUoL6idYeTcKp
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello,

I got btrfs corruption and I'm not sure if it is known yet. i suspect
that it happened after hard reset (I got freeze first so I'm not sure if
it wasn't caused by something else).

The symptoms are that the allocation grows at all time during
read/writes (it reached 49 GB for 30 GB of data on disk in total).
Btrfsck reported several errors (and wasted space) but the partition
mounted nonetheless. I created the disk image and copy the data from
image to the partition. I haven't compared the checksums of files but I
haven't found any other then 1 new file with random (i.e. the nautilus
complained that the name is not valid) name.

Is is known error or should I include the debug data (the btrfsck output
etc.)? My kernel is 3.0.3.

Regards

--=-A8X1ybIfUoL6idYeTcKp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIcBAABAwAGBQJOUlR3AAoJEJIdee2Vr4aPQ2wQAMuo6b1jm5NmE3fH3dN/DFW+
wFS6WvzJzkDfS4t16gocr+m3sT8PagLklbNo9PieyTtnGBcIFl+XE4QwCOAaqyPF
77j0Jkiy/beakToCCUc95njm0ay+6Hx7SwzcHX6/Im5IJcfKBlIObS9LNuYkh/TQ
S5LitisYlupfergfGYoVrS4s+LQj7+c1jlD1AIOe7Hvd86+d2UrAZBqBRH0Pxhdi
DoochxLC7bgWQFbYZaWQ70x3XGjjEDj5a42nfoPpRTt5cfExR+LarM4rphmV9Tor
giuB+rx3PU/tp5UhBVB2X0W+lCMLFIuZ3K/6eq8qTGAaKZJR2CWySI/VjzXsLAaO
tJ1miXSMPQoaSTUxn4+fRBZdeZg6vOvj2JuATE2Ly/nPdrKkmIp/7hv3HiGUnol1
98N6+p8jHcNoMl5FmZJjxmdZ8rt1LkkDDVR3jg4iScg2oqr3zoF/0S1Ey7L+icHV
ir/oISQ+CGXfhw/yPkS+HEqOLUiv889irCVh0RXGX2JrpHl1js+sAtupf3nixl+c
sc/fVb3gQCyMq6pb311KOUNzPq0ITy1RZVkz2UHSqFFcBW+yXEtfJCorK1wx751F
Aqx3QMG/nhm0mGfo1fGGWJr57GxNQvwvPLuRZuXlwoDeyUA8jTWBchKBSvbJReLO
ax3xUhiLTYFunvuw6HdW
=Ig5R
-----END PGP SIGNATURE-----

--=-A8X1ybIfUoL6idYeTcKp--


