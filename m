From: "Jan Beulich" <JBeulich@novell.com>
Subject: [PATCH] fix (latent?) memory corruption in btrfs_encode_fh()
Date: Thu, 07 Oct 2010 10:28:44 +0100
Message-ID: <4CADAEEC020000780001B32C@vpn.id2.novell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: <linux-btrfs@vger.kernel.org>
To: "Chris Mason" <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

The earlier checks only cover the two smaller cases, and hence if the
caller specified size is less than what's needed to fit
parent_root_objectid unrelated memory may get overwritten.

Signed-off-by: Jan Beulich <jbeulich@novell.com>

---
 fs/btrfs/export.c |    2 ++
 1 file changed, 2 insertions(+)

--- linux-2.6.36-rc7/fs/btrfs/export.c
+++ 2.6.36-rc7-btrfs-encode-fh/fs/btrfs/export.c
@@ -46,6 +46,8 @@ static int btrfs_encode_fh(struct dentry
 		spin_unlock(&dentry->d_lock);
 
 		if (parent_root_id != fid->root_objectid) {
+			if (*max_len < BTRFS_FID_SIZE_CONNECTABLE_ROOT)
+				return 255;
 			fid->parent_root_objectid = parent_root_id;
 			len = BTRFS_FID_SIZE_CONNECTABLE_ROOT;
 			type = FILEID_BTRFS_WITH_PARENT_ROOT;



