From: Sergei Trofimovich <slyfox@gentoo.org>
Subject: [PATCH v2 8/9] mkfs.btrfs: fix memory leak caused by 'scandir()' calls
Date: Sat,  4 Jun 2011 11:19:23 +0300
Message-ID: <1307175564-25355-9-git-send-email-slyfox@gentoo.org>
References: <1307175564-25355-1-git-send-email-slyfox@gentoo.org>
Cc: linux-btrfs@vger.kernel.org, Sergei Trofimovich <slyfox@gentoo.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1307175564-25355-1-git-send-email-slyfox@gentoo.org>
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Sergei Trofimovich <slyfox@gentoo.org>
---
 mkfs.c |   16 ++++++++++++++++
 1 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/mkfs.c b/mkfs.c
index c8b19c1..a65fb4d 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -451,53 +451,67 @@ static int fill_inode_item(struct btrfs_trans_handle *trans,
 				blocks += 1;
 			blocks *= sectorsize;
 			btrfs_set_stack_inode_nbytes(dst, blocks);
 		}
 	}
 	if (S_ISLNK(src->st_mode))
 		btrfs_set_stack_inode_nbytes(dst, src->st_size + 1);
 
 	return 0;
 }
 
 static int directory_select(const struct direct *entry)
 {
 	if ((strncmp(entry->d_name, ".", entry->d_reclen) == 0) ||
 		(strncmp(entry->d_name, "..", entry->d_reclen) == 0))
 		return 0;
 	else
 		return 1;
 }
 
+static void free_namelist(struct direct **files, int count)
+{
+	int i;
+
+	if (count < 0)
+		return;
+
+	for (i = 0; i < count; ++i)
+		free(files[i]);
+	free (files);
+}
+
 static u64 calculate_dir_inode_size(char *dirname)
 {
 	int count, i;
 	struct direct **files, *cur_file;
 	u64 dir_inode_size = 0;
 
 	count = scandir(dirname, &files, directory_select, NULL);
 
 	for (i = 0; i < count; i++) {
 		cur_file = files[i];
 		dir_inode_size += strlen(cur_file->d_name);
 	}
 
+	free_namelist(files, count);
+
 	dir_inode_size *= 2;
 	return dir_inode_size;
 }
 
 static int add_inode_items(struct btrfs_trans_handle *trans,
 			   struct btrfs_root *root,
 			   struct stat *st, char *name,
 			   u64 self_objectid, ino_t parent_inum,
 			   int dir_index_cnt, struct btrfs_inode_item *inode_ret)
 {
 	int ret;
 	struct btrfs_key inode_key;
 	struct btrfs_inode_item btrfs_inode;
 	u64 objectid;
 	u64 inode_size = 0;
 	int name_len;
 
 	name_len = strlen(name);
 	fill_inode_item(trans, root, &btrfs_inode, st);
 	objectid = self_objectid;
@@ -954,49 +968,51 @@ static int traverse_directory(struct btrfs_trans_handle *trans,
 				dir_entry->inum = cur_inum;
 				list_add_tail(&dir_entry->list,	&dir_head->list);
 			} else if (S_ISREG(st.st_mode)) {
 				ret = add_file_items(trans, root, &cur_inode,
 						     cur_inum, parent_inum, &st,
 						     cur_file->d_name, out_fd);
 				if (ret) {
 					fprintf(stderr, "add_file_items failed\n");
 					goto fail;
 				}
 			} else if (S_ISLNK(st.st_mode)) {
 				ret = add_symbolic_link(trans, root,
 						        cur_inum, cur_file->d_name);
 				if (ret) {
 					fprintf(stderr, "add_symbolic_link failed\n");
 					goto fail;
 				}
 			}
 		}
 
+		free_namelist(files, count);
 		free(parent_dir_entry->path);
 		free(parent_dir_entry);
 
 		index_cnt = 2;
 
 	} while (!list_empty(&dir_head->list));
 
 	return 0;
 fail:
+	free_namelist(files, count);
 	free(parent_dir_entry->path);
 	free(parent_dir_entry);
 	return -1;
 }
 
 static int open_target(char *output_name)
 {
 	int output_fd;
 	output_fd = open(output_name, O_CREAT | O_RDWR | O_TRUNC,
 		         S_IRUSR | S_IWUSR | S_IRGRP | S_IWGRP | S_IROTH);
 
 	return output_fd;
 }
 
 static int create_chunks(struct btrfs_trans_handle *trans,
 			 struct btrfs_root *root, u64 num_of_meta_chunks,
 			 u64 size_of_data)
 {
 	u64 chunk_start;
 	u64 chunk_size;
-- 
1.7.3.4

