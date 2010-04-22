From: Dan Magenheimer <dan.magenheimer@oracle.com>
Subject: Cleancache [PATCH 4/7] (was Transcendent Memory): ext3 hook
Date: Thu, 22 Apr 2010 06:28:49 -0700
Message-ID: <20100422132849.GA27333__32027.2766439759$1271943051$gmane$org@ca-server1.us.oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: chris.mason@oracle.com, viro@zeniv.linux.org.uk,
	akpm@linux-foundation.org, adilger@sun.com, tytso@mit.edu,
	mfasheh@suse.com, joel.becker@oracle.com, matthew@wil.cx,
	linux-btrfs@vger.
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

(Sorry for resend... Mail server DNS problems sending to some recipients)

Cleancache [PATCH 4/7] (was Transcendent Memory): ext3 hook

Filesystems must explicitly enable cleancache.  For ext3,
all other cleancache hooks are in the VFS layer.

Signed-off-by: Dan Magenheimer <dan.magenheimer@oracle.com>

Diffstat:
 super.c                                  |    2 ++
 1 file changed, 2 insertions(+)

--- linux-2.6.34-rc5/fs/ext3/super.c	2010-04-19 17:29:56.000000000 -0600
+++ linux-2.6.34-rc5-cleancache/fs/ext3/super.c	2010-04-21 10:06:48.000000000 -0600
@@ -37,6 +37,7 @@
 #include <linux/quotaops.h>
 #include <linux/seq_file.h>
 #include <linux/log2.h>
+#include <linux/cleancache.h>
 
 #include <asm/uaccess.h>
 
@@ -1344,6 +1345,7 @@ static int ext3_setup_super(struct super
 	} else {
 		ext3_msg(sb, KERN_INFO, "using internal journal");
 	}
+	sb->cleancache_poolid = cleancache_init_fs(PAGE_SIZE);
 	return res;
 }
 
