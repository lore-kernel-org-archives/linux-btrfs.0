From: Robert Collins <robertc@robertcollins.net>
Subject: BackupPC, per-dir hard link limit, Debian packaging
Date: Tue, 02 Mar 2010 13:29:05 +1100
Message-ID: <1267496945.9222.155.camel@lifeless-64>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-IP9TtOA9ArFD5Wi/227b"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


--=-IP9TtOA9ArFD5Wi/227b
Content-Type: text/plain; charset="ANSI_X3.4-1968"
Content-Transfer-Encoding: quoted-printable

I realise that the hard link limit is in the queue to fix, and I read
the recent thread as well as the older (october I think) thread.

I just wanted to note that BackupPC *does* in fact run into the hard
link limit, and its due to the dpkg configuration scripts.

BackupPC hard links files with the same content together by scanning new
files and linking them together, whether or not they started as a hard
link in the backed up source PCs.

It also builds a directory structure precisely matching the source
machine (basically it rsyncs across, then hardlinks aggressively).

If you back up a Debian host, /var/lib/dpkg/info contains many identical
files because debhelper generates the same script in the common case:
ls /var/lib/dpkg/info/*.postinst | xargs -n1 sha1sum | awk '{ print
$1 }' | sort -u | wc -l
862
ls /var/lib/dpkg/info/*.postinst | wc -l
1533

As I say, I realise this is queued to get addressed anyway, but it seems
like a realistic thing for people to do (use BackupPC on btrfs) - even
if something better still can be written to replace the BackupPC store
in the future. I will note though, that simple snapshots won't achieve
the deduplication level that BackupPC does, because the fils don't start
out as the same: they are identified as being identical post-backup.

Cheers,
Rob

--=-IP9TtOA9ArFD5Wi/227b
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAkuMd/AACgkQhnv5qfvT646bgACgoBEHvkUU5kjcwGDpdZME2ToE
MKQAn07gznbGhSC3jgxr/EfHMN0/kGAh
=G8Zj
-----END PGP SIGNATURE-----

--=-IP9TtOA9ArFD5Wi/227b--

