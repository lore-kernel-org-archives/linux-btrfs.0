Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f195.google.com ([209.85.223.195]:33438 "EHLO
        mail-io0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965474AbdAFDk7 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 5 Jan 2017 22:40:59 -0500
Received: by mail-io0-f195.google.com with SMTP id 71so4383130ioe.0
        for <linux-btrfs@vger.kernel.org>; Thu, 05 Jan 2017 19:40:59 -0800 (PST)
From: Nicholas D Steeves <nsteeves@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Nicholas D Steeves <nsteeves@gmail.com>
Subject: [PATCH] Fix spelling/typos in user-facing strings.
Date: Thu,  5 Jan 2017 22:40:47 -0500
Message-Id: <20170106034047.26632-2-nsteeves@gmail.com>
In-Reply-To: <20170106034047.26632-1-nsteeves@gmail.com>
References: <20170106034047.26632-1-nsteeves@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Nicholas D Steeves <nsteeves@gmail.com>
---
 Documentation/btrfs-device.asciidoc | 2 +-
 Documentation/btrfs-quota.asciidoc  | 4 ++--
 image/main.c                        | 2 +-
 mkfs/main.c                         | 2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/Documentation/btrfs-device.asciidoc b/Documentation/btrfs-device.asciidoc
index 58dc9b0..eedcac8 100644
--- a/Documentation/btrfs-device.asciidoc
+++ b/Documentation/btrfs-device.asciidoc
@@ -186,7 +186,7 @@ logial mappings).
 
 What changed:
 
-* available data space decreased by 3GiB, usable rougly (50 - 3) + (100 - 3) = 144 GiB
+* available data space decreased by 3GiB, usable roughly (50 - 3) + (100 - 3) = 144 GiB
 * metadata redundancy increased
 
 IOW, the unequal device sizes allow for combined space for data yet improved
diff --git a/Documentation/btrfs-quota.asciidoc b/Documentation/btrfs-quota.asciidoc
index 33c3bfd..77d4c68 100644
--- a/Documentation/btrfs-quota.asciidoc
+++ b/Documentation/btrfs-quota.asciidoc
@@ -16,7 +16,7 @@ of a btrfs filesystem. The quota groups (qgroups) are managed by the subcommand
 `btrfs qgroup`(8).
 
 NOTE: the qgroups are different than the traditional user quotas and designed
-to track shared and exlusive data per-subvolume.  Plese refer to the section
+to track shared and exclusive data per-subvolume.  Please refer to the section
 'HIERARCHICAL QUOTA GROUP CONCEPTS' for a detailed description.
 
 PERFORMANCE IMPLICATIONS
@@ -91,7 +91,7 @@ Qgroups of level 0 get created automatically when a subvolume/snapshot gets
 created.  The ID of the qgroup corresponds to the ID of the subvolume, so 0/5
 is the qgroup for the root subvolume.
 For the *btrfs qgroup* command, the path to the subvolume can also be used
-instead of '0/ID'.  For all higher levels, the ID can be choosen freely.
+instead of '0/ID'.  For all higher levels, the ID can be chosen freely.
 
 Each qgroup can contain a set of lower level qgroups, thus creating a hierarchy
 of qgroups. Figure 1 shows an example qgroup tree.
diff --git a/image/main.c b/image/main.c
index c464b65..58dcecb 100644
--- a/image/main.c
+++ b/image/main.c
@@ -2533,7 +2533,7 @@ static int restore_metadump(const char *input, FILE *out, int old_restore,
 	ret = mdrestore_init(&mdrestore, in, out, old_restore, num_threads,
 			     fixup_offset, info, multi_devices);
 	if (ret) {
-		error("failed to intialize metadata restore state: %d", ret);
+		error("failed to initialize metadata restore state: %d", ret);
 		goto failed_cluster;
 	}
 
diff --git a/mkfs/main.c b/mkfs/main.c
index 5756a72..8cdc74b 100644
--- a/mkfs/main.c
+++ b/mkfs/main.c
@@ -366,7 +366,7 @@ static void print_usage(int ret)
 	printf("\t-V|--version            print the mkfs.btrfs version and exit\n");
 	printf("\t--help                  print this help and exit\n");
 	printf("  deprecated:\n");
-	printf("\t-A|--alloc-start START  the offset to start the filesytem\n");
+	printf("\t-A|--alloc-start START  the offset to start the filesystem\n");
 	printf("\t-l|--leafsize SIZE      deprecated, alias for nodesize\n");
 	exit(ret);
 }
-- 
2.9.3

