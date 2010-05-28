From: Dan Magenheimer <dan.magenheimer@oracle.com>
Subject: [PATCH V2 6/7] Cleancache (was Transcendent Memory): ext4 hook
Date: Fri, 28 May 2010 10:37:11 -0700
Message-ID: <20100528173711.GA20112__23466.2757291973$1275068382$gmane$org@ca-server1.us.oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: chris.mason@oracle.com, viro@zeniv.linux.org.uk,
	akpm@linux-foundation.org, adilger@sun.com, tytso@mit.edu,
	mfasheh@suse.com, joel.becker@oracle.com, matthew@wil.cx,
	linux-btrfs@vger.
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

[PATCH V2 6/7] Cleancache (was Transcendent Memory): ext4 hook

Filesystems must explicitly enable cleancache.  For ext4,
all other cleancache hooks are in the VFS layer.

Signed-off-by: Dan Magenheimer <dan.magenheimer@oracle.com>
Acked-by: Andreas Dilger <adilger@sun.com>

Diffstat:
 super.c                                  |    2 ++
 1 file changed, 2 insertions(+)

--- linux-2.6.34/fs/ext4/super.c	2010-05-16 15:17:36.000000000 -0600
+++ linux-2.6.34-cleancache/fs/ext4/super.c	2010-05-24 12:14:44.000000000 -0600
@@ -39,6 +39,7 @@
 #include <linux/ctype.h>
 #include <linux/log2.h>
 #include <linux/crc16.h>
+#include <linux/cleancache.h>
 #include <asm/uaccess.h>
 
 #include "ext4.h"
@@ -1784,6 +1785,7 @@ static int ext4_setup_super(struct super
 			EXT4_INODES_PER_GROUP(sb),
 			sbi->s_mount_opt);
 
+	sb->cleancache_poolid = cleancache_init_fs(PAGE_SIZE);
 	return res;
 }
 
