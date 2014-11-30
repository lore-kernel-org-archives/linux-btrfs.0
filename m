Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-35-i2.italiaonline.it ([212.48.25.208]:36709 "EHLO
	smtp-35.italiaonline.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752395AbaK3Rv2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 30 Nov 2014 12:51:28 -0500
Message-ID: <547B5724.1060507@libero.it>
Date: Sun, 30 Nov 2014 18:43:00 +0100
From: Goffredo Baroncelli <kreijack@libero.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: linux-btrfs <linux-btrfs@vger.kernel.org>
CC: David Sterba <dsterba@suse.cz>, Zygo Blaxell <zblaxell@furryterror.org>
Subject: [RFC][PATCH v2] mount.btrfs helper
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi all,

this patch provides a "mount.btrfs" helper for the mount command.
A btrfs filesystem could span several disks. This helper scans all the
partitions to discover all the disks required to mount a filesystem.
So it would not necessary any-more to "scan" the partitions to mount a filesystem.

mount.btrfs passes in the option parameters the devices required to mount a 
filesystem. 
Supposing that a filesystem is composed by several disks (/dev/sd[cdef]), when
the user runs "mount /dev/sdd /mnt", mount.btrfs is called and it executes the
the mount(2) syscall as below:

mount("/dev/sdd", "/mnt", "btrfs", 0, "device=/dev/sdc,device=/dev/sde,device=/de/vsdf").

This helper uses both the libblkid and libmount to discover the devices, to
manipulate the parameters and to update the mtab file.

I got the idea from the btrfs.wiki; the initial idea was to avoid the
separation of scanning phases (at boot time or during the block device
discovery) from the mounting. 
But now I think that its biggest advantage is that now it is possible to
perform some actions that before would not be possible, like:
- check that all the disks have different disk_uuid
Before mounting the filesystem, it is checked that all the disks have 
different uuid, otherwise it stops the process because it is impossible
to guarantee that the right disks are used (i.e. some disks may be 
snapshotted by lvm...)
- wait the availability of all disks
May be that when mount is called not all the disks are available. This helper
waits few second (now 10, tunable via the device_timeout option) that the
disks appear.
If the timeout expires, there are two possibilities:
	1) if the option "degraded" is passed, the filesystem is mounted in 
	   "degraded mode" 
	2) otherwise the filesystem is NOT mounted with an error message

All the controls above may be avoided passing the disks explicitly:

	mount /dev/sdb -o device=/dev/sdc,device=/dev/sdd /mnt

Of course all the previous kernels checks are still present.

Below an example of use:

ghigo@emulato:~$ sudo mkfs.btrfs /dev/vdb /dev/vdc /dev/vdd /dev/vde
ghigo@emulato:~$ sudo mount -v /dev/vdb /mnt/btrfs1/
mount: you didn't specify a filesystem type for /dev/vdb
       I will try type btrfs
INFO: scan the first device
INFO: find filesystem 'test1' [d43585b9-233e-4ce3-9201-81d68ec8e538]
INFO: source: /dev/vdb
INFO: target: /mnt/btrfs1/
INFO: vfs_opts: 0x00000000 - rw
INFO: fs_opts: (null)
INFO:    dev='/dev/vdb' UUID='9e83d673-a76c-4b56-8daa-0a0659897d8c' gen=6
INFO:    dev='/dev/vde' UUID='53647bb0-9c39-445a-ba3f-ce31e35026a7' gen=6
INFO:    dev='/dev/vdd' UUID='8396ee54-fba1-46b3-801c-1918a9812603' gen=6
INFO:    dev='/dev/vdc' UUID='577b77df-2c95-4087-90d7-2331ee10a59d' gen=6
INFO: mtab updated
INFO: mount succeded
ghigo@emulato:~$ 

you can pull the source from:

	https://github.com/kreijack/btrfs-progs.git

branch
	mount.btrfs

