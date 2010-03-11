From: Goffredo Baroncelli <kreijack@gmail.com>
Subject: [PATCH 1/2] Re: New btrfs command pushed into the btrfs-progs subvol branch - commands
Date: Thu, 11 Mar 2010 22:44:21 +0100
Message-ID: <201003112244.31375.kreijack@inwind.it>
References: <20100311185421.GM6509@think> <201003112003.18245.kreijack@inwind.it> <20100311190828.GN6509@think>
Reply-To: kreijack@inwind.it
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1310407.Euym9iRH6h";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Cc: linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100311190828.GN6509@think>
List-ID: <linux-btrfs.vger.kernel.org>

--nextPart1310407.Euym9iRH6h
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Hi Chris,

I updated my git repository. You can pull from=20

git pull http://cassiopea.homelinux.net/git/btrfs-command.git mlc-subvol

(branch mlc-subvol, commit e59135a27dc1fde6acc4fb198499be2b6cbd9f6f)

$ git diff remotes/origin/subvol | diffstat
 btrfs-list.c   |   15 +++--
 btrfs.c        |   56 +++++++++++++++++-
 btrfs_cmds.c   |   84 +++++++++++++++++-----------
 btrfs_cmds.h   |    1=20
 man/btrfs.8.in |  150 +++++++++++++++++++++++++++++++++++++++++++++[...]
 5 files changed, 283 insertions(+), 43 deletions(-)


As you requested I update the parser in order set the argv[0] argument as t=
he=20
program name + the verb. For example if I do

	$ btrfs dev add

the argv[0] will be equal to "btrfs device add". I hope that is what you=20
requested.

Due to this change I update all the commands in order to evaluate the=20
arguments from argv[1] and not from argv[0] anymore. (I update also your=20
do_defrag() function)

Also because I implemented that already the week ago:
=2D I made some small modification to btrfs-list.c in order to be more frie=
ndly=20
in case of error (replace some "exit(2)" with "return -ERR")
=2D I implemented the command "btrf subvolume set-default"

Hoping that this can you help
Regards=20
G.Baroncelli


diff --git a/btrfs-list.c b/btrfs-list.c
index 6305d3c..f2f119b 100644
=2D-- a/btrfs-list.c
+++ b/btrfs-list.c
@@ -66,7 +66,7 @@ struct root_info {
 	char name[];
 };
=20
=2Dvoid root_lookup_init(struct root_lookup *tree)
+static void root_lookup_init(struct root_lookup *tree)
 {
 	tree->root.rb_node =3D NULL;
 }
