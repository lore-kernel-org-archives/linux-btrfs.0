From: Dan Magenheimer <dan.magenheimer@oracle.com>
Subject: [PATCH V5 2/8] Cleancache: cleancache_poolid in superblock
Date: Fri, 3 Sep 2010 13:02:13 -0700
Message-ID: <20100903200212.GA4581__13753.4018526368$1283544273$gmane$org@ca-server1.us.oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: chris.mason@oracle.com, viro@zeniv.linux.org.uk,
	akpm@linux-foundation.org, adilger@sun.com, tytso@mit.edu,
	mfasheh@suse.com, joel.becker@oracle.com, matthew@wil.cx,
	linux-btrfs@vger.
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

[PATCH V5 2/8] Cleancache: cleancache_poolid in superblock

Add cleancache_poolid to superblock structure... not tied
to CONFIG_CLEANCACHE so as to avoid unnecessary clutter.

Signed-off-by: Dan Magenheimer <dan.magenheimer@oracle.com>

Diffstat:
 fs.h                                     |    5 +++++
 1 file changed, 5 insertions(+)

--- linux-2.6.36-rc3/include/linux/fs.h	2010-08-29 09:36:04.000000000 -0600
+++ linux-2.6.36-rc3-cleancache/include/linux/fs.h	2010-08-30 09:20:43.000000000 -0600
@@ -1381,6 +1381,11 @@ struct super_block {
 	 * generic_show_options()
 	 */
 	char *s_options;
+
+	/*
+	 * Saved pool identifier for cleancache (-1 means none)
+	 */
+	int cleancache_poolid;
 };
 
 extern struct timespec current_fs_time(struct super_block *sb);