as bonus you will get also the test suite (under test/mount.btrfs-tests)

Comments are welcome

BR
G.Baroncelli

----------

diff --git a/Makefile b/Makefile
index 4cae30c..8d38138 100644
--- a/Makefile
+++ b/Makefile
@@ -48,7 +48,7 @@ MAKEOPTS = --no-print-directory Q=$(Q)
 
 progs = mkfs.btrfs btrfs-debug-tree btrfsck \
 	btrfs btrfs-map-logical btrfs-image btrfs-zero-log btrfs-convert \
-	btrfs-find-root btrfstune btrfs-show-super
+	btrfs-find-root btrfstune btrfs-show-super mount.btrfs
 
 progs_extra = btrfs-corrupt-block btrfs-fragments btrfs-calc-size \
 	      btrfs-select-super
@@ -239,6 +239,12 @@ ioctl-test: $(objects) $(libs) ioctl-test.o
 	@echo "    [LD]     $@"
 	$(Q)$(CC) $(CFLAGS) -o ioctl-test $(objects) ioctl-test.o $(LDFLAGS) $(LIBS)
 
+mount.btrfs: btrfs-mount.o btrfs-mount-find-disks.o crc32c.o utils.o
+	@echo "    [LD]     $@"
+	$(Q)$(CC) $(CFLAGS) -o mount.btrfs -lmount -lblkid -luuid \
+		crc32c.o \
+		btrfs-mount.o btrfs-mount-find-disks.o $(LDFLAGS) 
+
 send-test: $(objects) $(libs) send-test.o
 	@echo "    [LD]     $@"
 	$(Q)$(CC) $(CFLAGS) -o send-test $(objects) send-test.o $(LDFLAGS) $(LIBS) -lpthread
