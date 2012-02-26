From: "Brian J. Murrell" <brian@interlinx.bc.ca>
Subject: filesystem full when it's not?  out of inodes?  huh?
Date: Sat, 25 Feb 2012 20:55:12 -0500
Message-ID: <jic3e1$gpe$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig49DDD7274168507D8960E298"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig49DDD7274168507D8960E298
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

I have a 5G /usr btrfs filesystem on a 3.0.0-12-generic kernel that is
returning ENOSPC when it's only 75% full:

Filesystem            Size  Used Avail Use% Mounted on
/dev/mapper/rootvol-mint_usr
                      5.0G  2.8G  967M  75% /usr

And yet I can't even unpack a linux-headers package on to it, which
should be nowhere near 967MB.  dpkg says it will need 10MB:

$ sudo apt-get install -f
Reading package lists... Done
Building dependency tree      =20
Reading state information... Done
Correcting dependencies... Done
The following extra packages will be installed:
  linux-headers-3.0.0-16-generic
The following NEW packages will be installed:
  linux-headers-3.0.0-16-generic
0 upgraded, 1 newly installed, 0 to remove and 2 not upgraded.
264 not fully installed or removed.
Need to get 0 B/851 kB of archives.
After this operation, 10.8 MB of additional disk space will be used.
Do you want to continue [Y/n]? y
(Reading database ... 180246 files and directories currently installed.)
Unpacking linux-headers-3.0.0-16-generic (from .../linux-headers-3.0.0-16=
-generic_3.0.0-16.28_i386.deb) ...
dpkg: error processing /var/cache/apt/archives/linux-headers-3.0.0-16-gen=
eric_3.0.0-16.28_i386.deb (--unpack):
 unable to install new version of `/usr/src/linux-headers-3.0.0-16-generi=
c/include/config/dvb/tuner/dib0070.h': No space left on device

And indeed, using dd I am able to create a 967MB file:

$ sudo dd if=3D/dev/zero of=3D/usr/bigfile bs=3D1M count=3D10000000
dd: writing `/usr/bigfile': No space left on device
967+0 records in
966+0 records out
1012924416 bytes (1.0 GB) copied, 16.1545 s, 62.7 MB/s

strace yields this as the cause of the ENOSPC:

8213  rename("/usr/src/linux-headers-3.0.0-16-generic/include/config/dvb/=
tuner/dib0070.h.dpkg-new", "/usr/src/linux-headers-3.0.0-16-generic/inclu=
de/config/dvb/tuner/dib0070.h" <unfinished ...>
=2E..
8213  <... rename resumed> )            =3D -1 ENOSPC (No space left on d=
evice)

So this starts to feel like some kind of inode count limitation.  But I
didn't think btrfs had inode count limitations.  Here's the df stats on
the filesystem:

$ btrfs filesystem df /usr
Data: total=3D3.22GB, used=3D3.22GB
System, DUP: total=3D8.00MB, used=3D4.00KB
System: total=3D4.00MB, used=3D0.00
Metadata, DUP: total=3D896.00MB, used=3D251.62MB
Metadata: total=3D8.00MB, used=3D0.00

I don't know if that's useful or not.

Any ideas?

Cheers
b.


--------------enig49DDD7274168507D8960E298
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk9JkQAACgkQl3EQlGLyuXD5nwCfVsa1YvZle70uxLfmHMA+DGpD
IEsAoOyhuOcOUs2M77em10ssgH/Ly4am
=4q4e
-----END PGP SIGNATURE-----

--------------enig49DDD7274168507D8960E298--

