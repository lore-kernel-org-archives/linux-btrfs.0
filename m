Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from lgeamrelo04.lge.com ([156.147.1.127]:54769 "EHLO
	lgeamrelo04.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754376AbbHFJpO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 6 Aug 2015 05:45:14 -0400
From: =?ks_c_5601-1987?B?sK2787/s?= <kenneth.kang@lge.com>
To: <linux-btrfs@vger.kernel.org>
References: <003201d0d02c$3349fe10$99ddfa30$@lge.com>
In-Reply-To: <003201d0d02c$3349fe10$99ddfa30$@lge.com>
Subject: FW: btrfs-progs: android build
Date: Thu, 6 Aug 2015 18:45:11 +0900
Message-ID: <003f01d0d02c$96c92f10$c45b8d30$@lge.com>
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_0040_01D0D078.06B12530"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a multipart message in MIME format.

------=_NextPart_000_0040_01D0D078.06B12530
Content-Type: text/plain;
	charset="ks_c_5601-1987"
Content-Transfer-Encoding: quoted-printable

Hi, I made btrfs-progs android build script and test it.\
And need some help on btrfs_wipe_existing_sb().\
On the test it looks work well.\
But I=A1=AFm not sure it=A1=AFs ok.

------=_NextPart_000_0040_01D0D078.06B12530
Content-Type: application/octet-stream;
	name="0001-btrfs-progs-Add-Android-build-mk-file.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="0001-btrfs-progs-Add-Android-build-mk-file.patch"

>From 66bae04ded4feb8f218f0a6d30f360792430be7c Mon Sep 17 00:00:00 2001=0A=
From: "kenneth.kang" <kenneth.kang@lge.com>=0A=
Date: Wed, 5 Aug 2015 18:08:25 +0900=0A=
Subject: [PATCH] btrfs-progs: Add Android build mk file=0A=
=0A=
Add Android.mk to use btrfs on android device.=0A=
=0A=
To using this funtion, there are some limitation.=0A=
1) phread_cancel was changed to pthread_kill due to android didn't =
support=0A=
that.=0A=
2) This module needs lzo library on android/external folder.=0A=
3) blkid library doesn't support fully. So have to use -f option to=0A=
work.=0A=
---=0A=
 Android.mk      | 111 =
++++++++++++++++++++++++++++++++++++++++++++++++++++++++=0A=
 chunk-recover.c |   8 ++++=0A=
 cmds-receive.c  |   4 ++=0A=
 cmds-restore.c  |   1 +=0A=
 cmds-scrub.c    |  22 ++++++++++-=0A=
 kerncompat.h    |   3 ++=0A=
 mkfs.c          |   9 +++++=0A=
 utils.c         |   9 +++--=0A=
 8 files changed, 162 insertions(+), 5 deletions(-)=0A=
 create mode 100644 Android.mk=0A=
