From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: fix regression in orphan cleanup
Date: Fri, 15 Jan 2010 15:08:22 -0500
Message-ID: <20100115200821.GA3699@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tomas.carnecky@gmail.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Currently orphan cleanup only ever gets triggered if we cross subvolumes during
a lookup, which means that if we just mount a plain jane fs that has orphans in
it, they will never get cleaned up.  This results in panic's like these

http://www.kerneloops.org/oops.php?number=1109085

where adding an orphan entry results in -EEXIST being returned and we panic.  In
order to fix this, we check to see on lookup if our root has had the orphan
cleanup done, and if not go ahead and do it.  This is easily reproduceable by
running this testcase

#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <string.h>
#include <unistd.h>
#include <stdio.h>

int main(int argc, char **argv)
{
	char data[4096];
	char newdata[4096];
	int fd1, fd2;

	memset(data, 'a', 4096);
	memset(newdata, 'b', 4096);

	while (1) {
		int i;

		fd1 = creat("file1", 0666);
		if (fd1 < 0)
			break;

		for (i = 0; i < 512; i++)
			write(fd1, data, 4096);

		fsync(fd1);
		close(fd1);

		fd2 = creat("file2", 0666);
		if (fd2 < 0)
			break;

		ftruncate(fd2, 4096 * 512);

		for (i = 0; i < 512; i++)
			write(fd2, newdata, 4096);
		close(fd2);

		i = rename("file2", "file1");
		unlink("file1");
	}

	return 0;
}

and then pulling the power on the box, and then trying to run that test again
when the box comes back up.  I've tested this locally and it fixes the problem.
Thanks to Tomas Carnecky for helping me track this down initially.

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/inode.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 5440bab..f5d9384 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3796,6 +3796,12 @@ struct inode *btrfs_lookup_dentry(struct inode *dir, struct dentry *dentry)
 
 	if (location.type == BTRFS_INODE_ITEM_KEY) {
 		inode = btrfs_iget(dir->i_sb, &location, root);
+		if (unlikely(root->clean_orphans) &&
+		    !(inode->i_sb->s_flags & MS_RDONLY)) {
+			down_read(&root->fs_info->cleanup_work_sem);
+			btrfs_orphan_cleanup(root);
+			up_read(&root->fs_info->cleanup_work_sem);
+		}
 		return inode;
 	}
 
-- 
1.5.4.3

