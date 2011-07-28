From: Bruce Guenter <bruce@untroubled.org>
Subject: Slow snapshot deletion
Date: Thu, 28 Jul 2011 14:04:45 -0600
Message-ID: <20110728200444.GA30801@untroubled.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="RnlQjJ0d97Da+TV1"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


--RnlQjJ0d97Da+TV1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


At work we have a backup server system running btrfs.  The main backup
pool is a 1.3TB partition (on LVM).  Every night, a series of backups
are done with rsync, with each backup onto a separate subvolume, and a
snapshot made of each backup.  Compression is used to minimize disk
space used.

When the system was first provisioned, all the operations ran
impressively fast, but now it is almost unusably slow.  It has taken 2
days to delete snapshots that recovered 30GB of space, and some of the
backups are taking longer than 24 hours to complete.

Is there any way to monitor the progress of the snapshot deletions?

What could be causing it to run so slow?

What could we do to speed things up?

Kernel is 2.6.39-gentoo-r3.  It was last rebooted 2 days ago, and
rebooting does not seem to improve the situation.  Mount options
according to /proc are "rw,nosuid,noatime,nodiratime,compress=3Dzlib,noacl"
btrfs filesystem df shows:

Data: total=3D1.15TB, used=3D1.10TB
System, DUP: total=3D8.00MB, used=3D184.00KB
System: total=3D4.00MB, used=3D0.00
Metadata, DUP: total=3D49.38GB, used=3D31.59GB
Metadata: total=3D8.00MB, used=3D0.00

--=20
Bruce Guenter <bruce@untroubled.org>                http://untroubled.org/

--RnlQjJ0d97Da+TV1
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iQIcBAEBAgAGBQJOMcDcAAoJEFFRvcnBTTxnD2MP/jAOVPSuwnySD/8BcCk4F/w7
sWteBqUcYAqMCQM8z4oUKnerH1vQ5bY5qwK0UXU3dxmrPTqrrnAGQbHlfZAFBRde
LSSRA98uvIlDHHQ3DABTwB5r9ni/6v0eBPgtNCIN89R2L3PRVOSX45n4gp0Vm+rk
e5kmkShz9ycX5wuy8LMwSfrkaM/VNT6TpLHpOqjZUCgvXSu/b/kjbenkprvG7P0Z
0pD5od+awY/Q+4EdbEZtqvVjppa+BCiz9To6OFtfASoHFQARd7oYeGoM76UqsVtL
qwJwxj2OSIXKrEsMcQaAbmv4gYjyH+01kwu7WcXNjYAOwFE9k8tScAC7Droe13+R
0rKOFI/4UA4AOsXfTqbfz2MkuFK3eBC4ZRZfuxEAIuop4TtsWowkmAz8GO0uZOZe
H1oSgxUWHzVOt80sMoIt5gYYEWBiDIX+APPvagBuExbR3XHwYVMZYaBH0+QPu77Q
fIvYvJJb5arFXhdFOqQ+UyoiUtKYaFm+vyFhGfvsmhyybn8gs2Lj+RcSyMrXqhtD
wDuX1mGoEMye58xi+VpX5W4A5zjaDN8sTggMOaa5Qt5QJ/6tvUiGHLvASs4skmvp
GgC/ByelVzn6t3xab0K2PrO/QsRU6UgDvsM1rsmDMs58qC+K0SN5F3kqHDxDaY7V
tHUxs5CC7O4BfkEENT61
=IbJ9
-----END PGP SIGNATURE-----

--RnlQjJ0d97Da+TV1--
