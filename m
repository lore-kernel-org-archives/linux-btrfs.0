From: Donggeun Kim <dg77.kim@samsung.com>
Subject: [PATCH] btrfs-progs: Add new feature to mkfs.btrfs to make file system
 image file from source directory
Date: Tue, 06 Jul 2010 18:37:31 +0900
Message-ID: <4C32F95B.3070504@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: kyungmin.park@samsung.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi, 

To make a btrfs file system image including the desired files,
users should create a target image file with 'dd' command, format it with 'mkfs.btrfs', loop-mount it, copy the desired files into the mounted point, and finally unmount it.

By applying this patch, users do not need to execute the commands (e.g. dd, mount, cp, and umount) sequentially. 

The new feature can be tested by the following command.
#mkfs.btrfs -r <source directory>
The source directory is specified through an absolute path.
After executing 'mkfs.btrfs' program, the image file named 'output.img' is created.

The main sequences are as follows.
1. Calculate the file size of 'output.img' based on the sum of data size of all files in the specified source directory.
2. Fill 'output.img' file with zero up to the calculated file size in step 1.
3. Format the output file through the original function call flows (make_btrfs, make_root_dir, etc.) in mkfs.c file.
4. Allocate meta data chunks and a data chunk into the output file.
    The length of the all meta data chunks is equivalent to the half of the calculated data size in step 1.
    The length of the data chunk is equivalent to the calculated data size in step 1.
5. Traverse the source directory. 
    All meta data and data for each file in the source directory is inserted to the output file according to the file type.
    inode and directory entry items are commonly added in file system tree regardless of the file type (directory, regular file, and symbolic link).
    For a regular file, a file extent item is inserted to file system tree and an extent item is likely to be inserted to extent tree depending on the file size.
    If the extents are allocated for the file data, the file data is written to the location of the allocated extents.
    

Thanks.

Signed-off-by: Donggeun Kim <dg77.kim@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 mkfs.c    |  948 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
 volumes.c |   17 +-
 volumes.h |   19 ++
 3 files changed, 943 insertions(+), 41 deletions(-)

diff --git a/mkfs.c b/mkfs.c
index 2e99b95..fd04f49 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -29,6 +29,7 @@
 #include <stdlib.h>
 #include <sys/types.h>
 #include <sys/stat.h>
+#include <sys/dir.h>
 #include <fcntl.h>
 #include <unistd.h>
 #include <getopt.h>
@@ -43,6 +44,15 @@
 #include "utils.h"
 #include "version.h"
 
+static u64 index_cnt = 2;
+
+struct directory_name_entry {
+	char *dir_name;
+	char *path;
+	ino_t inum;
+	struct list_head list;
+};
+
 static u64 parse_size(char *s)
 {
 	int len = strlen(s);
@@ -276,6 +286,7 @@ static void print_usage(void)
 	fprintf(stderr, "\t -m --metadata metadata profile, values like data profile\n");
 	fprintf(stderr, "\t -n --nodesize size of btree nodes\n");
 	fprintf(stderr, "\t -s --sectorsize min block allocation\n");
+	fprintf(stderr, "\t -r --rootdir the source directory\n");
 	fprintf(stderr, "%s\n", BTRFS_BUILD_VERSION);
 	exit(1);
 }
@@ -332,9 +343,851 @@ static struct option long_options[] = {
 	{ "sectorsize", 1, NULL, 's' },
 	{ "data", 1, NULL, 'd' },
 	{ "version", 0, NULL, 'V' },
+	{ "rootdir", 1, NULL, 'r' },
 	{ 0, 0, 0, 0}
 };
 
