From: Chris Samuel <chris@csamuel.org>
Subject: [PATCH] Prefix mount messages with btrfs: for clarity
Date: Wed, 30 Nov 2011 22:15:27 +1100
Message-ID: <201111302215.28250.chris@csamuel.org>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1331577.hPpuHdisbT";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
To: linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

--nextPart1331577.hPpuHdisbT
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Currently when mounting a btrfs filesystem a user searching dmesg
has no obvious string to search for as currently we report something
cryptic like:

[ 5775.216078] device label DR devid 1 transid 15757 /dev/sdh1

It would be much nicer if there was some mention of btrfs to find
(as other filesystems generally provide), so this change prefixes
that message with btrfs: to make it appear as:

[ 5775.216078] btrfs: device label DR devid 1 transid 15757 /dev/sdh1

Signed-off-by: Chris Samuel <chris@csamuel.org>
=2D--
 fs/btrfs/volumes.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index c37433d..bc08087 100644
=2D-- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -722,9 +722,9 @@ int btrfs_scan_one_device(const char *path, fmode_t fla=
gs, void *holder,
 	devid =3D btrfs_stack_device_id(&disk_super->dev_item);
 	transid =3D btrfs_super_generation(disk_super);
 	if (disk_super->label[0])
=2D		printk(KERN_INFO "device label %s ", disk_super->label);
+		printk(KERN_INFO "btrfs: device label %s ", disk_super->label);
 	else
=2D		printk(KERN_INFO "device fsid %pU ", disk_super->fsid);
+		printk(KERN_INFO "btrfs: device fsid %pU ", disk_super->fsid);
 	printk(KERN_CONT "devid %llu transid %llu %s\n",
 	       (unsigned long long)devid, (unsigned long long)transid, path);
 	ret =3D device_list_add(path, disk_super, devid, fs_devices_ret);
=2D-=20
1.7.4.1

=2D-=20
 Chris Samuel  :  http://www.csamuel.org/  :  Melbourne, VIC

This email may come with a PGP signature as a file. Do not panic.
=46or more info see: http://en.wikipedia.org/wiki/OpenPGP

--nextPart1331577.hPpuHdisbT
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEVAwUATtYQUI1yjaOTJg85AQKvUQf/Y5Z72onT7As6YO7pg/WqqyrQJ0TT7Tqr
1UqEQsApvwXuWclKuZ45oosCGcWHa/LXfre43sRo/9uu2yCi+Dt8o60ah7t2UAHP
kRU5oow3xjrtRruCHKWleFIOzNQ4wurANmv4kaYfKUmTV3lpCzm3Z2yEih/AL3oJ
DxozeCargV5eWrsIAHkFZWFEaVHXQRGlOVdwIzvqs/3XibJtWSQ7yxn6ilX7rGxN
R7s2kw71MUgfH6PZvndq071rSfdyFi6DQV5CFUKwho189ZwFwTVcJJqq2Z5LxeVx
NznUPl5S8B8+Il6u29cUdPArx3m1t2nA10qfz7oehpxKiWZadlMXdg==
=r9pj
-----END PGP SIGNATURE-----

--nextPart1331577.hPpuHdisbT--
