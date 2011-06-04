From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Safe fsck / consistent backup while mounted
Date: Sat, 4 Jun 2011 12:25:55 +0200
Message-ID: <201106041225.56028.Martin@lichtvoll.de>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1378788.jD5h3qRMXR";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
To: "linux-btrfs" <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

--nextPart1378788.jD5h3qRMXR
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Hi!

In mailing list debian-user-german we are discussing safe ways to do a=20
fsck when mounted.

I tested with Ext4 that fsck -nf works either with mount -o remount,ro or=20
fsfreeze -f while writing with:

I=3D0; while true ; let I=3DI+1 ; do touch /boot/test$I ; sleep 0.2 ; done

In the read only mount case the write application returns errors, in the=20
fsfreeze case Linux kernel stacks the changes in memory, but the fsck=20
reports no errors like it should.


Now I thought about a way to safely backup a MySQL or other database -=20
without long service interruption:

=2D Tell DB to turn itself into consistent state and freeze there
=2D sync / btrfs filesystem sync ; fsfreeze -f /mountpoint
=2D btrfs subvolume snapshot
=2D fsfreeze -u /mountpoint
=2D Tell DB to continue business as usual

My questions are:

1) Would this work?

2) Is the sync needed? And if so how to avoid the race condition between=20
the sync and the fsfreeze invocation? Reading from the fsfreeze manpage I=20
understand that fsfreeze allows all ongoing transactions to complete. But=20
does that include everything what sync would bring to disk?

3) Is the fsfreeze needed at all? Does btrfs subvolume freeze the=20
filesystem prior to the snapshot? The manpage doesn=B4t tell it.

Thanks,
=2D-=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

--nextPart1378788.jD5h3qRMXR
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAk3qCDMACgkQmRvqrKWZhMdSbQCfcXgmaj1Um5/DkPES39gIukbK
wY4AnRBXfiDVwN7dQEl1Fd2OZWtlMoZQ
=I4AT
-----END PGP SIGNATURE-----

--nextPart1378788.jD5h3qRMXR--
