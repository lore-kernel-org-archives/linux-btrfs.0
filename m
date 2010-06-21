From: Dan Magenheimer <dan.magenheimer@oracle.com>
Subject: [PATCH V3 2/8] Cleancache: cleancache_poolid in superblock
Date: Mon, 21 Jun 2010 16:19:09 -0700
Message-ID: <20100621231909.GA19488__46907.2567219429$1277162415$gmane$org@ca-server1.us.oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: chris.mason@oracle.com, viro@zeniv.linux.org.uk,
	akpm@linux-foundation.org, adilger@sun.com, tytso@mit.edu,
	mfasheh@suse.com, joel.becker@oracle.com, matthew@wil.cx,
	linux-btrfs@vger.
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

[PATCH V3 2/8] Cleancache: cleancache_poolid in superblock

Add cleancache_poolid to superblock structure... not tied
to CONFIG_CLEANCACHE so as to avoid unnecessary clutter.

Signed-off-by: Dan Magenheimer <dan.magenheimer@oracle.com>

Diffstat:
 fs.h                                     |    5 +++++
 1 file changed, 5 insertions(+)

--- linux-2.6.35-rc2/include/linux/fs.h	2010-06-05 21:43:24.000000000 -0600
+++ linux-2.6.35-rc2-cleancache/include/linux/fs.h	2010-06-11 09:01:37.000000000 -0600
@@ -1382,6 +1382,11 @@ struct super_block {
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
