From: Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH 09/12] Btrfs: Free correct pointer after using strsep
Date: Thu, 27 Jan 2011 16:45:10 +0800
Message-ID: <4D413096.30701@cn.fujitsu.com>
References: <4D412FE6.7050101@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
	Tero Roponen <tero.roponen@gmail.com>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4D412FE6.7050101@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

From: Tero Roponen <tero.roponen@gmail.com>

We must save and free the original kstrdup()'ed pointer
because strsep() modifies its first argument.

Signed-off-by: Tero Roponen <tero.roponen@gmail.com>
Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 fs/btrfs/super.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index f50253c..78ee681 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -277,7 +277,7 @@ static int btrfs_parse_early_options(const char *options, fmode_t flags,
 		struct btrfs_fs_devices **fs_devices)
 {
 	substring_t args[MAX_OPT_ARGS];
-	char *opts, *p;
+	char *opts, *orig, *p;
 	int error = 0;
 	int intarg;
 
@@ -291,6 +291,7 @@ static int btrfs_parse_early_options(const char *options, fmode_t flags,
 	opts = kstrdup(options, GFP_KERNEL);
 	if (!opts)
 		return -ENOMEM;
+	orig = opts;
 
 	while ((p = strsep(&opts, ",")) != NULL) {
 		int token;
@@ -326,7 +327,7 @@ static int btrfs_parse_early_options(const char *options, fmode_t flags,
 	}
 
  out_free_opts:
-	kfree(opts);
+	kfree(orig);
  out:
 	/*
 	 * If no subvolume name is specified we use the default one.  Allocate
-- 
1.6.3