diff --git a/btrfs-mount-find-disks.c b/btrfs-mount-find-disks.c
new file mode 100644
index 0000000..89aac8b
--- /dev/null
+++ b/btrfs-mount-find-disks.c
@@ -0,0 +1,446 @@
+#define _XOPEN_SOURCE 500
+#define _GNU_SOURCE 1
+
+#include <stdio.h>
+#include <unistd.h>
+#include <string.h>
+#include <stdlib.h>
+#include <assert.h>
+#include <sys/mount.h>
+#include <errno.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <fcntl.h>
+#include <unistd.h>
+
+#include <blkid/blkid.h>
+#include <uuid/uuid.h>
+#include <libmount/libmount.h>
+
+#include "crc32c.h"
+
+#include "kerncompat.h"
+#include "extent_io.h"
+#include "ctree.h"
+#include "disk-io.h"
+#include "btrfs-mount.h"
+
+#define BTRFS_UUID_UNPARSED_SIZE 37
+
+/*
+ * checks if a path is a block device node
+ * Returns negative errno on failure, otherwise
+ * returns 1 for blockdev, 0 for not-blockdev
+ */
+static int is_block_device(const char *path)
+{
+	struct stat statbuf;
+
+	if (stat(path, &statbuf) < 0)
+		return -errno;
+
+	return S_ISBLK(statbuf.st_mode);
+}
+
+/* add a new btrfs_device to the list */
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
+void free_btrfs_devices_list(struct btrfs_device **p)
+{
+	while (*p) {
+		struct btrfs_device *next;
+		next = (*p)->next;
+		free_btrfs_device(*p);
+		*p = next;
+	}
+}
+
+/* TBD: from disk-io.c, should we get from a library ? */
+static u32 csum_data(char *data, u32 seed, size_t len)
+{
+        return crc32c(seed, data, len);
+}
+
+static void csum_final(u32 crc, char *result)
+{
+	*(__le32 *)result = ~cpu_to_le32(crc);
+}
+
+static int check_csum_sblock(void *sb, int csum_size)
+{
+	char result[BTRFS_CSUM_SIZE];
+	u32 crc = ~(u32)0;
+
+	crc = csum_data((char *)sb + BTRFS_CSUM_SIZE,
+				crc, BTRFS_SUPER_INFO_SIZE - BTRFS_CSUM_SIZE);
+	csum_final(crc, result);
+
+	return !memcmp(sb, &result, csum_size);
+}
+
+/*
+ * Load and check superblock info
+ * return values:
+ * 0	ok
+ * >0	sb content invalid
+ * <0	other error
+ */
+
+static int load_and_check_sb_info(char *devname, char **dev_uuid, char **fs_uuid,
+			char **fs_label, long long unsigned *num_devices,
+			long long unsigned *generation) {
+
+	u8 super_block_data[BTRFS_SUPER_INFO_SIZE];
+	struct btrfs_super_block *sb;
+	u64 ret;
+	int fd;
+	u64 sb_bytenr = btrfs_sb_offset(0);
+
+	if (!is_block_device(devname)) {
+		fprintf(stderr, "ERROR: '%s' is not a block device\n", devname);
+		return -4;
+	}
+
+	fd = open(devname, O_RDONLY, 0666);
+	if (fd < 0) {
+		fprintf(stderr, "ERROR: Can't acces the device '%s'\n", devname);
+		return -3;
+	}
+	sb = (struct btrfs_super_block *)super_block_data;
+
+	ret = pread64(fd, super_block_data, BTRFS_SUPER_INFO_SIZE, sb_bytenr);
+	close(fd);
+
+	if (ret != BTRFS_SUPER_INFO_SIZE) {
+		int e = errno;
+
+		fprintf(stderr,
+		   "ERROR: Failed to read the superblock on %s at %llu\n",
+		   devname, (unsigned long long)sb_bytenr);
+		fprintf(stderr,
+		   "ERROR: error = '%s', errno = %d\n", strerror(e), e);
+		return -4;
+	}
+
+	/*
+	 * TBD: this would be the place to check for further superblock
+	 * 	if the first one fails
+	 */
+
+	if (btrfs_super_magic(sb) != BTRFS_MAGIC) {
+		fprintf(stderr, "ERROR: Failed check of BTRFS_MAGIC (device=%s)\n",
+			devname);
+		return 4;
+	}
+
+	if (!check_csum_sblock(sb, btrfs_super_csum_size(sb))) {
+		fprintf(stderr, "ERROR: Failed check of checksum (device=%s)\n",
+			devname);
+		return 5;
+	}
+
+	*dev_uuid = malloc(BTRFS_UUID_UNPARSED_SIZE+1);
+	*fs_uuid = malloc(BTRFS_UUID_UNPARSED_SIZE+1);
+	*fs_label = strdup(sb->label);
+	if (!*dev_uuid || !*fs_uuid || !*fs_label) {
+		fprintf(stderr, "ERROR: not enough memory\n");
+		return 6;
+	}
+
+	uuid_unparse(sb->fsid, *fs_uuid);
+	uuid_unparse(sb->dev_item.uuid, *dev_uuid);
+
+	*num_devices = (unsigned long long)btrfs_super_num_devices(sb);
+	*generation = (unsigned long long)btrfs_super_generation(sb);
+	return 0;
+
+}
+
+/*
+ * this function extracts information from a device
+ * 0	ok
+ * >0	sb content invalid
+ * <0	other error
+ */
+static int get_btrfs_dev_info(const char *devname, struct btrfs_device **devret)
+{
+	int ret=0;
+	struct btrfs_device *device = NULL;
+
+	*devret = NULL;
+
+	device = calloc(sizeof(struct btrfs_device), 1);
+	if (!device) {
+		fprintf(stderr, "ERROR: not enough memory!\n");
+		ret = -20;
+		goto quit;
+	}
+	device->device_name = strdup(devname);
+	if (!device->device_name) {
+		fprintf(stderr, "ERROR: not enough memory!\n");
+		ret = -21;
+		goto quit;
+	}
+
+	ret = load_and_check_sb_info(device->device_name, &device->device_uuid,
+		&device->fs_uuid, &device->fs_name,
+		&device->num_devices, &device->generation);
+
+quit:
+	/* if failed, clean *device memory allocation */
+	if (ret && device)
+		free_btrfs_device(device);
+	else
+		*devret = device;
+
+	return ret;
+}
+
+/*
+ * 	this function get all the devices related to a filesystem
+ * 	return values:
+ * 	0 	-> OK
+ * 	>0	-> sb error
+ * 	<0	-> other error
+ */
+static int _get_devices_list(int flag, struct btrfs_device *device0,
+	 blkid_cache *bcache)
+{
+	/*blkid_cache 		bcache;*/
+	blkid_dev_iterate	bit;
+	blkid_dev 		bdev;
+
+	int 			ret=0;
+	struct btrfs_device *devices=NULL;
+
+	assert(device0);
+
+	bit = blkid_dev_iterate_begin(*bcache);
+	if (blkid_dev_set_search(bit, "UUID", device0->fs_uuid)) {
+		fprintf(stderr,"ERROR: unable to setup blkid_dev_set_search()\n");
+		ret = -4;
+		goto exit;
+	}
+
+	while (!blkid_dev_next(bit, &bdev)) {
+		struct btrfs_device *p;
+		const char *dev = strdup(blkid_dev_devname(bdev));
+
+		if ((ret = get_btrfs_dev_info(dev, &p)) != 0)
+			break;
+
+		if (!strcmp(device0->device_name, p->device_name))
+			continue;
+
+		add_to_list(&devices, p);
+	}
+
+exit:
+	blkid_dev_iterate_end(bit);
+	if (ret && devices) {
+		free_btrfs_devices_list(&devices);
+	}
+
+	blkid_dev_iterate_end(bit);
+	device0->next = devices;
+
+	return ret;
+}
+
+/*
+ * Check that the superblock info are coherent and the device are enough
+ *
+ * <0		error
+ * 0		ok
+ * >0		not enough device, retry
+ */
+static int check_devices(struct btrfs_device *l)
+{
+	u64 c;
+	int e=0;
+	struct btrfs_device *p;
+
+	assert(l);
+
+	/* check the superblocks disk count*/
+	p = l->next;
+	while (p) {
+		if (p->num_devices != l->num_devices) {
+			fprintf(stderr, "ERROR: "
+				"superblock number of device mismatch (device=%s)",
+				p->device_name);
+				e--;
+		}
+		p = p-> next;
+	}
+	if (e)
+		return e;
+
+	/* check for the superblock disk uuid */
+	for (p = l ; p ; p = p->next ) {
+		struct btrfs_device *p2 = p->next;
+		while (p2) {
+			if (!strcmp(p->device_uuid, p2->device_uuid)) {
+				fprintf(stderr, "ERROR: "
+					"disk '%s' and '%s' have the same disk uuid\n",
+					p->device_name, p2->device_name);
+					e--;
+			}
+			p2 = p2->next;
+		}
+	}
+
+	if (e)
+		return e;
+
+	for ( c=0, p=l ; p ; p= p->next, c++ ) ;
+	if (c > l->num_devices) {
+		fprintf(stderr, "ERROR: found more device than required.\n");
+		return -1;
+	}
+
+	/* not enough device; wait for further */
+	if (c < l->num_devices)
+		return 1;
+
+	return 0;
+
+}
+
+/*
+ * 	this function get info for a device)
+ * 	return values:
+ * 	0 	-> OK
+ * 	<0	-> error
+ */
+int get_device_info(char *spec, struct btrfs_device **device)
+{
+	blkid_cache	bcache;
+	int 		ret;
+	char		*dev;
+
+	if (blkid_get_cache(&bcache, NULL)) {
+		fprintf(stderr, "ERROR: cannot get blkid cache\n");
+		return -1;
+	}
+
+	if (!strncmp(spec, "LABEL=", 6)) {
+		dev = blkid_evaluate_tag("LABEL", spec+6, &bcache);
+	} else if (!strncmp(spec, "UUID=", 5)) {
+		dev = blkid_evaluate_tag("UUID", spec+5, &bcache);
+	} else {
+		dev = strdup(spec);
+	}
+
+	ret = get_btrfs_dev_info(dev, device);
+	if (ret)
+		ret = 1;
+	blkid_put_cache(bcache);
+	return ret;
+
+}
+
+/*
+ * 	this function get all the devices related to a filesystem
+ * 	return values:
+ * 	0 	-> OK
+ * 	400	-> not enough disk
+ * 	>0	-> error on the sb content
+ *	<0	-> other error
+ */
+int get_devices_list(int flag, struct btrfs_device *device0, int timeout)
+{
+	blkid_cache	bcache = NULL;
+	int 		ret;
+	int		first=1;
+
+	assert(device0);
+	assert(device0->num_devices > 1);
+
+	if (blkid_get_cache(&bcache, NULL)) {
+		fprintf(stderr, "ERROR: cannot get blkid cache\n");
+		return -1;
+	}
+
+	do {
+
+		free_btrfs_devices_list(&device0->next);
+		ret = _get_devices_list(flag, device0, &bcache);
+
+		if (ret)
+			break;
+
+		/* check if the devices are ok */
+		ret = check_devices(device0);
+
+		/* all ok */
+		if (!ret)
+			break;
+
+		/*
+		 * error or not enough device: regenerate cache and
+		 * try another time
+		 */
+		if (first) {
+			free(bcache);
+			if (blkid_get_cache(&bcache, "/dev/null")) {
+				free_btrfs_devices_list(&device0->next);
+				fprintf(stderr, "ERROR: cannot get blkid cache\n");
+				return -1;
+			}
+			blkid_probe_all_new(bcache);
+			first = 0;
+			continue;
+		}
+
+		/* error even with cache regenerate */
+		if (ret < 0)
+			break;
+
+		if (flag & MOUNT_FLAG_VERBOSE) {
+			struct btrfs_device *p;
+			printf("INFO: sleep 1s [timeout=%ds][", timeout);
+			for (p=device0 ; p ; p=p->next) {
+				char *dev = p->device_name;
+				if (!strncmp(dev, "/dev/", 5))
+					dev += 5;
+				printf("%s", dev);
+				if (p->next)
+					printf(",");
+			}
+			printf(" / %llu]\n",device0->num_devices);
+		}
+		/* wait and check for new entryes */
+		sleep(1);
+		timeout--;
+		blkid_probe_all_new(bcache);
+
+	}while(timeout>0);
+
+	if (timeout <=0) {
+		fprintf(stderr, "WARNING: not enough devices\n");
+		ret = 400;
+	}
+
+	free(bcache);
+	return ret;
+}
+
+
diff --git a/btrfs-mount.c b/btrfs-mount.c
new file mode 100644
index 0000000..ed15d55
--- /dev/null
+++ b/btrfs-mount.c
@@ -0,0 +1,390 @@
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
+#include "btrfs-mount.h"
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
+	} else if(!l1) {
+		*dst = strdup(vfs_opts);
+		return *dst == NULL;
+	} else if(!l2) {
+		*dst = strdup(fs_opts);
+		return *dst == NULL;
+	} else {
+
+		*dst = calloc(l1+l2+2, 1);
+		if (!*dst)
+			return 3;
+
+		strcpy(*dst, fs_opts);
+		strcat(*dst, ",");
+		strcat(*dst, vfs_opts);
+
+		return 0;
+	}
+
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
+	int 	ret=0;
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
+	/*
+	 * If additional devices are passed via option,
+	 * the device scan is NOT performed
+	 */
+	if (devices) {
+
+		/* skip the first device, but append additional devices */
+		device = devices->next;
+		while (device) {
+			rc = mnt_optstr_append_option(&fs_opts,
+				"device", device->device_name);
+			if (rc) {
+				fprintf(stderr, "ERROR: not enough memory\n");
+				ret = 4;
+				goto exit;
+			}
+			device = device->next;
+		}
+	}
+
+	if (mnt_optstr_remove_option(&fs_opts, DEVICE_TIMEOUT_OPTS) < 0 ) {
+		fprintf(stderr, "ERROR: not enough memory\n");
+		ret = 4;
+		goto exit;
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
+exit:
+	free(vfs_opts);
+	free(fs_opts);
+	free(user_opts);
+	return ret;
+
+}
+
+/* this function update the mtab file (if needed )*/
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
+
+	if (!(update = mnt_new_update()))
+		goto memoryerror;
+
+	rc = mnt_update_set_fs(update, 0, NULL, fs);
+
+	if (rc == 1) {
+		/* FIXME: check the reason that rc is always 1 */
+		/*fprintf(stderr, "WARNING: update of mtab not needed\n");*/
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
+	size_t size;
+	int try_degraded = 0;
+	char *value;
+	int explicit_devices=0;
+	int timeout=DEVICE_TIMEOUT;
+
+	ret = parse_args(argc, argv, &fs_opts, &spec, &dir, &flags);
+
+	if (ret)
+		goto incorrect_invocation;
+
+	if (!mnt_optstr_get_option(fs_opts, DEGRADED_OPTS,&value, &size))
+		try_degraded = 1;
+
+	if (!mnt_optstr_get_option(fs_opts, "device", &value, &size))
+		explicit_devices = 1;
+
+	if (!mnt_optstr_get_option(fs_opts, DEVICE_TIMEOUT_OPTS, &value,
+		&size)) {
+		if (sscanf(value, "%d", &timeout) != 1 || timeout < 1) {
+			fprintf(stderr, "ERROR: error parsing '"
+				DEVICE_TIMEOUT_OPTS
+				"' option\n");
+			goto incorrect_invocation;
+		}
+	}
+
+	if (flags & MOUNT_FLAG_VERBOSE)
+		printf("INFO: scan the first device\n");
+	/*
+	 * get_devices_info returns the "spec" device
+	 */
+	ret = get_device_info(spec, &devices);
+	if (ret>0)
+		goto mountfailure;
+	if (ret<0)
+		goto internalerror;
+
+	if (flags & MOUNT_FLAG_VERBOSE)
+		printf("INFO: find filesystem '%s' [%s]\n",
+			devices->fs_name, devices->fs_uuid);
+
+	assert(devices != NULL);
+
+	if (!explicit_devices && devices->num_devices>1) {
+		/*
+		 * get_devices_list() must returns at least the "spec" device
+		 */
+		ret = get_devices_list(flags, devices, timeout);
+		if (ret<0)
+			goto mountfailure;
+		assert(devices != NULL);
+	}
+
+	ret = rearrange_options(flags, &fs_opts, &mount_flags,
+		&all_options, NULL);
+	if (ret)
+		goto internalerror;
+
+	if (flags & MOUNT_FLAG_VERBOSE) {
+		char *vfs_opts=NULL;
+		struct btrfs_device *p;
+		printf("INFO: source: %s\n",  devices->device_name);
+		printf("INFO: target: %s\n",  dir);
+		mnt_optstr_apply_flags(&vfs_opts, mount_flags,
+			mnt_get_builtin_optmap(MNT_LINUX_MAP));
+		printf("INFO: vfs_opts: 0x%08lx - %s\n",
+		       mount_flags, vfs_opts);
+		printf("INFO: fs_opts: %s\n", fs_opts);
+		free(vfs_opts);
+
+		for (p = devices ; p ; p = p-> next )
+			printf("INFO:    dev='%s' UUID='%s' gen=%llu\n",
+				p->device_name,
+				p->device_uuid,
+				p->generation);
+	}
+
+	if (flags & MOUNT_FLAG_FAKE_MOUNT) {
+		printf("INFO: FAKE mount\n");
+		exit(0);
+	}
+
+	if (!explicit_devices) {
+		/*
+		 * check the number of devices
+		 */
+		unsigned long long c = 0;
+		struct btrfs_device *dev;
+		for (dev = devices ; dev ; dev = dev->next)
+			c++;
+		if (c != devices->num_devices) {
+			if (try_degraded) {
+				fprintf(stderr, "WARNING: "
+					"required %llu disks, only %llu found\n"
+					"WARNING: mount in degraded mode\n",
+					devices->num_devices, c);
+			} else {
+				fprintf(stderr, "ERROR: "
+					"required %llu disks, only %llu found\n",
+					devices->num_devices, c);
+
+				goto mountfailure;
+			}
+		}
+
+		for (dev = devices->next ; dev ; dev = dev->next)
+			if (dev->generation != devices->generation) {
+				fprintf(stderr, "WARNING: generation numbers mismatch.\n");
+				break;
+			}
+	}
+
+	ret = mount(devices->device_name, dir, "btrfs", mount_flags,
+		fs_opts);
+	if (ret) {
+		int e = errno;
+		fprintf(stderr, "ERROR: mount failed : %d - %s\n",
+			e, strerror(e));
+		goto mountfailure;
+	}
+	if (!(flags & MOUNT_FLAG_NOT_WRITIING_MTAB)) {
+		ret = update_mtab(flags, devices->device_name, dir,
+			all_options);
+		/* update_mtab error messages alredy printed */
+		if (ret)
+			goto errormtab;
+	}
+
+	if (flags & MOUNT_FLAG_VERBOSE)
+		printf("INFO: mount succeded\n");
+
+	exit(0);
+
+mountfailure:
+	exit(32);
+
+errormtab:
+	exit(16);
+
+internalerror:
+	exit(2);
+incorrect_invocation:
+	exit(1);
+
+}
diff --git a/btrfs-mount.h b/btrfs-mount.h
new file mode 100644
index 0000000..cf27570
--- /dev/null
+++ b/btrfs-mount.h
@@ -0,0 +1,47 @@
+
+#define MOUNT_FLAG_FAKE_MOUNT		1
+#define MOUNT_FLAG_VERBOSE		2
+#define MOUNT_FLAG_NOT_WRITIING_MTAB	4
+#define MOUNT_FLAG_IGNORE_SLOPPY_OPTS	8
+
+
+/* seconds to wait for devices */
+#define DEVICE_TIMEOUT		10
+#define DEVICE_TIMEOUT_OPTS	"device_timeout"
+
+#define DEGRADED_OPTS	"degraded"
+
+struct btrfs_device {
+	char			*device_name;
+	char			*device_uuid;
+	char 			*fs_name;
+	char			*fs_uuid;
+	long long unsigned	num_devices;
+	struct btrfs_device	*next;
+	unsigned long long	generation;
+};
+
+/* free a btrfs devices(s) list */
+void free_btrfs_devices_list(struct btrfs_device **p);
+
+/* load devices info */
+int get_devices_list(int flag, struct btrfs_device *devices, int timeout);
+/* load device info */
+int get_device_info(char *spec, struct btrfs_device **device);
+
+#define DEBUG 1
+
+#ifdef DEBUG
+
+  #define DPRINTF(x...) \
+	do { fprintf(stderr,"DPRINTF: %s()@%s,%d: ", __FUNCTION__, \
+		__FILE__, __LINE__); \
+		fprintf(stderr, x); \
+	}while(0)
+
+#else
+
+  #define DPRINTF(x...)
+
+#endif
+

-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