=0A=
diff --git a/Android.mk b/Android.mk=0A=
new file mode 100644=0A=
index 0000000..f6f3e28=0A=
--- /dev/null=0A=
+++ b/Android.mk=0A=
@@ -0,0 +1,111 @@=0A=
+LOCAL_PATH:=3D $(call my-dir)=0A=
+=0A=
+#include $(call all-subdir-makefiles)=0A=
+=0A=
+CFLAGS :=3D -g -O1 -Wall -D_FORTIFY_SOURCE=3D2 -include config.h =
-DBTRFS_FLAT_INCLUDES -D_XOPEN_SOURCE=3D700 -fno-strict-aliasing -fPIC=0A=
+=0A=
+LDFLAGS :=3D -static -rdynamic=0A=
+=0A=
+LIBS :=3D -luuid   -lblkid   -lz   -llzo2 -L. -lpthread=0A=
+LIBBTRFS_LIBS :=3D $(LIBS)=0A=
+=0A=
+STATIC_CFLAGS :=3D $(CFLAGS) -ffunction-sections -fdata-sections=0A=
+STATIC_LDFLAGS :=3D -static -Wl,--gc-sections=0A=
+STATIC_LIBS :=3D -luuid   -lblkid -luuid \=0A=
+              -lz   -llzo2 -L. -pthread=0A=
+=0A=
+btrfs_shared_libraries :=3D libext2_uuid \=0A=
+			libext2_blkid=0A=
+=0A=
+objects :=3D ctree.c disk-io.c radix-tree.c extent-tree.c print-tree.c \=0A=
+          root-tree.c dir-item.c file-item.c inode-item.c inode-map.c \=0A=
+          extent-cache.c extent_io.c volumes.c utils.c repair.c \=0A=
+          qgroup.c raid6.c free-space-cache.c list_sort.c props.c \=0A=
+          ulist.c qgroup-verify.c backref.c string-table.c task-utils.c =
\=0A=
+          inode.c file.c find-root.c=0A=
+cmds_objects :=3D cmds-subvolume.c cmds-filesystem.c cmds-device.c =
cmds-scrub.c \=0A=
+               cmds-inspect.c cmds-balance.c cmds-send.c cmds-receive.c =
\=0A=
+               cmds-quota.c cmds-qgroup.c cmds-replace.c cmds-check.c \=0A=
+               cmds-restore.c cmds-rescue.c chunk-recover.c =
super-recover.c \=0A=
+               cmds-property.c cmds-fi-usage.c=0A=
+libbtrfs_objects :=3D send-stream.c send-utils.c rbtree.c btrfs-list.c =
crc32c.c \=0A=
+                   uuid-tree.c utils-lib.c rbtree-utils.c=0A=
+libbtrfs_headers :=3D send-stream.h send-utils.h send.h rbtree.h =
btrfs-list.h \=0A=
+                   crc32c.h list.h kerncompat.h radix-tree.h =
extent-cache.h \=0A=
+                   extent_io.h ioctl.h ctree.h btrfsck.h version.h=0A=
+TESTS :=3D fsck-tests.sh convert-tests.sh=0A=
+blkid_objects :=3D partition/ superblocks/ topology/=0A=
+=0A=
+=0A=
+# external/e2fsprogs/lib is needed for uuid/uuid.h=0A=
+common_C_INCLUDES :=3D $(LOCAL_PATH) external/e2fsprogs/lib/ =
external/lzo/include/ external/zlib/=0A=
+=0A=
+#----------------------------------------------------------=0A=
+include $(CLEAR_VARS)=0A=
+LOCAL_SRC_FILES :=3D $(libbtrfs_objects)=0A=
+LOCAL_CFLAGS :=3D $(STATIC_CFLAGS)=0A=
+LOCAL_MODULE :=3D libbtrfs=0A=
+LOCAL_C_INCLUDES :=3D $(common_C_INCLUDES)=0A=
+include $(BUILD_STATIC_LIBRARY)=0A=
+=0A=
+#----------------------------------------------------------=0A=
+include $(CLEAR_VARS)=0A=
+LOCAL_MODULE :=3D btrfs=0A=
+#LOCAL_FORCE_STATIC_EXECUTABLE :=3D true=0A=
+LOCAL_SRC_FILES :=3D \=0A=
+		$(objects) \=0A=
+		$(cmds_objects) \=0A=
+		btrfs.c \=0A=
+		help.c \=0A=
+=0A=
+LOCAL_C_INCLUDES :=3D $(common_C_INCLUDES)=0A=
+LOCAL_CFLAGS :=3D $(STATIC_CFLAGS)=0A=
+#LOCAL_LDLIBS :=3D $(LIBBTRFS_LIBS)=0A=
+#LOCAL_LDFLAGS :=3D $(STATIC_LDFLAGS)=0A=
+LOCAL_SHARED_LIBRARIES :=3D $(btrfs_shared_libraries)=0A=
+LOCAL_STATIC_LIBRARIES :=3D libbtrfs liblzo-static libz=0A=
+LOCAL_SYSTEM_SHARED_LIBRARIES :=3D libc libcutils=0A=
+=0A=
+LOCAL_EXPORT_C_INCLUDES :=3D $(common_C_INCLUDES)=0A=
+#LOCAL_MODULE_TAGS :=3D optional=0A=
+include $(BUILD_EXECUTABLE)=0A=
+=0A=
+#----------------------------------------------------------=0A=
+include $(CLEAR_VARS)=0A=
+LOCAL_MODULE :=3D mkfs.btrfs=0A=
+LOCAL_SRC_FILES :=3D \=0A=
+                $(objects) \=0A=
+                mkfs.c=0A=
+=0A=
+LOCAL_C_INCLUDES :=3D $(common_C_INCLUDES)=0A=
+LOCAL_CFLAGS :=3D $(STATIC_CFLAGS)=0A=
+#LOCAL_LDLIBS :=3D $(LIBBTRFS_LIBS)=0A=
+#LOCAL_LDFLAGS :=3D $(STATIC_LDFLAGS)=0A=
+LOCAL_SHARED_LIBRARIES :=3D $(btrfs_shared_libraries)=0A=
+LOCAL_STATIC_LIBRARIES :=3D libbtrfs liblzo-static=0A=
+LOCAL_SYSTEM_SHARED_LIBRARIES :=3D libc libcutils=0A=
+=0A=
+LOCAL_EXPORT_C_INCLUDES :=3D $(common_C_INCLUDES)=0A=
+#LOCAL_MODULE_TAGS :=3D optional=0A=
+include $(BUILD_EXECUTABLE)=0A=
+=0A=
+#---------------------------------------------------------------=0A=
+include $(CLEAR_VARS)=0A=
+LOCAL_MODULE :=3D btrfstune=0A=
+LOCAL_SRC_FILES :=3D \=0A=
+                $(objects) \=0A=
+                btrfstune.c=0A=
+=0A=
+LOCAL_C_INCLUDES :=3D $(common_C_INCLUDES)=0A=
+LOCAL_CFLAGS :=3D $(STATIC_CFLAGS)=0A=
+LOCAL_SHARED_LIBRARIES :=3D $(btrfs_shared_libraries)=0A=
+#LOCAL_LDLIBS :=3D $(LIBBTRFS_LIBS)=0A=
+#LOCAL_LDFLAGS :=3D $(STATIC_LDFLAGS)=0A=
+LOCAL_SHARED_LIBRARIES :=3D $(btrfs_shared_libraries)=0A=
+LOCAL_STATIC_LIBRARIES :=3D libbtrfs liblzo-static=0A=
+LOCAL_SYSTEM_SHARED_LIBRARIES :=3D libc libcutils=0A=
+=0A=
+LOCAL_EXPORT_C_INCLUDES :=3D $(common_C_INCLUDES)=0A=
+LOCAL_MODULE_TAGS :=3D optional=0A=
+include $(BUILD_EXECUTABLE)=0A=
+#--------------------------------------------------------------=0A=
diff --git a/chunk-recover.c b/chunk-recover.c=0A=
index 832b3b1..7f793af 100644=0A=
--- a/chunk-recover.c=0A=
+++ b/chunk-recover.c=0A=
@@ -17,7 +17,9 @@=0A=
  */=0A=
 =0A=
 #include <stdio.h>=0A=