+static int add_directory_items(struct btrfs_trans_handle *trans,
+			struct btrfs_root *root, u64 objectid,
+			ino_t parent_inum, const char *name,
+			u8 filetype, int *dir_index_cnt)
+{
+	int ret;
+	int name_len;
+	struct btrfs_key location;
+
+	name_len = strlen(name);
+
+	location.objectid = objectid;
+	location.offset = 0;
+	btrfs_set_key_type(&location, BTRFS_INODE_ITEM_KEY);
+
+	ret = btrfs_insert_dir_item(trans, root, name, name_len,
+				parent_inum, &location,
+				filetype, index_cnt);
+	if (ret)
+		return ret;
+	*dir_index_cnt = index_cnt;
+	index_cnt++;
+
+	return ret;
+}
+
+static int fill_inode_item(struct btrfs_trans_handle *trans,
+			struct btrfs_root *root,
+			struct btrfs_inode_item *dst, struct stat *src)
+{
+	u64 blocks = 0;
+	u64 sectorsize = root->sectorsize;
+
+	btrfs_set_stack_inode_generation(dst, trans->transid);
+	btrfs_set_stack_inode_size(dst, src->st_size);
+	btrfs_set_stack_inode_nbytes(dst, 0);
+	btrfs_set_stack_inode_block_group(dst, 0);
+	btrfs_set_stack_inode_nlink(dst, src->st_nlink);
+	btrfs_set_stack_inode_uid(dst, src->st_uid);
+	btrfs_set_stack_inode_gid(dst, src->st_gid);
+	btrfs_set_stack_inode_mode(dst, src->st_mode);
+	btrfs_set_stack_inode_rdev(dst, 0);
+	btrfs_set_stack_inode_flags(dst, 0);
+	btrfs_set_stack_timespec_sec(&dst->atime, src->st_atime);
+	btrfs_set_stack_timespec_nsec(&dst->atime, 0);
+	btrfs_set_stack_timespec_sec(&dst->ctime, src->st_ctime);
+	btrfs_set_stack_timespec_nsec(&dst->ctime, 0);
+	btrfs_set_stack_timespec_sec(&dst->mtime, src->st_mtime);
+	btrfs_set_stack_timespec_nsec(&dst->mtime, 0);
+	btrfs_set_stack_timespec_sec(&dst->otime, 0);
+	btrfs_set_stack_timespec_nsec(&dst->otime, 0);
+
+	if (S_ISDIR(src->st_mode)) {
+		btrfs_set_stack_inode_size(dst, 0);
+		btrfs_set_stack_inode_nlink(dst, 1);
+	}
+	if (S_ISREG(src->st_mode)) {
+		btrfs_set_stack_inode_size(dst, (u64)src->st_size);
+		if (src->st_size <= BTRFS_MAX_INLINE_DATA_SIZE(root))
+			btrfs_set_stack_inode_nbytes(dst, src->st_size);
+		else {
+			blocks = src->st_size / sectorsize;
+			if (src->st_size % sectorsize)
+				blocks += 1;
+			blocks *= sectorsize;
+			btrfs_set_stack_inode_nbytes(dst, blocks);
+		}
+	}
+	if (S_ISLNK(src->st_mode))
+		btrfs_set_stack_inode_nbytes(dst, src->st_size + 1);
+
+	return 0;
+}
+
+static int directory_select(const struct direct *entry)
+{
+	if ((strncmp(entry->d_name, ".", entry->d_reclen) == 0) ||
+		(strncmp(entry->d_name, "..", entry->d_reclen) == 0))
+		return 0;
+	else
+		return 1;
+}
+
+static u64 calculate_dir_inode_size(char *dirname)
+{
+	int count, i;
+	struct direct **files, *cur_file;
+	u64 dir_inode_size = 0;
+
+	count = scandir(dirname, &files, directory_select, NULL);
+
+	for (i = 0; i < count; i++) {
+		cur_file = files[i];
+		dir_inode_size += strlen(cur_file->d_name);
+	}
+
+	dir_inode_size *= 2;
+	return dir_inode_size;
+}
+
+static int add_inode_items(struct btrfs_trans_handle *trans,
+			struct btrfs_root *root,
+			struct stat *st, char *name,
+			u64 self_objectid, ino_t parent_inum,
+			int dir_index_cnt, struct btrfs_inode_item *inode_ret)
+{
+	int ret;
+	struct btrfs_key inode_key;
+	struct btrfs_inode_item btrfs_inode;
+	u64 objectid;
+	u64 inode_size = 0;
+	int name_len;
+
+	name_len = strlen(name);
+	fill_inode_item(trans, root, &btrfs_inode, st);
+	objectid = self_objectid;
+
+	if (S_ISDIR(st->st_mode)) {
+		inode_size = calculate_dir_inode_size(name);
+		btrfs_set_stack_inode_size(&btrfs_inode, inode_size);
+	}
+
+	inode_key.objectid = objectid;
+	inode_key.offset = 0;
+	btrfs_set_key_type(&inode_key, BTRFS_INODE_ITEM_KEY);
+
+	ret = btrfs_insert_inode(trans, root, objectid, &btrfs_inode);
+	if (ret)
+		goto fail;
+
+	ret = btrfs_insert_inode_ref(trans, root, name, name_len,
+				     objectid, parent_inum, dir_index_cnt);
+	if (ret)
+		goto fail;
+
+	*inode_ret = btrfs_inode;
+fail:
+	return ret;
+}
+
+static int custom_alloc_extent(struct btrfs_root *root, u64 num_bytes,
+			       u64 hint_byte, struct btrfs_key *ins)
+{
+	u64 start;
+	u64 end;
+	u64 last = hint_byte;
+	int ret;
+	int wrapped = 0;
+	struct btrfs_block_group_cache *cache;
+
+	while (1) {
+		ret = find_first_extent_bit(&root->fs_info->free_space_cache,
+					    last, &start, &end, EXTENT_DIRTY);
+		if (ret) {
+			if (wrapped++ == 0) {
+				last = 0;
+				continue;
+			} else {
+				goto fail;
+			}
+		}
+
+		start = max(last, start);
+		last = end + 1;
+		if (last - start < num_bytes)
+			continue;
+
+		last = start + num_bytes;
+		if (test_range_bit(&root->fs_info->pinned_extents,
+				   start, last - 1, EXTENT_DIRTY, 0))
+			continue;
+
+		cache = btrfs_lookup_block_group(root->fs_info, start);
+		BUG_ON(!cache);
+		if (cache->flags & BTRFS_BLOCK_GROUP_SYSTEM ||
+		    last > cache->key.objectid + cache->key.offset) {
+			last = cache->key.objectid + cache->key.offset;
+			continue;
+		}
+
+		if (cache->flags & (BTRFS_BLOCK_GROUP_SYSTEM |
+			    BTRFS_BLOCK_GROUP_METADATA)) {
+			last = cache->key.objectid + cache->key.offset;
+			continue;
+		}
+
+		clear_extent_dirty(&root->fs_info->free_space_cache,
+				   start, start + num_bytes - 1, 0);
+
+		ins->objectid = start;
+		ins->offset = num_bytes;
+		ins->type = BTRFS_EXTENT_ITEM_KEY;
+		return 0;
+	}
+fail:
+	fprintf(stderr, "not enough free space\n");
+	return -ENOSPC;
+}
+
+static int record_file_extent(struct btrfs_trans_handle *trans,
+			      struct btrfs_root *root, u64 objectid,
+			      struct btrfs_inode_item *inode,
+			      u64 file_pos, u64 disk_bytenr,
+			      u64 num_bytes)
+{
+	int ret;
+	struct btrfs_fs_info *info = root->fs_info;
+	struct btrfs_root *extent_root = info->extent_root;
+	struct extent_buffer *leaf;
+	struct btrfs_file_extent_item *fi;
+	struct btrfs_key ins_key;
+	struct btrfs_path path;
+	struct btrfs_extent_item *ei;
+
+	btrfs_init_path(&path);
+
+	ins_key.objectid = objectid;
+	ins_key.offset = 0;
+	btrfs_set_key_type(&ins_key, BTRFS_EXTENT_DATA_KEY);
+	ret = btrfs_insert_empty_item(trans, root, &path, &ins_key,
+				      sizeof(*fi));
+	if (ret)
+		goto fail;
+	leaf = path.nodes[0];
+	fi = btrfs_item_ptr(leaf, path.slots[0],
+			    struct btrfs_file_extent_item);
+	btrfs_set_file_extent_generation(leaf, fi, trans->transid);
+	btrfs_set_file_extent_type(leaf, fi, BTRFS_FILE_EXTENT_REG);
+	btrfs_set_file_extent_disk_bytenr(leaf, fi, disk_bytenr);
+	btrfs_set_file_extent_disk_num_bytes(leaf, fi, num_bytes);
+	btrfs_set_file_extent_offset(leaf, fi, 0);
+	btrfs_set_file_extent_num_bytes(leaf, fi, num_bytes);
+	btrfs_set_file_extent_ram_bytes(leaf, fi, num_bytes);
+	btrfs_set_file_extent_compression(leaf, fi, 0);
+	btrfs_set_file_extent_encryption(leaf, fi, 0);
+	btrfs_set_file_extent_other_encoding(leaf, fi, 0);
+	btrfs_mark_buffer_dirty(leaf);
+
+	btrfs_release_path(root, &path);
+
+	ins_key.objectid = disk_bytenr;
+	ins_key.offset = num_bytes;
+	ins_key.type = BTRFS_EXTENT_ITEM_KEY;
+
+	ret = btrfs_insert_empty_item(trans, extent_root, &path,
+				&ins_key, sizeof(*ei));
+	if (ret == 0) {
+		leaf = path.nodes[0];
+		ei = btrfs_item_ptr(leaf, path.slots[0],
+				    struct btrfs_extent_item);
+
+		btrfs_set_extent_refs(leaf, ei, 0);
+		btrfs_set_extent_generation(leaf, ei, trans->transid);
+		btrfs_set_extent_flags(leaf, ei, BTRFS_EXTENT_FLAG_DATA);
+
+		btrfs_mark_buffer_dirty(leaf);
+		ret = btrfs_update_block_group(trans, root, disk_bytenr,
+					       num_bytes, 1, 0);
+		if (ret)
+			goto fail;
+	} else if (ret != -EEXIST) {
+		goto fail;
+	}
+
+	ret = btrfs_inc_extent_ref(trans, root, disk_bytenr, num_bytes, 0,
+				   root->root_key.objectid,
+				   objectid, 0);
+fail:
+	btrfs_release_path(root, &path);
+	return ret;
+}
+
+static int add_symbolic_link(struct btrfs_trans_handle *trans,
+			struct btrfs_root *root,
+			u64 objectid, const char *path_name)
+{
+	int ret;
+	u64 sectorsize = root->sectorsize;
+	char *buf = malloc(sectorsize);
+
+	/* Take the symlink as is */
+	ret = readlink(path_name, buf, sectorsize);
+	if (ret <= 0) {
+		fprintf(stderr, "readlink failed for %s\n", path_name);
+		goto fail;
+	}
+	if (ret > sectorsize) {
+		fprintf(stderr, "symlink too long for %s", path_name);
+		ret = -1;
+		goto fail;
+	}
+	ret = btrfs_insert_inline_extent(trans, root, objectid, 0,
+					 buf, ret + 1);
+fail:
+	free(buf);
+	return ret;
+}
+
+static int add_file_items(struct btrfs_trans_handle *trans,
+			struct btrfs_root *root,
+			struct btrfs_inode_item *btrfs_inode, u64 objectid,
+			ino_t parent_inum, struct stat *st,
+			const char *path_name, int out_fd)
+{
+	int ret;
+	ssize_t ret_read;
+	u64 bytes_read = 0;
+	char *buffer = NULL;
+	struct btrfs_key key;
+	int blocks;
+	u32 sectorsize = root->sectorsize;
+	u64 first_block = 0;
+	u64 num_blocks = 0;
+	int fd;
+
+	fd = open(path_name, O_RDONLY);
+	if (fd == -1) {
+		fprintf(stderr, "%s open failed\n", path_name);
+		goto end;
+	}
+
+	blocks = st->st_size / sectorsize;
+	if (st->st_size % sectorsize)
+		blocks += 1;
+
+	if (st->st_size <= BTRFS_MAX_INLINE_DATA_SIZE(root)) {
+		buffer = malloc(st->st_size);
+		ret_read = pread64(fd, buffer, st->st_size, bytes_read);
+		if (ret_read == -1) {
+			fprintf(stderr, "%s read failed\n", path_name);
+			goto end;
+		}
+
+		ret = btrfs_insert_inline_extent(trans, root, objectid, 0,
+						buffer, st->st_size);
+		goto end;
+	}
+
+	ret = custom_alloc_extent(root, blocks * sectorsize, 0, &key);
+	if (ret)
+		goto end;
+
+	first_block = key.objectid;
+	bytes_read = 0;
+	buffer = malloc(sectorsize);
+
+	do {
+		memset(buffer, 0, sectorsize);
+		ret_read = pread64(fd, buffer, sectorsize, bytes_read);
+		if (ret_read == -1) {
+			fprintf(stderr, "%s read failed\n", path_name);
+			goto end;
+		}
+
+		ret = pwrite64(out_fd, buffer, sectorsize,
+			first_block + bytes_read);
+		if (ret != sectorsize) {
+			fprintf(stderr, "output file write failed\n");
+			goto end;
+		}
+
+		/* checksum for file data */
+		ret = btrfs_csum_file_block(trans, root->fs_info->csum_root,
+				first_block + (blocks * sectorsize),
+				first_block + bytes_read,
+				buffer, sectorsize);
+		if (ret) {
+			fprintf(stderr, "%s checksum failed\n", path_name);
+			goto end;
+		}
+
+		bytes_read += ret_read;
+		num_blocks++;
+	} while (ret_read == sectorsize);
+
+	if (num_blocks > 0) {
+		ret = record_file_extent(trans, root, objectid, btrfs_inode,
+					first_block, first_block,
+					blocks * sectorsize);
+		if (ret)
+			goto end;
+	}
+
+end:
+	if (buffer)
+		free(buffer);
+	close(fd);
+	return ret;
+}
+
+static char *make_path(char *dir, char *name)
+{
+	char *path;
+
+	path = malloc(strlen(dir) + strlen(name) + 2);
+	if (!path)
+		return NULL;
+	strcpy(path, dir);
+	if (dir[strlen(dir) - 1] != '/')
+		strcat(path, "/");
+	strcat(path, name);
+	return path;
+}
+
+static int traverse_directory(struct btrfs_trans_handle *trans,
+			struct btrfs_root *root, char *dir_name,
+			struct directory_name_entry *dir_head, int out_fd)
+{
+	int ret = 0;
+
+	struct btrfs_inode_item cur_inode;
+	struct btrfs_inode_item *inode_item;
+	u8 filetype;
+	int count, i, dir_index_cnt;
+	struct direct **files;
+	struct stat st;
+	struct directory_name_entry *dir_entry, *parent_dir_entry;
+	struct direct *cur_file;
+	ino_t parent_inum, cur_inum;
+	ino_t highest_inum = 0;
+	char *parent_dir_name;
+	struct btrfs_path path;
+	struct extent_buffer *leaf;
+	struct btrfs_key root_dir_key;
+	u64 root_dir_inode_size = 0;
+
+	/* Add list for source directory */
+	INIT_LIST_HEAD(&dir_head->list);
+	dir_entry = malloc(sizeof(struct directory_name_entry));
+	dir_entry->dir_name = dir_name;
+	dir_entry->path = malloc(strlen(dir_name) + 1);
+	strcpy(dir_entry->path, dir_name);
+
+	parent_inum = highest_inum + BTRFS_FIRST_FREE_OBJECTID;
+	dir_entry->inum = parent_inum;
+	list_add_tail(&dir_entry->list, &dir_head->list);
+
+	btrfs_init_path(&path);
+
+	root_dir_key.objectid = btrfs_root_dirid(&root->root_item);
+	root_dir_key.offset = 0;
+	btrfs_set_key_type(&root_dir_key, BTRFS_INODE_ITEM_KEY);
+	ret = btrfs_lookup_inode(trans, root, &path, &root_dir_key, 1);
+	if (ret) {
+		fprintf(stderr, "root dir lookup error\n");
+		goto fail;
+	}
+
+	leaf = path.nodes[0];
+	inode_item = btrfs_item_ptr(leaf, path.slots[0],
+		struct btrfs_inode_item);
+
+	root_dir_inode_size = calculate_dir_inode_size(dir_name);
+	btrfs_set_inode_size(leaf, inode_item, root_dir_inode_size);
+	btrfs_mark_buffer_dirty(leaf);
+
+	btrfs_release_path(root, &path);
+
+	do {
+		parent_dir_entry = list_entry(dir_head->list.next,
+				struct directory_name_entry, list);
+		list_del(&parent_dir_entry->list);
+
+		parent_inum = parent_dir_entry->inum;
+		parent_dir_name = parent_dir_entry->dir_name;
+		if (chdir(parent_dir_entry->path)) {
+			fprintf(stderr, "chdir error for %s\n",
+				parent_dir_name);
+			goto fail;
+		}
+
+		count = scandir(parent_dir_entry->path, &files,
+				directory_select, NULL);
+
+		for (i = 0; i < count; i++) {
+			cur_file = files[i];
+
+			if (lstat(cur_file->d_name, &st) == -1) {
+				fprintf(stderr, "lstat failed for file %s\n",
+					cur_file->d_name);
+				goto fail;
+			}
+
+			if (S_ISDIR(st.st_mode)) {
+				dir_entry = malloc(sizeof(struct directory_name_entry));
+				dir_entry->dir_name = cur_file->d_name;
+				dir_entry->path = make_path(
+							parent_dir_entry->path,
+							cur_file->d_name);
+				dir_entry->inum = ++highest_inum +
+						BTRFS_FIRST_FREE_OBJECTID;
+				list_add_tail(&dir_entry->list,
+						&dir_head->list);
+
+				filetype = BTRFS_FT_DIR;
+				ret = add_directory_items(trans, root,
+						dir_entry->inum, parent_inum,
+						dir_entry->dir_name,
+						filetype, &dir_index_cnt);
+				if (ret) {
+					fprintf(stderr, "add_directory_items failed\n");
+					goto fail;
+				}
+
+				ret = add_inode_items(trans, root, &st,
+					dir_entry->dir_name, dir_entry->inum,
+					parent_inum, dir_index_cnt, &cur_inode);
+				if (ret) {
+					fprintf(stderr, "add_inode_items failed\n");
+					goto fail;
+				}
+			} else if (S_ISREG(st.st_mode)) {
+				cur_inum = ++highest_inum +
+					BTRFS_FIRST_FREE_OBJECTID;
+				filetype = BTRFS_FT_REG_FILE;
+				ret = add_directory_items(trans, root,
+						cur_inum, parent_inum,
+						cur_file->d_name,
+						filetype, &dir_index_cnt);
+				if (ret) {
+					fprintf(stderr, "add_directory_items failed\n");
+					goto fail;
+				}
+
+				ret = add_inode_items(trans, root, &st,
+					cur_file->d_name, cur_inum,
+					parent_inum, dir_index_cnt, &cur_inode);
+				if (ret) {
+					fprintf(stderr, "add_inode_items failed\n");
+					goto fail;
+				}
+
+				ret = add_file_items(trans, root, &cur_inode,
+						cur_inum, parent_inum, &st,
+						cur_file->d_name, out_fd);
+				if (ret) {
+					fprintf(stderr, "add_file_items failed\n");
+					goto fail;
+				}
+			} else if (S_ISLNK(st.st_mode)) {
+				cur_inum = ++highest_inum +
+					BTRFS_FIRST_FREE_OBJECTID;
+				filetype = BTRFS_FT_SYMLINK;
+				ret = add_directory_items(trans, root, cur_inum,
+						parent_inum, cur_file->d_name,
+						filetype, &dir_index_cnt);
+				if (ret) {
+					fprintf(stderr, "add_directory_items failed\n");
+					goto fail;
+				}
+
+				ret = add_inode_items(trans, root, &st,
+					cur_file->d_name, cur_inum,
+					parent_inum, dir_index_cnt, &cur_inode);
+				if (ret) {
+					fprintf(stderr, "add_inode_items failed\n");
+					goto fail;
+				}
+
+				ret = add_symbolic_link(trans, root,
+						cur_inum, cur_file->d_name);
+				if (ret) {
+					fprintf(stderr, "add_symbolic_link failed\n");
+					goto fail;
+				}
+			}
+		}
+
+		free(parent_dir_entry->path);
+		free(parent_dir_entry);
+
+		index_cnt = 2;
+
+	} while (!list_empty(&dir_head->list));
+
+	return 0;
+fail:
+	free(parent_dir_entry->path);
+	free(parent_dir_entry);
+	return -1;
+}
+
+static int open_target(char *output_name)
+{
+	int output_fd;
+	output_fd = open(output_name, O_CREAT | O_RDWR | O_TRUNC,
+		      S_IRUSR | S_IWUSR | S_IRGRP | S_IWGRP | S_IROTH);
+
+	return output_fd;
+}
+
+static int btrfs_alloc_data_chunk(struct btrfs_trans_handle *trans,
+			struct btrfs_root *extent_root, u64 *start,
+			u64 num_bytes, u64 type)
+{
+	u64 dev_offset;
+	struct btrfs_fs_info *info = extent_root->fs_info;
+	struct btrfs_root *chunk_root = extent_root->fs_info->chunk_root;
+	struct btrfs_stripe *stripes;
+	struct btrfs_device *device = NULL;
+	struct btrfs_chunk *chunk;
+	struct list_head *dev_list = &extent_root->fs_info->fs_devices->devices;
+	struct list_head *cur;
+	struct map_lookup *map;
+	u64 physical;
+	u64 calc_size = 8 * 1024 * 1024;
+	int num_stripes = 1;
+	int sub_stripes = 0;
+	int ret;
+	int index;
+	int stripe_len = 64 * 1024;
+	struct btrfs_key key;
+
+	key.objectid = BTRFS_FIRST_CHUNK_TREE_OBJECTID;
+	key.type = BTRFS_CHUNK_ITEM_KEY;
+	ret = find_next_chunk(chunk_root, BTRFS_FIRST_CHUNK_TREE_OBJECTID,
+			      &key.offset);
+	if (ret)
+		return ret;
+
+	chunk = kmalloc(btrfs_chunk_item_size(num_stripes), GFP_NOFS);
+	if (!chunk)
+		return -ENOMEM;
+
+	map = kmalloc(map_lookup_size(num_stripes), GFP_NOFS);
+	if (!map) {
+		kfree(chunk);
+		return -ENOMEM;
+	}
+
+	stripes = &chunk->stripe;
+	calc_size = num_bytes;
+
+	index = 0;
+	cur = dev_list->next;
+	device = list_entry(cur, struct btrfs_device, dev_list);
+
+	while (index < num_stripes) {
+		struct btrfs_stripe *stripe;
+
+		ret = btrfs_alloc_dev_extent(trans, device,
+			     info->chunk_root->root_key.objectid,
+			     BTRFS_FIRST_CHUNK_TREE_OBJECTID, key.offset,
+			     calc_size, &dev_offset);
+		BUG_ON(ret);
+
+		device->bytes_used += calc_size;
+		ret = btrfs_update_device(trans, device);
+		BUG_ON(ret);
+
+		map->stripes[index].dev = device;
+		map->stripes[index].physical = dev_offset;
+		stripe = stripes + index;
+		btrfs_set_stack_stripe_devid(stripe, device->devid);
+		btrfs_set_stack_stripe_offset(stripe, dev_offset);
+		memcpy(stripe->dev_uuid, device->uuid, BTRFS_UUID_SIZE);
+		physical = dev_offset;
+		index++;
+	}
+
+	/* key was set above */
+	btrfs_set_stack_chunk_length(chunk, num_bytes);
+	btrfs_set_stack_chunk_owner(chunk, extent_root->root_key.objectid);
+	btrfs_set_stack_chunk_stripe_len(chunk, stripe_len);
+	btrfs_set_stack_chunk_type(chunk, type);
+	btrfs_set_stack_chunk_num_stripes(chunk, num_stripes);
+	btrfs_set_stack_chunk_io_align(chunk, stripe_len);
+	btrfs_set_stack_chunk_io_width(chunk, stripe_len);
+	btrfs_set_stack_chunk_sector_size(chunk, extent_root->sectorsize);
+	btrfs_set_stack_chunk_sub_stripes(chunk, sub_stripes);
+	map->sector_size = extent_root->sectorsize;
+	map->stripe_len = stripe_len;
+	map->io_align = stripe_len;
+	map->io_width = stripe_len;
+	map->type = type;
+	map->num_stripes = num_stripes;
+	map->sub_stripes = sub_stripes;
+
+	ret = btrfs_insert_item(trans, chunk_root, &key, chunk,
+				btrfs_chunk_item_size(num_stripes));
+	BUG_ON(ret);
+	*start = key.offset;
+
+	map->ce.start = key.offset;
+	map->ce.size = num_bytes;
+
+	ret = insert_existing_cache_extent(
+			   &extent_root->fs_info->mapping_tree.cache_tree,
+			   &map->ce);
+	BUG_ON(ret);
+
+	kfree(chunk);
+	return ret;
+}
+
+static int create_chunks(struct btrfs_trans_handle *trans,
+		struct btrfs_root *root, u64 num_of_meta_chunks,
+		u64 size_of_data)
+{
+	u64 chunk_start;
+	u64 chunk_size;
+	u64 meta_type = BTRFS_BLOCK_GROUP_METADATA;
+	u64 data_type = BTRFS_BLOCK_GROUP_DATA;
+	u64 minimum_data_chunk_size = 64 * 1024 * 1024;
+	u64 i;
+	int ret;
+
+	for (i = 0; i < num_of_meta_chunks; i++) {
+		ret = btrfs_alloc_chunk(trans, root->fs_info->extent_root,
+					&chunk_start, &chunk_size, meta_type);
+		ret = btrfs_make_block_group(trans, root->fs_info->extent_root, 0,
+				     meta_type, BTRFS_FIRST_CHUNK_TREE_OBJECTID,
+				     chunk_start, chunk_size);
+		set_extent_dirty(&root->fs_info->free_space_cache,
+				chunk_start, chunk_start + chunk_size - 1, 0);
+	}
+
+	if (size_of_data < minimum_data_chunk_size)
+		size_of_data = minimum_data_chunk_size;
+	ret = btrfs_alloc_data_chunk(trans, root->fs_info->extent_root,
+				&chunk_start, size_of_data, data_type);
+	ret = btrfs_make_block_group(trans, root->fs_info->extent_root, 0,
+				     data_type, BTRFS_FIRST_CHUNK_TREE_OBJECTID,
+				     chunk_start, size_of_data);
+	set_extent_dirty(&root->fs_info->free_space_cache,
+			   chunk_start, chunk_start + size_of_data - 1, 0);
+	return ret;
+}
+
+static int make_image(char *source_dir, struct btrfs_root *root, int out_fd)
+{
+	int ret;
+	struct btrfs_trans_handle *trans;
+
+	struct stat root_st;
+	int root_len;
+
+	struct directory_name_entry dir_head;
+
+	ret = lstat(source_dir, &root_st);
+	if (ret) {
+		fprintf(stderr, "unable to lstat the %s\n", source_dir);
+		goto fail;
+	}
+
+	root_len = strlen(source_dir);
+
+	INIT_LIST_HEAD(&dir_head.list);
+
+	trans = btrfs_start_transaction(root, 1);
+	ret = traverse_directory(trans, root, source_dir, &dir_head, out_fd);
+	if (ret) {
+		fprintf(stderr, "unable to traverse_directory\n");
+		goto fail;
+	}
+	btrfs_commit_transaction(trans, root);
+
+	printf("Making image is completed.\n");
+	return 0;
+fail:
+	fprintf(stderr, "Making image is aborted.\n");
+	return -1;
+}
+
+static u64 size_sourcedir(char *dir_name, u64 sectorsize,
+		u64 *num_of_meta_chunks_ret, u64 *size_of_data_ret)
+{
+	u64 dir_size = 0;
+	u64 total_size = 0;
+	int ret;
+	char command[1024];
+	char path[512];
+	char *file_name = "temp_file";
+	FILE *file;
+	u64 minimum_data_size = 256 * 1024 * 1024;	/* 256MB */
+	u64 default_chunk_size = 8 * 1024 * 1024;	/* 8MB */
+	u64 allocated_meta_size = 8 * 1024 * 1024;	/* 8MB */
+	u64 allocated_total_size = 20 * 1024 * 1024;	/* 20MB */
+	u64 num_of_meta_chunks = 0;
+	u64 num_of_allocated_meta_chunks =
+			allocated_meta_size / default_chunk_size;
+
+	ret = sprintf(command, "du -B 4096 -s ");
+	if (ret < 0) {
+		fprintf(stderr, "error executing sprintf for du command\n");
+		return -1;
+	}
+	strcat(command, dir_name);
+	strcat(command, " > ");
+	strcat(command, file_name);
+	ret = system(command);
+
+	file = fopen(file_name, "r");
+	ret = fscanf(file, "%lld %s\n", &dir_size, path);
+	fclose(file);
+	remove(file_name);
+
+	dir_size *= sectorsize;
+	*size_of_data_ret = dir_size;
+
+	num_of_meta_chunks = (dir_size / 2) / default_chunk_size;
+	if (((dir_size / 2) % default_chunk_size) != 0)
+		num_of_meta_chunks++;
+	if (num_of_meta_chunks <= num_of_allocated_meta_chunks)
+		num_of_meta_chunks = 0;
+	else
+		num_of_meta_chunks -= num_of_allocated_meta_chunks;
+
+	total_size = allocated_total_size + dir_size +
+		(num_of_meta_chunks * default_chunk_size);
+
+	*num_of_meta_chunks_ret = num_of_meta_chunks;
+
+	if (total_size < minimum_data_size)
+		total_size = minimum_data_size;
+
+	return total_size;
+}
+
+static int zero_output_file(int out_fd, u64 size, u32 sectorsize)
+{
+	int len = sectorsize;
+	int loop_num = size / sectorsize;
+	u64 location = 0;
+	char *buf = malloc(len);
+	int ret = 0, i;
+	ssize_t written;
+
+	if (!buf)
+		return -ENOMEM;
+	memset(buf, 0, len);
+	for (i = 0; i < loop_num; i++) {
+		written = pwrite64(out_fd, buf, len, location);
+		if (written != len)
+			ret = -EIO;
+		location += sectorsize;
+	}
+	free(buf);
+	return ret;
+}
+
 int main(int ac, char **av)
 {
 	char *file;
@@ -359,9 +1212,15 @@ int main(int ac, char **av)
 	int ret;
 	int i;
 
+	char *source_dir = NULL;
+	int source_dir_set = 0;
+	char *output = "output.img";
+	u64 num_of_meta_chunks = 0;
+	u64 size_of_data = 0;
+
 	while(1) {
 		int c;
-		c = getopt_long(ac, av, "A:b:l:n:s:m:d:L:V", long_options,
+		c = getopt_long(ac, av, "A:b:l:n:s:m:d:L:r:V", long_options,
 				&option_index);
 		if (c < 0)
 			break;
@@ -401,6 +1260,10 @@ int main(int ac, char **av)
 			case 'V':
 				print_version();
 				break;
+			case 'r':
+				source_dir = optarg;
+				source_dir_set = 1;
+				break;
 			default:
 				print_usage();
 		}
@@ -414,6 +1277,8 @@ int main(int ac, char **av)
 		fprintf(stderr, "Illegal nodesize %u\n", nodesize);
 		exit(1);
 	}
+	if (source_dir_set)
+		ac++;
 	ac = ac - optind;
 	if (ac == 0)
 		print_usage();
@@ -421,27 +1286,47 @@ int main(int ac, char **av)
 	printf("\nWARNING! - %s IS EXPERIMENTAL\n", BTRFS_BUILD_VERSION);
 	printf("WARNING! - see http://btrfs.wiki.kernel.org before using\n\n");
 
-	file = av[optind++];
-	ret = check_mounted(file);
-	if (ret < 0) {
-		fprintf(stderr, "error checking %s mount status\n", file);
-		exit(1);
-	}
-	if (ret == 1) {
-		fprintf(stderr, "%s is mounted\n", file);
-		exit(1);
-	}
-	ac--;
-	fd = open(file, O_RDWR);
-	if (fd < 0) {
-		fprintf(stderr, "unable to open %s\n", file);
-		exit(1);
+	if (source_dir == 0) {
+		file = av[optind++];
+		ret = check_mounted(file);
+		if (ret < 0) {
+			fprintf(stderr, "error checking %s mount status\n", file);
+			exit(1);
+		}
+		if (ret == 1) {
+			fprintf(stderr, "%s is mounted\n", file);
+			exit(1);
+		}
+		ac--;
+		fd = open(file, O_RDWR);
+		if (fd < 0) {
+			fprintf(stderr, "unable to open %s\n", file);
+			exit(1);
+		}
+		first_fd = fd;
+		first_file = file;
+		ret = btrfs_prepare_device(fd, file, zero_end, &dev_block_count);
+		if (block_count == 0)
+			block_count = dev_block_count;
+	} else {
+		ac--;
+		fd = open_target(output);
+		if (fd < 0) {
+			fprintf(stderr, "unable to open the %s\n", file);
+			exit(1);
+		}
+
+		file = output;
+		first_fd = fd;
+		first_file = file;
+		block_count = size_sourcedir(source_dir, sectorsize,
+				&num_of_meta_chunks, &size_of_data);
+		ret = zero_output_file(fd, block_count, sectorsize);
+		if (ret) {
+			fprintf(stderr, "unable to zero the output file\n");
+			exit(1);
+		}
 	}
-	first_fd = fd;
-	first_file = file;
-	ret = btrfs_prepare_device(fd, file, zero_end, &dev_block_count);
-	if (block_count == 0)
-		block_count = dev_block_count;
 
 	blocks[0] = BTRFS_SUPER_INFO_OFFSET;
 	for (i = 1; i < 7; i++) {
@@ -464,7 +1349,6 @@ int main(int ac, char **av)
 		fprintf(stderr, "failed to setup the root directory\n");
 		exit(1);
 	}
-
 	trans = btrfs_start_transaction(root, 1);
 
 	if (ac == 0)
@@ -514,9 +1398,11 @@ int main(int ac, char **av)
 	}
 
 raid_groups:
-	ret = create_raid_groups(trans, root, data_profile,
-				 metadata_profile);
-	BUG_ON(ret);
+	if (!source_dir_set) {
+		ret = create_raid_groups(trans, root, data_profile,
+					 metadata_profile);
+		BUG_ON(ret);
+	}
 
 	ret = create_data_reloc_tree(trans, root);
 	BUG_ON(ret);
@@ -528,6 +1414,18 @@ raid_groups:
 
 	printf("%s\n", BTRFS_BUILD_VERSION);
 	btrfs_commit_transaction(trans, root);
+
+	if (source_dir_set) {
+		trans = btrfs_start_transaction(root, 1);
+		ret = create_chunks(trans, root,
+				num_of_meta_chunks, size_of_data);
+		BUG_ON(ret);
+		btrfs_commit_transaction(trans, root);
+
+		ret = make_image(source_dir, root, fd);
+		BUG_ON(ret);
+	}
+
 	ret = close_ctree(root);
 	BUG_ON(ret);
 
diff --git a/volumes.c b/volumes.c
index 7671855..7f2e8b7 100644
--- a/volumes.c
+++ b/volumes.c
@@ -35,21 +35,6 @@ struct stripe {
 	u64 physical;
 };
 
-struct map_lookup {
-	struct cache_extent ce;
-	u64 type;
-	int io_align;
-	int io_width;
-	int stripe_len;
-	int sector_size;
-	int num_stripes;
-	int sub_stripes;
-	struct btrfs_bio_stripe stripes[];
-};
-
-#define map_lookup_size(n) (sizeof(struct map_lookup) + \
-			    (sizeof(struct btrfs_bio_stripe) * (n)))
-
 static LIST_HEAD(fs_uuids);
 
 static struct btrfs_device *__find_device(struct list_head *head, u64 devid,
@@ -400,7 +385,7 @@ err:
 	return ret;
 }
 
