From: Goffredo Baroncelli <kreijack@libero.it>
Subject: [RFC] Improve btrfs subvolume find-new command
Date: Sat, 11 Dec 2010 23:47:02 +0100
Message-ID: <201012112347.10004.kreijack@libero.it>
Reply-To: kreijack@libero.it
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1673920.vkyoHVyFld";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

--nextPart1673920.vkyoHVyFld
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hi all,

enclose a patch to improve the "btrfs subvolume find-new" command. This is =
a=20
RFC because it is not finished, but it is an usable state and may be=20
discussed. The aim of this patch is:
=2D take in account not only an update of the extent but also an update of =
the=20
inode and xattr (which includes the acl)
=2D extract the generation reference number directly from a snapshot

The new syntax is:

  btrfs subvolume find-new [-v|--verbose][-s|--subvol]<path> <last_gen>
       List the recently modified files in a filesystem.

the switch -v increase the verbosity of the output (see example below); if =
the=20
switch '-s' is passed <last_gen> is not a number, but a snapshot path from=
=20
which the command extract the generation number.

Examples

# btrfs subvolume find-new rootfs/ -s snap-20101207
tmp
var/log/exim4/mainlog
var/log/kdm.log
var/log/daemon.log
var/log/kern.log
var/log/syslog
var/log/messages
var/log/wtmp
var/log/auth.log
var/tmp/kdecache-ghigo/icon-cache.kcache
var/tmp/kdecache-ghigo/plasma_theme_default.kcache
var/run/utmp
var/log/Xorg.0.log
var/run/freepops.pid
[...]


# btrfs subvolume find-new -v snap-20101207 10639
inode 485761 name tmp/paperopoli
   INODE: mode 0x000041ed gen 12326 nbyte 0 nlink 1 uid 0 gid 0 flags 0x0000
inode 485762 name tmp/paperopoli/topolinea
   XATTR: namelen 10 datalen 10 name user.pippo
inode 485764 name tmp/paperopoli/metropolis
   INODE: mode 0x000081ac gen 12347 nbyte 7 nlink 1 uid 0 gid 0 flags 0x0000
   XATTR: namelen 23 datalen 52 name system.posix_acl_access
   XATTR: namelen 11 datalen 13 name user.pluto3
   XATTR: namelen 10 datalen 13 name user.pluto
   EXTENT: file offset 0 len 7 disk start 0 offset 0 gen 12326 flags INLINE


The output above means:
=2D file "tmp/paperopoli", inode 485761, the inode is updated
=2D file "tmp/paperopoli/topolinea", inode 485762, the extended attribute=20
"user.pippo" is updated
=2D file "tmp/paperopoli/metropolis", inode 485764, the inode, an extent an=
d=20
some xtended attribute and the acl (system.posix_acl_access) are updated

Open point:

=2D are really useful so too much information ?(I think that we can short t=
he=20
inode line without loosing anything) . Another option is to make less verbo=
se=20
the message shortening "file offset" in "fo:" and so...

=2D take in account that a filename may contains a "new line".. (may be tha=
t I=20
am paranoid ? :-) )

=2D I am thinking about intermediated mode between the verbose mode and the=
=20
"standard" mode. Something like:
	XEI tmp/foo/bar
 where
	X,E,I are flags which track if there are changes in a Inode, eXtended
        attribute or in the Extent
I thick that from a "bash scriptiong" POV would be more usefoul.

=2D it is impossible to track the "deleted" items (files,dirs, eXtended=20
attributes). I can develop a command which compare two subvolumes an extrac=
t=20
all of this kind of information. But this command would return correct=20
information *only if*=20
   A) a subvolume is a snapshot of the other one
   B.1) the reference snapshot is not touched OR
   B.2) I have the lastgen "when" the snapshot is taken
I have to highlight that these conditions cannot be guarantee (nor check) b=
y a=20
tool like the "btrfs" command. However may be evaluated that for every=20
snapshot is track the root uuid from which the snapshot is taken and the=20
lastgen when the snapshot happened... It may be another item in the tree=20
called "btrfs_snapshot_info_item" or handled in userspace.

=2D what I wrote in the last sentence would lead to remove the "-s" switch.=
=2E.

