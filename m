Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53734 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727216AbeHGKdL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 7 Aug 2018 06:33:11 -0400
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 75E98ADB4
        for <linux-btrfs@vger.kernel.org>; Tue,  7 Aug 2018 08:19:58 +0000 (UTC)
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 09/11] btrfs-progs: mkfs: Introduce mkfs time quota support
Date: Tue,  7 Aug 2018 16:19:36 +0800
Message-Id: <20180807081938.21348-10-wqu@suse.com>
In-Reply-To: <20180807081938.21348-1-wqu@suse.com>
References: <20180807081938.21348-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The result fs will has quota enabled, with consistent qgroup accounting.

This is quite handy to test quota with fstests, which doesn't support to
call ioctl for btrfs at mount time.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 Documentation/mkfs.btrfs.asciidoc |  5 +++++
 mkfs/main.c                       | 16 +++++++++++++++-
 2 files changed, 20 insertions(+), 1 deletion(-)

diff --git a/Documentation/mkfs.btrfs.asciidoc b/Documentation/mkfs.btrfs.asciidoc
index 2a1c3592bcb4..821aad337ab5 100644
--- a/Documentation/mkfs.btrfs.asciidoc
+++ b/Documentation/mkfs.btrfs.asciidoc
@@ -81,6 +81,11 @@ updating the metadata blocks.
 +
 NOTE: versions up to 3.11 set the nodesize to 4k.
 
+*-Q|--quota*::
+Enable btrfs quota support. Result filesystem will have quota enabled and all
+qgroup accounting correct.
+See also `btrfs-quota`(8).
+
 *-s|--sectorsize <size>*::
 Specify the sectorsize, the minimum data block allocation unit.
 +
diff --git a/mkfs/main.c b/mkfs/main.c
index 07e5f6112aad..77eec08ef5f1 100644
--- a/mkfs/main.c
+++ b/mkfs/main.c
@@ -860,6 +860,7 @@ int main(int argc, char **argv)
 	char *source_dir = NULL;
 	bool source_dir_set = false;
 	bool shrink_rootdir = false;
+	bool enable_quota = false;
 	u64 source_dir_size = 0;
 	u64 min_dev_size;
 	u64 shrink_size;
@@ -889,13 +890,14 @@ int main(int argc, char **argv)
 			{ "nodiscard", no_argument, NULL, 'K' },
 			{ "features", required_argument, NULL, 'O' },
 			{ "uuid", required_argument, NULL, 'U' },
+			{ "quota", required_argument, NULL, 'Q' },
 			{ "quiet", 0, NULL, 'q' },
 			{ "shrink", no_argument, NULL, GETOPT_VAL_SHRINK },
 			{ "help", no_argument, NULL, GETOPT_VAL_HELP },
 			{ NULL, 0, NULL, 0}
 		};
 
-		c = getopt_long(argc, argv, "A:b:fl:n:s:m:d:L:O:r:U:VMKq",
+		c = getopt_long(argc, argv, "A:b:fl:n:s:m:d:L:O:r:U:VMKqQ",
 				long_options, NULL);
 		if (c < 0)
 			break;
@@ -970,6 +972,9 @@ int main(int argc, char **argv)
 			case 'q':
 				verbose = 0;
 				break;
+			case 'Q':
+				enable_quota = true;
+				break;
 			case GETOPT_VAL_SHRINK:
 				shrink_rootdir = true;
 				break;
@@ -1363,6 +1368,15 @@ raid_groups:
 		}
 	}
 
+	if (enable_quota) {
+		ret = setup_quota_root(fs_info);
+		if (ret < 0) {
+			error("failed to initialize quota: %d (%s)", ret,
+				strerror(-ret));
+			goto out;
+		}
+	}
+
 	if (verbose) {
 		char features_buf[64];
 
-- 
2.18.0

