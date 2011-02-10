From: Eduardo Silva <eduardo.silva@oracle.com>
Subject: Re: [PATCH] Btrfs-progs use safe string manipulation functions
Date: Thu, 10 Feb 2011 10:29:45 -0300
Message-ID: <1297344585.28159.12.camel@monotop>
References: <1297081322.4615.10.camel@monotop> <4D53C711.3000309@nsc.liu.se>
	 <AANLkTi=OaU8Wj+W2KuPZLbq_85_yVK9mTer9Q7hfTCUc@mail.gmail.com>
	 <ij0iku$hbq$1@dough.gmane.org>
	 <AANLkTi=7B1FLtSrcJ88zgitCBiRctwveRhLzt_2yAHZL@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-NLXZyhHSIV2nmKFkXL6O"
Cc: Jeremy Sanders <jeremy@jeremysanders.net>,
	linux-btrfs@vger.kernel.org
To: Olaf van der Spek <olafvdspek@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=7B1FLtSrcJ88zgitCBiRctwveRhLzt_2yAHZL@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>


--=-NLXZyhHSIV2nmKFkXL6O
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

On Thu, 2011-02-10 at 12:39 +0100, Olaf van der Spek wrote:
> On Thu, Feb 10, 2011 at 12:37 PM, Jeremy Sanders
> <jeremy@jeremysanders.net> wrote:
> > Olaf van der Spek wrote:
> >
> >> On Thu, Feb 10, 2011 at 12:08 PM, Thomas Bellman <bellman@nsc.liu.se>
> >> wrote:
> >>> strncpy(args.name, source, BTRFS_PATH_NAME_MAX);
> >>> args.name[BTRFS_PATH_NAME_MAX] = '\0';
> >>
> >> That's silly. Isn't there a sane safe variant of strcpy?
> >
> > There's strlcpy, but it's not in glibc because of possible truncation
> > errors!
> 
> Then use a private wrapper.
> 

Here's the new patch:

----
[PATCH] Add safe string manipulation functions

Deprecate direct use of strcpy(3)
The following string manipulation function has been added:

   - string_copy() : wrapper of strcpy(3)
   - string_ncopy(): wrapper of strncpy(3)

both function compose safe NULL terminated strings.
----

I check that the code most of the time raise an error if the path is too
long, so the new wrappers should be ok...

best, 

Eduardo Silva
 

--=-NLXZyhHSIV2nmKFkXL6O
Content-Disposition: attachment; filename="0001-Add-safe-string-manipulation-functions.patch"
Content-Type: text/x-patch; name="0001-Add-safe-string-manipulation-functions.patch"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

>From 6e551f4d9482a438beb336c4ec3a54735a15b76c Mon Sep 17 00:00:00 2001
From: Eduardo Silva <eduardo.silva@oracle.com>
Date: Thu, 10 Feb 2011 10:25:15 -0300
Subject: [PATCH] Add safe string manipulation functions

Deprecate direct use of strcpy(3)
The following string manipulation function has been added:

   - string_copy() : wrapper of strcpy(3)
   - string_ncopy(): wrapper of strncpy(3)

both function compose safe NULL terminated strings.

Signed-off-by: Eduardo Silva <eduardo.silva@oracle.com>
---
 btrfs-list.c |    4 ++--
 btrfs-vol.c  |    2 +-
 btrfs.c      |    3 ++-
 btrfs_cmds.c |   14 +++++++-------
 btrfsctl.c   |    2 +-
 convert.c    |    4 ++--
 utils.c      |   38 ++++++++++++++++++++++++++++++++------
 utils.h      |    5 +++++
 8 files changed, 52 insertions(+), 20 deletions(-)

diff --git a/btrfs-list.c b/btrfs-list.c
index 93766a8..ede51a4 100644
--- a/btrfs-list.c
+++ b/btrfs-list.c
@@ -291,7 +291,7 @@ static int lookup_ino_path(int fd, struct root_info *ri)
 			perror("malloc failed");
 			exit(1);
 		}
-		strcpy(ri->path, args.name);
+		string_copy(ri->path, args.name);
 		strcat(ri->path, ri->name);
 	} else {
 		/* we're at the root of ref_tree */
@@ -448,7 +448,7 @@ char *build_name(char *dirid, char *name)
 	full = malloc(strlen(dirid) + strlen(name) + 1);
 	if (!full)
 		return NULL;
-	strcpy(full, dirid);
+	string_copy(full, dirid);
 	strcat(full, name);
 	return full;
 }
diff --git a/btrfs-vol.c b/btrfs-vol.c
index 4ed799d..60361f6 100644
--- a/btrfs-vol.c
+++ b/btrfs-vol.c
@@ -151,7 +151,7 @@ int main(int ac, char **av)
 	}
 	fd = dirfd(dirstream);
 	if (device)
-		strcpy(args.name, device);
+		string_copy(args.name, device);
 	else
 		args.name[0] = '\0';
 