TODO:
=2D improve the cache of the filename and the dir (now only the last entry =
is=20
cached)
=2D improve the function ino_resolve to return all the path associated to a=
n=20
inode (a file with multiple hardlinks has more paths)
=2D  improve the man page

The patch is based on the great work of "Sean Reifschneider" who developed =
the=20
"last-gen" command, winch unfortunately is not yet in the repo .


Comments are welcome.

G.Baroncelli

 btrfs-list.c   |  245 ++++++++++++++++++++++++++++++++++++++++------------=
=2D--
 btrfs.c        |    5 -
 btrfs_cmds.c   |   84 ++++++++++++++++++-
 btrfs_cmds.h   |    4=20
 man/btrfs.8.in |   19 ++++
 5 files changed, 277 insertions(+), 80 deletions(-)

diff --git a/btrfs-list.c b/btrfs-list.c
index 93766a8..3905436 100644
=2D-- a/btrfs-list.c
+++ b/btrfs-list.c
@@ -310,7 +310,7 @@ static int lookup_ino_path(int fd, struct root_info *ri)
  * Then we use the tree search ioctl to scan all the root items for a
  * given root id and spit out the latest generation we can find
  */
=2Dstatic u64 find_root_gen(int fd)
+u64 find_root_gen(int fd)
 {
 	struct btrfs_ioctl_ino_lookup_args ino_args;
 	int ret;
@@ -657,11 +657,43 @@ int list_subvols(int fd)
 	return ret;
 }