@@ -275,9 +275,9 @@ static int lookup_ino_path(int fd, struct root_info *ri)
=20
 	ret =3D ioctl(fd, BTRFS_IOC_INO_LOOKUP, &args);
 	if (ret) {
=2D		fprintf(stderr, "Failed to lookup path for root %llu\n",
+		fprintf(stderr, "ERROR: Failed to lookup path for root=20
%llu\n",
 			(unsigned long long)ri->ref_tree);
=2D		exit(1);
+		return ret;
 	}
=20
 	if (args.name[0]) {
@@ -346,8 +346,8 @@ int list_subvols(int fd)
 	while(1) {
 		ret =3D ioctl(fd, BTRFS_IOC_TREE_SEARCH, &args);
 		if (ret < 0) {
=2D			perror("ioctl:");
=2D			break;
+			fprintf(stderr, "ERROR: can't perform the search\n");
+			return ret;
 		}
 		/* the ioctl returns the number of item it found in nr_items=20
*/
 		if (sk->nr_items =3D=3D 0)
@@ -398,8 +398,11 @@ int list_subvols(int fd)
 	n =3D rb_first(&root_lookup.root);
 	while (n) {
 		struct root_info *entry;
+		int ret;
 		entry =3D rb_entry(n, struct root_info, rb_node);
=2D		lookup_ino_path(fd, entry);
+		ret =3D lookup_ino_path(fd, entry);
+		if(ret < 0)
+			return ret;
 		n =3D rb_next(n);
 	}
=20
diff --git a/btrfs.c b/btrfs.c
index 20f7413..58271f6 100644
=2D-- a/btrfs.c
+++ b/btrfs.c
@@ -60,10 +60,15 @@ static struct Command commands[] =3D {
 	{ do_subvol_list, 1, "subvolume list", "<path>\n"
 		"List the snapshot/subvolume of a filesystem."
 	},
=2D
 	{ do_defrag, -1,
 	  "filesystem defragment", "[-vcf] [-s start] [-l len] [-t size]=20
<file>|<dir> [<file>|<dir>...]\n"
 		"Defragment a file or a directory."
+
+	},
+	{ do_set_default_subvol, 2,
+	  "subvolume set-default", "<id> <path>\n"
+		"Set the subvolume of the filesystem <path> which will be=20
mounted\n"
+		"as default."
 	},
 	{ do_fssync, 1,
 	  "filesystem sync", "<path>\n"
@@ -88,11 +93,12 @@ static struct Command commands[] =3D {
 		"Scan all device for or the passed device for a btrfs\n"
 		"filesystem."
 	},
=2D	{ do_add_volume, -1,
+
+	{ do_add_volume, -2,
 	  "device add", "<dev> [<dev>..] <path>\n"
 		"Add a device to a filesystem."
 	},
=2D	{ do_remove_volume, -1,
+	{ do_remove_volume, -2,
 	  "device delete", "<dev> [<dev>..] <path>\n"
 		"Remove a device from a filesystem."
 	},
@@ -208,6 +214,41 @@ static int check_ambiguity(struct Command *cmd, char=20
**argv){
 }
=20
 /*
+ * This function, compacts the program name and the command in the first
+ * element of the '*av' array
+ */
+static int prepare_args(int *ac, char ***av, char *prgname, struct Command=
=20
*cmd ){
+
+	char	**ret;
+	int	i;
+	char	*newname;
+
+	ret =3D (char **)malloc(sizeof(char*)*(*ac+1));
+	newname =3D (char*)malloc(strlen(prgname)+strlen(cmd->verb)+2);
+	if( !ret || !newname ){
+		free(ret);
+		free(newname);
+		return -1;
+	}
+
+	ret[0] =3D newname;
+	for(i=3D0; i < *ac ; i++ )
+		ret[i+1] =3D (*av)[i];
+
+	strcpy(newname, prgname);
+	strcat(newname, " ");
+	strcat(newname, cmd->verb);
+
+	(*ac)++;
+	*av =3D ret;
+
+	return 0;
+
+}
+
+
+
+/*
=20
 	This function perform the following jobs:
 	- show the help if '--help' or 'help' or '-h' are passed
@@ -307,11 +348,18 @@ static int parse_args(int argc, char **argv,
 			matchcmd->verb, -matchcmd->nargs);
 			return -2;
 	}
=2D	if(matchcmd->nargs >=3D 0 && matchcmd->nargs !=3D *nargs_ && matchcmd-
>nargs !=3D 999 ){
+
+	if(matchcmd->nargs >=3D 0 && matchcmd->nargs !=3D *nargs_ && matchcmd-
>nargs !=3D 999){
 		fprintf(stderr, "ERROR: '%s' requires %d arg(s)\n",
 			matchcmd->verb, matchcmd->nargs);
 			return -2;
 	}
+=09
+        if (prepare_args( nargs_, args_, prgname, matchcmd )){
+                fprintf(stderr, "ERROR: not enough memory\\n");
+		return -20;
+        }
+
=20
 	return 1;
 }
diff --git a/btrfs_cmds.c b/btrfs_cmds.c
index 3a21be3..89f47c2 100644
=2D-- a/btrfs_cmds.c
+++ b/btrfs_cmds.c
@@ -59,7 +59,7 @@ static inline int ioctl(int fd, int define, void *arg) {=
=20
return 0; }
 static int test_issubvolume(char *path)
 {
=20
=2D	struct stat	st;
+	struct stat 	st;
 	int		res;
=20
 	res =3D stat(path, &st);
@@ -79,7 +79,7 @@ static int test_issubvolume(char *path)
  */
 static int test_isdir(char *path)
 {
=2D	struct stat	st;
+	struct stat 	st;
 	int		res;
=20
 	res =3D stat(path, &st);
@@ -142,7 +142,7 @@ static u64 parse_size(char *s)
 	return atoll(s) * mult;
 }
=20
=2Dint do_defrag(int ac, char **avp)
+int do_defrag(int ac, char **av)
 {
 	int fd;
 	int compress =3D 0;
@@ -156,17 +156,6 @@ int do_defrag(int ac, char **avp)
 	int verbose =3D 0;
 	int fancy_ioctl =3D 0;
 	struct btrfs_ioctl_defrag_range_args range;
=2D	char **av;
=2D
=2D	/*
=2D	 * getopt expects av[0] to be the program name and it seems
=2D	 * to get confused when this isn't the case
=2D	 */
=2D	av =3D malloc((ac + 2) * sizeof(char *));
=2D	av[0] =3D "defrag";
=2D	av[ac + 1] =3D NULL;
=2D	memcpy(av + 1, avp, ac * sizeof(char *));
=2D	ac +=3D 1;
=20
 	optind =3D 1;
 	while(1) {
@@ -264,7 +253,7 @@ int do_subvol_list(int argc, char **argv)
 	int ret;
 	char *subvol;
=20
=2D	subvol =3D argv[0];
+	subvol =3D argv[1];
=20
 	ret =3D test_issubvolume(subvol);
 	if (ret < 0) {
@@ -289,13 +278,13 @@ int do_subvol_list(int argc, char **argv)
=20
 int do_clone(int argc, char **argv)
 {
=2D	char	*subvol, *dst;
+	char 	*subvol, *dst;
 	int	res, fd, fddst, len;
 	char	*newname;
 	char	*dstdir;
=20
=2D	subvol =3D argv[0];
=2D	dst =3D argv[1];
+	subvol =3D argv[1];
+	dst =3D argv[2];
 	struct btrfs_ioctl_vol_args	args;
=20
 	res =3D test_issubvolume(subvol);
@@ -375,7 +364,7 @@ int do_delete_subvolume(int argc, char **argv)
 	int	res, fd, len;
 	struct btrfs_ioctl_vol_args	args;
 	char	*dname, *vname, *cpath;
=2D	char	*path =3D argv[0];
+	char	*path =3D argv[1];
=20
 	res =3D test_issubvolume(path);
 	if(res<0){
@@ -436,7 +425,7 @@ int do_create_subvol(int argc, char **argv)
 	char	*newname;
 	char	*dstdir;
 	struct btrfs_ioctl_vol_args	args;
=2D	char	*dst =3D argv[0];
+	char	*dst =3D argv[1];
=20
 	res =3D test_isdir(dst);
 	if(res >=3D 0 ){
@@ -487,7 +476,7 @@ int do_create_subvol(int argc, char **argv)
 int do_fssync(int argc, char **argv)
 {
 	int fd, res;
=2D	char	*path =3D argv[0];
+	char	*path =3D argv[1];
=20
 	fd =3D open_file_or_dir(path);
 	if (fd < 0) {
@@ -506,10 +495,10 @@ int do_fssync(int argc, char **argv)
 	return 0;
 }
=20
=2Dint do_scan(int nargs, char **argv)
+int do_scan(int argc, char **argv)
 {
 	int	i, fd;
=2D	if(!nargs){
+	if(argc<=3D1){
 		int ret;
=20
 		printf("Scanning for Btrfs filesystems\n");
@@ -527,8 +516,8 @@ int do_scan(int nargs, char **argv)
 		return 10;
 	}
=20
=2D	for( i =3D 0 ; i < nargs ; i++ ){
=2D		struct btrfs_ioctl_vol_args	args;
+	for( i =3D 1 ; i < argc ; i++ ){
+		struct btrfs_ioctl_vol_args 	args;
 		int	ret;
=20
 		printf("Scanning for Btrfs filesystems in '%s'\n", argv[i]);
@@ -558,8 +547,8 @@ int do_resize(int argc, char **argv)
=20
 	struct btrfs_ioctl_vol_args	args;
 	int	fd, res, len;
=2D	char	*amount=3Dargv[0], *path=3Dargv[1];
=2D
+	char 	*amount=3Dargv[1], *path=3Dargv[2];
+=09
 	fd =3D open_file_or_dir(path);
 	if (fd < 0) {
 		fprintf(stderr, "ERROR: can't access to '%s'\n", path);
@@ -646,7 +635,7 @@ int do_show_filesystem(int argc, char **argv)
 	struct list_head *all_uuids;
 	struct btrfs_fs_devices *fs_devices;
 	struct list_head *cur_uuid;
=2D	char *search =3D argv[0];
+	char *search =3D argv[1];
 	int ret;
=20
 	ret =3D btrfs_scan_one_dir("/dev", 0);
@@ -680,8 +669,8 @@ int do_add_volume(int nargs, char **args)
 		return 12;
 	}
=20
=2D	for(i=3D0 ; i < (nargs-1) ; i++ ){
=2D		struct	btrfs_ioctl_vol_args ioctl_args;
+	for(i=3D1 ; i < (nargs-1) ; i++ ){
+		struct 	btrfs_ioctl_vol_args ioctl_args;
 		int	devfd, res;
 		u64 dev_block_count =3D 0;
 		struct stat st;
@@ -737,8 +726,8 @@ int do_balance(int argc, char **argv)
 {
=20
 	int	fdmnt, ret=3D0;
=2D	char	*path =3D argv[0];
 	struct btrfs_ioctl_vol_args args;
+	char	*path =3D argv[1];
=20
 	fdmnt =3D open_file_or_dir(path);
 	if (fdmnt < 0) {
@@ -768,8 +757,8 @@ int do_remove_volume(int nargs, char **args)
 		return 12;
 	}
=20
=2D	for(i=3D0 ; i < (nargs-1) ; i++ ){
=2D		struct	btrfs_ioctl_vol_args arg;
+	for(i=3D1 ; i < (nargs-1) ; i++ ){
+		struct 	btrfs_ioctl_vol_args arg;
 		int	res;
=20
 		strcpy(arg.name, args[i]);
@@ -786,3 +775,32 @@ int do_remove_volume(int nargs, char **args)
 	else
 		return 0;
 }
+
+int do_set_default_subvol(int nargs, char **argv)
+{
+	int	ret=3D0, fd;
+	u64	objectid;
+	char 	*path =3D argv[2];
+	char	*subvolid =3D argv[1];
+
+	fd =3D open_file_or_dir(path);
+	if (fd < 0) {
+		fprintf(stderr, "ERROR: can't access to '%s'\n", path);
+		return 12;
+	}
+
+	objectid =3D (unsigned long long)strtoll(subvolid, NULL, 0);
+	if (errno =3D=3D ERANGE) {
+		fprintf(stderr, "ERROR: invalid tree id (%s)\n",subvolid);
+		return 30;
+	}
+	ret =3D ioctl(fd, BTRFS_IOC_DEFAULT_SUBVOL, &objectid);
+	close(fd);
+	if( ret < 0 ){
+		fprintf(stderr, "ERROR: unable to set a new default=20
subvolume\n");
+		return 30;
+	}
+	return 0;
+=09
+}
+
diff --git a/btrfs_cmds.h b/btrfs_cmds.h
index cfdbde2..c63baa9 100644
=2D-- a/btrfs_cmds.h
+++ b/btrfs_cmds.h
@@ -27,4 +27,5 @@ int do_remove_volume(int nargs, char **args);
 int do_scan(int nargs, char **argv);
 int do_resize(int nargs, char **argv);
 int do_subvol_list(int nargs, char **argv);
+int do_set_default_subvol(int nargs, char **argv);
 int list_subvols(int fd);


=2D---




On Thursday 11 March 2010, you (Chris Mason) wrote:
> Thanks for all your work on btrfs!
>=20
> -chris
>=20
> On Thu, Mar 11, 2010 at 08:03:17PM +0100, Goffredo Baroncelli wrote:
> > On Thursday 11 March 2010, Chris Mason wrote:
> > > Hi everyone,
> > >=20
> > > I've pushed Goffredo's new btrfs utility into the subvol branch of the
> > > btrfs-progs repo.  I'm using it as my starting point for the subvol
> > > listing utility as well as my fancy new defrag range ioctl.
> > >=20
> > > Goffredo, the new defrag ioctl takes a bunch of arguments, and I used
> > > getopt inside the command to do it.  The tricky part is that getopt
> > > expects argv[0] to be the command name, so I had to hack things a bit.
> > >=20
> > > Could you please send a patch that changes the commands to include the
> > > command name in argv[0]?  That'll make it easier to be flexible.
> > >=20
> >=20
> > I will start to work=20
> >=20
> > > -chris
> > >=20
> >=20
> >=20
> > --=20
> > gpg key@ keyserver.linux.it: Goffredo Baroncelli (ghigo)=20
<kreijack@inwind.it>
> > Key fingerprint =3D 4769 7E51 5293 D36C 814E  C054 BF04 F161 3DC5 0512
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


=2D-=20
gpg key@ keyserver.linux.it: Goffredo Baroncelli (ghigo) <kreijackATinwind.=
it>
Key fingerprint =3D 4769 7E51 5293 D36C 814E  C054 BF04 F161 3DC5 0512

--nextPart1310407.Euym9iRH6h
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iD8DBQBLmWQ2vwTxYT3FBRIRAtlgAJ9J994G89BMc6VqA1cZkh6qMQuGuwCeOYBZ
WdBrZxEfdOiWNvij9A+AVuo=
=HBnl
-----END PGP SIGNATURE-----

--nextPart1310407.Euym9iRH6h--
