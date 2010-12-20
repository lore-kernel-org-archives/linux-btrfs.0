From: Goffredo Baroncelli <kreijack@libero.it>
Subject: [TRIVIAL][PATCH] Improve error handling in the btrfs command
Date: Mon, 20 Dec 2010 21:06:19 +0100
Message-ID: <201012202106.26603.kreijack@libero.it>
Reply-To: kreijack@libero.it
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2108316.z0bevh2fcb";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Cc: linux-btrfs@vger.kernel.org, Ben Gamari <bgamari.foss@gmail.com>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

--nextPart2108316.z0bevh2fcb
Content-Type: multipart/mixed;
  boundary="Boundary-01=_7c7DNKMiWRkKvdj"
Content-Transfer-Encoding: 7bit


--Boundary-01=_7c7DNKMiWRkKvdj
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi Chris,

below is enclosed a trivial patch, which has the aim to improve the error=20
reporting of the "btrfs" command.

You can pull from

	http://cassiopea.homelinux.net/git/btrfs-progs-unstable.git

branch
=09
	strerror

I changed every printf("some-error") to something like:

	e =3D errno;
	fprintf(stderr, "ERROR: .... - %s", strerror(e));

so:

1) all the error are reported to standard error
2) At the end of the message is printed the error as returned by the system.

The change is quite simple, I replaced every printf("some-error") to the li=
ne
above. I don't touched anything other.
I also integrated a missing "printf" on the basis of the Ben patch.

This patch leads the btrfs command to be more "user friendly" :-)

Regards
G.Baroncelli

 btrfs-list.c |   40 ++++++++++++++++++++++--------
 btrfs_cmds.c |   77 ++++++++++++++++++++++++++++++++++++++++--------------=
=2D--
 utils.c      |    6 ++++
 3 files changed, 89 insertions(+), 34 deletions(-)


=2D-=20
gpg key@ keyserver.linux.it: Goffredo Baroncelli (ghigo) <kreijack@inwind.i=
t>
Key fingerprint =3D 4769 7E51 5293 D36C 814E  C054 BF04 F161 3DC5 0512

--Boundary-01=_7c7DNKMiWRkKvdj
Content-Type: text/x-patch;
  charset="us-ascii";
  name="strerror.diff"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline;
	filename="strerror.diff"

