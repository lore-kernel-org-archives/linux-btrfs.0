From: Keith Mannthey <kmannth@us.ibm.com>
Subject: [RFC][PATCH] Sector Size check during Mount
Date: Tue, 29 Nov 2011 17:44:12 -0800
Message-ID: <1322617452.10304.15.camel@keith-laptop>
Mime-Version: 1.0
Content-Type: text/plain
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Gracefully fail when trying to mount a BTRFS file system that has a
sectorsize smaller than PAGE_SIZE.  

On PPC it is possible to build a FS while using a 4k PAGE_SIZE kernel
then boot into a 64K PAGE_SIZE kernel.  Presently open_ctree fails in an
endless loop and hangs the machine in this situation. 

My debugging has show this Sector size < Page size to be a non trivial
situation and a graceful exit from the situation would be nice for the
time being. 


Signed-off-by:  Keith Mannthey <kmannth@us.ibm.com>

---

diff -urN a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
--- a/fs/btrfs/disk-io.c	2011-10-09 21:53:11.000000000 -0500
+++ b/fs/btrfs/disk-io.c	2011-11-29 17:33:15.000000000 -0600
@@ -1916,6 +1916,12 @@
 		goto fail_sb_buffer;
 	}
 
+	if (sectorsize < PAGE_SIZE) {
+		printk(KERN_WARNING "btrfs: Incompatible sector size "
+		       "found on %s\n", sb->s_id);
+		goto fail_sb_buffer;
+	}
+
 	mutex_lock(&fs_info->chunk_mutex);
 	ret = btrfs_read_sys_array(tree_root);
 	mutex_unlock(&fs_info->chunk_mutex);


