Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:24203 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S932607AbdDQD0z (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 16 Apr 2017 23:26:55 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>, <dsterba@suse.cz>
Subject: [PATCH 9/9] btrfs-progs: modify: Introduce option to specify the pattern to fill mirror
Date: Mon, 17 Apr 2017 11:26:42 +0800
Message-ID: <20170417032642.30770-10-quwenruo@cn.fujitsu.com>
In-Reply-To: <20170417032642.30770-1-quwenruo@cn.fujitsu.com>
References: <20170417032642.30770-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Introduce a new option, --pattern, to specify the pattern to fill
mirror.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 Documentation/btrfs-modify.asciidoc |  5 +++++
 modify/mirror.c                     | 11 ++++++++++-
 2 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/Documentation/btrfs-modify.asciidoc b/Documentation/btrfs-modify.asciidoc
index ae2ada65..d82fb0df 100644
--- a/Documentation/btrfs-modify.asciidoc
+++ b/Documentation/btrfs-modify.asciidoc
@@ -41,6 +41,11 @@ stripe number 1.
 P for RAID56 1st parity stripe. Only RAID5 and RAID6 support stripe number P.
 Q for RAID6 2nd parity stripe.
 
+--pattern <pattern>::::
+Specify to pattern to modify the mirror data5f536652.
++
+Default value is "0x66524842" (ascii "BHRf", part of the btrfs magic "_BHRfS_M").
+
 EXIT STATUS
 -----------
 *btrfs-modify* returns a zero exit status if all its operations succeed.
diff --git a/modify/mirror.c b/modify/mirror.c
index c89927f6..dd717fbe 100644
--- a/modify/mirror.c
+++ b/modify/mirror.c
@@ -373,13 +373,15 @@ int modify_mirror(int argc, char **argv)
 	char *device;
 	u64 length = (u64)-1;
 	u64 logical = (u64)-1;
+	u32 pattern = 0x66524842;
 	int stripe = STRIPE_UNINITILIZED;
 	int ret;
 
 	while (1) {
 		int c;
 		enum { GETOPT_VAL_LOGICAL = 257, GETOPT_VAL_LENGTH,
-			GETOPT_VAL_STRIPE, GETOPT_VAL_ROOT_INO_OFFSET };
+			GETOPT_VAL_STRIPE, GETOPT_VAL_ROOT_INO_OFFSET,
+			GETOPT_VAL_PATTERN };
 		static const struct option long_options[] = {
 			{ "logical", required_argument, NULL,
 				GETOPT_VAL_LOGICAL },
@@ -388,6 +390,8 @@ int modify_mirror(int argc, char **argv)
 			{ "stripe", required_argument, NULL, GETOPT_VAL_STRIPE },
 			{ "root-ino-offset", required_argument, NULL,
 				GETOPT_VAL_ROOT_INO_OFFSET},
+			{ "pattern", required_argument, NULL,
+				GETOPT_VAL_PATTERN},
 			{ NULL, 0, NULL, 0 }
 		};
 
@@ -407,6 +411,9 @@ int modify_mirror(int argc, char **argv)
 		case GETOPT_VAL_ROOT_INO_OFFSET:
 			parse_root_ino_offset(&dest, optarg);
 			break;
+		case GETOPT_VAL_PATTERN:
+			pattern = arg_strtou32(optarg);
+			break;
 		case '?':
 		case 'h':
 			usage(modify_mirror_usage);
@@ -439,6 +446,8 @@ int modify_mirror(int argc, char **argv)
 		stripe = 0;
 	}
 
+	memset(write_buf, pattern, sizeof(write_buf) / sizeof(pattern));
+
 	fs_info = open_ctree_fs_info(device, 0, 0, 0, OPEN_CTREE_WRITES);
 	if (!fs_info) {
 		error("failed to open btrfs on device %s\n", device);
-- 
2.12.2



