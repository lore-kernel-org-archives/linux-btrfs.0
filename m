From: Sergei Trofimovich <slyfox@gentoo.org>
Subject: [PATCH 8/9] mkfs.btrfs: fix memory leak caused by 'scandir()' calls
Date: Tue, 31 May 2011 00:19:07 +0300
Message-ID: <1306790348-9553-9-git-send-email-slyfox@gentoo.org>
References: <1306790348-9553-1-git-send-email-slyfox@gentoo.org>
Cc: linux-btrfs@vger.kernel.org, Sergei Trofimovich <slyfox@gentoo.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1306790348-9553-1-git-send-email-slyfox@gentoo.org>
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Sergei Trofimovich <slyfox@gentoo.org>
---
 mkfs.c |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/mkfs.c b/mkfs.c
index c8b19c1..73c898b 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -468,6 +468,15 @@ static int directory_select(const struct direct *entry)
 		return 1;
 }
 
+static void free_namelist(struct direct **files, int count)
+{
+	int i;
+
+	for (i = 0; i < count; ++i)
+		free(files[i]);
+	free (files);
+}
+
 static u64 calculate_dir_inode_size(char *dirname)
 {
 	int count, i;
@@ -481,6 +490,8 @@ static u64 calculate_dir_inode_size(char *dirname)
 		dir_inode_size += strlen(cur_file->d_name);
 	}
 
+	free_namelist(files, count);
+
 	dir_inode_size *= 2;
 	return dir_inode_size;
 }
@@ -971,6 +982,7 @@ static int traverse_directory(struct btrfs_trans_handle *trans,
 			}
 		}
 
+		free_namelist(files, count);
 		free(parent_dir_entry->path);
 		free(parent_dir_entry);
 
@@ -980,6 +992,7 @@ static int traverse_directory(struct btrfs_trans_handle *trans,
 
 	return 0;
 fail:
+	free_namelist(files, count);
 	free(parent_dir_entry->path);
 	free(parent_dir_entry);
 	return -1;
-- 
1.7.3.4

