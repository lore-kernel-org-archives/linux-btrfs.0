From: Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 1/1] FS: btrfs, use helpers for rlimits
Date: Tue, 15 Jun 2010 15:48:08 +0200
Message-ID: <1276609688-2117-1-git-send-email-jslaby@suse.cz>
Cc: linux-kernel@vger.kernel.org, jirislaby@gmail.com,
	Jiri Slaby <jslaby@suse.cz>, linux-btrfs@vger.kernel.org
To: chris.mason@oracle.com
Return-path: <linux-kernel-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Make sure compiler won't do weird things with limits. E.g. fetching
them twice may return 2 different values after writable limits are
implemented.

I.e. either use rlimit helpers added in
3e10e716abf3c71bdb5d86b8f507f9e72236c9cd
or ACCESS_ONCE if not applicable.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Chris Mason <chris.mason@oracle.com>
Cc: linux-btrfs@vger.kernel.org
---
 fs/btrfs/inode.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 44d404c..8f11078 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3576,8 +3576,7 @@ static int btrfs_setattr_size(struct inode *inode, struct iattr *attr)
 		return 0;
 
 	if (attr->ia_size > inode->i_size) {
-		unsigned long limit;
-		limit = current->signal->rlim[RLIMIT_FSIZE].rlim_cur;
+		unsigned long limit = rlimit(RLIMIT_FSIZE);
 		if (attr->ia_size > inode->i_sb->s_maxbytes)
 			return -EFBIG;
 		if (limit != RLIM_INFINITY && attr->ia_size > limit) {
-- 
1.7.1
