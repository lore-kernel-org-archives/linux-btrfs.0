From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: handle the space_cache option properly
Date: Fri, 19 Nov 2010 08:40:41 -0500
Message-ID: <1290174041-8458-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

So when I added the clear_cache option I screwed up and took the break out of
the space_cache case statement, so whenever you mount with space_cache you also
get clear_cache, which does you no good if you say set space_cache in fstab so
it always gets set.  This patch adds the break back in properly.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/super.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 9145551..5bf03af 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -244,6 +244,7 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
 		case Opt_space_cache:
 			printk(KERN_INFO "btrfs: enabling disk space caching\n");
 			btrfs_set_opt(info->mount_opt, SPACE_CACHE);
+			break;
 		case Opt_clear_cache:
 			printk(KERN_INFO "btrfs: force clearing of disk cache\n");
 			btrfs_set_opt(info->mount_opt, CLEAR_CACHE);
-- 
1.6.6.1

