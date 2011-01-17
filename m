From: Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH] Btrfs: fix memory leak in btrfs_parse_early_options()
Date: Mon, 17 Jan 2011 21:39:10 +0200
Message-ID: <20110117193910.GA26094@kwango.lan.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Chris Mason <chris.mason@oracle.com>, linux-kernel@vger.kernel.org
To: linux-btrfs@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

strsep() modifies the string pointer, therefore freeing it instead of
original one results in a small memory leak.  Fixes kmemleak warning.

Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 fs/btrfs/super.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 883c6fa..291b630 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -277,7 +277,7 @@ static int btrfs_parse_early_options(const char *options, fmode_t flags,
 		struct btrfs_fs_devices **fs_devices)
 {
 	substring_t args[MAX_OPT_ARGS];
-	char *opts, *p;
+	char *opts, *opts_orig, *p;
 	int error = 0;
 	int intarg;
 
@@ -288,7 +288,7 @@ static int btrfs_parse_early_options(const char *options, fmode_t flags,
 	 * strsep changes the string, duplicate it because parse_options
 	 * gets called twice
 	 */
-	opts = kstrdup(options, GFP_KERNEL);
+	opts = opts_orig = kstrdup(options, GFP_KERNEL);
 	if (!opts)
 		return -ENOMEM;
 
@@ -326,7 +326,7 @@ static int btrfs_parse_early_options(const char *options, fmode_t flags,
 	}
 
  out_free_opts:
-	kfree(opts);
+	kfree(opts_orig);
  out:
 	/*
 	 * If no subvolume name is specified we use the default one.  Allocate
-- 
1.7.2.3
