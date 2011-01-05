From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs-progs: add dedup functionality
Date: Wed,  5 Jan 2011 11:20:51 -0500
Message-ID: <1294244451-4558-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

This program very basically does dedup.  It searches a directory recursively and
scans all of the files looking for 64k extents and hashing them to figure out if
there are any duplicates.  After that it calls the btrfs same extent ioctl for
all of the duplicates in order to dedup the space on disk.  There is alot more
that can be done with this, like changing the block size and so on, but for now
this will get us started.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 dedup.c |  658 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 658 insertions(+), 0 deletions(-)
 create mode 100644 dedup.c

diff --git a/dedup.c b/dedup.c
new file mode 100644
index 0000000..5385e28
--- /dev/null
+++ b/dedup.c
@@ -0,0 +1,658 @@
+/*
+ * Copyright (C) 2011 Red Hat.  All rights reserved.
+ *
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
+#define _GNU_SOURCE 1
+#define X_OPEN_SOURCE 500
+
+#include <linux/fs.h>
+#include <linux/fiemap.h>
+#include <sys/ioctl.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <dirent.h>
+#include <errno.h>
+#include <fcntl.h>
+#include <gcrypt.h>
+#include <stdio.h>
+#include <string.h>
+#include <stdint.h>
+#include <unistd.h>
+#include "rbtree.h"
+#include "ioctl.h"
+
+struct file_entry {
+	ino_t ino;
+	unsigned long pos;
+	unsigned long len;
+	unsigned long physical;
+	char *hash;
+	int entries;
+	int fd;
+	struct file_entry *next;
+	struct rb_node n;
+};
+
+struct file {
+	char *name;
+	ino_t ino;
+	struct rb_node n;
+};
+
+static unsigned int digest_len;
+static char *digest;
+static struct rb_root hash_tree;
+static struct rb_root file_tree;
+unsigned int buffer_len = 65536;
+
+static void print_hash(uint64_t *hash)
+{
+	int i;
+
+	for (i = 0; i < 8; i++) {
+		printf("%llx", (unsigned long long)hash[i]);
+	}
+}
+
+static char *hash_buffer(void *buffer, int len)
+{
+	gcry_md_hash_buffer(GCRY_MD_SHA256, digest, buffer, len);
+
+	return strndup(digest, digest_len);
+}
+
+static struct rb_node *hash_tree_insert(struct file_entry *fe)
+{
+	struct rb_node **p = &hash_tree.rb_node;
+	struct rb_node *parent = NULL;
+	struct file_entry *entry;
+
+	while (*p) {
+		int cmp;
+
+		parent = *p;
+		entry = rb_entry(parent, struct file_entry, n);
+
+		cmp = memcmp(fe->hash, entry->hash, digest_len);
+
+		if (cmp < 0)
+			p = &(*p)->rb_left;
+		else if (cmp > 0)
+			p = &(*p)->rb_right;
+		else
+			return parent;
+	}
+
+	rb_link_node(&fe->n, parent, p);
+	rb_insert_color(&fe->n, &hash_tree);
+
+	return NULL;
+}
+
+#if 0
+static unsigned long logical_to_physical(int fd, unsigned long logical,
+					 unsigned long len)
+{
+	struct fiemap *map;
+	struct fiemap_extent *extent;
+	unsigned long physical = 0;
+	int size = sizeof(struct fiemap) + sizeof(struct fiemap_extent);
+	int ret;
+
+	map = malloc(sizeof(struct fiemap) + sizeof(struct fiemap_extent));
+	if (!map)
+		return 0;
+
+	memset(map, 0, size);
+	map->fm_start = logical;
+	map->fm_length = len;
+	map->fm_flags = FIEMAP_FLAG_SYNC;
+	map->fm_extent_count = 1;
+	ret = ioctl(fd, FS_IOC_FIEMAP, map);
+	if (ret) {
+		fprintf(stderr, "failed to do fiemap %d\n", errno);
+		return 0;
+	}
+	extent = &map->fm_extents[0];
+
+	physical = extent->fe_physical;
+	if (extent->fe_logical < logical)
+		physical +=  (logical - extent->fe_logical);
+	free(map);
+
+	return physical;
+}
+#endif
+
+static struct rb_node *file_tree_insert(struct file *file)
+{
+	struct rb_node **p = &file_tree.rb_node;
+	struct rb_node *parent = NULL;
+	struct file *entry;
+
+	while (*p) {
+		parent = *p;
+		entry = rb_entry(parent, struct file, n);
+
+		if (file->ino < entry->ino)
+			p = &(*p)->rb_left;
+		else if (file->ino > entry->ino)
+			p = &(*p)->rb_right;
+		else
+			return parent;
+	}
+
+	rb_link_node(&file->n, parent, p);
+	rb_insert_color(&file->n, &file_tree);
+
+	return NULL;
+}
+
+static struct file *file_tree_search(ino_t ino)
+{
+	struct rb_node *node = file_tree.rb_node;
+	struct file *entry;
+
+	while (node) {
+		entry = rb_entry(node, struct file, n);
+		if (ino < entry->ino)
+			node = node->rb_left;
+		else if (ino > entry->ino)
+			node = node->rb_right;
+		else
+			return entry;
+	}
+
+	return NULL;
+}
+
+static int hash_file(char *filename)
+{
+	char *buffer;
+	struct rb_node *node;
+	struct file *file;
+	int fd;
+	ssize_t bytes;
+	size_t pos = 0;
+	struct stat st;
+	ino_t ino;
+
+	buffer = malloc(buffer_len);
+	if (!buffer) {
+		fprintf(stderr, "failed to alloc buffer\n");
+		return 1;
+	}
+
+	file = malloc(sizeof(*file));
+	if (!file) {
+		free(buffer);
+		fprintf(stderr, "failed to alloc file thing\n");
+		return 1;
+	}
+
+	fd = open(filename, O_RDONLY);
+	if (fd < 0) {
+		free(buffer);
+		return 1;
+	}
+
+	if (fstat(fd, &st) < 0) {
+		fprintf(stderr, "failed to stat\n");
+		free(buffer);
+		return 1;
+	}
+
+	ino = st.st_ino;
+	file->ino = ino;
+
+	node = file_tree_insert(file);
+	if (node) {
+		printf("wtf?\n");
+		free(file);
+		free(buffer);
+		close(fd);
+		return 0;
+	}
+
+	file->name = strdup(filename);
+
+	while ((bytes = read(fd, buffer, buffer_len)) > 0) {
+		struct file_entry *entry = malloc(sizeof(struct file_entry));
+
+		if (!entry) {
+			fprintf(stderr, "failed to allocate entry\n");
+			bytes = -1;
+			break;
+		}
+
+		entry->ino = ino;
+		entry->pos = pos;
+		entry->len = bytes;
+		entry->hash = hash_buffer(buffer, bytes);
+		if (!entry->hash) {
+			fprintf(stderr, "failed to allocate hash\n");
+			bytes = -1;
+			break;
+		}
+		entry->next = NULL;
+		entry->entries = 0;
+		node = hash_tree_insert(entry);
+		if (node) {
+			struct file_entry *existing;
+
+			existing = rb_entry(node, struct file_entry, n);
+			free(entry->hash);
+			entry->hash = NULL;
+			entry->next = existing->next;
+			existing->next = entry;
+			existing->entries++;
+		} else {
+//			entry->physical = logical_to_physical(fd, pos, bytes);
+		}
+		pos += bytes;
+	}
+
+	close(fd);
+	free(buffer);
+
+	if (bytes < 0)
+		printf("Bytes negative, error %d\n", errno);
+	return (bytes < 0);
+}
+
+static void print_stats()
+{
+	struct rb_node *node;
+	int total_extents = 0;
+	int total_duplicates = 0;
+
+	for (node = rb_first(&hash_tree); node; node = rb_next(node)) {
+		struct file_entry *entry;
+		entry = rb_entry(node, struct file_entry, n);
+		total_extents++;
+		if (entry->entries)
+			total_duplicates += entry->entries;
+	}
+
+	printf("Total extents hashed:\t%d\n", total_extents);
+	printf("Total duplicates:\t%d\n", total_duplicates);
+	printf("Total space saved:\t%d\n", total_duplicates * buffer_len);
+
+}
+
+static void free_hash_tree()
+{
+	struct rb_node *node;
+
+	while ((node = rb_first(&hash_tree))) {
+		struct file_entry *entry;
+		entry = rb_entry(node, struct file_entry, n);
+		rb_erase(node, &hash_tree);
+		do {
+			struct file_entry *temp;
+
+			if (entry->next == NULL)
+				break;
+			temp = entry->next;
+			free(entry->hash);
+			free(entry);
+			entry = temp;
+		} while (1);
+
+		free(entry->hash);
+		free(entry);
+	}
+}
+
+static void free_file_tree()
+{
+	struct rb_node *node;
+
+	while ((node = rb_first(&file_tree))) {
+		struct file *entry;
+		entry = rb_entry(node, struct file, n);
+		rb_erase(node, &file_tree);
+//		printf("freeing %s, ino %lu\n", entry->name, entry->ino);
+		free(entry->name);
+		free(entry);
+	}
+}
+
+static void verify_match(struct file_entry *fe)
+{
+	struct file_entry *orig = fe;
+	struct file *file;
+	char *buffer;
+	char *temp;
+	ssize_t bytes;
+	int fd;
+
+	buffer = malloc(buffer_len);
+	if (!buffer)
+		return;
+
+	temp = malloc(buffer_len);
+	if (!temp) {
+		free(buffer);
+		return;
+	}
+
+	file = file_tree_search(fe->ino);
+	if (!file) {
+		fprintf(stderr, "couldn't find file, weird %lu\n", fe->ino);
+		goto out;
+	}
+
+	fd = open(file->name, O_RDONLY);
+	if (fd < 0) {
+		fprintf(stderr, "failed to open%s\n", file->name);
+		goto out;
+	}
+
+	bytes = pread(fd, buffer, fe->len, fe->pos);
+	close(fd);
+	if (bytes < fe->len) {
+		fprintf(stderr, "short read\n");
+		goto out;
+	}
+
+	while (fe->next != NULL) {
+		struct file_entry *prev = fe;
+
+		fe = fe->next;
+		file = file_tree_search(fe->ino);
+		if (!file) {
+			fprintf(stderr, "couldn't find file, weird\n");
+			prev->next = fe->next;
+			free(fe->hash);
+			free(fe);
+			orig->entries--;
+			fe = prev;
+			continue;
+		}
+
+		fd = open(file->name, O_RDONLY);
+		if (fd < 0) {
+			fprintf(stderr, "couldn't open %s\n", file->name);
+			prev->next = fe->next;
+			free(fe->hash);
+			free(fe);
+			orig->entries--;
+			fe = prev;
+			continue;
+		}
+
+		bytes = pread(fd, temp, fe->len, fe->pos);
+		close(fd);
+		if (bytes < fe->len) {
+			fprintf(stderr, "short read\n");
+			prev->next = fe->next;
+			free(fe->hash);
+			free(fe);
+			orig->entries--;
+			fe = prev;
+			continue;
+		}
+
+		if (memcmp(buffer, temp, fe->len)) {
+			fprintf(stderr, "manual compare doesn't match: %s\n",
+				file->name);
+			prev->next = fe->next;
+			free(fe->hash);
+			free(fe);
+			orig->entries--;
+			fe = prev;
+			continue;
+		}
+	}
+
+	if (!orig->entries) {
+		rb_erase(&orig->n, &hash_tree);
+		free(orig->hash);
+		free(orig);
+	}
+out:
+	free(buffer);
+	free(temp);
+}
+
+static void prune_entries()
+{
+	struct rb_node *node;
+
+	node = rb_first(&hash_tree);
+	while (node) {
+		struct file_entry *entry;
+		entry = rb_entry(node, struct file_entry, n);
+		if (entry->entries) {
+			node = rb_next(node);
+			verify_match(entry);
+			continue;
+		}
+
+		node = rb_next(node);
+		rb_erase(&entry->n, &hash_tree);
+		free(entry->hash);
+		free(entry);
+	}
+}
+
+static void print_hashes()
+{
+	struct rb_node *hash_node;
+
+	for (hash_node = rb_first(&hash_tree); hash_node;
+	     hash_node = rb_next(hash_node)) {
+		struct file_entry *fe;
+		struct file *file;
+
+		fe = rb_entry(hash_node, struct file_entry, n);
+
+		file = file_tree_search(fe->ino);
+		if (!file) {
+			fprintf(stderr, "couldnt find file, weird %lu\n", fe->ino);
+			break;
+		}
+
+		print_hash((uint64_t *)fe->hash);
+		printf("\n");
+		printf("\t%s: pos=%lu, phys=%lu, len=%lu\n", file->name,
+		       fe->pos, fe->physical, fe->len);
+
+		while (fe->next != NULL) {
+			fe = fe->next;
+			file = file_tree_search(fe->ino);
+			if (!file) {
+				fprintf(stderr, "couldnt find file, weird\n");
+				continue;
+			}
+
+			printf("\t%s: pos=%lu, len=%lu\n", file->name,
+			       fe->pos, fe->len);
+		}
+	}
+}
+
+
+static void do_dedup()
+{
+	struct rb_node *node;
+	struct btrfs_ioctl_same_args *args;
+	struct btrfs_ioctl_file_extent_info *info;
+	size_t size;
+	int allocated_entries = 1;
+
+	size = sizeof(*args) + sizeof(*info);
+	args = malloc(size);
+	if (!args) {
+		fprintf(stderr, "error allocating ioctl arguments\n");
+		return;
+	}
+
+	memset(args, 0, size);
+
+	for (node = rb_first(&hash_tree); node; node = rb_next(node)) {
+		struct file_entry *fe, *orig;
+		struct file *file;
+		int fd;
+		int ret;
+
+		orig = fe = rb_entry(node, struct file_entry, n);
+
+		file = file_tree_search(fe->ino);
+		if (!file) {
+			fprintf(stderr, "couldnt find file, weird %lu\n", fe->ino);
+			break;
+		}
+
+		fd = open(file->name, O_WRONLY);
+		if (fd < 0) {
+			fprintf(stderr, "error opening file (%s) for dedup: %s\n",
+				file->name, strerror(errno));
+			continue;
+		}
+
+		if (fe->entries > allocated_entries) {
+			allocated_entries = fe->entries;
+			size = sizeof(*args) +
+				(sizeof(*info) * allocated_entries);
+			args = realloc(args, size);
+			if (!args) {
+				fprintf(stderr, "error allocating ioctl "
+					"arguments\n");
+				return;
+			}
+			memset(args, 0, size);
+		}
+
+		args->total_files = 0;
+		args->logical_offset = fe->pos;
+		args->length = fe->len;
+		args->hash_len = digest_len;
+		args->hash_type = BTRFS_SAME_EXTENT_HASH_SHA256;
+		args->hash = fe->hash;
+
+		info = &args->info[0];
+		while (fe->next != NULL) {
+			fe = fe->next;
+			file = file_tree_search(fe->ino);
+			if (!file) {
+				fprintf(stderr, "couldnt find file, weird\n");
+				continue;
+			}
+
+			fe->fd = info->fd = open(file->name, O_WRONLY);
+			if (info->fd < 0) {
+				fprintf(stderr, "error opening file (%s) for "
+					"dedup: %s\n", file->name,
+					strerror(errno));
+				continue;
+			}
+			info->logical_offset = fe->pos;
+			info++;
+			args->total_files++;
+		}
+
+		if (args->total_files == 0) {
+			close(fd);
+			continue;
+		}
+
+		ret = ioctl(fd, BTRFS_IOC_FILE_EXTENT_SAME, args);
+		if (ret)
+			fprintf(stderr, "failed to do extent same %d\n",
+				errno);
+
+		fe = orig;
+		while (fe->next != NULL) {
+			fe = fe->next;
+			if (fe->fd >= 0)
+				close(fe->fd);
+		}
+		close(fd);
+	}
+}
+
+static void scan_dir(char *dirname)
+{
+	DIR *dir;
+	struct dirent *dirent;
+
+	dir = opendir(dirname);
+	if (!dir) {
+		fprintf(stderr, "failed to open dir %s: %d\n", dirname, errno);
+		return;
+	}
+
+	while (((dirent = readdir(dir)) != NULL)) {
+		char name[PATH_MAX];
+		if (dirent->d_type == DT_DIR) {
+			if (dirent->d_name[0] == '.')
+				continue;
+			snprintf(name, PATH_MAX, "%s/%s", dirname,
+				 dirent->d_name);
+			scan_dir(name);
+		} else if (dirent->d_type == DT_REG) {
+			snprintf(name, PATH_MAX, "%s/%s", dirname,
+				 dirent->d_name);
+			hash_file(name);
+		}
+	}
+
+	closedir(dir);
+}
+
+int main(int argc, char **argv)
+{
+	if (argc < 2) {
+		fprintf(stderr, "dedup <directory>\n");
+		exit(1);
+	}
+
+	if (!gcry_check_version(GCRYPT_VERSION)) {
+		fprintf(stderr, "libgcrypt version mismatch\n");
+		exit(1);
+	}
+
+	gcry_control(GCRYCTL_DISABLE_SECMEM, 0);
+	gcry_control(GCRYCTL_INITIALIZATION_FINISHED, 0);
+
+	digest_len = gcry_md_get_algo_dlen(GCRY_MD_SHA256);
+	digest = malloc(digest_len);
+	if (!digest) {
+		fprintf(stderr, "failed to alloc digest\n");
+		exit(1);
+	}
+
+	hash_tree = RB_ROOT;
+	file_tree = RB_ROOT;
+
+	scan_dir(argv[1]);
+
+	print_stats();
+
+	prune_entries();
+
+	print_hashes();
+
+	do_dedup();
+
+	free_hash_tree();
+	free_file_tree();
+	free(digest);
+
+	return 0;
+}
-- 
1.6.6.1

