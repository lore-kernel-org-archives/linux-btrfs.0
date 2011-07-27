From: Dan Carpenter <error27@gmail.com>
Subject: [patch] btrfs: unlock on error in btrfs_file_llseek()
Date: Wed, 27 Jul 2011 12:50:33 +0300
Message-ID: <20110727095033.GI3824@shale.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Chris Mason <chris.mason@oracle.com>,
	"open list:BTRFS FILE SYSTEM" <linux-btrfs@vger.kernel.org>,
	kernel-janitors@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

There were some unlocks on error missing in a recent patch to
btrfs_file_llseek().

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 59cbdb1..94d8342 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1804,10 +1804,14 @@ static loff_t btrfs_file_llseek(struct file *file, loff_t offset, int origin)
 		}
 	}
 
-	if (offset < 0 && !(file->f_mode & FMODE_UNSIGNED_OFFSET))
-		return -EINVAL;
-	if (offset > inode->i_sb->s_maxbytes)
-		return -EINVAL;
+	if (offset < 0 && !(file->f_mode & FMODE_UNSIGNED_OFFSET)) {
+		ret = -EINVAL;
+		goto out;
+	}
+	if (offset > inode->i_sb->s_maxbytes) {
+		ret = -EINVAL;
+		goto out;
+	}
 
 	/* Special lock needed here? */
 	if (offset != file->f_pos) {