diff --git a/btrfs.c b/btrfs.c
index 46314cf..ddf4960 100644
--- a/btrfs.c
+++ b/btrfs.c
@@ -21,6 +21,7 @@
 
 #include "kerncompat.h"
 #include "btrfs_cmds.h"
+#include "utils.h"
 #include "version.h"
 
 typedef int (*CommandFunction)(int argc, char **argv);
@@ -241,7 +242,7 @@ static int prepare_args(int *ac, char ***av, char *prgname, struct Command *cmd
 	for(i=0; i < *ac ; i++ )
 		ret[i+1] = (*av)[i];
 
-	strcpy(newname, prgname);
+	string_copy(newname, prgname);
 	strcat(newname, " ");
 	strcat(newname, cmd->verb);
 
diff --git a/btrfs_cmds.c b/btrfs_cmds.c
index 8031c58..f4be8c2 100644
--- a/btrfs_cmds.c
+++ b/btrfs_cmds.c
@@ -375,7 +375,7 @@ int do_clone(int argc, char **argv)
 	printf("Create a snapshot of '%s' in '%s/%s'\n",
 	       subvol, dstdir, newname);
 	args.fd = fd;
-	strcpy(args.name, newname);
+	string_ncopy(args.name, newname, BTRFS_PATH_NAME_MAX);
 	res = ioctl(fddst, BTRFS_IOC_SNAP_CREATE, &args);
 
 	close(fd);
@@ -436,7 +436,7 @@ int do_delete_subvolume(int argc, char **argv)
 	}
 
 	printf("Delete subvolume '%s/%s'\n", dname, vname);
-	strcpy(args.name, vname);
+	string_ncopy(args.name, vname, BTRFS_PATH_NAME_MAX);
 	res = ioctl(fd, BTRFS_IOC_SNAP_DESTROY, &args);
 
 	close(fd);
@@ -490,7 +490,7 @@ int do_create_subvol(int argc, char **argv)
 	}
 
 	printf("Create subvolume '%s/%s'\n", dstdir, newname);
-	strcpy(args.name, newname);
+	string_ncopy(args.name, newname, BTRFS_PATH_NAME_MAX);
 	res = ioctl(fddst, BTRFS_IOC_SUBVOL_CREATE, &args);
 
 	close(fddst);
@@ -553,7 +553,7 @@ int do_scan(int argc, char **argv)
 
 		printf("Scanning for Btrfs filesystems in '%s'\n", argv[i]);
 
