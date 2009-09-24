From: Edward Shishkin <edward@redhat.com>
Subject: [patch 2/2] grub-0.97: btrfs multidevice configuration support
Date: Fri, 25 Sep 2009 00:06:40 +0200
Message-ID: <4ABBED70.30106@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------000002010703000601060405"
To: The development of BTRFS <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

This is a multi-part message in MIME format.
--------------000002010703000601060405
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit



--------------000002010703000601060405
Content-Type: text/plain;
 name="grub-btrfs-multidev.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="grub-btrfs-multidev.patch"

Signed-off-by: Edward Shishkin <edward@redhat.com>

---
 grub/Makefile.am    |    2 
 stage2/btrfs.h      |   55 ++--
 stage2/builtins.c   |   10 
 stage2/disk_io.c    |    2 
 stage2/filesys.h    |    4 
 stage2/fsys_btrfs.c |  693 +++++++++++++++++++++++++++++++++++++++++-----------
 6 files changed, 595 insertions(+), 171 deletions(-)

--- grub-0.97.orig/stage2/btrfs.h
+++ grub-0.97/stage2/btrfs.h
@@ -124,6 +124,7 @@ static int btrfs_csum_sizes[] = { 4, 0 }
 #define BTRFS_DEFAULT_NUM_DEVICES     1
 #define BTRFS_DEFAULT_NODE_SIZE       4096
 #define BTRFS_DEFAULT_LEAF_SIZE       4096
+#define BTRFS_NUM_CACHED_DEVICES      128
 
 #define WARN_ON(c)
 #define cassert(cond) ({ switch (-1) { case (cond): case 0: break; } })
@@ -315,13 +316,22 @@ struct btrfs_node {
 	struct btrfs_key_ptr ptrs[];
 } __attribute__ ((__packed__));
 
+struct btrfs_device {
+	/* the internal btrfs device id */
+	u64 devid;
+	/* the internal grub device representation */
+	unsigned long drive;
+	unsigned long part;
+	unsigned long length;
+};
+
 struct extent_buffer {
 	/* metadata */
+	struct btrfs_device dev;
 	u64 start;
 	u64 dev_bytenr;
 	u32 len;
-	int refs;
-	int flags;
+	/* data */
 	char *data;
 };
 
@@ -555,12 +565,8 @@ struct btrfs_block_group_item {
 struct btrfs_root {
 	struct extent_buffer   node;
 	char                   data[4096];
-	struct extent_buffer   *commit_root;
 	struct btrfs_root_item root_item;
-	struct btrfs_key       root_key;
-	struct btrfs_fs_info   *fs_info;
 	u64 objectid;
-	u64 last_trans;
 
 	/* data allocations are done in sectorsize units */
 	u32 sectorsize;
@@ -573,42 +579,31 @@ struct btrfs_root {
 
 	/* leaf allocations are done in leafsize units */
 	u32 stripesize;
+};
 
-	int ref_cows;
-	int track_dirty;
-
-
-	u32 type;
-	u64 highest_inode;
-	u64 last_inode_alloc;
+struct btrfs_file_info {
+	struct btrfs_key key;
 };
 
 struct btrfs_root;
 struct btrfs_fs_devices;
 struct btrfs_fs_info {
 	u8 fsid[BTRFS_FSID_SIZE];
-	u8 chunk_tree_uuid[BTRFS_UUID_SIZE];
 	struct btrfs_root fs_root;
 	struct btrfs_root tree_root;
 	struct btrfs_root chunk_root;
 
-	struct btrfs_key  file_info; /* currently opened file */
+	struct btrfs_file_info file_info; /* currently opened file */
 	struct btrfs_path paths [LAST_LOOKUP_POOL];
 
-	u64 generation;
-	u64 last_trans_committed;
+	char mbr[SECTOR_SIZE];
 
-	u64 system_alloc_profile;
-	u64 alloc_start;
+	int sb_mirror;
+	u64 sb_transid;
+	struct btrfs_device sb_dev;
+   	struct btrfs_super_block sb_copy;
 
-	struct btrfs_super_block super_temp;
-   	struct btrfs_super_block super_copy;
-
-	u64 super_bytenr;
-	u64 total_pinned;
-
-	int system_allocs;
-	int readonly;
+	struct btrfs_device devices[BTRFS_NUM_CACHED_DEVICES + 1];
 };
 
 /*
@@ -1129,6 +1124,11 @@ static inline void btrfs_set_key_type(st
 	key->type = val;
 }
 
+static inline u64 btrfs_super_devid(struct btrfs_super_block *disk_super)
+{
+	return le64_to_cpu(disk_super->dev_item.devid);
+}
+
 /* struct btrfs_header */
 BTRFS_SETGET_HEADER_FUNCS(header_bytenr, struct btrfs_header, bytenr, 64);
 BTRFS_SETGET_HEADER_FUNCS(header_generation, struct btrfs_header,
@@ -1317,6 +1317,7 @@ struct btrfs_fs_devices {
 };
 
 struct btrfs_bio_stripe {
+	struct btrfs_device dev;
 	u64 physical;
 };
 
--- grub-0.97.orig/stage2/fsys_btrfs.c
+++ grub-0.97/stage2/fsys_btrfs.c
@@ -31,15 +31,21 @@
 #define BTRFS_FS_INFO							\
 	((struct btrfs_fs_info *)((unsigned long)FSYS_BUF +		\
 				  LOOKUP_CACHE_SIZE))
-#define BTRFS_CACHE_SIZE        (sizeof(struct btrfs_fs_info) +	\
-				 LOOKUP_CACHE_SIZE)
-#define BTRFS_FILE_INFO         (&BTRFS_FS_INFO->file_info)
-#define BTRFS_TREE_ROOT         (&BTRFS_FS_INFO->tree_root)
-#define BTRFS_CHUNK_ROOT        (&BTRFS_FS_INFO->chunk_root)
-#define BTRFS_FS_ROOT           (&BTRFS_FS_INFO->fs_root)
-#define BTRFS_SUPER             (&BTRFS_FS_INFO->super_copy)
-#define LOOKUP_CACHE_BUF(id)	((char *)((unsigned long)FSYS_BUF +	\
-					  id * LOOKUP_CACHE_BUF_SIZE))
+#define BTRFS_CACHE_SIZE         (sizeof(struct btrfs_fs_info) +	\
+				  LOOKUP_CACHE_SIZE)
+#define BTRFS_TREE_ROOT          (&BTRFS_FS_INFO->tree_root)
+#define BTRFS_CHUNK_ROOT         (&BTRFS_FS_INFO->chunk_root)
+#define BTRFS_FS_ROOT            (&BTRFS_FS_INFO->fs_root)
+#define BTRFS_SUPER              (&BTRFS_FS_INFO->sb_copy)
+#define BTRFS_DEVICES            (&BTRFS_FS_INFO->devices[0])
+#define BTRFS_FILE_INFO          (&BTRFS_FS_INFO->file_info)
+#define BTRFS_FILE_INFO_KEY      (&BTRFS_FILE_INFO->key)
+
+#define BTRFS_VOLATILE_DEV_CACHE				        \
+	(&BTRFS_FS_INFO->devices[BTRFS_NUM_CACHED_DEVICES])
+
+#define LOOKUP_CACHE_BUF(id) ((char *)((unsigned long)FSYS_BUF +	\
+				       id * LOOKUP_CACHE_BUF_SIZE))
 
 #define noop   do {; } while (0)
 
