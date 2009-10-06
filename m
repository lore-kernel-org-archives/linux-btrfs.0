From: Diego Calleja <diegocg@gmail.com>
Subject: [PATCH] Fix possible pointer dereference
Date: Tue, 6 Oct 2009 22:15:22 +0200
Message-ID: <200910062215.22562.diegocg@gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

We should always check btrfs_alloc_path(). Some places BUG(),
others return -ENOMEM, btrfs_insert_dir_item() seems like it can return
safely.

Signed-off-by: Diego Calleja <diegocg@gmail.com>

--- linux/fs/btrfs/dir-item.c.BAK	2009-10-06 19:00:48.887361896 +0200
+++ linux/fs/btrfs/dir-item.c	2009-10-06 19:01:00.329132291 +0200
@@ -147,6 +147,9 @@ int btrfs_insert_dir_item(struct btrfs_t
 	key.offset = btrfs_name_hash(name, name_len);
 
 	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
+
 	path->leave_spinning = 1;
 
 	data_size = sizeof(*dir_item) + name_len;
