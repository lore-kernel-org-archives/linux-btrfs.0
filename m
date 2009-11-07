From: Sage Weil <sage@newdream.net>
Subject: [PATCH] Btrfs: fail mount on bad mount options
Date: Fri,  6 Nov 2009 22:19:16 -0800
Message-ID: <1257574756-13333-1-git-send-email-sage@newdream.net>
Cc: Sage Weil <sage@newdream.net>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

We shouldn't silently ignore unrecognized options.

Signed-off-by: Sage Weil <sage@newdream.net>
---
 fs/btrfs/super.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index ad4d378..73adcef 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -129,6 +129,7 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
 	substring_t args[MAX_OPT_ARGS];
 	char *p, *num;
 	int intarg;
+	int ret = 0;
 
 	if (!options)
 		return 0;
@@ -268,12 +269,18 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
 		case Opt_discard:
 			btrfs_set_opt(info->mount_opt, DISCARD);
 			break;
+		case Opt_err:
+			printk(KERN_INFO "btrfs: unrecognized mount option "
+			       "'%s'\n", p);
+			ret = -EINVAL;
+			goto out;
 		default:
 			break;
 		}
 	}
+out:
 	kfree(options);
-	return 0;
+	return ret;
 }
 
 /*
-- 
1.5.6.5

