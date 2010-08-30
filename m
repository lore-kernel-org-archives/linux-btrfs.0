From: Tero Roponen <tero.roponen@gmail.com>
Subject: btrfs: Free correct pointer after using strsep
Date: Mon, 30 Aug 2010 16:14:06 +0300 (EEST)
Message-ID: <alpine.LFD.2.00.1008301609440.10601@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: chris.mason@oracle.com, josef@redhat.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

We must save and free the original kstrdup()'ed pointer
because strsep() modifies its first argument.

Signed-off-by: Tero Roponen <tero.roponen@gmail.com>

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 1776dbd..9e2c9ec 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -260,7 +260,7 @@ static int btrfs_parse_early_options(const char *options, fmode_t flags,
 		struct btrfs_fs_devices **fs_devices)
 {
 	substring_t args[MAX_OPT_ARGS];
-	char *opts, *p;
+	char *opts, *orig, *p;
 	int error = 0;
 	int intarg;
 
@@ -275,6 +275,8 @@ static int btrfs_parse_early_options(const char *options, fmode_t flags,
 	if (!opts)
 		return -ENOMEM;
 
+	orig = opts;
+
 	while ((p = strsep(&opts, ",")) != NULL) {
 		int token;
 		if (!*p)
@@ -309,7 +311,7 @@ static int btrfs_parse_early_options(const char *options, fmode_t flags,
 	}
 
  out_free_opts:
-	kfree(opts);
+	kfree(orig);
  out:
 	/*
 	 * If no subvolume name is specified we use the default one.  Allocate