@@ -76,13 +82,19 @@ static inline struct btrfs_path *btrfs_g
 	return &BTRFS_FS_INFO->paths[lpid];
 }
 
-static inline void btrfs_update_file_info(struct btrfs_path *path)
+static inline void btrfs_set_path_key(struct btrfs_path *path,
+				      struct btrfs_key *key)
 {
 	btrfs_item_key_to_cpu(&path->nodes[0],
-			      BTRFS_FILE_INFO,
+			      key,
 			      path->slots[0]);
 }
 
+static inline void btrfs_update_file_info(struct btrfs_path *path)
+{
+	btrfs_set_path_key(path, BTRFS_FILE_INFO_KEY);
+}
+
 static inline void btrfs_set_root_dir_key(struct btrfs_key *key)
 {
 	key->objectid = BTRFS_FIRST_FREE_OBJECTID;
@@ -120,14 +132,13 @@ static inline void init_btrfs_path(looku
 static inline void init_btrfs_info(void)
 {
 	int i;
-	struct btrfs_fs_info *fs = BTRFS_FS_INFO;
 
-	memset(fs, 0, sizeof (*fs));
+	memset(BTRFS_FS_INFO, 0, sizeof(struct btrfs_fs_info));
 	for(i = 0; i < LAST_LOOKUP_POOL; i++)
 		init_btrfs_path(i);
-	init_btrfs_root(&fs->tree_root);
-	init_btrfs_root(&fs->chunk_root);
-	init_btrfs_root(&fs->fs_root);
+	init_btrfs_root(BTRFS_TREE_ROOT);
+	init_btrfs_root(BTRFS_CHUNK_ROOT);
+	init_btrfs_root(BTRFS_FS_ROOT);
 }
 
 static void setup_root(struct btrfs_root *root,
@@ -137,7 +148,6 @@ static void setup_root(struct btrfs_root
 		       u32 stripesize,
 		       u64 objectid)
 {
-	root->fs_info = BTRFS_FS_INFO;
 	root->nodesize = nodesize;
 	root->leafsize = leafsize;
 	root->sectorsize = sectorsize;
@@ -152,7 +162,6 @@ static void setup_root(struct btrfs_root
 static int btrfs_find_last_root(struct btrfs_root *tree_root,
 				u64 objectid,
 				struct btrfs_root_item *item,
-				struct btrfs_key *key,
 				lookup_pool_id lpid)
 {
 	int ret;
@@ -175,10 +184,10 @@ static int btrfs_find_last_root(struct b
 	btrfs_item_key_to_cpu(&path->nodes[0], &found_key, slot);
 	if (found_key.objectid != objectid)
 		return 1;
+
 	read_extent_buffer(&path->nodes[0], item,
 			   btrfs_item_ptr_offset(&path->nodes[0], slot),
 			   sizeof(*item));
-	memcpy(key, &found_key, sizeof(found_key));
 	return 0;
 }
 
@@ -210,14 +219,13 @@ static int find_setup_root(struct btrfs_
 		 */
 		ret = btrfs_find_last_root(tree_root, objectid,
 					   &dest_root->root_item,
-					   &dest_root->root_key,
 					   lpid);
 		if (ret)
 			return ret;
 		bytenr = btrfs_root_bytenr(&dest_root->root_item);
 		blocksize = btrfs_level_size(dest_root,
 				       btrfs_root_level(&dest_root->root_item));
-		generation = btrfs_root_generation(&tree_root->root_item);
+		generation = btrfs_root_generation(&dest_root->root_item);
 	}
 	ret = read_tree_block(dest_root,
 			      &eb,
@@ -243,12 +251,34 @@ static inline int btrfs_strncmp(const ch
 	return __res;
 }
 
-static int btrfs_check_super_block(struct btrfs_super_block *sb)
-{
-	if (sb->num_devices != BTRFS_DEFAULT_NUM_DEVICES) {
-		btrfs_msg("Btrfs multi-device configuration unsupported\n");
-		goto error;
+/*
+ * the same as devread, but accepts
+ * device number, start and length.
+ */
+static int btrfs_devread(unsigned long drive, unsigned long part,
+			 unsigned long dev_len, int sector,
+			 int byte_offset, int byte_len, char *buf)
+{
+	if (sector < 0
+	    || ((sector + ((byte_offset + byte_len - 1) >> SECTOR_BITS))
+		>= dev_len)) {
+		errnum = ERR_OUTSIDE_PART;
+		return 0;
 	}
+	sector += byte_offset >> SECTOR_BITS;
+	byte_offset &= SECTOR_SIZE - 1;
+#if !defined(STAGE1_5)
+	if (disk_read_hook && debug)
+		printf ("<%d, %d, %d>", sector, byte_offset, byte_len);
+#endif /* !STAGE1_5 */
+	return rawread(drive, part + sector, byte_offset,
+		       byte_len, buf);
+}
+
+static int btrfs_check_super(void)
+{
+	struct btrfs_super_block *sb = BTRFS_SUPER;
+
 	if (sb->nodesize != BTRFS_DEFAULT_NODE_SIZE) {
 		btrfs_msg("Btrfs node size (%d) != %d unsupported\n",
 			  sb->nodesize, BTRFS_DEFAULT_NODE_SIZE);
@@ -259,103 +289,412 @@ static int btrfs_check_super_block(struc
 			  sb->leafsize, BTRFS_DEFAULT_LEAF_SIZE);
 		goto error;
 	}
-	return 1;
- error:
-	errnum = ERR_FSYS_MOUNT;
 	return 0;
+ error:
+	return 1;
 }
 
-int btrfs_mount(void)
+/* lift the super block */
+static int btrfs_uptodate_super_copy(struct btrfs_fs_info *fs)
 {
-	int i;
-	int ret;
-	u64 transid = 0;
-	u64 bytenr;
-
-	struct btrfs_fs_info *fs = BTRFS_FS_INFO;
-	struct btrfs_super_block *sb_tmp; /* current */
-	struct btrfs_super_block *sb;     /* latest */
-
-	struct btrfs_root *tree_root = &fs->tree_root;
-	struct btrfs_root *chunk_root = &fs->chunk_root;
-	struct btrfs_root *fs_root = &fs->fs_root;
-
-	check_btrfs_cache_size();
-	init_btrfs_info();
+	errnum = ERR_NONE;
+	btrfs_devread(BTRFS_FS_INFO->sb_dev.drive,
+		      BTRFS_FS_INFO->sb_dev.part,
+		      BTRFS_FS_INFO->sb_dev.length,
+		      btrfs_sb_offset(BTRFS_FS_INFO->sb_mirror) >> SECTOR_BITS,
+		      0,
+		      sizeof(struct btrfs_super_block),
+		      (char *)BTRFS_SUPER);
+	return btrfs_check_super();
+}
 
-	sb_tmp = &fs->super_temp;
-	sb = &fs->super_copy;
+/*
+ * Looking for a btrfs super block by magic, @fsid and @devid
+ * (the last two ones are optional). Update latest transid (if
+ * any). Return 0, if such super block was found. Otherwise,
+ * return 1.
+ *
+ * NOTE:
+ * After calling this function the sb_copy of global btrfs_fs_info
+ * can contain garbage, so the caller is responsible for this to be
+ * uptodate (see the function btrfs_uptodate_super_copy()).
+ */
+static int btrfs_find_super(struct btrfs_device *dev, char *fsid, u64 *devid)
+{
+	int i, ret;
+	int found = 0;
 
-	/* pick up the latest version of superblock */
 	for (i = 0; i < BTRFS_SUPER_MIRROR_MAX; i++) {
-		bytenr = btrfs_sb_offset(i);
-		ret = devread(bytenr >> SECTOR_BITS,
-			      0,
-			      sizeof(*sb_tmp),
-			      (char *)sb_tmp);
-		if (!ret)
-		        continue;
-
-		if (btrfs_super_bytenr(sb_tmp) != bytenr ||
-		    btrfs_strncmp((char *)(&sb_tmp->magic),
+		ret = btrfs_devread(dev->drive,
+				    dev->part,
+				    dev->length,
+				    btrfs_sb_offset(i) >> SECTOR_BITS,
+				    0,
+				    sizeof(struct btrfs_super_block),
+				    (char *)BTRFS_SUPER);
+		if (!ret) {
+			if (errnum == ERR_OUTSIDE_PART) {
+				errnum = ERR_NONE;
+				break;
+			} else {
+				errnum = ERR_NONE;
+				continue;
+			}
+		}
+		if (btrfs_super_bytenr(BTRFS_SUPER) != btrfs_sb_offset(i) ||
+		    btrfs_strncmp((char *)(&BTRFS_SUPER->magic),
 				  BTRFS_MAGIC,
-				  sizeof(sb_tmp->magic)))
+				  sizeof(BTRFS_SUPER->magic)))
 			continue;
-		if (btrfs_super_generation(sb_tmp) > transid) {
-			memcpy(sb, sb_tmp, sizeof(*sb_tmp));
-			transid = btrfs_super_generation(sb);
+		if (fsid &&
+		    btrfs_strncmp(fsid,
+				  (char *)BTRFS_SUPER->fsid,
+				  BTRFS_FSID_SIZE))
+			return 1;
+		if (devid &&
+		    *devid != btrfs_super_devid(BTRFS_SUPER))
+			return 1;
+		found = 1;
+		dev->devid = btrfs_super_devid(BTRFS_SUPER);
+
+		if (btrfs_super_generation(BTRFS_SUPER) >
+		    BTRFS_FS_INFO->sb_transid) {
+			BTRFS_FS_INFO->sb_transid =
+				btrfs_super_generation(BTRFS_SUPER);
+			BTRFS_FS_INFO->sb_mirror = i;
+			BTRFS_FS_INFO->sb_dev.devid =
+				btrfs_super_devid(BTRFS_SUPER);
+			BTRFS_FS_INFO->sb_dev.drive = dev->drive;
+			BTRFS_FS_INFO->sb_dev.part = dev->part;
+			BTRFS_FS_INFO->sb_dev.length = dev->length;
+		}
+	}
+	return !found;
+}
+
+/*
+ * "Discern" a btrfs device by fsid and
+ * optionaly by devid (if lookup is set).
+ * Populate persistent device cache (if
+ * there are free slots).
+ */
+static int btrfs_discerner(struct btrfs_device **dev, int lookup)
+{
+	if (btrfs_find_super(*dev,
+			     (char *)BTRFS_FS_INFO->fsid,
+			     (lookup ? &(*dev)->devid : 0)))
+		/* not found */
+		return 0;
+	if (*dev < BTRFS_VOLATILE_DEV_CACHE) {
+		/* populate persistent device cache */
+		memcpy(*dev + 1, *dev, sizeof(struct btrfs_device));
+		(*dev)++;
+	}
+	return 1;
+}
+
+/*
+ * Scan available grub devices and call discerner
+ * for them. Return a number of discerned devices
+ * The scanner was stolen from print_completions().
+ *
+ * Preconditions:
+ * The global structure btrfs_fs_info contains
+ * the latest valid version of btrfs superblock
+ * (the field @sb_copy)
+ */
+static u64 scan_grub_devices(struct btrfs_device *dev,
+			     int (*discerner)(struct btrfs_device **, int),
+			     int lookup)
+{
+	int i, j;
+	u64 count = 0;
+	struct geometry geom;
+
+	for (i = 0; i < 2; i++)
+		for (j = 0; j < 8; j++) {
+			unsigned long part = 0xFFFFFF;
+			int type, entry, gpt_count, gpt_size;
+			unsigned long offset, ext_offset, gpt_offset;
+
+			dev->drive = (i * 0x80) + j;
+			if (get_diskinfo(dev->drive, &geom))
+				continue;
+			while (1) {
+				int ret;
+				buf_drive = -1;
+				errnum = ERR_NONE;
+				ret = next_partition(dev->drive, 0xFFFFFF,
+						     &part, &type, &dev->part,
+						     &dev->length, &offset,
+						     &entry, &ext_offset,
+						     &gpt_offset, &gpt_count,
+						     &gpt_size,
+						     BTRFS_FS_INFO->mbr);
+				if (!ret)
+					break;
+				if (discerner(&dev, lookup)) {
+					count++;
+					if (lookup)
+						goto exit;
+				}
+			}
+		}
+	errnum = ERR_NONE;
+	if (cdrom_drive != GRUB_INVALID_DRIVE &&
+	    !get_diskinfo(cdrom_drive, &geom)) {
+		dev->drive = cdrom_drive;
+		dev->part = 0;
+		dev->length = geom.total_sectors;
+		if (discerner(&dev, lookup)) {
+			count++;
+			if (lookup)
+				goto exit;
+		}
+	}
+#ifdef SUPPORT_NETBOOT
+	errnum = ERR_NONE;
+	if (network_ready &&
+	    !get_diskinfo(NETWORK_DRIVE, &geom)) {
+		dev->drive = NETWORK_DRIVE;
+		dev->part = 0;
+		dev->length = geom.total_sectors;
+		if (discerner(&dev, lookup)) {
+			count++;
+			if (lookup)
+				goto exit;
+		}
+	}
+#endif /* SUPPORT_NETBOOT */
+ exit:
+	return count;
+}
+
+#if 0
+static int btrfs_next_item(struct btrfs_root *root,
+			   struct btrfs_path *path);
+
+/*
+ * Scan the chunk tree for dev items
+ * and call a seeker for all of them.
+ * Preconditions: chunk root is installed
+ * to the global btrfs_fs_info.
+ */
+static int scan_dev_tree(struct btrfs_device* (*seeker)(u64))
+{
+	int ret;
+	u64 num_devices = 0;
+	struct btrfs_key key;
+	struct btrfs_key found_key;
+	struct btrfs_path *path;
+	struct btrfs_root *root;
+
+	root = BTRFS_CHUNK_ROOT;
+	path = btrfs_grab_path(FIRST_EXTERNAL_LOOKUP_POOL);
+	key.objectid = BTRFS_DEV_ITEMS_OBJECTID;
+	key.type = 0;
+	key.offset = 0;
+
+	ret = aux_tree_lookup(root, &key, path);
+	if (ret == -1)
+		goto corrupted;
+	while (1) {
+		struct btrfs_device *result;
+		struct btrfs_dev_item *dev_item;
+
+		btrfs_item_key_to_cpu(&path->nodes[0],
+				      &found_key,
+				      path->slots[0]);
+		if (found_key.objectid != BTRFS_DEV_ITEMS_OBJECTID)
+			break;
+		dev_item = btrfs_item_ptr(&path->nodes[0],
+					  path->slots[0],
+					  struct btrfs_dev_item);
+		result = seeker(btrfs_device_id(&path->nodes[0], dev_item));
+		if (result == NULL) {
+			btrfs_msg("Btrfs device %llu is not available\n",
+				  btrfs_device_id(&path->nodes[0], dev_item));
+			goto missed_dev;
 		}
+		num_devices++;
+		ret = btrfs_next_item(root, path);
+		if (ret)
+			break;
 	}
-	/* there might be errors when reading super mirrors */
-	if (errnum == ERR_OUTSIDE_PART)
-		errnum = ERR_NONE;
-	if (transid <= 0) {
-		btrfs_msg("No valid Btrfs superblock found\n");
+	if (num_devices == btrfs_super_num_devices(BTRFS_SUPER))
+		return 0;
+ corrupted:
+	errnum = ERR_FSYS_CORRUPT;
+	return 1;
+ missed_dev:
+	errnum = ERR_FSYS_MOUNT;
+	return 1;
+}
+#endif /* 0 */
+
+/*
+ * Find a grub btrfs device by devid.
+ * Preconditions: global btrfs_fs_info
+ * contains a copy of btrfs super block.
+ *
+ * Return pointer to the cached device on success.
+ * Otherwise return NULL.
+ */
+static struct btrfs_device *btrfs_lookup_device(u64 devid)
+{
+	int i, result;
+	struct btrfs_device *cdev;
+
+	for (i = 0; i < BTRFS_NUM_CACHED_DEVICES; i++) {
+		cdev = &BTRFS_DEVICES[i];
+		if (cdev->devid == devid)
+			goto found_in_cache;
+		if (cdev->devid == 0)
+			goto not_found_in_cache;
+	}
+ not_found_in_cache:
+	cdev = BTRFS_VOLATILE_DEV_CACHE;
+	cdev->devid = devid;
+	result = scan_grub_devices(cdev,
+				   btrfs_discerner,
+				   1);
+	if (result == 0)
+		/*
+		 * At mount time we have figured out that
+		 * number of available devices is not less
+		 * then number of devices recorded in the
+		 * super block. Hence we treat this case as
+		 * file system corruption.
+		 */
+		goto corrupt;
+	result = btrfs_uptodate_super_copy(BTRFS_FS_INFO);
+	if (result)
+		goto corrupt;
+ found_in_cache:
+	return cdev;
+ corrupt:
+	errnum = ERR_FSYS_CORRUPT;
+	return NULL;
+}
+
+static int btrfs_find_device(struct btrfs_device *dev)
+{
+	struct btrfs_device *cdev;
+
+	if (btrfs_super_num_devices(BTRFS_SUPER) == 1) {
+		dev->drive = current_drive;
+		dev->part = part_start;
+		dev->length = part_length;
 		return 0;
 	}
-	if (!btrfs_check_super_block(sb))
+	cdev = btrfs_lookup_device(dev->devid);
+	if (cdev == NULL)
+		return 1;
+	dev->drive  = cdev->drive;
+	dev->part   = cdev->part;
+	dev->length = cdev->length;
+	return 0;
+}
+
+static inline void init_btrfs_volatile_dev_cache(void)
+{
+	BTRFS_VOLATILE_DEV_CACHE->devid = 0;
+	BTRFS_VOLATILE_DEV_CACHE->drive = current_drive;
+	BTRFS_VOLATILE_DEV_CACHE->part = part_start;
+	BTRFS_VOLATILE_DEV_CACHE->length = part_length;
+}
+
+/*
+ * check availability of btrfs devices
+ * and populate the persistent device cache
+ */
+static int btrfs_check_devices(void)
+{
+	u64 num_dev;
+
+	if (btrfs_super_num_devices(BTRFS_SUPER) == 1)
 		return 0;
+	num_dev = scan_grub_devices(BTRFS_DEVICES,
+				    btrfs_discerner, 0);
+	if (btrfs_uptodate_super_copy(BTRFS_FS_INFO))
+		return 1;
+	if (num_dev < btrfs_super_num_devices(BTRFS_SUPER)) {
+		btrfs_msg("Some (%llu) Btrfs devices is not available\n",
+			  btrfs_super_num_devices(BTRFS_SUPER) - num_dev);
+	        return 1;
+	}
+	return 0;
+}
+
+int btrfs_mount(void)
+{
+	int ret;
+
+	check_btrfs_cache_size();
+	init_btrfs_info();
+	init_btrfs_volatile_dev_cache();
+
+	ret = btrfs_find_super(BTRFS_VOLATILE_DEV_CACHE, NULL, NULL);
+	if (ret) {
+		btrfs_msg("Drive %lu, partition %lu: no Btrfs metadata\n",
+			  current_drive, part_start);
+		goto error;
+	}
+	ret = btrfs_uptodate_super_copy(BTRFS_FS_INFO);
+	if (ret)
+		goto error;
+	BTRFS_FS_INFO->sb_transid =
+		btrfs_super_generation(BTRFS_SUPER);
+	memcpy(BTRFS_FS_INFO->fsid,
+	       BTRFS_SUPER->fsid,
+	       BTRFS_FSID_SIZE);
+	ret = btrfs_check_devices();
+	if (ret)
+		goto error;
 	/* setup chunk root */
 	ret = find_setup_root(NULL,
-			      btrfs_super_nodesize(sb),
-			      btrfs_super_leafsize(sb),
-			      btrfs_super_sectorsize(sb),
-			      btrfs_super_stripesize(sb),
+			      btrfs_super_nodesize(BTRFS_SUPER),
+			      btrfs_super_leafsize(BTRFS_SUPER),
+			      btrfs_super_sectorsize(BTRFS_SUPER),
+			      btrfs_super_stripesize(BTRFS_SUPER),
 			      BTRFS_CHUNK_TREE_OBJECTID,
-			      chunk_root,
-			      btrfs_super_chunk_root(sb),
-			      btrfs_chunk_root_level_size(sb),
-			      btrfs_super_chunk_root_generation(sb),
+			      BTRFS_CHUNK_ROOT,
+			      btrfs_super_chunk_root(BTRFS_SUPER),
+			      btrfs_chunk_root_level_size(BTRFS_SUPER),
+			      btrfs_super_chunk_root_generation(BTRFS_SUPER),
 			      FIRST_EXTERNAL_LOOKUP_POOL);
 	if (ret)
 		return 0;
 	/* setup tree root */
 	ret = find_setup_root(NULL,
-			      btrfs_super_nodesize(sb),
-			      btrfs_super_leafsize(sb),
-			      btrfs_super_sectorsize(sb),
-			      btrfs_super_stripesize(sb),
+			      btrfs_super_nodesize(BTRFS_SUPER),
+			      btrfs_super_leafsize(BTRFS_SUPER),
+			      btrfs_super_sectorsize(BTRFS_SUPER),
+			      btrfs_super_stripesize(BTRFS_SUPER),
 			      BTRFS_ROOT_TREE_OBJECTID,
-			      tree_root,
-			      btrfs_super_root(sb),
-			      btrfs_root_level_size(sb),
-			      btrfs_super_generation(sb),
+			      BTRFS_TREE_ROOT,
+			      btrfs_super_root(BTRFS_SUPER),
+			      btrfs_root_level_size(BTRFS_SUPER),
+			      btrfs_super_generation(BTRFS_SUPER),
 			      FIRST_EXTERNAL_LOOKUP_POOL);
 	if (ret)
 		return 0;
 	/* setup fs_root */
-	ret = find_setup_root(tree_root,
-			      btrfs_super_nodesize(sb),
-			      btrfs_super_leafsize(sb),
-			      btrfs_super_sectorsize(sb),
-			      btrfs_super_stripesize(sb),
+	ret = find_setup_root(BTRFS_TREE_ROOT,
+			      btrfs_super_nodesize(BTRFS_SUPER),
+			      btrfs_super_leafsize(BTRFS_SUPER),
+			      btrfs_super_sectorsize(BTRFS_SUPER),
+			      btrfs_super_stripesize(BTRFS_SUPER),
 			      BTRFS_FS_TREE_OBJECTID,
-			      fs_root,
+			      BTRFS_FS_ROOT,
 			      0,
 			      0,
 			      0,
 			      FIRST_EXTERNAL_LOOKUP_POOL);
 	return !ret;
+ error:
+	errnum = ERR_FSYS_MOUNT;
+	return 0;
 }
 
 /*
@@ -371,7 +710,7 @@ int check_read_chunk(struct btrfs_key *k
 			    struct map_lookup *map,
 			    u64 logical)
 {
-	int i;
+	int i, ret;
 	u64 chunk_start;
 	u64 chunk_size;
 	int num_stripes;
@@ -397,20 +736,26 @@ int check_read_chunk(struct btrfs_key *k
 	for (i = 0; i < num_stripes; i++) {
 		map->stripes[i].physical =
 			btrfs_stripe_offset_nr(leaf, chunk, i);
+		map->stripes[i].dev.devid =
+			btrfs_stripe_devid_nr(leaf, chunk, i);
+		ret = btrfs_find_device(&map->stripes[i].dev);
+		if (ret)
+			return 0;
 	}
 	return 1;
 }
 
 static void init_extent_buffer(struct extent_buffer *eb,
+			       struct btrfs_device *dev,
 			       u64 logical,
 			       u32 blocksize,
 			       u64 physical,
 			       lookup_pool_id lpid)
 {
+	if (dev)
+		memcpy(&eb->dev, dev, sizeof(*dev));
 	eb->start = logical;
 	eb->len = blocksize;
-	eb->refs = 2;
-	eb->flags = 0;
 	eb->dev_bytenr = physical;
 	eb->data = grab_lookup_cache(lpid);
 }
@@ -516,8 +861,9 @@ static int chunk_tree_lookup(struct map_
  * Look for an appropriate map-extent and
  * perform a translation. Return 1 on errors.
  */
-int __btrfs_map_block(u64 logical, u64 *length, struct btrfs_multi_bio *multi,
-		      int mirror_num)
+static int btrfs_map_block(u64 logical, u64 *length,
+			   struct btrfs_multi_bio *multi,
+			   int mirror_num)
 {
 	struct map_lookup map;
 	u64 offset;
@@ -592,29 +938,57 @@ int __btrfs_map_block(u64 logical, u64 *
 		multi->stripes[i].physical =
 			map.stripes[stripe_index].physical + stripe_offset +
 			stripe_nr * map.stripe_len;
+		memcpy(&multi->stripes[i].dev,
+		       &map.stripes[stripe_index].dev,
+		       sizeof(struct btrfs_device));
 		stripe_index++;
 	}
 	return 0;
 }
 
-static u64 btrfs_map_block(u64 logical)
+static u64 read_data_extent(u64 logical_start, u64 to_read, char *pos)
 {
 	int ret;
 	u64 length;
 	struct btrfs_multi_bio multi;
 
-	ret = __btrfs_map_block(logical, &length, &multi, 0);
-	if (ret) {
-		errnum = ERR_FSYS_CORRUPT;
-		return 0;
+	while (to_read) {
+		ret = btrfs_map_block(logical_start, &length, &multi, 0);
+		if (ret) {
+			errnum = ERR_FSYS_CORRUPT;
+			return ret;
+		}
+		if (length > to_read)
+			length = to_read;
+		disk_read_func = disk_read_hook;
+		ret = btrfs_devread(multi.stripes[0].dev.drive,
+				    multi.stripes[0].dev.part,
+				    multi.stripes[0].dev.length,
+				    multi.stripes[0].physical >> SECTOR_BITS,
+				    logical_start & ((u64)SECTOR_SIZE - 1),
+				    length,
+				    pos);
+		disk_read_func = NULL;
+		if (!ret)
+			return 1;
+		btrfs_msg("BTRFS data extent: read %llu bytes\n", length);
+		to_read -= length;
+		pos += length;
+		logical_start += length;
 	}
-	return multi.stripes[0].physical;
+	return 0;
 }
 
 static int read_extent_from_disk(struct extent_buffer *eb)
 {
 	WARN_ON(eb->dev_bytenr % SECTOR_BITS);
-	return devread(eb->dev_bytenr >> SECTOR_BITS, 0, eb->len, eb->data);
+	return btrfs_devread(eb->dev.drive,
+			     eb->dev.part,
+			     eb->dev.length,
+			     eb->dev_bytenr >> SECTOR_BITS,
+			     0,
+			     eb->len,
+			     eb->data);
 }
 
 static int verify_parent_transid(struct extent_buffer *eb, u64 parent_transid)
@@ -660,13 +1034,14 @@ int read_tree_block(struct btrfs_root *r
 	dev_nr = 0;
 	length = blocksize;
 	while (1) {
-		ret = __btrfs_map_block(bytenr,
-					&length, &multi, mirror_num);
+		ret = btrfs_map_block(bytenr,
+				      &length, &multi, mirror_num);
 		if (ret) {
 			errnum = ERR_FSYS_CORRUPT;
 			return 0;
 		}
 		init_extent_buffer(eb,
+				   &multi.stripes[0].dev,
 				   bytenr,
 				   blocksize,
 				   multi.stripes[0].physical,
@@ -814,6 +1189,7 @@ int aux_tree_lookup(struct btrfs_root *r
 	int level;
 	struct extent_buffer node;
 	init_extent_buffer(&node,
+			   NULL,
 			   0,
 			   0,
 			   0,
@@ -939,13 +1315,18 @@ static int btrfs_next_item(struct btrfs_
  * search for read operation
  */
 static int path_is_valid(struct btrfs_path *path,
-			 struct btrfs_key *key)
+			 struct btrfs_key *key, u64 offset)
 {
 	btrfs_item_key_to_cpu(&path->nodes[0],
 			      key,
 			      path->slots[0]);
-	return (key->objectid == BTRFS_FILE_INFO->objectid) &&
-		(btrfs_key_type(key) == BTRFS_EXTENT_DATA_KEY);
+	if (BTRFS_FILE_INFO_KEY->objectid != key->objectid)
+		return 0;
+	if (btrfs_key_type(key) == BTRFS_INODE_ITEM_KEY)
+		return 1;
+	if (btrfs_key_type(key) != BTRFS_EXTENT_DATA_KEY)
+		return 0;
+	return BTRFS_FILE_INFO_KEY->offset <= offset;
 }
 
 /* ->read_func() */
@@ -954,31 +1335,35 @@ int btrfs_read(char *buf, int len)
 	int ret;
 	struct btrfs_root *fs_root;
 	struct btrfs_path *path;
-	struct btrfs_key *info_key;
 	struct btrfs_key  path_key;
-	u64 off;
+	u64 ioff;
 	u64 bytes;
-	unsigned int to_read;
+	int to_read;
 	char *pos = buf;
 
 	fs_root = BTRFS_FS_ROOT;
-	info_key = BTRFS_FILE_INFO;
 	path = btrfs_grab_path(FIRST_EXTERNAL_LOOKUP_POOL);
 
-	if (!path_is_valid(path, &path_key)) {
-		btrfs_set_key_type(info_key, BTRFS_EXTENT_DATA_KEY);
-		info_key->offset = filepos;
-		ret = aux_tree_lookup(fs_root, info_key, path);
+	if (!path_is_valid(path, &path_key, filepos)) {
+		ret = aux_tree_lookup(fs_root, BTRFS_FILE_INFO_KEY, path);
 		if (ret < 0)
 			errnum = ERR_FSYS_CORRUPT;
 	}
 	while (!errnum) {
 		struct btrfs_item *item;
 		struct btrfs_file_extent_item *fi;
-		unsigned int from;
+		u64 from;
 
-		if (!path_is_valid(path, &path_key))
+		btrfs_item_key_to_cpu(&path->nodes[0],
+				      &path_key,
+				      path->slots[0]);
+		if (BTRFS_FILE_INFO_KEY->objectid != path_key.objectid)
 			break;
+		if (btrfs_key_type(&path_key) != BTRFS_EXTENT_DATA_KEY)
+			goto next;
+		/*
+		 * current position is extent item
+		 */
 		item = btrfs_item_nr(&path->nodes[0], path->slots[0]);
 		fi = btrfs_item_ptr(&path->nodes[0],
 				    path->slots[0],
@@ -988,44 +1373,54 @@ int btrfs_read(char *buf, int len)
 		       errnum = ERR_BAD_FILETYPE;
 		       goto exit;
 		}
-		off = filepos - path_key.offset;
+		ioff = filepos - path_key.offset;
 
 		switch (btrfs_file_extent_type(&path->nodes[0], fi)) {
 		case BTRFS_FILE_EXTENT_INLINE:
 			bytes = btrfs_file_extent_inline_item_len(&path->
 								  nodes[0],
 								  item);
-			to_read = bytes - off;
+			if (path_key.offset + bytes < filepos)
+				goto next;
+			to_read = bytes - ioff;
 			if (to_read > len)
 				to_read = len;
-			from = off + btrfs_file_extent_inline_start(fi);
+			from = ioff + btrfs_file_extent_inline_start(fi);
 			if (disk_read_hook != NULL) {
 				disk_read_func = disk_read_hook;
-				ret = devread(path->nodes[0].dev_bytenr >>
-					      SECTOR_BITS, from, to_read, pos);
+				ret = btrfs_devread(path->nodes[0].dev.drive,
+						    path->nodes[0].dev.part,
+						    path->nodes[0].dev.length,
+						    path->nodes[0].dev_bytenr >>
+						    SECTOR_BITS,
+						    from,
+						    to_read,
+						    pos);
 				disk_read_func = NULL;
-			} else {
+				if (ret)
+					goto exit;
+			} else
 				memcpy(pos,
 				       path->nodes[0].data + from,
 				       to_read);
-			}
+			btrfs_msg("BTRFS inline extent: read %d bytes pos %d\n",
+				  to_read, filepos);
 			break;
 		case BTRFS_FILE_EXTENT_REG:
 			bytes = btrfs_file_extent_num_bytes(&path->nodes[0],
 							    fi);
-			to_read = bytes - off;
+			if (path_key.offset + bytes < filepos)
+				goto next;
+			to_read = bytes - ioff;
 			if (to_read > len)
 				to_read = len;
-			from = off +
+			from = ioff +
 				btrfs_file_extent_disk_bytenr(&path->nodes[0],
-							      fi);
-			disk_read_func = disk_read_hook;
-			ret = devread(btrfs_map_block(from) >> SECTOR_BITS,
-				      from & ((u64)SECTOR_SIZE - 1),
-				      to_read,
-				      pos);
-			disk_read_func = NULL;
-			if (!ret)
+							      fi) +
+				btrfs_file_extent_offset(&path->nodes[0],
+							 fi);
+			ret = read_data_extent(from, to_read, pos);
+			if (ret)
 				goto exit;
 			break;
 		case BTRFS_FILE_EXTENT_PREALLOC:
@@ -1042,12 +1437,14 @@ int btrfs_read(char *buf, int len)
 		if (len == 0)
 			break;
 		/* not everything was read */
+	next:
 		ret = btrfs_next_item(fs_root, path);
-		if (ret) {
-			/* something should be found */
+		if (ret < 0) {
 			errnum = ERR_FSYS_CORRUPT;
 			break;
 		}
+		btrfs_update_file_info(path);
+		continue;
 	}
  exit:
 	return errnum ? 0 : pos - buf;
@@ -1082,14 +1479,14 @@ static int btrfs_follow_link(struct btrf
 	filepos = 0;
 	/* extract symlink content */
 	while (1) {
-		u64 oid = BTRFS_FILE_INFO->objectid;
+		u64 oid = BTRFS_FILE_INFO_KEY->objectid;
 		ret = btrfs_next_item(root, path);
 		if (ret)
 			break;
 		btrfs_update_file_info(path);
-		if (oid != BTRFS_FILE_INFO->objectid)
+		if (oid != BTRFS_FILE_INFO_KEY->objectid)
 			break;
-		if (btrfs_key_type(BTRFS_FILE_INFO) ==
+		if (btrfs_key_type(BTRFS_FILE_INFO_KEY) ==
 		    BTRFS_EXTENT_DATA_KEY)
 			goto found;
 	}
@@ -1114,7 +1511,7 @@ static int update_fs_root(struct btrfs_r
 
 	if (location->offset != (u64)-1)
 		return 0;
-	tree_root = &fs_root->fs_info->tree_root;
+	tree_root = &BTRFS_FS_INFO->tree_root;
 	ret = find_setup_root(tree_root,
 			      tree_root->nodesize,
 			      tree_root->leafsize,
@@ -1388,6 +1785,22 @@ int btrfs_dir(char *dirname)
 	}
 }
 
+int btrfs_embed(int *start_sector, int needed_sectors)
+{
+	int ret;
+	init_btrfs_info();
+	init_btrfs_volatile_dev_cache();
+
+	ret = btrfs_find_super(BTRFS_VOLATILE_DEV_CACHE, NULL, NULL);
+	if (ret)
+		return 0;
+	ret = btrfs_uptodate_super_copy(BTRFS_FS_INFO);
+	if (ret)
+		return 0;
+	*start_sector = 1; /* reserve first sector for stage1 */
+	return needed_sectors <=
+		((BTRFS_SUPER_INFO_OFFSET >> SECTOR_BITS) - 1);
+}
 #endif /* FSYS_BTRFS */
 
 /*
--- grub-0.97.orig/stage2/filesys.h
+++ grub-0.97/stage2/filesys.h
@@ -137,8 +137,8 @@ int iso9660_dir (char *dirname);
 #ifndef NUM_FSYS
 #define NUM_FSYS	\
   (FSYS_FFS_NUM + FSYS_FAT_NUM + FSYS_EXT2FS_NUM + FSYS_MINIX_NUM	\
-   + FSYS_REISERFS_NUM + FSYS_VSTAFS_NUM + FSYS_JFS_NUM + FSYS_XFS_NUM	\
-   + FSYS_TFTP_NUM + FSYS_ISO9660_NUM + FSYS_UFS2_NUM)
+   + FSYS_REISERFS_NUM + FSYS_BTRFS_NUM + FSYS_VSTAFS_NUM + FSYS_JFS_NUM \
+   + FSYS_XFS_NUM + FSYS_TFTP_NUM + FSYS_ISO9660_NUM + FSYS_UFS2_NUM)
 #endif
 
 /* defines for the block filesystem info area */
--- grub-0.97.orig/grub/Makefile.am
+++ grub-0.97/grub/Makefile.am
@@ -8,7 +8,7 @@ endif
 
 AM_CPPFLAGS = -DGRUB_UTIL=1 -DFSYS_EXT2FS=1 -DFSYS_FAT=1 -DFSYS_FFS=1 \
 	-DFSYS_ISO9660=1 -DFSYS_JFS=1 -DFSYS_MINIX=1 -DFSYS_REISERFS=1 \
-	-DFSYS_UFS2=1 -DFSYS_VSTAFS=1 -DFSYS_XFS=1 \
+	-DFSYS_BTRFS=1 -DFSYS_UFS2=1 -DFSYS_VSTAFS=1 -DFSYS_XFS=1 \
 	-DUSE_MD5_PASSWORDS=1 -DSUPPORT_HERCULES=1 \
 	$(SERIAL_FLAGS) -I$(top_srcdir)/stage2 \
 	-I$(top_srcdir)/stage1 -I$(top_srcdir)/lib
--- grub-0.97.orig/stage2/disk_io.c
+++ grub-0.97/stage2/disk_io.c
@@ -65,7 +65,7 @@ struct fsys_entry fsys_table[NUM_FSYS + 
   {"reiserfs", reiserfs_mount, reiserfs_read, reiserfs_dir, 0, reiserfs_embed},
 # endif
 # ifdef FSYS_BTRFS
-  {"btrfs", btrfs_mount, btrfs_read, btrfs_dir, 0, 0},
+  {"btrfs", btrfs_mount, btrfs_read, btrfs_dir, 0, btrfs_embed},
 # endif
 # ifdef FSYS_VSTAFS
   {"vstafs", vstafs_mount, vstafs_read, vstafs_dir, 0, 0},
--- grub-0.97.orig/stage2/builtins.c
+++ grub-0.97/stage2/builtins.c
@@ -2423,6 +2423,16 @@ install_func (char *arg, int flags)
 	  else
 #endif /* GRUB_UTIL */
 	    {
+	      /*
+	       * FIXME: Ugly hack.
+	       * Do not write to btrfs partition
+	       * without a help of the file system!
+	       */
+	      if (!strcmp(fsys_table[fsys_type].name, "btrfs"))
+		{
+		  errnum = ERR_BAD_ARGUMENT;
+		  goto fail;
+		}
 	      if (! devwrite (*saved_sector - part_start, 1, stage2_buffer))
 		goto fail;
 	    }

--------------000002010703000601060405--
