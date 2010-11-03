From: Sean Reifschneider <sean@support.tummy.com>
Subject: Patch to provide "btrfs subvolume last-gen".
Date: Wed, 03 Nov 2010 03:23:34 -0600
Message-ID: <4CD12A16.4070802@support.tummy.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigB6637EC16661C758E64F21B9"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigB6637EC16661C758E64F21B9
Content-Type: multipart/mixed;
 boundary="------------010904040105090509080302"

This is a multi-part message in MIME format.
--------------010904040105090509080302
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Here is a patch to btrfs-progs to provide the command "subvolume last-gen=
":

   $ sudo ./btrfs subvolume last-gen /.snaps/1h-20101102-010001
   transid marker was 2808
   $ sudo ./btrfs subvolume last-gen /.snaps/1h-20101102-020001/
   transid marker was 2942
   $

So we can do something like:

   $ sudo ./btrfs subvolume find-new /.snaps/1h-20101102-020001 2808 | he=
ad -5
   inode 100399 file offset 2093056 len 4096 disk start 58160975872 offse=
t 0
gen 2901 flags NONE var/log/messages
   inode 100399 file offset 2097152 len 4096 disk start 58161836032 offse=
t 0
gen 2934 flags NONE var/log/messages
   inode 100400 file offset 40960 len 4096 disk start 58162188288 offset =
0 gen
2941 flags NONE var/log/secure
   inode 100401 file offset 139264 len 4096 disk start 58155618304 offset=
 0
gen 2883 flags NONE var/log/maillog
   inode 100401 file offset 143360 len 8192 disk start 58154278912 offset=
 0
gen 2930 flags NONE var/log/maillog
   $

Otherwise, the only way I could figure out to do it was to pass a gen id
that was hopefully too big to get the transid line:

   $ sudo ./btrfs subvolume find-new /.snapshots/1h-20101102-010001 \
         999999999999999
   transid marker was 2808
   $

Unless I'm missing something...

Sean

--------------010904040105090509080302
Content-Type: text/plain;
 name="0001-Adding-last-gen-comand.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="0001-Adding-last-gen-comand.patch"

=46rom 0a831df42f5b64db5c2f6a80531d2c4572ba5fc4 Mon Sep 17 00:00:00 2001
From: Sean Reifschneider <jafo@tummy.com>
Date: Wed, 3 Nov 2010 03:03:56 -0600
Subject: [PATCH] Adding last-gen comand.

---
 btrfs-list.c |    2 +-
 btrfs.c      |    3 +++
 btrfs_cmds.c |   29 +++++++++++++++++++++++++++++
 btrfs_cmds.h |    2 ++
 4 files changed, 35 insertions(+), 1 deletions(-)

diff --git a/btrfs-list.c b/btrfs-list.c
index 93766a8..7e4a282 100644
--- a/btrfs-list.c
+++ b/btrfs-list.c
@@ -310,7 +310,7 @@ static int lookup_ino_path(int fd, struct root_info *=
ri)
  * Then we use the tree search ioctl to scan all the root items for a
  * given root id and spit out the latest generation we can find
  */
-static u64 find_root_gen(int fd)
+u64 find_root_gen(int fd)
 {
 	struct btrfs_ioctl_ino_lookup_args ino_args;
 	int ret;
diff --git a/btrfs.c b/btrfs.c
index 46314cf..188b451 100644
--- a/btrfs.c
+++ b/btrfs.c
@@ -64,6 +64,9 @@ static struct Command commands[] =3D {
 	{ do_find_newer, 2, "subvolume find-new", "<path> <last_gen>\n"
 		"List the recently modified files in a filesystem."
 	},
+	{ do_get_latest_gen, 1, "subvolume last-gen", "<path>\n"
+		"Return the latest generation of a filesystem."
+	},
 	{ do_defrag, -1,
 	  "filesystem defragment", "[-vcf] [-s start] [-l len] [-t size] <file>=
|<dir> [<file>|<dir>...]\n"
 		"Defragment a file or a directory."
diff --git a/btrfs_cmds.c b/btrfs_cmds.c
index 8031c58..25eafb8 100644
--- a/btrfs_cmds.c
+++ b/btrfs_cmds.c
@@ -247,6 +247,35 @@ int do_defrag(int ac, char **av)
 	return errors + 20;
 }
=20
+int do_get_latest_gen(int argc, char **argv)
+{
+	int fd;
+	int ret;
+	char *subvol;
+	u64 max_found =3D 0;
+
+	subvol =3D argv[1];
+
+	ret =3D test_issubvolume(subvol);
+	if (ret < 0) {
+		fprintf(stderr, "ERROR: error accessing '%s'\n", subvol);
+		return 12;
+	}
+	if (!ret) {
+		fprintf(stderr, "ERROR: '%s' is not a subvolume\n", subvol);
+		return 13;
+	}
+
+	fd =3D open_file_or_dir(subvol);
+	if (fd < 0) {
+		fprintf(stderr, "ERROR: can't access '%s'\n", subvol);
+		return 12;
+	}
+	max_found =3D find_root_gen(fd);
+	printf("transid marker was %llu\n", (unsigned long long)max_found);
+	return 0;
+}
+
 int do_find_newer(int argc, char **argv)
 {
 	int fd;
diff --git a/btrfs_cmds.h b/btrfs_cmds.h
index 7bde191..ea4e18e 100644
--- a/btrfs_cmds.h
+++ b/btrfs_cmds.h
@@ -20,6 +20,7 @@ int do_delete_subvolume(int nargs, char **argv);
 int do_create_subvol(int nargs, char **argv);
 int do_fssync(int nargs, char **argv);
 int do_defrag(int argc, char **argv);
+int do_get_latest_gen(int argc, char **argv);
 int do_show_filesystem(int nargs, char **argv);
 int do_add_volume(int nargs, char **args);
 int do_balance(int nargs, char **argv);
@@ -32,3 +33,4 @@ int list_subvols(int fd);
 int do_df_filesystem(int nargs, char **argv);
 int find_updated_files(int fd, u64 root_id, u64 oldest_gen);
 int do_find_newer(int argc, char **argv);
+u64 find_root_gen(int fd);
--=20
1.7.3.1


--------------010904040105090509080302--

--------------enigB6637EC16661C758E64F21B9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org/

iD8DBQFM0SoWxUhyMYEjVX0RAh46AJ9M+t6WQvzUrsB4uS0KlMpQWJv/uwCfVoOa
T1uhOKyCI9UYgcd84cP/bV0=
=Fftj
-----END PGP SIGNATURE-----

--------------enigB6637EC16661C758E64F21B9--
