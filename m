From: Goffredo Baroncelli <kreijack@gmail.com>
Subject: [PATCH 1/2 V2] btrfs, a new tool to manage a btrfs filesystem; source code
Date: Wed, 17 Feb 2010 21:02:24 +0100
Message-ID: <201002172102.30645.kreijack@inwind.it>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2968703.03iS9QVd6E";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

--nextPart2968703.03iS9QVd6E
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

This is the source code of btrfs.c.
The main changes from my previous patch are:
=2D Rearranged the short command in order to avoid conflicts
=2D Renamed the 'create' verb is 'subvolume'
=2D Rearranged the parsing code, which now is integrated in the help in ord=
er to avoid mismatch

BR
G.Baroncelli

diff --git a/Makefile b/Makefile
index 02f881e..888ef8d 100644
=2D-- a/Makefile
+++ b/Makefile
@@ -17,7 +17,7 @@ bindir =3D $(prefix)/bin
 LIBS=3D-luuid
=20
 progs =3D btrfsctl mkfs.btrfs btrfs-debug-tree btrfs-show btrfs-vol btrfsc=
k \
=2D	btrfs-map-logical
+	btrfs-map-logical btrfs
=20
 # make C=3D1 to enable sparse
 ifdef C
@@ -36,6 +36,9 @@ all: version $(progs) manpages
 version:
 	bash version.sh
=20
+btrfs: $(objects) btrfs.o
+	gcc $(CFLAGS) -o btrfs btrfs.o $(objects) $(LDFLAGS) $(LIBS)
+
 btrfsctl: $(objects) btrfsctl.o
 	gcc $(CFLAGS) -o btrfsctl btrfsctl.o $(objects) $(LDFLAGS) $(LIBS)