+#ifndef ANDROID=0A=
 #include <stdio_ext.h>=0A=
+#endif=0A=
 #include <stdlib.h>=0A=
 #include <sys/types.h>=0A=
 #include <sys/stat.h>=0A=
@@ -755,9 +757,11 @@ static int scan_one_device(void *dev_scan_struct)=0A=
 	int fd =3D dev_scan->fd;=0A=
 	int oldtype;=0A=
 =0A=
+#ifndef ANDROID=0A=
 	ret =3D pthread_setcanceltype(PTHREAD_CANCEL_ASYNCHRONOUS, &oldtype);=0A=
 	if (ret)=0A=
 		return 1;=0A=
+#endif=0A=
 =0A=
 	buf =3D malloc(sizeof(*buf) + rc->leafsize);=0A=
 	if (!buf)=0A=
@@ -884,7 +888,11 @@ static int scan_devices(struct recover_control *rc)=0A=
 	}=0A=
 out1:=0A=
 	while (ret && (cancel_from <=3D cancel_to)) {=0A=
+#ifdef ANDROID=0A=
+		pthread_kill(t_scans[cancel_from], SIGUSR1);=0A=
+#else=0A=
 		pthread_cancel(t_scans[cancel_from]);=0A=
+#endif=0A=
 		cancel_from++;=0A=
 	}=0A=
 out2:=0A=
diff --git a/cmds-receive.c b/cmds-receive.c=0A=
index 071bea9..3e9d912 100644=0A=
--- a/cmds-receive.c=0A=
+++ b/cmds-receive.c=0A=
@@ -25,7 +25,11 @@=0A=
 #include <pthread.h>=0A=
 #include <math.h>=0A=
 #include <ftw.h>=0A=
+#ifndef ANDROID=0A=
 #include <wait.h>=0A=
+#else=0A=
+#include <sys/wait.h>=0A=
+#endif=0A=
 #include <assert.h>=0A=
 #include <getopt.h>=0A=
 =0A=