-		strcpy(args.name, argv[i]);
+		string_ncopy(args.name, argv[i], BTRFS_PATH_NAME_MAX);
 		/*
 		 * FIXME: which are the error code returned by this ioctl ?
 		 * it seems that is impossible to understand if there no is
@@ -593,7 +593,7 @@ int do_resize(int argc, char **argv)
 	}
 
 	printf("Resize '%s' of '%s'\n", path, amount);
-	strcpy(args.name, amount);
+	string_ncopy(args.name, amount, BTRFS_VOL_NAME_MAX);
 	res = ioctl(fd, BTRFS_IOC_RESIZE, &args);
 	close(fd);
 	if( res < 0 ){
@@ -736,7 +736,7 @@ int do_add_volume(int nargs, char **args)
 		}
 		close(devfd);
 
-		strcpy(ioctl_args.name, args[i]);
+		string_ncopy(ioctl_args.name, args[i], BTRFS_PATH_NAME_MAX);
 		res = ioctl(fdmnt, BTRFS_IOC_ADD_DEV, &ioctl_args);
 		if(res<0){
 			fprintf(stderr, "ERROR: error adding the device '%s'\n", args[i]);
@@ -792,7 +792,7 @@ int do_remove_volume(int nargs, char **args)
 		struct	btrfs_ioctl_vol_args arg;
 		int	res;
 
-		strcpy(arg.name, args[i]);
+		string_ncopy(arg.name, args[i], BTRFS_PATH_NAME_MAX);
 		res = ioctl(fdmnt, BTRFS_IOC_RM_DEV, &arg);
 		if(res<0){
 			fprintf(stderr, "ERROR: error removing the device '%s'\n", args[i]);
diff --git a/btrfsctl.c b/btrfsctl.c
index 92bdf39..adfa519 100644
--- a/btrfsctl.c
+++ b/btrfsctl.c
@@ -237,7 +237,7 @@ int main(int ac, char **av)
 	 }
 
 	if (name)
-		strcpy(args.name, name);
+                strncpy(args.name, name, BTRFS_PATH_NAME_MAX + 1);
 	else
 		args.name[0] = '\0';
 
diff --git a/convert.c b/convert.c
index d037c98..67706f3 100644
--- a/convert.c
+++ b/convert.c
@@ -857,7 +857,7 @@ static int copy_single_xattr(struct btrfs_trans_handle *trans,
 		data = databuf;
 		datalen = bufsize;
 	}
-	strcpy(namebuf, xattr_prefix_table[name_index]);
+	strncpy(namebuf, xattr_prefix_table[name_index], XATTR_NAME_MAX);
 	strncat(namebuf, EXT2_EXT_ATTR_NAME(entry), entry->e_name_len);
 	if (name_len + datalen > BTRFS_LEAF_DATA_SIZE(root) -
 	    sizeof(struct btrfs_item) - sizeof(struct btrfs_dir_item)) {
@@ -1465,7 +1465,7 @@ struct btrfs_root *link_subvol(struct btrfs_root *root, const char *base,
 	key.offset = (u64)-1;
 	key.type = BTRFS_ROOT_ITEM_KEY;
 
-	strcpy(buf, base);
+	string_copy(buf, base);
 	for (i = 0; i < 1024; i++) {
 		ret = btrfs_insert_dir_item(trans, root, buf, strlen(buf),
 					    dirid, &key, BTRFS_FT_DIR, index);
diff --git a/utils.c b/utils.c
index fd894f3..0c052c1 100644
--- a/utils.c
+++ b/utils.c
@@ -108,7 +108,7 @@ int make_btrfs(int fd, const char *device, const char *label,
 	btrfs_set_super_csum_type(&super, BTRFS_CSUM_TYPE_CRC32);
 	btrfs_set_super_chunk_root_generation(&super, 1);
 	if (label)
-		strcpy(super.label, label);
+		strncpy(super.label, label, BTRFS_LABEL_SIZE - 1);
 
 	buf = malloc(sizeof(*buf) + max(sectorsize, leafsize));
 
@@ -828,7 +828,7 @@ void btrfs_register_one_device(char *fname)
 			"skipping device registration\n");
 		return;
 	}
-	strcpy(args.name, fname);
+	strncpy(args.name, fname, BTRFS_PATH_NAME_MAX);
 	ret = ioctl(fd, BTRFS_IOC_SCAN_DEV, &args);
 	close(fd);
 }
@@ -853,7 +853,7 @@ int btrfs_scan_one_dir(char *dirname, int run_ioctl)
 	pending = malloc(sizeof(*pending));
 	if (!pending)
 		return -ENOMEM;
-	strcpy(pending->name, dirname);
+	string_copy(pending->name, dirname);
 
 again:
 	dirname_len = strlen(pending->name);
@@ -894,7 +894,7 @@ again:
 				ret = -ENOMEM;
 				goto fail;
 			}
-			strcpy(next->name, fullpath);
+			string_copy(next->name, fullpath);
 			list_add_tail(&next->list, &pending_list);
 		}
 		if (!S_ISBLK(st.st_mode)) {
@@ -971,6 +971,7 @@ static char *size_strs[] = { "", "KB", "MB", "GB", "TB",
 char *pretty_sizes(u64 size)
 {
 	int num_divs = 0;
+        int pretty_len = 16;
 	u64 last_size = size;
 	u64 fract_size = size;
 	float fraction;
@@ -988,8 +989,33 @@ char *pretty_sizes(u64 size)
 		return NULL;
 
 	fraction = (float)fract_size / 1024;
-	pretty = malloc(16);
-	sprintf(pretty, "%.2f%s", fraction, size_strs[num_divs-1]);
+	pretty = malloc(pretty_len);
+	snprintf(pretty, pretty_len, "%.2f%s", fraction, size_strs[num_divs-1]);
 	return pretty;
 }
 
+char *string_copy(char *dest, const char *src)
+{
+	if (!dest || !src) {
+		fprintf(stderr, "ERROR: invalid string_copy() parameters");
+		exit(EXIT_FAILURE);
+	}
+
+	memset(dest, '\0', sizeof(dest));
+	return strcpy(dest, src);
+}
+
+char *string_ncopy(char *dest, const char *src, size_t n)
+{
+	/* Just a basic test to avoid silly bugs */
+	if (!dest || !src || n <= 0) {
+		fprintf(stderr, "ERROR: invalid string_ncopy() parameters\n");
+		exit(EXIT_FAILURE);
+	}
+
+	strncpy(dest, src, n);
+	dest[n] = '\0';
+	
+	return dest;
+}
+
diff --git a/utils.h b/utils.h
index 9dce5b0..39c8455 100644
--- a/utils.h
+++ b/utils.h
@@ -19,6 +19,8 @@
 #ifndef __UTILS__
 #define __UTILS__
 
+#include "ctree.h"
+
 #define BTRFS_MKFS_SYSTEM_GROUP_SIZE (4 * 1024 * 1024)
 
 int make_btrfs(int fd, const char *device, const char *label,
@@ -40,4 +42,7 @@ int check_mounted(const char *devicename);
 int btrfs_device_already_in_root(struct btrfs_root *root, int fd,
 				 int super_offset);
 char *pretty_sizes(u64 size);
+
+char *string_copy(char *dest, const char *src);
+char *string_ncopy(char *dest, const char *src, size_t n);
 #endif
-- 
1.7.1


--=-NLXZyhHSIV2nmKFkXL6O--

