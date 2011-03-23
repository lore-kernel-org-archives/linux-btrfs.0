From: "Brian J. Murrell" <brian@interlinx.bc.ca>
Subject: Re: efficiency of btrfs cow
Date: Wed, 23 Mar 2011 08:39:51 -0400
Message-ID: <4D89EA17.20506@interlinx.bc.ca>
References: <il0a8d$4ev$1@dough.gmane.org> <1299427596.15017.8.camel@ayu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigD70C087A48A80C8C18BACE4F"
Cc: linux-btrfs@vger.kernel.org
To: Calvin Walton <calvin.walton@kepstin.ca>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1299427596.15017.8.camel@ayu>
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigD70C087A48A80C8C18BACE4F
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 11-03-06 11:06 AM, Calvin Walton wrote:
>=20
> To see exactly what's going on, you should use the "btrfs filesystem df=
"
> command to see how space is being allocated for data and metadata
> separately:

OK.  So with an empty filesystem, before my first copy (i.e. the base on
which the next copy will CoW from) df reports:

Filesystem           1K-blocks      Used Available Use% Mounted on
/dev/mapper/btrfs--test-btrfs--test
                     922746880        56 922746824   1% /mnt/btrfs-test

and btrfs fi df reports:

Data: total=3D8.00MB, used=3D0.00
Metadata: total=3D1.01GB, used=3D24.00KB
System: total=3D12.00MB, used=3D4.00KB

after the first copy df and btrfs fi df report:

Filesystem           1K-blocks      Used Available Use% Mounted on
/dev/mapper/btrfs--test-btrfs--test
                     922746880 121402328 801344552  14% /mnt/btrfs-test

root@linux:/mnt/btrfs-test# cat .snapshots/monthly.22/metadata/btrfs_df-s=
top
Data: total=3D110.01GB, used=3D109.26GB
Metadata: total=3D5.01GB, used=3D3.26GB
System: total=3D12.00MB, used=3D24.00KB

So it's clear that total usage (as reported by df) was 121,402,328KB but
Metadata has two values:

Metadata: total=3D5.01GB, used=3D3.26GB

What's the difference between total and used?  And for that matter,
what's the difference between the total and used for Data
(total=3D110.01GB, used=3D109.26GB)?

Even if I take the largest values (i.e. the total values) for Data and
Metadata (each converted to KB first) and add them up they are:
120,607,211.52 which is not quite the 121,402,328 that df reports.
There is a 795,116.48KB discrepancy.

In any case, which value from a btrfs df fi should I be subtracting from
df's accounting to get a real accounting of the amount of data used?

Cheers,
b.


--------------enigD70C087A48A80C8C18BACE4F
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk2J6hcACgkQl3EQlGLyuXCOUgCfYrgBRal/pfsssuZ/DWju76MI
eMYAn0m5Zs/kGtVsNMPEtMpuIWSTwTsF
=Hr6j
-----END PGP SIGNATURE-----

--------------enigD70C087A48A80C8C18BACE4F--