diff --git a/cmds-restore.c b/cmds-restore.c=0A=
index 8fc8b2a..9a53058 100644=0A=
--- a/cmds-restore.c=0A=
+++ b/cmds-restore.c=0A=
@@ -86,6 +86,7 @@ static int decompress_zlib(char *inbuf, char *outbuf, =
u64 compress_len,=0A=
 	(void)inflateEnd(&strm);=0A=
 	return 0;=0A=
 }=0A=
+=0A=
 static inline size_t read_compress_length(unsigned char *buf)=0A=
 {=0A=
 	__le32 dlen;=0A=
diff --git a/cmds-scrub.c b/cmds-scrub.c=0A=
index b7aa809..2b03f71 100644=0A=
--- a/cmds-scrub.c=0A=
+++ b/cmds-scrub.c=0A=
@@ -780,12 +780,13 @@ static int scrub_write_progress(pthread_mutex_t =
*m, const char *fsid,=0A=
 	int fd =3D -1;=0A=
 	int old;=0A=
 =0A=
+#ifndef ANDROID=0A=
 	ret =3D pthread_setcancelstate(PTHREAD_CANCEL_DISABLE, &old);=0A=
 	if (ret) {=0A=
 		err =3D -ret;=0A=
 		goto out3;=0A=
 	}=0A=
-=0A=
+#endif=0A=
 	ret =3D pthread_mutex_lock(m);=0A=
 	if (ret) {=0A=
 		err =3D -ret;=0A=
@@ -816,10 +817,11 @@ out1:=0A=
 		err =3D -ret;=0A=
 =0A=
 out2:=0A=
+#ifndef ANDROID=0A=
 	ret =3D pthread_setcancelstate(PTHREAD_CANCEL_ENABLE, &old);=0A=
 	if (ret && !err)=0A=
 		err =3D -ret;=0A=
-=0A=
+#endif=0A=
 out3:=0A=
 	return err;=0A=
 }=0A=
@@ -898,9 +900,11 @@ static void *scrub_progress_cycle(void *ctx)=0A=
 	struct sockaddr_un peer;=0A=
 	socklen_t peer_size =3D sizeof(peer);=0A=
 =0A=
+#ifndef ANDROID=0A=
 	perr =3D pthread_setcanceltype(PTHREAD_CANCEL_ASYNCHRONOUS, &old);=0A=
 	if (perr)=0A=
 		goto out;=0A=
+#endif=0A=
 =0A=
 	uuid_unparse(spc->fi->fsid, fsid);=0A=
 =0A=
@@ -952,10 +956,12 @@ static void *scrub_progress_cycle(void *ctx)=0A=
 			 * result we got for the current write and go=0A=
 			 * on. flag should be set on next cycle, then.=0A=
 			 */=0A=
+#ifndef ANDROID=0A=
 			perr =3D pthread_setcancelstate(=0A=
 					PTHREAD_CANCEL_DISABLE, &old);=0A=
 			if (perr)=0A=
 				goto out;=0A=
+#endif=0A=
 			perr =3D pthread_mutex_lock(&sp_shared->progress_mutex);=0A=
 			if (perr)=0A=
 				goto out;=0A=
@@ -964,20 +970,24 @@ static void *scrub_progress_cycle(void *ctx)=0A=
 						&sp_shared->progress_mutex);=0A=
 				if (perr)=0A=
 					goto out;=0A=
+#ifndef ANDROID=0A=
 				perr =3D pthread_setcancelstate(=0A=
 						PTHREAD_CANCEL_ENABLE, &old);=0A=
 				if (perr)=0A=
 					goto out;=0A=
+#endif=0A=
 				memcpy(sp, sp_last, sizeof(*sp));=0A=
 				continue;=0A=
 			}=0A=
 			perr =3D pthread_mutex_unlock(&sp_shared->progress_mutex);=0A=
 			if (perr)=0A=
 				goto out;=0A=
+#ifndef ANDROID=0A=
 			perr =3D pthread_setcancelstate(=0A=
 					PTHREAD_CANCEL_ENABLE, &old);=0A=
 			if (perr)=0A=
 				goto out;=0A=
+#endif=0A=
 			memcpy(sp, sp_shared, sizeof(*sp));=0A=
 			memcpy(sp_last, sp_shared, sizeof(*sp));=0A=
 		}=0A=