=20
=2Dstatic int print_one_extent(int fd, struct btrfs_ioctl_search_header *sh,
+static u64 cache_get_full_path_dirid =3D 0;
+static u64 cache_get_full_path_ino =3D 0;
+static char *cache_get_full_path_dir_name =3D NULL;
+static char *cache_get_full_path_full_name =3D NULL;
+
+static void init_cache_get_full_path(void)
+{
+	cache_get_full_path_dirid =3D 0;
+	cache_get_full_path_ino =3D 0;
+	cache_get_full_path_dir_name =3D NULL;
+	cache_get_full_path_full_name =3D NULL;
+}
+=09
+static char *get_full_path(int fd, struct btrfs_ioctl_search_header *sh)
+{
+	char *name =3D NULL;
+
+	if (sh->objectid =3D=3D cache_get_full_path_ino) {
+		name =3D cache_get_full_path_full_name;
+	} else if (cache_get_full_path_full_name) {
+		free(cache_get_full_path_full_name);
+		cache_get_full_path_full_name =3D NULL;
+	}
+	if (!name) {
+		name =3D ino_resolve(fd, sh->objectid,=20
+				   &cache_get_full_path_dirid,
+				   &cache_get_full_path_dir_name);
+		cache_get_full_path_full_name =3D name;
+		cache_get_full_path_ino =3D sh->objectid;
+	}
+
+	return name;
+}
+
+static int print_one_extent(struct btrfs_ioctl_search_header *sh,
 			    struct btrfs_file_extent_item *item,
=2D			    u64 found_gen, u64 *cache_dirid,
=2D			    char **cache_dir_name, u64 *cache_ino,
=2D			    char **cache_full_name)
+			    u64 found_gen)
 {
 	u64 len =3D 0;
 	u64 disk_start =3D 0;
@@ -669,22 +701,6 @@ static int print_one_extent(int fd, struct=20
btrfs_ioctl_search_header *sh,
 	u8 type;
 	int compressed =3D 0;
 	int flags =3D 0;
=2D	char *name =3D NULL;
=2D
=2D	if (sh->objectid =3D=3D *cache_ino) {
=2D		name =3D *cache_full_name;
=2D	} else if (*cache_full_name) {
=2D		free(*cache_full_name);
=2D		*cache_full_name =3D NULL;
=2D	}
=2D	if (!name) {
=2D		name =3D ino_resolve(fd, sh->objectid, cache_dirid,
=2D				   cache_dir_name);
=2D		*cache_full_name =3D name;
=2D		*cache_ino =3D sh->objectid;
=2D	}
=2D	if (!name)
=2D		return -EIO;
=20
 	type =3D btrfs_stack_file_extent_type(item);
 	compressed =3D btrfs_stack_file_extent_compression(item);
@@ -708,9 +724,8 @@ static int print_one_extent(int fd, struct=20
btrfs_ioctl_search_header *sh,
=20
 		return -EIO;
 	}
=2D	printf("inode %llu file offset %llu len %llu disk start %llu "
+	printf("\tEXTENT: file offset %llu len %llu disk start %llu "
 	       "offset %llu gen %llu flags ",
=2D	       (unsigned long long)sh->objectid,
 	       (unsigned long long)sh->offset,
 	       (unsigned long long)len,
 	       (unsigned long long)disk_start,
@@ -732,29 +747,151 @@ static int print_one_extent(int fd, struct=20
btrfs_ioctl_search_header *sh,
 	if (!flags)
 		printf("NONE");
=20
=2D	printf(" %s\n", name);
+	printf("\n");
 	return 0;
 }
=20
=2Dint find_updated_files(int fd, u64 root_id, u64 oldest_gen)
+BTRFS_SETGET_STACK_FUNCS(stack_inode_nbyte,
+                         struct btrfs_inode_item, nbytes, 32);
+int print_one_inode(struct btrfs_inode_item *item,
+			    u64 found_gen)
 {
=2D	int ret;
=2D	struct btrfs_ioctl_search_args args;
=2D	struct btrfs_ioctl_search_key *sk =3D &args.key;
+	u32 mode;
+
+	mode =3D btrfs_stack_inode_mode(item);
+	printf("\tINODE: mode 0x%08x gen %llu nbyte %llu nlink %llu uid %llu"
+		" gid %llu flags 0x%016llx\n",
+	       		mode, found_gen,=20
+			(unsigned long long)btrfs_stack_inode_nbyte(item),
+			(unsigned long long)btrfs_stack_inode_nlink(item),
+			(unsigned long long)btrfs_stack_inode_uid(item),
+			(unsigned long long)btrfs_stack_inode_gid(item),
+			(unsigned long long)btrfs_stack_inode_flags(item)
+	);
+
+	return 0;
+}
+
+
+BTRFS_SETGET_STACK_FUNCS(stack_dir_name_len,
+                         struct btrfs_dir_item, name_len, 16);
+BTRFS_SETGET_STACK_FUNCS(stack_dir_data_len,
+                         struct btrfs_dir_item, data_len, 16);
+static int print_one_xattr( struct btrfs_dir_item *item )
+
+{
+	u32 name_len;
+	u32 data_len;
+
+	name_len =3D btrfs_stack_dir_name_len(item);
+	data_len =3D btrfs_stack_dir_data_len(item);
+
+	printf("\tXATTR: namelen %llu datalen %llu name %.*s\n",
+			(unsigned long long)name_len,=20
+			(unsigned long long)data_len,=20
+			name_len, (char *)(item + 1));
+	return 0;
+}
+
+
+static inline void print_filename_one_time( int fd,
+	struct btrfs_ioctl_search_header *sh, u64 *old_objectid,
+	int verbose)
+{=09
+	if ( sh->objectid !=3D *old_objectid ){
+		if(verbose >=3D50 )
+			printf("inode %llu name ",
+			       (unsigned long long)sh->objectid);
+		printf("%s\n", get_full_path(fd, sh));
+		*old_objectid =3D sh->objectid;
+	}
+}=09
+
+
+BTRFS_SETGET_STACK_FUNCS(stack_inode_transid,
+                         struct btrfs_inode_item, transid, 64);
+static void _find_updated_files_2(int fd,=20
+			struct btrfs_ioctl_search_args *args,
+			u64 *old_objectid,
+			u64 oldest_gen,
+			int verbose )
+{=09
+	struct btrfs_ioctl_search_key *sk =3D &args->key;
 	struct btrfs_ioctl_search_header *sh;
 	struct btrfs_file_extent_item *item;
 	unsigned long off =3D 0;
 	u64 found_gen;
=2D	u64 max_found =3D 0;
 	int i;
=2D	u64 cache_dirid =3D 0;
=2D	u64 cache_ino =3D 0;
=2D	char *cache_dir_name =3D NULL;
=2D	char *cache_full_name =3D NULL;
 	struct btrfs_file_extent_item backup;
=20
 	memset(&backup, 0, sizeof(backup));
+
+	/*
+	 * for each item, pull the key out of the header and then
+	 * read the root_ref item it contains
+	 */
+	for (off =3D 0, i =3D 0; i < sk->nr_items; i++) {
+		sh =3D (struct btrfs_ioctl_search_header *)(args->buf +
+							  off);
+		off +=3D sizeof(*sh);
+
+		/*
+		 * just in case the item was too big, pass something other
+		 * than garbage
+		 */
+		if (sh->len =3D=3D 0)
+			item =3D &backup;
+		else
+			item =3D (struct btrfs_file_extent_item *)(args->buf +
+							 off);
+		found_gen =3D btrfs_stack_file_extent_generation(item);
+
+		if (sh->type =3D=3D BTRFS_EXTENT_DATA_KEY &&
+		    found_gen >=3D oldest_gen) {
+			print_filename_one_time(fd, sh, old_objectid,=20
verbose);
+			if(verbose>=3D100)
+				print_one_extent(sh,item, found_gen);
+		} else if (sh->type =3D=3D BTRFS_INODE_ITEM_KEY ){
+			struct btrfs_inode_item *i =3D
+				(struct btrfs_inode_item*)(args->buf+off);
+			found_gen =3D btrfs_stack_inode_transid(i);
+			if( found_gen >=3D oldest_gen) {
+				print_filename_one_time(fd, sh, old_objectid,
+							verbose);
+				if(verbose>=3D100)
+					print_one_inode(i,found_gen);
+
+			}
+		} else if (sh->type =3D=3D BTRFS_XATTR_ITEM_KEY ){
+			struct btrfs_dir_item *i =3D
+			    	(struct btrfs_dir_item*)(args->buf+off);
+			print_filename_one_time(fd, sh, old_objectid,=20
verbose);
+			if(verbose>=3D100)
+					print_one_xattr(i);
+		}
+
+		off +=3D sh->len;
+
+		/*
+		 * record the mins in sk so we can make sure the
+		 * next search doesn't repeat this root
+		 */
+		sk->min_objectid =3D sh->objectid;
+		sk->min_offset =3D sh->offset;
+		sk->min_type =3D sh->type;
+	}
+
+}
+
+int find_updated_files(int fd, u64 root_id, u64 oldest_gen, int verbose)
+{
+	int ret;
+	struct btrfs_ioctl_search_args args;
+	struct btrfs_ioctl_search_key *sk =3D &args.key;
+	u64 old_objectid =3D -1;
+=09
 	memset(&args, 0, sizeof(args));
+	init_cache_get_full_path();
=20
 	sk->tree_id =3D root_id;
=20
@@ -770,7 +907,6 @@ int find_updated_files(int fd, u64 root_id, u64=20
oldest_gen)
 	/* just a big number, doesn't matter much */
 	sk->nr_items =3D 4096;
=20
=2D	max_found =3D find_root_gen(fd);
 	while(1) {
 		ret =3D ioctl(fd, BTRFS_IOC_TREE_SEARCH, &args);
 		if (ret < 0) {
@@ -781,43 +917,9 @@ int find_updated_files(int fd, u64 root_id, u64=20
oldest_gen)
 		if (sk->nr_items =3D=3D 0)
 			break;
=20
=2D		off =3D 0;
=2D
=2D		/*
=2D		 * for each item, pull the key out of the header and then
=2D		 * read the root_ref item it contains
=2D		 */
=2D		for (i =3D 0; i < sk->nr_items; i++) {
=2D			sh =3D (struct btrfs_ioctl_search_header *)(args.buf +
=2D								  off);
=2D			off +=3D sizeof(*sh);
=2D
=2D			/*
=2D			 * just in case the item was too big, pass something=20
other
=2D			 * than garbage
=2D			 */
=2D			if (sh->len =3D=3D 0)
=2D				item =3D &backup;
=2D			else
=2D				item =3D (struct btrfs_file_extent_item *)
(args.buf +
=2D								 off);
=2D			found_gen =3D btrfs_stack_file_extent_generation(item);
=2D			if (sh->type =3D=3D BTRFS_EXTENT_DATA_KEY &&
=2D			    found_gen >=3D oldest_gen) {
=2D				print_one_extent(fd, sh, item, found_gen,
=2D						 &cache_dirid,=20
&cache_dir_name,
=2D						 &cache_ino,=20
&cache_full_name);
=2D			}
=2D			off +=3D sh->len;
+		_find_updated_files_2( fd, &args, &old_objectid, oldest_gen,
+					verbose );
=20
=2D			/*
=2D			 * record the mins in sk so we can make sure the
=2D			 * next search doesn't repeat this root
=2D			 */
=2D			sk->min_objectid =3D sh->objectid;
=2D			sk->min_offset =3D sh->offset;
=2D			sk->min_type =3D sh->type;
=2D		}
 		sk->nr_items =3D 4096;
 		if (sk->min_offset < (u64)-1)
 			sk->min_offset++;
@@ -828,8 +930,5 @@ int find_updated_files(int fd, u64 root_id, u64=20
oldest_gen)
 		} else
 			break;
 	}
=2D	free(cache_dir_name);
=2D	free(cache_full_name);
=2D	printf("transid marker was %llu\n", (unsigned long long)max_found);
 	return ret;
 }
diff --git a/btrfs.c b/btrfs.c
index 46314cf..1b5fe9f 100644
=2D-- a/btrfs.c
+++ b/btrfs.c
@@ -61,9 +61,12 @@ static struct Command commands[] =3D {
 	{ do_subvol_list, 1, "subvolume list", "<path>\n"
 		"List the snapshot/subvolume of a filesystem."
 	},
=2D	{ do_find_newer, 2, "subvolume find-new", "<path> <last_gen>\n"
+	{ do_find_newer, -2, "subvolume find-new", "[-v|--verbose][-s|--
subvol]<path> <last_gen>\n"
 		"List the recently modified files in a filesystem."
 	},
+	{ do_get_latest_gen, 1, "subvolume last-gen", "<path>\n"
+		"Return the latest generation of a filesystem."
+	},
 	{ do_defrag, -1,
 	  "filesystem defragment", "[-vcf] [-s start] [-l len] [-t size]=20
<file>|<dir> [<file>|<dir>...]\n"
 		"Defragment a file or a directory."
diff --git a/btrfs_cmds.c b/btrfs_cmds.c
index 8031c58..9bcc280 100644
=2D-- a/btrfs_cmds.c
+++ b/btrfs_cmds.c
@@ -247,16 +247,90 @@ int do_defrag(int ac, char **av)
 	return errors + 20;
 }
=20
+static int _get_latest_gen(char *subvol, u64 *max_found)
+{
+	int fd;
+	int ret;
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
+	*max_found =3D find_root_gen(fd);
+	return 0;
+}
+
+
+int do_get_latest_gen(int argc, char **argv)
+{
+	int ret;
+	u64 max_found =3D 0;
+
+	ret =3D _get_latest_gen(argv[1], &max_found);
+	if(ret)
+		return ret;
+	printf("%llu\n", (unsigned long long)max_found);
+	return 0;
+}
+
 int do_find_newer(int argc, char **argv)
 {
 	int fd;
 	int ret;
=2D	char *subvol;
=2D	u64 last_gen;
+	char *subvol=3D0, *gen=3D0;
+	u64 last_gen =3D (u64)-1;
+	int i =3D 1;
+	int verbose=3D0;	/* 0 print only file/dir name; 100 is verbose */
+	int last_gen_as_subvol=3D0;
=20
=2D	subvol =3D argv[1];
=2D	last_gen =3D atoll(argv[2]);
=20
+	for(i=3D1;i<argc;i++){
+		if(!strcmp(argv[i],"-v")||!strcmp(argv[i],"--verbose")){
+			verbose =3D 100;
+			continue;
+		}
+		if(!strcmp(argv[i],"-s")||!strcmp(argv[i],"--subvol")){
+			last_gen_as_subvol =3D 1;
+			continue;
+		}
+		if( !subvol ){
+			subvol =3D argv[i];
+			continue;
+		}
+		if( !gen ){
+			gen =3D argv[i];
+			continue;
+		}
+
+		fprintf(stderr, "ERROR: too much number of parameters\n");
+		return 12;
+
+	}
+
+	if( !subvol){
+		fprintf(stderr, "ERROR: not ebough number of parameters\n");
+       	        return 12;
+        }
+
+	if(last_gen_as_subvol){
+		ret =3D _get_latest_gen(gen, &last_gen);
+		if(ret)
+			return ret;
+	} else
+		last_gen =3D atoll(gen);
+=09
+printf("last_gen=3D%llu; gen=3D%s\n",last_gen,gen);
 	ret =3D test_issubvolume(subvol);
 	if (ret < 0) {
 		fprintf(stderr, "ERROR: error accessing '%s'\n", subvol);
@@ -272,7 +346,7 @@ int do_find_newer(int argc, char **argv)
 		fprintf(stderr, "ERROR: can't access '%s'\n", subvol);
 		return 12;
 	}
=2D	ret =3D find_updated_files(fd, 0, last_gen);
+	ret =3D find_updated_files(fd, 0, last_gen, verbose);
 	if (ret)
 		return 19;
 	return 0;
diff --git a/btrfs_cmds.h b/btrfs_cmds.h
index 7bde191..41372e7 100644
=2D-- a/btrfs_cmds.h
+++ b/btrfs_cmds.h
@@ -20,6 +20,7 @@ int do_delete_subvolume(int nargs, char **argv);
 int do_create_subvol(int nargs, char **argv);
 int do_fssync(int nargs, char **argv);
 int do_defrag(int argc, char **argv);
+int do_get_latest_gen(int argc, char **argv);
 int do_show_filesystem(int nargs, char **argv);
 int do_add_volume(int nargs, char **args);
 int do_balance(int nargs, char **argv);
@@ -30,5 +31,6 @@ int do_subvol_list(int nargs, char **argv);
 int do_set_default_subvol(int nargs, char **argv);
 int list_subvols(int fd);
 int do_df_filesystem(int nargs, char **argv);
=2Dint find_updated_files(int fd, u64 root_id, u64 oldest_gen);
+int find_updated_files(int fd, u64 root_id, u64 oldest_gen, int verbose);
 int do_find_newer(int argc, char **argv);
+u64 find_root_gen(int fd);
diff --git a/man/btrfs.8.in b/man/btrfs.8.in
index 26ef982..23ba7d2 100644
=2D-- a/man/btrfs.8.in
+++ b/man/btrfs.8.in
@@ -15,6 +15,10 @@ btrfs \- control a btrfs filesystem
 .PP
 \fBbtrfs\fP \fBsubvolume set-default\fP\fI <id> <path>\fP
 .PP
+\fBbtrfs\fP \fBsubvolume last-gen\fP\fI <path>\fP
+.PP
+\fBbtrfs\fP \fBsubvolume find-new\fP\fI <path> <last_gen>\fP
+.PP
 \fBbtrfs\fP \fBfilesystem defrag\fP\fI <file>|<dir> [<file>|<dir>...]\fP
 .PP
 \fBbtrfs\fP \fBfilesystem sync\fP\fI <path> \fP
@@ -96,6 +100,21 @@ These <ID> may be used by the \fBsubvolume set-default\=
fR=20
command, or at
 mount time via the \fIsubvol=3D\fR option.
 .TP
=20
+\fBsubvolume last-gen\fR\fI <path>\fR
+Return the most current generation id of \fI<path>\fR.  This number is
+suitable for use with the \fBsubvolume find-new\fR command, for example.
+A single number is sent to stdout, representing the most recent generation
+within a subvolume/snapshot.
+
+\fBsubvolume find-new\fR\fI <path> <last_gen>\fR
+Display changes to the subvolume \fI<path>\fR since the generation id
+\fI<last_gen>\fR.  The resulting information includes filenames, offset
+within the file, length, and more.  The last line output displays the most
+recent generation id represented by the output.  For example, one could
+feed this id back in to get an ongoing report of changes to the
+subvolume.
+.TP
+
 \fBsubvolume set-default\fR\fI <id> <path>\fR
 Set the subvolume of the filesystem \fI<path>\fR which is mounted as=20
 \fIdefault\fR. The subvolume is identified by \fB<id>\fR, which=20

=2D-=20
gpg key@ keyserver.linux.it: Goffredo Baroncelli (ghigo) <kreijack@inwind.i=
t>
Key fingerprint =3D 4769 7E51 5293 D36C 814E  C054 BF04 F161 3DC5 0512

--nextPart1673920.vkyoHVyFld
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQBNA/9mvwTxYT3FBRIRAnLeAJ40XCcyw4wyfyPzlm05xpnOgmRUHgCeN7fD
Wul1HNPPHuauWtyrlrMJZzw=
=MZpg
-----END PGP SIGNATURE-----

--nextPart1673920.vkyoHVyFld--
