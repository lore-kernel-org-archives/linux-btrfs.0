From: Jeff Liu <jeff.liu@oracle.com>
Subject: [PATCH] btrfs: trivial fix, a potential memory leak in btrfs_parse_early_options()
Date: Tue, 13 Sep 2011 14:06:05 +0800
Message-ID: <4E6EF2CD.3070302@oracle.com>
Reply-To: jeff.liu@oracle.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Jie Liu <jeff.liu@oracle.com>

---
  fs/btrfs/super.c |   10 ++++++++--
  1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 15634d4..16f31e1 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -406,7 +406,7 @@ static int btrfs_parse_early_options(const char 
*options, fmode_t flags,
          u64 *subvol_rootid, struct btrfs_fs_devices **fs_devices)
  {
      substring_t args[MAX_OPT_ARGS];
-    char *opts, *orig, *p;
+    char *device_name, *opts, *orig, *p;
      int error = 0;
      int intarg;

@@ -457,8 +457,14 @@ static int btrfs_parse_early_options(const char 
*options, fmode_t flags,
              }
              break;
          case Opt_device:
-            error = btrfs_scan_one_device(match_strdup(&args[0]),
+            device_name = match_strdup(&args[0]);
+            if (!device_name) {
+                error = -ENOMEM;
+                goto out_free_opts;
+            }
+            error = btrfs_scan_one_device(device_name,
                      flags, holder, fs_devices);
+            kfree(device_name);
              if (error)
                  goto out_free_opts;
              break;
-- 
1.7.4.1