@@ -1506,7 +1516,11 @@ static int scrub_start(int argc, char **argv, int =
resume)=0A=
 		}=0A=
 	}=0A=
 =0A=
+#ifdef ANDROID=0A=
+	ret =3D pthread_kill(t_prog, SIGUSR1);=0A=
+#else=0A=
 	ret =3D pthread_cancel(t_prog);=0A=
+#endif=0A=
 	if (!ret)=0A=
 		ret =3D pthread_join(t_prog, &terr);=0A=
 =0A=
@@ -1517,7 +1531,11 @@ static int scrub_start(int argc, char **argv, int =
resume)=0A=
 	}=0A=
 =0A=
 	/* check for errors returned from the progress thread itself */=0A=
+#ifdef ANDROID=0A=
+	if (do_print && terr) {=0A=
+#else=0A=
 	if (do_print && terr && terr !=3D PTHREAD_CANCELED) {=0A=
+#endif=0A=
 		fprintf(stderr, "ERROR: recording progress "=0A=
 			"failed: %s\n", strerror(-PTR_ERR(terr)));=0A=
 	}=0A=
diff --git a/kerncompat.h b/kerncompat.h=0A=
index 5d92856..ae5b724 100644=0A=
--- a/kerncompat.h=0A=
+++ b/kerncompat.h=0A=
@@ -134,6 +134,9 @@ typedef long long s64;=0A=
 typedef int s32;=0A=
 #endif=0A=
 =0A=
+#ifdef ANDROID=0A=
+typedef struct blkid_struct_probe *blkid_probe;=0A=
+#endif=0A=
 =0A=
 struct vma_shared { int prio_tree_node; };=0A=
 struct vm_area_struct {=0A=
diff --git a/mkfs.c b/mkfs.c=0A=
index dafd500..face183 100644=0A=
--- a/mkfs.c=0A=
+++ b/mkfs.c=0A=
@@ -25,7 +25,12 @@=0A=
 #include <stdlib.h>=0A=
 #include <sys/types.h>=0A=
 #include <sys/stat.h>=0A=
+#ifndef ANDROID=0A=
 #include <sys/dir.h>=0A=
+#else=0A=
+#include <dirent.h>=0A=
+#define direct dirent=0A=
+#endif=0A=
 #include <fcntl.h>=0A=
 #include <unistd.h>=0A=
 #include <getopt.h>=0A=
@@ -1359,7 +1364,11 @@ int main(int ac, char **av)=0A=
 	dev_cnt =3D ac - optind;=0A=
 =0A=
 	file =3D av[optind++];=0A=
+#ifndef ANDROID=0A=
 	ssd =3D is_ssd(file);=0A=
+#else=0A=
+	ssd =3D true;=0A=
+#endif=0A=
 =0A=
 	if (is_vol_small(file) || mixed) {=0A=
 		if (verbose)=0A=
diff --git a/utils.c b/utils.c=0A=
index 39b295a..24deb65 100644=0A=
--- a/utils.c=0A=
+++ b/utils.c=0A=
@@ -878,9 +878,9 @@ int btrfs_prepare_device(int fd, char *file, int =
zero_end, u64 *block_count_ret,=0A=
 			file, strerror(-ret));=0A=
 		return 1;=0A=
 	}=0A=
-=0A=
+#ifndef ANDROID=0A=
 	btrfs_wipe_existing_sb(fd);=0A=
-=0A=
+#endif=0A=
 	*block_count_ret =3D block_count;=0A=
 	return 0;=0A=
 }=0A=
@@ -2267,7 +2267,6 @@ check_overwrite(=0A=
 		return 0;=0A=
 =0A=
 	ret =3D -1; /* will reset on success of all setup calls */=0A=
-=0A=
 	pr =3D blkid_new_probe_from_filename(device);=0A=
 	if (!pr)=0A=
 		goto out;=0A=
@@ -2436,7 +2435,11 @@ int test_dev_for_mkfs(char *file, int =
force_overwrite)=0A=
 		return 1;=0A=
 	}=0A=
 	if (!force_overwrite) {=0A=
+#ifndef ANDROID=0A=
 		if (check_overwrite(file)) {=0A=
+#else=0A=
+		{=0A=
+#endif=0A=
 			fprintf(stderr, "Use the -f option to force overwrite.\n");=0A=
 			return 1;=0A=
 		}=0A=
-- =0A=
1.8.2=0A=
=0A=

------=_NextPart_000_0040_01D0D078.06B12530--

