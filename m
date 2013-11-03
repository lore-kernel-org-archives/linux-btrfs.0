Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ea0-f173.google.com ([209.85.215.173]:38287 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752926Ab3KCSiq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 3 Nov 2013 13:38:46 -0500
Received: by mail-ea0-f173.google.com with SMTP id g10so3014551eak.18
        for <linux-btrfs@vger.kernel.org>; Sun, 03 Nov 2013 10:38:44 -0800 (PST)
From: Goffredo Baroncelli <kreijack@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Goffredo Baroncelli <kreijack@inwind.it>
Subject: [PATCH] Provide mount.btrfs helper
Date: Sun,  3 Nov 2013 19:38:41 +0100
Message-Id: <1383503921-6694-2-git-send-email-kreijack@inwind.it>
In-Reply-To: <1383503921-6694-1-git-send-email-kreijack@inwind.it>
References: <1383503921-6694-1-git-send-email-kreijack@inwind.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patch provides a mount.btrfs helper for the mount command to mounting a
btrfs filesystem.
A btrfs filesystem could span several disks. This helper scans all the
partition to discover all the disks required to mount a filesystem.
So it is not necessary any-more to "scan" the partitions to mount a filesystem.

It adds in the option parameters the devices required to mount a filesystem.
Supposing that a filesystem is composed by several disks (/dev/sd[cdef]), when
the user does "mount /dev/sdd /mnt", mount calls mount.btrfs which int turn
calls the mount(2) so:
mount("/dev/sdd", "/mnt", "btrfs", 0, "device=/dev/sdc,device=/dev/sde,device=/de/vsdf").

This helper uses both the libblkid and libmount to discover the devices, to
compute the parameters manipulation and to update the mtab file.

I got the idea from the btrfs.wiki; its biggest gains is to avoid the
separation of scanning phases (at boot time or during the block device
discovery) from the mounting. Also mkfs.btrfs could avoid to re-do a rescan of
the devices after a formatting.

mount.btrfs doesn't add more requirement than the mount command. It would be
possible to remove the "btrfs" command from the initramfs, and all the related
scripts (in my debian both udev and btrfs-tools packages contains three udev
rules for btrfs).
---
 Makefile      |   6 +-
 btrfs-mount.c | 617 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 622 insertions(+), 1 deletion(-)
 create mode 100644 btrfs-mount.c

diff --git a/Makefile b/Makefile
index c43cb68..974e8ad 100644
--- a/Makefile
+++ b/Makefile
@@ -45,7 +45,7 @@ MAKEOPTS = --no-print-directory Q=$(Q)
 
 progs = mkfs.btrfs btrfs-debug-tree btrfsck \
 	btrfs btrfs-map-logical btrfs-image btrfs-zero-log btrfs-convert \
-	btrfs-find-root btrfstune btrfs-show-super
+	btrfs-find-root btrfstune btrfs-show-super mount.btrfs
 
 # external libs required by various binaries; for btrfs-foo,
 # specify btrfs_foo_libs = <list of libs>; see $($(subst...)) rules below
@@ -171,6 +171,10 @@ ioctl-test: $(objects) $(libs) ioctl-test.o
 	@echo "    [LD]     $@"
 	$(Q)$(CC) $(CFLAGS) -o ioctl-test $(objects) ioctl-test.o $(LDFLAGS) $(LIBS)
 
+mount.btrfs: btrfs-mount.o
+	@echo "    [LD]     $@"
+	$(Q)$(CC) $(CFLAGS) -o mount.btrfs -lmount -lblkid btrfs-mount.o $(LDFLAGS) 
+
 send-test: $(objects) $(libs) send-test.o
 	@echo "    [LD]     $@"
 	$(Q)$(CC) $(CFLAGS) -o send-test $(objects) send-test.o $(LDFLAGS) $(LIBS) -lpthread
diff --git a/btrfs-mount.c b/btrfs-mount.c
new file mode 100644
index 0000000..fe07f9e
--- /dev/null
+++ b/btrfs-mount.c
@@ -0,0 +1,617 @@
+#include <stdio.h>
+#include <unistd.h>
+#include <string.h>
+#include <stdlib.h>
+#include <assert.h>
+#include <sys/mount.h>
+#include <errno.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+       
+#include <blkid/blkid.h>
+#include <libmount/libmount.h>
+
+#define MOUNT_FLAG_FAKE_MOUNT		1
+#define MOUNT_FLAG_VERBOSE		2
+#define MOUNT_FLAG_NOT_WRITIING_MTAB	4
+#define MOUNT_FLAG_IGNORE_SLOPPY_OPTS	8
+
+struct btrfs_device {
+	char			*device_name;
+	char			*device_uuid;
+	char 			*fs_name;
+	char			*fs_uuid;
+	struct btrfs_device	*next;
+};
+
+/* Parse program args, and set the related variables */
+static int parse_args(int argc, char **argv, char **options, 
+				char **spec, char **dir, int *flag)
+{
+	char	opt;
+
+	*options = NULL;
+
+	while ((opt = getopt(argc, argv, "sfnvo:")) != -1) {
+
+		switch (opt) {
+			
+		case 's':	/* tolerate sloppy mount options */
+			*flag |= MOUNT_FLAG_IGNORE_SLOPPY_OPTS;
+			break;
+		case 'f':	/* fake mount */
+			*flag |= MOUNT_FLAG_FAKE_MOUNT;
+			break;
+		case 'n':	/* mount without writing in mtab */
+			*flag |= MOUNT_FLAG_NOT_WRITIING_MTAB;
+			break;
+		case 'v':	/* verbose */
+			*flag |= MOUNT_FLAG_VERBOSE;
+			break;
+		case 'o':
+			*options = optarg;
+			break;
+		default:
+			fprintf( stderr,"ERROR: unknown option: '%c'\n", opt);
+			return 1;
+		}
+	}
+
+	if (argc-optind != 2) {
+		fprintf(stderr, "ERROR: two arguments are needed\n");
+		return 1;
+	}
+
+	*spec = argv[optind];
+	*dir  = argv[optind+1];
+
+	return 0;
+
+}
+
+/* add a new string to the string array */
+static void add_to_list(struct btrfs_device **head, struct btrfs_device *d)
+{
+	d->next = (*head);
+	*head = d;
+}
+
+/* free a btrfs_device struct */
+static void free_btrfs_device(struct btrfs_device *p)
+{
+	if (!p) return;
+	
+	free( p->device_name );
+	free( p->device_uuid );
+	free( p->fs_name );
+	free( p->fs_uuid );
+	free(p);
+}
+
+/* free a btrfs devices(s) list */
+static void free_btrfs_devices_list(struct btrfs_device **p)
+{
+	while (*p) {
+		struct btrfs_device *next;
+		next = (*p)->next;
+		free_btrfs_device(*p);
+		*p = next;
+	}
+}
+
+/*
+ * this function extracts information from a device
+ */
+static int get_btrfs_dev_info(const char *devname, struct btrfs_device **device)
+{
+	int rc, ret=0;
+	blkid_probe pr;
+	
+	*device = NULL;
+
+	pr = blkid_new_probe_from_filename(devname);
+	if (!pr) {
+		fprintf(stderr, "ERROR: faild to create a new libblkid "
+			"probe for '%s'\n", devname);
+		return 1;
+	}
+
+	/* enable topology probing */
+	blkid_probe_enable_superblocks(pr, 1);
+
+	/* set all flags */
+	blkid_probe_set_superblocks_flags(pr,
+		BLKID_SUBLKS_LABEL |
+		BLKID_SUBLKS_UUID |
+		BLKID_SUBLKS_TYPE );
+
+	rc = blkid_do_safeprobe(pr);
+	if (rc == -1) {
+		fprintf(stderr, "ERROR: blkid_do_safeprobe() failed for '%s'\n", 
+			devname);
+		ret = 2; 
+	} else if (rc == 1) {
+		fprintf(stderr, "ERROR: cannot gather information about "
+			"superblocks for '%s'\n", devname);
+		ret = 3;
+	} else {
+		int i, nvals = blkid_probe_numof_values(pr);
+		
+		*device = calloc(sizeof(struct btrfs_device), 1);
+		if (!*device) {
+			fprintf(stderr, "ERROR: not enough memory!\n");
+			ret = 20;
+			goto quit;
+		}
+		(*device)->device_name = strdup(devname);
+		if (!(*device)->device_name) {
+			fprintf(stderr, "ERROR: not enough memory!\n");
+			ret = 21;
+			goto quit;
+		}
+		for (i = 0; i < nvals; i++) {
+			const char *name, *data;
+			blkid_probe_get_value(pr, i, &name, &data, NULL);
+
+			if (!strcmp("UUID_SUB", name)) {
+				(*device)->device_uuid = strdup(data);
+				if ((*device)->device_uuid) 
+					continue;
+				fprintf(stderr, 
+					"ERROR: not enough memory!\n");
+				ret = 22;
+				goto quit;
+			} else if (!strcmp("UUID", name)) {
+				(*device)->fs_uuid = strdup(data);
+				if ((*device)->fs_uuid) 
+					continue;
+				fprintf(stderr, 
+					"ERROR: not enough memory!\n");
+				ret = 23;
+				goto quit;
+			} else if (!strcmp("LABEL", name)) {
+				(*device)->fs_name = strdup(data);
+				if ((*device)->fs_name) 
+					continue;
+				fprintf(stderr, 
+					"ERROR: not enough memory!\n");
+				ret = 24;
+				goto quit;
+			} else if (!strcmp("TYPE", name) && 
+					strcmp(data, "btrfs")) {
+				
+				fprintf(stderr, "ERROR: scanning a non-btrfs"
+					" device (%s)\n", devname);
+				ret = 25;
+				goto quit;
+			}
+		}
+	}
+quit:
+	/* if failed, clean *device memory allocation */
+	if (ret && *device) {
+		free_btrfs_device(*device);
+		*device = NULL;
+	}
+	blkid_free_probe(pr);
+	return ret;
+}
+
+/* check if path is a valid block device */
+static int is_block_device(char *path)
+{
+	struct stat st;
+	
+	if (stat(path, &st))
+		return 0;
+	
+	return S_ISBLK(st.st_mode);
+}
+
+/*
+ * 	this function get all the devices related to a filesystem
+ * 	return values:
+ * 	0 	-> OK
+ * 	>0	-> error
+ * 	<0	-> cache incoerency
+ */
+static int _get_devices_list(int flag, char *spec, 
+	struct btrfs_device **devices, blkid_cache *bcache)
+{
+	/*blkid_cache 		bcache;*/
+	blkid_dev_iterate	bit;
+	blkid_dev 		bdev;
+	
+	char			*dev;
+	struct btrfs_device	*device0;
+	struct btrfs_device 	*d, *prevd;
+	int 			ret;
+
+	*devices = NULL;
+
+	if (!strncmp(spec, "LABEL=", 6)) {
+		dev = blkid_evaluate_tag("LABEL", spec+6, bcache);
+	} else if (!strncmp(spec, "UUID=", 5)) {
+		dev = blkid_evaluate_tag("UUID", spec+5, bcache);
+	} else {
+		dev = spec;
+	}
+	
+	if (!dev || !is_block_device(dev)) {
+		fprintf(stderr, "ERROR: '%s' is not a valid block device\n", 
+			spec);
+		return 2;
+	}
+	
+	if (flag & MOUNT_FLAG_VERBOSE)
+		printf("INFO: start from device %s\n", dev);
+		
+	if (flag & MOUNT_FLAG_VERBOSE)
+		printf("INFO: scan the first device\n");
+	
+	ret = get_btrfs_dev_info(dev, &device0);
+	if (ret) 
+		/* the error messages was already emitted */
+		return 3;
+
+	bit = blkid_dev_iterate_begin(*bcache);
+	if (blkid_dev_set_search(bit, "UUID", device0->fs_uuid)) {
+		fprintf(stderr,"ERROR: unable to setup blkid_dev_set_search()\n");
+		ret = 4;
+		goto exit;
+	}
+	
+	while (!blkid_dev_next(bit, &bdev)) {
+		const char *dev;
+		
+		struct btrfs_device *p;
+		dev = blkid_dev_devname(bdev);		
+		
+		if (get_btrfs_dev_info(dev, &p)) {
+			/* the error messages was already emitted */
+			ret = 5;
+			goto exit;
+		}
+		if (strcmp(device0->fs_uuid, p->fs_uuid)) {
+			/* cache incoherency */
+			free_btrfs_devices_list(devices);
+			*devices = NULL;
+			ret = -1;
+			goto exit;
+		};
+		add_to_list(devices, p);
+	}
+
+	/* sort the list so dev is the first device */
+	for (prevd = NULL, d = *devices ; d ; prevd = d, d = d->next) {
+		if (strcmp(d->device_name, dev))
+			continue;
+		if (!prevd)
+			/* ok, dev is the first device: do nothing */
+			break;
+		
+		prevd->next = d->next;
+		d->next = *devices;
+		*devices = d;
+	}
+
+exit:
+	if (ret && *devices) {
+		free_btrfs_devices_list(devices);
+		*devices = NULL;
+	}
+	
+	blkid_dev_iterate_end(bit);
+	free_btrfs_device(device0);
+	
+	return ret;
+}
+
+/*
+ * 	this function get all the devices related to a filesystem
+ * 	return values:
+ * 	0 	-> OK
+ * 	>0	-> error
+ */
+static int get_devices_list(int flag, char *spec, 
+			     struct btrfs_device **devices)
+{
+	blkid_cache	bcache;
+	int 		ret;
+	
+	if (blkid_get_cache(&bcache, NULL)) {
+		fprintf(stderr, "ERROR: cannot get blkid cache\n");
+		return 1;
+	}
+	
+	ret = _get_devices_list(flag, spec, devices, &bcache);
+	/*
+	 * If ret < 0 a cache inchoernecy was detected
+	 * if ret == 0 and *devices == 0, still a cache inchoernecy 
+	 * was detected: anyway we rebuild the cache and retry a new serach 
+	 */
+	if (ret < 0 || (!ret && !*devices)) {
+		if (blkid_probe_all(bcache)) {
+			fprintf(stderr, 
+				"ERROR: cannot do a blkid_probe_all()\n");
+			ret = 6;
+			goto exit;
+		}
+		ret = _get_devices_list(flag, spec, devices, &bcache);
+	}
+	
+exit:
+	blkid_put_cache(bcache);
+	return ret;
+}
+
+/* joins two options string */
+static int join_options(char **dst, char *fs_opts, char *vfs_opts)
+{
+	int l1=0, l2=0;
+		
+	if (fs_opts && *fs_opts)
+		l1 = strlen(fs_opts);
+	
+	if (vfs_opts && *vfs_opts)
+		l2 = strlen(vfs_opts);
+	
+	if (!l1 && !l2) {
+		*dst = strdup("");
+		return *dst == NULL;
+	}
+	
+	*dst = calloc(l1+l2+2, 1);
+	if (!*dst)
+		return 3;
+	
+	if (l1) {
+		strcpy(*dst, fs_opts);
+		strcat(*dst, ",");
+	}
+	if (l2)
+		strcat(*dst, vfs_opts);
+		
+	return 0;
+}
+
+/*
+ * This function rearrange the options
+ * 1) removes from "options":
+ * - the vfs_options (which became bits in mount_flags)
+ * - eventually device=<xxx> options passed (these aren't used)
+ * 2) adds to "options" a true list of device=<xxx> 
+ * 3) put all the options in all_options, which will be used in 
+ *    updating mtab
+ */
+static int rearrange_options(int flags, char **options, 
+			     unsigned long *mount_flags, 
+			     char **all_options,
+			     struct btrfs_device *devices)
+{
+	int 	rc;
+	char	*user_opts=NULL, *vfs_opts=NULL, *fs_opts=NULL;
+	char	*value=NULL;
+	int 	ret=0;
+	size_t	size;
+	struct btrfs_device *device;
+	
+	*all_options = NULL;
+	
+	rc = mnt_split_optstr(*options, &user_opts, &vfs_opts, &fs_opts, 0, 0);
+	if (rc) {
+		fprintf(stderr, "ERROR: not enough memory\n");
+		ret = 1;
+		goto exit;
+	}
+	
+        rc = mnt_optstr_get_flags(vfs_opts, mount_flags, 
+				  mnt_get_builtin_optmap(MNT_LINUX_MAP));
+        if (rc) {
+		fprintf(stderr, "ERROR: not enough memory\n");
+		ret = 2;
+		goto exit;
+	}
+	
+	/* removes devices */
+	while (!mnt_optstr_get_option(fs_opts, "device", &value, &size)) {
+		rc = mnt_optstr_remove_option(&fs_opts, "device");
+		if (rc) {
+			fprintf(stderr, "ERROR: not enough memory\n");
+			ret = 3;
+			goto exit;
+		}
+		if (flags & MOUNT_FLAG_IGNORE_SLOPPY_OPTS) {
+			fprintf(stderr, "WARNING: 'device=' option ignored\n");
+			continue;
+		}
+		fprintf(stderr, "ERROR: 'device=' option not allowed\n");
+		ret=7;
+		goto exit;
+		
+	}
+	/* append additional devices */
+	device = devices->next;
+	while (device) {
+		rc = mnt_optstr_append_option(&fs_opts, 
+			"device", device->device_name);
+		if (rc) {
+			fprintf(stderr, "ERROR: not enough memory\n");
+			ret = 4;
+			goto exit;
+		}
+		device = device->next;
+	}
+	
+	if (join_options(all_options, fs_opts, vfs_opts)) {
+		fprintf(stderr, "ERROR: not enough memory\n");
+		ret = 4;
+		goto exit;
+	}
+	
+	*options = fs_opts;
+	fs_opts = NULL;
+	
+	if (flags & MOUNT_FLAG_VERBOSE) {
+		printf("INFO: final flags: %s\n", *options);
+		printf("INFO: all flags  : %s\n", *all_options);
+	}
+	
+exit:
+	free(vfs_opts);
+	free(fs_opts);
+	free(user_opts);
+	return ret;
+	
+}
+
+/* this function update the mtab file (if needed */
+static int update_mtab(int flags, char *device, char *target, char *all_opts )
+{
+	
+	struct libmnt_fs	*fs = NULL;
+	struct libmnt_update	*update = NULL;
+	
+	char			*vfs_opts = NULL;
+	int			ret = 0, rc;
+	
+	fs = mnt_new_fs();
+	if (!fs)
+		goto memoryerror;
+	if (mnt_fs_set_options(fs, all_opts)) 
+		goto memoryerror;
+	if (mnt_fs_set_source(fs, device)) 
+		goto memoryerror;
+	if (mnt_fs_set_target(fs, target)) 
+		goto memoryerror;
+	if (mnt_fs_set_fstype(fs, "btrfs")) 
+		goto memoryerror;
+	if (flags & MOUNT_FLAG_VERBOSE) 
+		printf("INFO: info for updating 'mtab' prepared\n");
+	if (!(update = mnt_new_update()))
+		goto memoryerror;
+	
+	rc = mnt_update_set_fs(update, 0, NULL, fs);
+
+	if (rc == 1) {
+		fprintf(stderr, "WARNING: update of mtab not needed\n");
+		ret = 0;
+		goto exit;
+	} else if (rc) {
+		fprintf(stderr, "ERROR: failed to set fs\n");
+		ret = 10;
+		goto exit;
+	}
+	
+	ret = mnt_update_table(update, NULL);
+	if (ret) 
+		fprintf(stderr, "ERROR: failed to update mtab\n");
+	else if (flags & MOUNT_FLAG_VERBOSE) 
+		printf("INFO: 'mtab' updated\n");
+	goto exit;
+
+memoryerror:
+	fprintf(stderr, "ERROR: not enough memory\n");
+	if (fs)     mnt_free_fs(fs);
+	if (update) mnt_free_update(update);
+				 
+	free(vfs_opts);
+	
+	return 100;
+		
+exit:
+	if (fs)     mnt_free_fs(fs);
+	if (update) mnt_free_update(update);
+				 
+	free(vfs_opts);
+	
+	return ret;
+}
+
+int main(int argc, char **argv)
+{
+
+	char *fs_opts, *spec, *dir, *all_options;
+	int ret, flags=0;
+	struct btrfs_device *devices;
+	unsigned long mount_flags = 0;
+	
+	ret = parse_args(argc, argv, &fs_opts, &spec, &dir, &flags);
+
+	if (ret)
+		goto internalerror;
+	
+	if (flags & MOUNT_FLAG_VERBOSE)
+		printf("INFO: parsed arguments\n");
+	
+	ret = get_devices_list(flags, spec, &devices);
+	if (ret)
+		goto internalerror;
+	
+	assert(devices);
+	
+	if (flags & MOUNT_FLAG_VERBOSE)
+		printf("INFO: extracted the devices list\n");
+
+	if (flags & MOUNT_FLAG_VERBOSE) {
+		struct btrfs_device *d;
+		printf("INFO: filesystem info:\n");
+		printf("INFO:\tUUID=%s\n", devices->fs_uuid);
+		printf("INFO:\tLABEL=%s\n", devices->fs_name);
+		for (d = devices ; d ; d=d->next) 
+			printf("INFO:\tUUID_SUB=%s - dev=%s\n",
+				d->device_uuid, d->device_name);
+	}
+
+	ret = rearrange_options(flags, &fs_opts, &mount_flags, &all_options, 
+					devices);
+	if (ret)
+		goto internalerror;
+
+	if (!(flags & MOUNT_FLAG_FAKE_MOUNT)) {
+		int e;
+		
+		if (flags & MOUNT_FLAG_VERBOSE) {
+			char *vfs_opts=NULL;
+			printf("INFO: source: %s\n",  devices->device_name);
+			printf("INFO: target: %s\n",  dir);
+			mnt_optstr_apply_flags(&vfs_opts, mount_flags,
+				mnt_get_builtin_optmap(MNT_LINUX_MAP));
+			printf("INFO: vfs_opts: 0x%08lx - %s\n", 
+			       mount_flags, vfs_opts);
+			printf("INFO: fs_opts: %s\n", fs_opts);
+			free(vfs_opts);
+		}
+
+		if (!(flags & MOUNT_FLAG_NOT_WRITIING_MTAB)) {
+			ret = update_mtab(flags, devices->device_name, dir,
+					all_options);
+			/* update_mtab error messages alredy printed */
+			if (ret)
+				goto errormtab;
+		}
+				
+		ret = mount(devices->device_name, dir, "btrfs", mount_flags,
+			fs_opts);
+		e = errno;
+		if (!ret) {
+			if (flags & MOUNT_FLAG_VERBOSE)
+				printf("INFO: mount succeded\n");
+		} else {
+			fprintf(stderr, "ERROR: mount failed : %d - %s\n",
+				e, strerror(e));
+		}
+			
+	} else {
+		ret = 0;
+	}
+	
+	exit(ret);
+	
+errormtab:
+	exit(16);
+	
+internalerror:
+	exit(2);
+	
+}
\ No newline at end of file
-- 
1.8.4.2

