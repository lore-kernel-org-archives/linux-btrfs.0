From: Sergei Trofimovich <slyfox@gentoo.org>
Subject: [PATCH v2 3/9] mkfs.btrfs: fail on scandir error (-r mode)
Date: Sat,  4 Jun 2011 11:19:18 +0300
Message-ID: <1307175564-25355-4-git-send-email-slyfox@gentoo.org>
References: <1307175564-25355-1-git-send-email-slyfox@gentoo.org>
Cc: linux-btrfs@vger.kernel.org, Sergei Trofimovich <slyfox@gentoo.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1307175564-25355-1-git-send-email-slyfox@gentoo.org>
List-ID: <linux-btrfs.vger.kernel.org>

mkfs.btrfs does not handle relative pathnames for now. When
they are passed to it it creates empty image. So first time
I thought it does not work at all.

This patch adds error handling for scandir(). With patch it behaves
this way:

    $ mkfs.btrfs -r ./root
    ...
    fs created label (null) on output.img
            nodesize 4096 leafsize 4096 sectorsize 4096 size 256.00MB
    Btrfs v0.19-52-g438c5ff-dirty
    scandir for ./root failed: No such file or directory
    unable to traverse_directory
    Making image is aborted.
    mkfs.btrfs: mkfs.c:1402: main: Assertion `!(ret)' failed.

Signed-off-by: Sergei Trofimovich <slyfox@gentoo.org>
---
 mkfs.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/mkfs.c b/mkfs.c
index 57c88f9..9d7b792 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -878,40 +878,46 @@ static int traverse_directory(struct btrfs_trans_handle *trans,
 	btrfs_mark_buffer_dirty(leaf);
 
 	btrfs_release_path(root, &path);
 
 	do {
 		parent_dir_entry = list_entry(dir_head->list.next,
 					      struct directory_name_entry,
 					      list);
 		list_del(&parent_dir_entry->list);
 
 		parent_inum = parent_dir_entry->inum;
 		parent_dir_name = parent_dir_entry->dir_name;
 		if (chdir(parent_dir_entry->path)) {
 			fprintf(stderr, "chdir error for %s\n",
 				parent_dir_name);
 			goto fail;
 		}
 
 		count = scandir(parent_dir_entry->path, &files,
 				directory_select, NULL);
+		if (count == -1)
+		{
+			fprintf(stderr, "scandir for %s failed: %s\n",
+				parent_dir_name, strerror (errno));
+			goto fail;
+		}
 
 		for (i = 0; i < count; i++) {
 			cur_file = files[i];
 
 			if (lstat(cur_file->d_name, &st) == -1) {
 				fprintf(stderr, "lstat failed for file %s\n",
 					cur_file->d_name);
 				goto fail;
 			}
 
 			cur_inum = ++highest_inum + BTRFS_FIRST_FREE_OBJECTID;
 			ret = add_directory_items(trans, root,
 						  cur_inum, parent_inum,
 						  cur_file->d_name,
 						  &st, &dir_index_cnt);
 			if (ret) {
 				fprintf(stderr, "add_directory_items failed\n");
 				goto fail;
 			}
 
-- 
1.7.3.4

