From: Dan Magenheimer <dan.magenheimer@oracle.com>
Subject: [PATCH V2 1/7] Cleancache (was Transcendent Memory):
	cleancache_poolid in superblock
Date: Fri, 28 May 2010 10:35:30 -0700
Message-ID: <20100528173530.GA12186__20067.1805687763$1275068448$gmane$org@ca-server1.us.oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: chris.mason@oracle.com, viro@zeniv.linux.org.uk,
	akpm@linux-foundation.org, adilger@sun.com, tytso@mit.edu,
	mfasheh@suse.com, joel.becker@oracle.com, matthew@wil.cx,
	linux-btrfs@vger.
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

[PATCH V2 1/7] Cleancache (was Transcendent Memory): cleancache_poolid in superblock

Add cleancache_poolid to superblock structure... not tied
to CONFIG_CLEANCACHE so as to avoid unnecessary clutter.

Signed-off-by: Dan Magenheimer <dan.magenheimer@oracle.com>

Diffstat:
 fs.h                                     |    5 +++++
 1 file changed, 5 insertions(+)

--- linux-2.6.34/include/linux/fs.h	2010-05-16 15:17:36.000000000 -0600
+++ linux-2.6.34-cleancache/include/linux/fs.h	2010-05-24 12:14:44.000000000 -0600
@@ -1383,6 +1383,11 @@ struct super_block {
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