=20
diff --git a/btrfs.c b/btrfs.c
new file mode 100644
index 0000000..cc55599
=2D-- /dev/null
+++ b/btrfs.c
@@ -0,0 +1,775 @@
+/*
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public
+ * License v2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public
+ * License along with this program; if not, write to the
+ * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
+ * Boston, MA 021110-1307, USA.
+ */
+
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/ioctl.h>
+#include <sys/types.h>
+#include <dirent.h>
+#include <sys/stat.h>
+#include <unistd.h>
+#include <fcntl.h>
+#include <libgen.h>
+#include <limits.h>
+#include <uuid/uuid.h>
+
+#undef ULONG_MAX
+
+#include "kerncompat.h"
+#include "ctree.h"
+#include "transaction.h"
+#include "utils.h"
+#include "version.h"
+#include "ioctl.h"
+#include "volumes.h"
+
+#ifdef __CHECKER__
+#define BLKGETSIZE64 0
+#define BTRFS_IOC_SNAP_CREATE 0
+#define BTRFS_VOL_NAME_MAX 255
+struct btrfs_ioctl_vol_args { char name[BTRFS_VOL_NAME_MAX]; };
+static inline int ioctl(int fd, int define, void *arg) { return 0; }
+#endif
+
+/*
+ * test if path is a subvolume:=20
+ * this function return
+ * 0-> path exists but it is not a subvolume
+ * 1-> path exists and it is  a subvolume
+ * -1 -> path is unaccessible
+ */
+static int test_issubvolume(char *path)
+{
+
+	struct stat 	st;
+	int		res;
+
+	res =3D stat(path, &st);
+	if(res < 0 )
+		return -1;
+
+	return (st.st_ino =3D=3D 256) && S_ISDIR(st.st_mode);
+=09
+}
+
+/*
+ * test if path is a directory
+ * this function return
+ * 0-> path exists but it is not a directory
+ * 1-> path exists and it is  a directory
+ * -1 -> path is unaccessible
+ */
+static int test_isdir(char *path)
+{
+	struct stat 	st;
+	int		res;
+
+	res =3D stat(path, &st);
+	if(res < 0 )
+		return -1;
+
+	return S_ISDIR(st.st_mode);
+
+}
+
+static int open_file_or_dir(const char *fname)
+{
+	int ret;
+	struct stat st;
+	DIR *dirstream;
+	int fd;
+
+	ret =3D stat(fname, &st);
+	if (ret < 0) {
+		return -1;
+	}
+	if (S_ISDIR(st.st_mode)) {
+		dirstream =3D opendir(fname);
+		if (!dirstream) {
+			return -2;
+		}
+		fd =3D dirfd(dirstream);
+	} else {
+		fd =3D open(fname, O_RDWR);
+	}
+	if (fd < 0) {
+		return -3;
+	}
+	return fd;
+}
+
+static int do_clone(char *subvol, char *dst)
+{
+	int	res, fd, fddst;
+	char	*newname;
+	char	*dstdir;
+	struct btrfs_ioctl_vol_args	args;
+
+	res =3D test_issubvolume(subvol);
+	if(res<0){
+		fprintf(stderr, "ERROR: error accessing '%s'\n", subvol);
+		return 12;
+	}
+	if(!res){
+		fprintf(stderr, "ERROR: '%s' is not a subvolume\n", subvol);
+		return 13;
+	}
+
+	res =3D test_isdir(dst);
+	if(res =3D=3D 0 ){
+		fprintf(stderr, "ERROR: '%s' exists and it is not a directory\n", dst);
+		return 12;
+	}
+
+	if(res>0){
+		newname =3D strdup(subvol);
+		newname =3D basename(newname);
+		dstdir =3D dst;
+	}else{
+		newname =3D strdup(dst);
+		newname =3D basename(newname);
+		dstdir =3D strdup(dst);
+		dstdir =3D dirname(dstdir);
+	}
+
+	if( !strcmp(newname,".") || !strcmp(newname,"..") ||
+	     strchr(newname, '/') ){
+		fprintf(stderr, "ERROR: uncorrect snapshot name ('%s')\n",
+			newname);
+		return 14;
+	}
+
+	fddst =3D open_file_or_dir(dstdir);
+	if (fddst < 0) {
+		fprintf(stderr, "ERROR: can't access to '%s'\n", dstdir);
+		return 12;
+	}
+
+	fd =3D open_file_or_dir(subvol);
+	if (fd < 0) {
+		close(fddst);
+		fprintf(stderr, "ERROR: can't access to '%s'\n", dstdir);
+		return 12;
+	}
+
+	printf("Create a snapshot of '%s' in '%s/%s'\n",
+	       subvol, dstdir, newname);
+	args.fd =3D fd;
+	strcpy(args.name, newname);
+	res =3D ioctl(fddst, BTRFS_IOC_SNAP_CREATE, &args);
+
+	close(fd);
+	close(fddst);
+
+	if(res < 0 ){
+		fprintf( stderr, "ERROR: cannot snapshot '%s'\n",subvol);
+		return 11;
+	}
+
+	return 0;
+
+}
+
+static int do_delete_subvolume(char *path)
+{
+	int	res, fd;
+	struct btrfs_ioctl_vol_args	args;
+	char	*dname, *vname, *cpath;
+=09
+	res =3D test_issubvolume(path);
+	if(res<0){
+		fprintf(stderr, "ERROR: error accessing '%s'\n", path);
+		return 12;
+	}
+	if(!res){
+		fprintf(stderr, "ERROR: '%s' is not a subvolume\n", path);
+		return 13;
+	}
+=09
+	cpath =3D realpath(path, 0);
+	dname =3D strdup(cpath);
+	dname =3D dirname(dname);
+	vname =3D strdup(cpath);
+	vname =3D basename(vname);
+	free(cpath);
+=09
+	if( !strcmp(vname,".") || !strcmp(vname,"..") ||
+	     strchr(vname, '/') ){
+		fprintf(stderr, "ERROR: uncorrect subvolume name ('%s')\n",
+			vname);
+		return 14;
+	}
+=09
+	fd =3D open_file_or_dir(dname);
+	if (fd < 0) {
+		close(fd);
+		fprintf(stderr, "ERROR: can't access to '%s'\n", dname);
+		return 12;
+	}
+
+	printf("Delete subvolume '%s/%s'\n", dname, vname);
+	strcpy(args.name, vname);
+	res =3D ioctl(fd, BTRFS_IOC_SNAP_DESTROY, &args);
+
+	close(fd);
+
+	if(res < 0 ){
+		fprintf( stderr, "ERROR: cannot delete '%s/%s'\n",dname, vname);
+		return 11;
+	}
+
+	return 0;
+
+}
+
+static int do_create_subvol(char *dst)
+{
+	int	res, fddst;
+	char	*newname;
+	char	*dstdir;
+	struct btrfs_ioctl_vol_args	args;
+
+	res =3D test_isdir(dst);
+	if(res >=3D 0 ){
+		fprintf(stderr, "ERROR: '%s' exists\n", dst);
+		return 12;
+	}
+
+	newname =3D strdup(dst);
+	newname =3D basename(newname);
+	dstdir =3D strdup(dst);
+	dstdir =3D dirname(dstdir);
+
+	if( !strcmp(newname,".") || !strcmp(newname,"..") ||
+	     strchr(newname, '/') ){
+		fprintf(stderr, "ERROR: uncorrect subvolume name ('%s')\n",
+			newname);
+		return 14;
+	}
+
+	fddst =3D open_file_or_dir(dstdir);
+	if (fddst < 0) {
+		fprintf(stderr, "ERROR: can't access to '%s'\n", dstdir);
+		return 12;
+	}
+
+	printf("Create subvolume '%s/%s'\n", dstdir, newname);
+	strcpy(args.name, newname);
+	res =3D ioctl(fddst, BTRFS_IOC_SUBVOL_CREATE, &args);
+
+	close(fddst);
+
+	if(res < 0 ){
+		fprintf( stderr, "ERROR: cannot create subvolume\n");
+		return 11;
+	}
+
+	return 0;
+
+}
+
+static int do_fssync(char *path)
+{
+	int fd, res;
+=09
+	fd =3D open_file_or_dir(path);
+	if (fd < 0) {
+		fprintf(stderr, "ERROR: can't access to '%s'\n", path);
+		return 12;
+	}
+
+	printf("FSSync '%s'\n", path);
+	res =3D ioctl(fd, BTRFS_IOC_SYNC);
+	close(fd);
+	if( res < 0 ){
+		fprintf(stderr, "ERROR: unable to fs-syncing '%s'\n", path);
+		return 16;
+	}
+
+	return 0;
+}
+
+static int do_scan(int nargs, char **argv)
+{
+	int	i, fd;
+	if(!nargs){
+		int ret;
+	=09
+		printf("Scanning for Btrfs filesystems\n");
+		ret =3D btrfs_scan_one_dir("/dev", 1);
+		if (ret){
+			fprintf(stderr, "ERROR: error %d while scanning\n", ret);
+			return 18;
+		}
+		return 0;
+	}
+
+	fd =3D open("/dev/btrfs-control", O_RDWR);
+	if (fd < 0) {
+		perror("failed to open /dev/btrfs-control");
+		return 10;
+	}
+
+	for( i =3D 0 ; i < nargs ; i++ ){
+		struct btrfs_ioctl_vol_args 	args;
+		int	ret;
+
+		printf("Scanning for Btrfs filesystems in '%s'\n", argv[i]);
+	=09
+		strcpy(args.name, argv[i]);
+		/*
+		 * FIXME: which are the error code returned by this ioctl ?
+		 * it seems that is impossible to undetand if there no is
+		 * a btrfs filesystem from an I/O error !!!
+		 */
+		ret =3D ioctl(fd, BTRFS_IOC_SCAN_DEV, &args);
+
+		if( ret < 0 ){
+			close(fd);
+			fprintf(stderr, "ERROR: unable to scan the device '%s'\n", argv[i]);
+			return 11;
+		}
+	}
+
+	close(fd);
+	return 0;
+	=09
+}
+
+static int do_defrag(int argc, char **argv)
+{
+
+	int	i, ret=3D0;
+=09
+	for(i=3D0 ; i <argc ; i++){
+		int	fd, res;
+		char	*path =3D argv[i];
+		fd =3D open_file_or_dir(path);
+		if (fd < 0) {
+			fprintf(stderr, "ERROR: can't access to '%s'\n", path);
+			ret++;
+			continue;
+		}
+
+		printf("Defrag '%s'\n", path);
+		res =3D ioctl(fd, BTRFS_IOC_DEFRAG);
+		close(fd);
+		if( res < 0 ){
+			fprintf(stderr, "ERROR: unable to defrag '%s'\n", argv[i]);
+			ret++;
+			continue;
+		}
+	}
+
+	/*
+	 * the return code is 0 (success) or the number of the failure + 20
+	 */
+	if(ret)
+		ret+=3D20;
+	return ret;
+}
+
+static int uuid_search(struct btrfs_fs_devices *fs_devices, char *search)
+{
+	struct list_head *cur;
+	struct btrfs_device *device;
+
+	list_for_each(cur, &fs_devices->devices) {
+		device =3D list_entry(cur, struct btrfs_device, dev_list);
+		if ((device->label && strcmp(device->label, search) =3D=3D 0) ||
+		    strcmp(device->name, search) =3D=3D 0)
+			return 1;
+	}
+	return 0;
+}
+
+static void print_one_uuid(struct btrfs_fs_devices *fs_devices)
+{
+	char uuidbuf[37];
+	struct list_head *cur;
+	struct btrfs_device *device;
+	char *super_bytes_used;
+	u64 devs_found =3D 0;
+	u64 total;
+
+	uuid_unparse(fs_devices->fsid, uuidbuf);
+	device =3D list_entry(fs_devices->devices.next, struct btrfs_device,
+			    dev_list);
+	if (device->label && device->label[0])
+		printf("Label: '%s' ", device->label);
+	else
+		printf("Label: none ");
+
+	super_bytes_used =3D pretty_sizes(device->super_bytes_used);
+
+	total =3D device->total_devs;
+	printf(" uuid: %s\n\tTotal devices %llu FS bytes used %s\n", uuidbuf,
+	       (unsigned long long)total, super_bytes_used);
+
+	free(super_bytes_used);
+
+	list_for_each(cur, &fs_devices->devices) {
+		char *total_bytes;
+		char *bytes_used;
+		device =3D list_entry(cur, struct btrfs_device, dev_list);
+		total_bytes =3D pretty_sizes(device->total_bytes);
+		bytes_used =3D pretty_sizes(device->bytes_used);
+		printf("\tdevid %4llu size %s used %s path %s\n",
+		       (unsigned long long)device->devid,
+		       total_bytes, bytes_used, device->name);
+		free(total_bytes);
+		free(bytes_used);
+		devs_found++;
+	}
+	if (devs_found < total) {
+		printf("\t*** Some devices missing\n");
+	}
+	printf("\n");
+}
+
+static int do_show_volume(char *search)
+{
+	struct list_head *all_uuids;
+	struct btrfs_fs_devices *fs_devices;
+	struct list_head *cur_uuid;
+	int ret;
+
+	ret =3D btrfs_scan_one_dir("/dev", 0);
+	if (ret){
+		fprintf(stderr, "ERROR: error %d while scanning\n", ret);
+		return 18;
+	}
+
+	all_uuids =3D btrfs_scanned_uuids();
+	list_for_each(cur_uuid, all_uuids) {
+		fs_devices =3D list_entry(cur_uuid, struct btrfs_fs_devices,
+					list);
+		if (search && uuid_search(fs_devices, search) =3D=3D 0)
+			continue;
+		print_one_uuid(fs_devices);
+	}
+	printf("%s\n", BTRFS_BUILD_VERSION);
+	return 0;
+}
+
+static int do_add_volume(int nargs, char **args)
+{
+
+	char	*mntpnt =3D args[nargs-1];
+	int	i, fdmnt, ret=3D0;
+
+
+	fdmnt =3D open_file_or_dir(mntpnt);
+	if (fdmnt < 0) {
+		fprintf(stderr, "ERROR: can't access to '%s'\n", mntpnt);
+		return 12;
+	}=09
+=09
+	for(i=3D0 ; i < (nargs-1) ; i++ ){
+		struct 	btrfs_ioctl_vol_args ioctl_args;
+		int	devfd, res;
+		u64 dev_block_count =3D 0;
+		struct stat st;
+
+		devfd =3D open(args[i], O_RDWR);
+		if (!devfd) {
+			fprintf(stderr, "ERROR: Unable to open device '%s'\n", args[i]);
+			close(devfd);
+			ret++;
+			continue;
+		}
+		ret =3D fstat(devfd, &st);
+		if (ret) {
+			fprintf(stderr, "ERROR: Unable to stat '%s'\n", args[i]);
+			close(devfd);
+			ret++;
+			continue;
+		}
+		if (!S_ISBLK(st.st_mode)) {
+			fprintf(stderr, "ERROR: '%s' is not a block device\n", args[i]);
+			close(devfd);
+			ret++;
+			continue;
+		}	=09
+
+		res =3D btrfs_prepare_device(devfd, args[i], 1, &dev_block_count);
+		if (ret) {
+			fprintf(stderr, "ERROR: Unable to init '%s'\n", args[i]);
+			close(devfd);
+			ret++;
+			continue;
+		}
+		close(devfd);
+	=09
+		strcpy(ioctl_args.name, args[i]);
+		res =3D ioctl(fdmnt, BTRFS_IOC_ADD_DEV, &ioctl_args);
+		if(res<0){
+			fprintf(stderr, "ERROR: error adding the device '%s'\n", args[i]);
+			ret++;
+		}
+
+	}
+
+	close(fdmnt);
+	if( ret)
+		return ret+20;
+	else
+		return 0;
+
+}
+
+static int do_balance(char *path)
+{
+
+	int	fdmnt, ret=3D0;
+
+	fdmnt =3D open_file_or_dir(path);
+	if (fdmnt < 0) {
+		fprintf(stderr, "ERROR: can't access to '%s'\n", path);
+		return 12;
+	}
+=09
+	ret =3D ioctl(fdmnt, BTRFS_IOC_BALANCE);
+	close(fdmnt);
+	if(ret<0){
+		fprintf(stderr, "ERROR: balancing '%s'\n", path);
+	=09
+		return 19;
+	}
+	return 0;
+}
+static int do_remove_volume(int nargs, char **args)
+{
+
+	char	*mntpnt =3D args[nargs-1];
+	int	i, fdmnt, ret=3D0;
+
+	fdmnt =3D open_file_or_dir(mntpnt);
+	if (fdmnt < 0) {
+		fprintf(stderr, "ERROR: can't access to '%s'\n", mntpnt);
+		return 12;
+	}
+
+	for(i=3D0 ; i < (nargs-1) ; i++ ){
+		struct 	btrfs_ioctl_vol_args arg;
+		int	res;
+
+		strcpy(arg.name, args[i]);
+		res =3D ioctl(fdmnt, BTRFS_IOC_RM_DEV, &arg);
+		if(res<0){
+			fprintf(stderr, "ERROR: error removing the device '%s'\n", args[i]);
+			ret++;
+		}
+	}
+
+	close(fdmnt);
+	if( ret)
+		return ret+20;
+	else
+		return 0;
+}
+
+struct Command {
+	int	nargs;		/* if =3D=3D 999, any number of arguments
+				   if >=3D 0, number of arguments,
+				   if < 0, _minimum_ number of arguments */
+	char	*verb, *alias;	/* verb and alias */
+	char	*help;		/* help lines; form the 2nd onward they are
+				   indented */
+};
+
+static struct Command commands[] =3D {
+
+	/*
+		avoid short commands different for the case only
+	*/
+	{ 2,  "snapshot", "-s", "[<dest>/]<name>\n"
+		"Create a writeble snapshot of the subvolume <source> with\n"
+		"the name <name> in the <dest> directory."
+	},
+	{ 1,  "delete", "-D","<subvolume>\n"
+		"Delete the subvolume <subvolume>."
+	},
+	{ 1,  "subvolume", "-c", "[<dest>/]<name>\n"
+		"Create a subvolume in <dest> (or the current directory if\n"
+		"not passed)."
+	},
+	{-1,  "defrag", "-f", "<file>|<dir> [<file>|<dir>...]\n"
+		"Defragment a file or a directory."
+	},
+	{ 999, "scan", "-n", "[<device> [<device>..]\n"
+		"Scan all device for or the passed device for a btrfs\n"
+		"filesystem."
+	},
+	{ 1,  "fssync", "-y", "<path>\n"
+		"Force a fs sync on the filesystem <path>"
+	},
+	{ 2,  "resize", "-z", "[+/-]<newsize>[gkm]|max <filesystem>\n"
+		"Resize the file system. If 'max' is passed, the filesystem\n"
+		"will occupe all available space on the device."
+	},
+	{ 999, "show", "-l", "[<dev>|<label>...]\n"
+		"Show the btrfs devices"
+	},
+	{ 1,  "balance", "-b", "<path>\n"
+		"Balance the chunk across the device"
+	},
+	{ -1, "add-dev", "-A", "<dev> [<dev>..] <path>\n"
+		"Add a device to a filesystem"
+	},
+	{ -1, "rm-dev", "-R", "<dev> [<dev>..] <path>\n"
+		"Remove a device to a filesystem"
+	},
+	/* coming soon
+	{ 2, "label", "-m", "<label> <path>\n"
+		"Set the label of a filesystem"
+	}
+	{ 2, "list", "-t", "<path>\n"
+		"List the snapshot/subvolume of a filesystem"
+	}
+	*/
+=09
+	{ 0, 0 , 0 }
+};
+
+static void help(char *programname)
+{
+	char *np, *pc;
+	struct Command *cp;
+
+	np =3D strrchr(programname,'/');
+	if(!np)
+		np =3D programname;
+	else
+		np++;
+
+	printf("Usage:\n");
+=09
+	for( cp =3D commands; cp->alias || cp->verb; cp++ ){
+		/* this syntax allows a command with a verb (or alias) only */
+		printf("\t%s %s%s%s ", np,
+		   cp->verb ? cp->verb : "",
+		   cp->verb && cp->alias ? "|": "",
+		   cp->alias ? cp->alias : "");
+
+		for(pc =3D cp->help; *pc; pc++){
+			putchar(*pc);
+			if(*pc =3D=3D '\n')
+				printf("\t\t");
+		}
+		putchar('\n');
+	}
+
+	printf("\n\t%s help|--help|-h\n\t\tShow the help.\n",np);
+	printf("\n%s\n", BTRFS_BUILD_VERSION);
+
+}
+
+static int parse_args(int argc, char **argv,
+			      int *nargs_, char **cmd_, char ***args_ )
+{
+	struct Command	*cp;
+	char		*cmd=3D0, **args;
+	int		nargs =3D argc -2;
+
+	if( argc < 2 || !strcmp(argv[1], "help") ||
+		!strcmp(argv[1], "-h") || !strcmp(argv[1], "--help")){
+		help(argv[0]);
+		return 0;
+	}
+
+	for( cp =3D commands; cp->alias || cp->verb; cp++ ){
+		if (strcmp(argv[1], cp->alias) && strcmp(argv[1], cp->verb))
+			continue;
+		if (cp->nargs < 0 && cp->nargs < -nargs ){
+			fprintf(stderr, "ERROR: '%s' requires minimum %d arg(s)\n",
+				argv[1], -cp->nargs);
+				exit(2);
+		}
+		if(cp->nargs >=3D 0 && cp->nargs !=3D nargs && cp->nargs !=3D 999 ){
+			fprintf(stderr, "ERROR: '%s' requires %d arg(s)\n",
+				argv[1], cp->nargs);
+				exit(2);
+		}
+
+		cmd =3D cp->verb ? cp->verb : cp->alias;
+		args =3D argv+2;
+		break;
+	}
+
+	if(!cmd){
+		fprintf( stderr, "ERROR: unknow command '%s'\n",argv[1]);
+		help(argv[0]);
+		return -1;
+	}
+
+	*cmd_ =3D cmd;
+	*args_ =3D args;
+	*nargs_ =3D nargs;
+	return 1;
+}
+
+int main(int ac, char **av )
+{
+
+	char		*cmd, **args;
+	int		nargs, r;
+
+	r =3D parse_args(ac, av, &nargs, &cmd, &args);
+	if( r <=3D 0 ){
+		/* error or no command to parse*/
+		exit(-r);
+	}
+
+	if( !strcmp(cmd, "scan") ){
+		exit(do_scan(nargs, args));
+	=09
+	}else if( !strcmp(cmd, "defrag") ){
+		exit(do_defrag(nargs, args));
+	=09
+	}else if( !strcmp(cmd, "snapshot")){
+		exit(do_clone(args[0], args[1]));
+
+	}else if( !strcmp(cmd, "subvolume")){
+		exit(do_create_subvol(args[0]));
+
+	}else if( !strcmp(cmd, "fssync") ){
+		exit(do_fssync(args[0]));
+
+	}else if( !strcmp(cmd, "delete")){
+		exit(do_delete_subvolume(args[0]));
+
+	}else if( !strcmp(cmd, "show")){
+		exit(do_show_volume(nargs ? args[0]:0));
+
+	}else if( !strcmp(cmd, "add-dev")){
+		exit(do_add_volume(nargs, args));
+
+	}else if( !strcmp(cmd, "rm-dev")){
+		exit(do_remove_volume(nargs, args));
+
+	}else if( !strcmp(cmd, "balance")){
+		exit(do_balance(args[0]));
+
+	}=20
+
+	fprintf(stderr, "ERROR: internal parsing error\n");
+	exit(111);
+
+}
+



=2D-=20
gpg key@ keyserver.linux.it: Goffredo Baroncelli (ghigo) <kreijackATinwind.=
it>
Key fingerprint =3D 4769 7E51 5293 D36C 814E  C054 BF04 F161 3DC5 0512

--nextPart2968703.03iS9QVd6E
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iD8DBQBLfEtQvwTxYT3FBRIRAluFAJ0e4k/I+wmV2MQMqxJ6MnXfvh1JhACggKc9
BvirYM5o6LDkOop6RFJfQL8=
=OUwD
-----END PGP SIGNATURE-----

--nextPart2968703.03iS9QVd6E--