-static int find_next_chunk(struct btrfs_root *root, u64 objectid, u64 *offset)
+int find_next_chunk(struct btrfs_root *root, u64 objectid, u64 *offset)
 {
 	struct btrfs_path *path;
 	int ret;
diff --git a/volumes.h b/volumes.h
index bb78751..cfad304 100644
--- a/volumes.h
+++ b/volumes.h
@@ -18,6 +18,9 @@
 
 #ifndef __BTRFS_VOLUMES_
 #define __BTRFS_VOLUMES_
+
+#include "extent-cache.h"
+
 struct btrfs_device {
 	struct list_head dev_list;
 	struct btrfs_root *dev_root;
@@ -91,6 +94,21 @@ struct btrfs_multi_bio {
 #define btrfs_multi_bio_size(n) (sizeof(struct btrfs_multi_bio) + \
 			    (sizeof(struct btrfs_bio_stripe) * (n)))
 
+struct map_lookup {
+	struct cache_extent ce;
+	u64 type;
+	int io_align;
+	int io_width;
+	int stripe_len;
+	int sector_size;
+	int num_stripes;
+	int sub_stripes;
+	struct btrfs_bio_stripe stripes[];
+};
+
+#define map_lookup_size(n) (sizeof(struct map_lookup) + \
+			    (sizeof(struct btrfs_bio_stripe) * (n)))
+
 int btrfs_alloc_dev_extent(struct btrfs_trans_handle *trans,
 			   struct btrfs_device *device,
 			   u64 chunk_tree, u64 chunk_objectid,
@@ -130,4 +148,5 @@ int btrfs_add_system_chunk(struct btrfs_trans_handle *trans,
 			   struct btrfs_root *root, struct btrfs_key *key,
 			   struct btrfs_chunk *chunk, int item_size);
 int btrfs_chunk_readonly(struct btrfs_root *root, u64 chunk_offset);
+int find_next_chunk(struct btrfs_root *root, u64 objectid, u64 *offset);
 #endif
-- 
1.6.3.3