diff --git a/btrfs-list.c b/btrfs-list.c
index 93766a8..abcc2f4 100644
=2D-- a/btrfs-list.c
+++ b/btrfs-list.c
@@ -265,7 +265,7 @@ static int resolve_root(struct root_lookup *rl, struct =
root_info *ri)
 static int lookup_ino_path(int fd, struct root_info *ri)
 {
 	struct btrfs_ioctl_ino_lookup_args args;
=2D	int ret;
+	int ret, e;
=20
 	if (ri->path)
 		return 0;
@@ -275,9 +275,11 @@ static int lookup_ino_path(int fd, struct root_info *r=
i)
 	args.objectid =3D ri->dir_id;
=20
 	ret =3D ioctl(fd, BTRFS_IOC_INO_LOOKUP, &args);
+	e =3D errno;
 	if (ret) {
=2D		fprintf(stderr, "ERROR: Failed to lookup path for root %llu\n",
=2D			(unsigned long long)ri->ref_tree);
+		fprintf(stderr, "ERROR: Failed to lookup path for root %llu - %s\n",
+			(unsigned long long)ri->ref_tree,
+			strerror(e));
 		return ret;
 	}
=20
@@ -320,15 +322,18 @@ static u64 find_root_gen(int fd)
 	unsigned long off =3D 0;
 	u64 max_found =3D 0;
 	int i;
+	int e;
=20
 	memset(&ino_args, 0, sizeof(ino_args));
 	ino_args.objectid =3D BTRFS_FIRST_FREE_OBJECTID;
=20
 	/* this ioctl fills in ino_args->treeid */
 	ret =3D ioctl(fd, BTRFS_IOC_INO_LOOKUP, &ino_args);
+	e =3D errno;
 	if (ret) {
=2D		fprintf(stderr, "ERROR: Failed to lookup path for dirid %llu\n",
=2D			(unsigned long long)BTRFS_FIRST_FREE_OBJECTID);
+		fprintf(stderr, "ERROR: Failed to lookup path for dirid %llu - %s\n",
+			(unsigned long long)BTRFS_FIRST_FREE_OBJECTID,
+			strerror(e));
 		return 0;
 	}
=20
@@ -351,8 +356,10 @@ static u64 find_root_gen(int fd)
=20
 	while (1) {
 		ret =3D ioctl(fd, BTRFS_IOC_TREE_SEARCH, &args);
+		e =3D errno;
 		if (ret < 0) {
=2D			fprintf(stderr, "ERROR: can't perform the search\n");
+			fprintf(stderr, "ERROR: can't perform the search - %s\n",
+				strerror(e));
 			return 0;
 		}
 		/* the ioctl returns the number of item it found in nr_items */
@@ -407,14 +414,16 @@ static char *__ino_resolve(int fd, u64 dirid)
 	struct btrfs_ioctl_ino_lookup_args args;
 	int ret;
 	char *full;
+	int e;
=20
 	memset(&args, 0, sizeof(args));
 	args.objectid =3D dirid;
=20
 	ret =3D ioctl(fd, BTRFS_IOC_INO_LOOKUP, &args);
+	e =3D errno;
 	if (ret) {
=2D		fprintf(stderr, "ERROR: Failed to lookup path for dirid %llu\n",
=2D			(unsigned long long)dirid);
+		fprintf(stderr, "ERROR: Failed to lookup path for dirid %llu - %s\n",
+			(unsigned long long)dirid, strerror(e) );
 		return ERR_PTR(ret);
 	}
=20
@@ -472,6 +481,7 @@ static char *ino_resolve(int fd, u64 ino, u64 *cache_di=
rid, char **cache_name)
 	struct btrfs_ioctl_search_header *sh;
 	unsigned long off =3D 0;
 	int namelen;
+	int e;
=20
 	memset(&args, 0, sizeof(args));
=20
@@ -490,8 +500,10 @@ static char *ino_resolve(int fd, u64 ino, u64 *cache_d=
irid, char **cache_name)
 	sk->nr_items =3D 1;
=20
 	ret =3D ioctl(fd, BTRFS_IOC_TREE_SEARCH, &args);
+	e =3D errno;
 	if (ret < 0) {
=2D		fprintf(stderr, "ERROR: can't perform the search\n");
+		fprintf(stderr, "ERROR: can't perform the search - %s\n",
+			strerror(e));
 		return NULL;
 	}
 	/* the ioctl returns the number of item it found in nr_items */
@@ -550,6 +562,7 @@ int list_subvols(int fd)
 	char *name;
 	u64 dir_id;
 	int i;
+	int e;
=20
 	root_lookup_init(&root_lookup);
=20
@@ -578,8 +591,10 @@ int list_subvols(int fd)
=20
 	while(1) {
 		ret =3D ioctl(fd, BTRFS_IOC_TREE_SEARCH, &args);
+		e =3D errno;
 		if (ret < 0) {
=2D			fprintf(stderr, "ERROR: can't perform the search\n");
+			fprintf(stderr, "ERROR: can't perform the search - %s\n",
+				strerror(e));
 			return ret;
 		}
 		/* the ioctl returns the number of item it found in nr_items */
@@ -747,6 +762,7 @@ int find_updated_files(int fd, u64 root_id, u64 oldest_=
gen)
 	u64 found_gen;
 	u64 max_found =3D 0;
 	int i;
+	int e;
 	u64 cache_dirid =3D 0;
 	u64 cache_ino =3D 0;
 	char *cache_dir_name =3D NULL;
@@ -773,8 +789,10 @@ int find_updated_files(int fd, u64 root_id, u64 oldest=
_gen)
 	max_found =3D find_root_gen(fd);
 	while(1) {
 		ret =3D ioctl(fd, BTRFS_IOC_TREE_SEARCH, &args);
+		e =3D errno;
 		if (ret < 0) {
=2D			fprintf(stderr, "ERROR: can't perform the search\n");
+			fprintf(stderr, "ERROR: can't perform the search- %s\n",
+				strerror(e));
 			return ret;
 		}
 		/* the ioctl returns the number of item it found in nr_items */
diff --git a/btrfs_cmds.c b/btrfs_cmds.c
index 8031c58..cda9b9d 100644
=2D-- a/btrfs_cmds.c
+++ b/btrfs_cmds.c
@@ -156,6 +156,7 @@ int do_defrag(int ac, char **av)
 	int verbose =3D 0;
 	int fancy_ioctl =3D 0;
 	struct btrfs_ioctl_defrag_range_args range;
+	int e=3D0;
=20
 	optind =3D 1;
 	while(1) {
@@ -219,19 +220,21 @@ int do_defrag(int ac, char **av)
 		}
 		if (!fancy_ioctl) {
 			ret =3D ioctl(fd, BTRFS_IOC_DEFRAG, NULL);
+			e=3Derrno;
 		} else {
 			ret =3D ioctl(fd, BTRFS_IOC_DEFRAG_RANGE, &range);
 			if (ret && errno =3D=3D ENOTTY) {
=2D				fprintf(stderr, "defrag range ioctl not "
+				fprintf(stderr, "ERROR: defrag range ioctl not "
 					"supported in this kernel, please try "
 					"without any options.\n");
 				errors++;
+				close(fd);
 				break;
 			}
 		}
 		if (ret) {
=2D			fprintf(stderr, "ioctl failed on %s ret %d errno %d\n",
=2D				av[i], ret, errno);
+			fprintf(stderr, "ERROR: defrag failed on %s - %s\n",
+				av[i], strerror(e));
 			errors++;
 		}
 		close(fd);
@@ -310,7 +313,7 @@ int do_subvol_list(int argc, char **argv)
 int do_clone(int argc, char **argv)
 {
 	char	*subvol, *dst;
=2D	int	res, fd, fddst, len;
+	int	res, fd, fddst, len, e;
 	char	*newname;
 	char	*dstdir;
=20
@@ -377,12 +380,14 @@ int do_clone(int argc, char **argv)
 	args.fd =3D fd;
 	strcpy(args.name, newname);
 	res =3D ioctl(fddst, BTRFS_IOC_SNAP_CREATE, &args);
+	e =3D errno;
=20
 	close(fd);
 	close(fddst);
=20
 	if(res < 0 ){
=2D		fprintf( stderr, "ERROR: cannot snapshot '%s'\n",subvol);
+		fprintf( stderr, "ERROR: cannot snapshot '%s' - %s\n",
+			subvol, strerror(e));
 		return 11;
 	}
=20
@@ -392,7 +397,7 @@ int do_clone(int argc, char **argv)
=20
 int do_delete_subvolume(int argc, char **argv)
 {
=2D	int	res, fd, len;
+	int	res, fd, len, e;
 	struct btrfs_ioctl_vol_args	args;
 	char	*dname, *vname, *cpath;
 	char	*path =3D argv[1];
@@ -438,11 +443,13 @@ int do_delete_subvolume(int argc, char **argv)
 	printf("Delete subvolume '%s/%s'\n", dname, vname);
 	strcpy(args.name, vname);
 	res =3D ioctl(fd, BTRFS_IOC_SNAP_DESTROY, &args);
+	e =3D errno;
=20
 	close(fd);
=20
 	if(res < 0 ){
=2D		fprintf( stderr, "ERROR: cannot delete '%s/%s'\n",dname, vname);
+		fprintf( stderr, "ERROR: cannot delete '%s/%s' - %s\n",
+			dname, vname, strerror(e));
 		return 11;
 	}
=20
@@ -452,7 +459,7 @@ int do_delete_subvolume(int argc, char **argv)
=20
 int do_create_subvol(int argc, char **argv)
 {
=2D	int	res, fddst, len;
+	int	res, fddst, len, e;
 	char	*newname;
 	char	*dstdir;
 	struct btrfs_ioctl_vol_args	args;
@@ -492,11 +499,13 @@ int do_create_subvol(int argc, char **argv)
 	printf("Create subvolume '%s/%s'\n", dstdir, newname);
 	strcpy(args.name, newname);
 	res =3D ioctl(fddst, BTRFS_IOC_SUBVOL_CREATE, &args);
+	e =3D errno;
=20
 	close(fddst);
=20
 	if(res < 0 ){
=2D		fprintf( stderr, "ERROR: cannot create subvolume\n");
+		fprintf( stderr, "ERROR: cannot create subvolume - %s\n",
+			strerror(e));
 		return 11;
 	}
=20
@@ -506,7 +515,7 @@ int do_create_subvol(int argc, char **argv)
=20
 int do_fssync(int argc, char **argv)
 {
=2D	int fd, res;
+	int 	fd, res, e;
 	char	*path =3D argv[1];
=20
 	fd =3D open_file_or_dir(path);
@@ -517,9 +526,11 @@ int do_fssync(int argc, char **argv)
=20
 	printf("FSSync '%s'\n", path);
 	res =3D ioctl(fd, BTRFS_IOC_SYNC);
+	e =3D errno;
 	close(fd);
 	if( res < 0 ){
=2D		fprintf(stderr, "ERROR: unable to fs-syncing '%s'\n", path);
+		fprintf(stderr, "ERROR: unable to fs-syncing '%s' - %s\n",=20
+			path, strerror(e));
 		return 16;
 	}
=20
@@ -528,7 +539,7 @@ int do_fssync(int argc, char **argv)
=20
 int do_scan(int argc, char **argv)
 {
=2D	int	i, fd;
+	int	i, fd, e;
 	if(argc<=3D1){
 		int ret;
=20
@@ -560,10 +571,12 @@ int do_scan(int argc, char **argv)
 		 * a btrfs filesystem from an I/O error !!!
 		 */
 		ret =3D ioctl(fd, BTRFS_IOC_SCAN_DEV, &args);
+		e =3D errno;
=20
 		if( ret < 0 ){
 			close(fd);
=2D			fprintf(stderr, "ERROR: unable to scan the device '%s'\n", argv[i]);
+			fprintf(stderr, "ERROR: unable to scan the device '%s' - %s\n",=20
+				argv[i], strerror(e));
 			return 11;
 		}
 	}
@@ -577,7 +590,7 @@ int do_resize(int argc, char **argv)
 {
=20
 	struct btrfs_ioctl_vol_args	args;
=2D	int	fd, res, len;
+	int	fd, res, len, e;
 	char	*amount=3Dargv[1], *path=3Dargv[2];
=20
 	fd =3D open_file_or_dir(path);
@@ -595,9 +608,11 @@ int do_resize(int argc, char **argv)
 	printf("Resize '%s' of '%s'\n", path, amount);
 	strcpy(args.name, amount);
 	res =3D ioctl(fd, BTRFS_IOC_RESIZE, &args);
+	e =3D errno;
 	close(fd);
 	if( res < 0 ){
=2D		fprintf(stderr, "ERROR: unable to resize '%s'\n", path);
+		fprintf(stderr, "ERROR: unable to resize '%s' - %s\n",=20
+			path, strerror(e));
 		return 30;
 	}
 	return 0;
@@ -691,7 +706,7 @@ int do_add_volume(int nargs, char **args)
 {
=20
 	char	*mntpnt =3D args[nargs-1];
=2D	int	i, fdmnt, ret=3D0;
+	int	i, fdmnt, ret=3D0, e;
=20
=20
 	fdmnt =3D open_file_or_dir(mntpnt);
@@ -738,8 +753,10 @@ int do_add_volume(int nargs, char **args)
=20
 		strcpy(ioctl_args.name, args[i]);
 		res =3D ioctl(fdmnt, BTRFS_IOC_ADD_DEV, &ioctl_args);
+		e =3D errno;
 		if(res<0){
=2D			fprintf(stderr, "ERROR: error adding the device '%s'\n", args[i]);
+			fprintf(stderr, "ERROR: error adding the device '%s' - %s\n",=20
+				args[i], strerror(e));
 			ret++;
 		}
=20
@@ -756,7 +773,7 @@ int do_add_volume(int nargs, char **args)
 int do_balance(int argc, char **argv)
 {
=20
=2D	int	fdmnt, ret=3D0;
+	int	fdmnt, ret=3D0, e;
 	struct btrfs_ioctl_vol_args args;
 	char	*path =3D argv[1];
=20
@@ -768,9 +785,11 @@ int do_balance(int argc, char **argv)
=20
 	memset(&args, 0, sizeof(args));
 	ret =3D ioctl(fdmnt, BTRFS_IOC_BALANCE, &args);
+	e =3D errno;
 	close(fdmnt);
 	if(ret<0){
=2D		fprintf(stderr, "ERROR: balancing '%s'\n", path);
+		fprintf(stderr, "ERROR: error during balancing '%s' - %s\n",=20
+			path, strerror(e));
=20
 		return 19;
 	}
@@ -780,7 +799,7 @@ int do_remove_volume(int nargs, char **args)
 {
=20
 	char	*mntpnt =3D args[nargs-1];
=2D	int	i, fdmnt, ret=3D0;
+	int	i, fdmnt, ret=3D0, e;
=20
 	fdmnt =3D open_file_or_dir(mntpnt);
 	if (fdmnt < 0) {
@@ -794,8 +813,10 @@ int do_remove_volume(int nargs, char **args)
=20
 		strcpy(arg.name, args[i]);
 		res =3D ioctl(fdmnt, BTRFS_IOC_RM_DEV, &arg);
+		e =3D errno;
 		if(res<0){
=2D			fprintf(stderr, "ERROR: error removing the device '%s'\n", args[i]);
+			fprintf(stderr, "ERROR: error removing the device '%s' - %s\n",=20
+				args[i], strerror(e));
 			ret++;
 		}
 	}
@@ -809,7 +830,7 @@ int do_remove_volume(int nargs, char **args)
=20
 int do_set_default_subvol(int nargs, char **argv)
 {
=2D	int	ret=3D0, fd;
+	int	ret=3D0, fd, e;
 	u64	objectid;
 	char	*path =3D argv[2];
 	char	*subvolid =3D argv[1];
@@ -826,9 +847,11 @@ int do_set_default_subvol(int nargs, char **argv)
 		return 30;
 	}
 	ret =3D ioctl(fd, BTRFS_IOC_DEFAULT_SUBVOL, &objectid);
+	e =3D errno;
 	close(fd);
 	if( ret < 0 ){
=2D		fprintf(stderr, "ERROR: unable to set a new default subvolume\n");
+		fprintf(stderr, "ERROR: unable to set a new default subvolume - %s\n",
+			strerror(e));
 		return 30;
 	}
 	return 0;
@@ -840,6 +863,7 @@ int do_df_filesystem(int nargs, char **argv)
 	u64 count =3D 0, i;
 	int ret;
 	int fd;
+	int e;
 	char *path =3D argv[1];
=20
 	fd =3D open_file_or_dir(path);
@@ -856,7 +880,10 @@ int do_df_filesystem(int nargs, char **argv)
 	sargs->total_spaces =3D 0;
=20
 	ret =3D ioctl(fd, BTRFS_IOC_SPACE_INFO, sargs);
+	e =3D errno;
 	if (ret) {
+		fprintf(stderr, "ERROR: couldn't get space info on '%s' - %s\n",
+			path, strerror(e));
 		free(sargs);
 		return ret;
 	}
@@ -874,7 +901,11 @@ int do_df_filesystem(int nargs, char **argv)
 	sargs->total_spaces =3D 0;
=20
 	ret =3D ioctl(fd, BTRFS_IOC_SPACE_INFO, sargs);
+	e =3D errno;
 	if (ret) {
+		fprintf(stderr, "ERROR: couldn't get space info on '%s' - %s\n",
+			path, strerror(e));
+		close(fd);
 		free(sargs);
 		return ret;
 	}
diff --git a/utils.c b/utils.c
index fd894f3..3e22403 100644
=2D-- a/utils.c
+++ b/utils.c
@@ -821,6 +821,7 @@ void btrfs_register_one_device(char *fname)
 	struct btrfs_ioctl_vol_args args;
 	int fd;
 	int ret;
+	int e;
=20
 	fd =3D open("/dev/btrfs-control", O_RDONLY);
 	if (fd < 0) {
@@ -830,6 +831,11 @@ void btrfs_register_one_device(char *fname)
 	}
 	strcpy(args.name, fname);
 	ret =3D ioctl(fd, BTRFS_IOC_SCAN_DEV, &args);
+	e =3D errno;
+	if(ret<0){
+		fprintf(stderr, "ERROR: unable to scan the device '%s' - %s\n",
+			fname, strerror(e));
+	}
 	close(fd);
 }
=20

--Boundary-01=_7c7DNKMiWRkKvdj--

--nextPart2108316.z0bevh2fcb
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQBND7c7vwTxYT3FBRIRAg6vAJ0WsZgIFGrJNhE+Ek8AFkljOF/dBACfcrbd
OuOEm2W/3pvvfrgsg5V2NgA=
=wOPU
-----END PGP SIGNATURE-----

--nextPart2108316.z0bevh2fcb--
