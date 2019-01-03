Return-Path: <SRS0=cNHg=PL=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DF41C43387
	for <linux-btrfs@archiver.kernel.org>; Thu,  3 Jan 2019 23:22:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E6991208E3
	for <linux-btrfs@archiver.kernel.org>; Thu,  3 Jan 2019 23:22:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727236AbfACXW4 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 3 Jan 2019 18:22:56 -0500
Received: from mx2.suse.de ([195.135.220.15]:41910 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725931AbfACXWz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 3 Jan 2019 18:22:55 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 8D381B020
        for <linux-btrfs@vger.kernel.org>; Thu,  3 Jan 2019 23:22:53 +0000 (UTC)
From:   David Disseldorp <ddiss@suse.de>
To:     linux-btrfs@vger.kernel.org
Cc:     David Disseldorp <ddiss@suse.de>
Subject: [PATCH 1/1] btrfs-progs: btrfstune: print seeding status
Date:   Fri,  4 Jan 2019 00:22:39 +0100
Message-Id: <20190103232239.11931-2-ddiss@suse.de>
X-Mailer: git-send-email 2.13.7
In-Reply-To: <20190103232239.11931-1-ddiss@suse.de>
References: <20190103232239.11931-1-ddiss@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

btrfstune -s <dev> prints "Seeding flag is currently [un]set", based on
whether or not BTRFS_SUPER_FLAG_SEEDING is enabled for the given device.

Signed-off-by: David Disseldorp <ddiss@suse.de>
---
 Documentation/btrfstune.asciidoc |  3 +++
 btrfstune.c                      | 29 +++++++++++++++++++++++++++--
 2 files changed, 30 insertions(+), 2 deletions(-)

diff --git a/Documentation/btrfstune.asciidoc b/Documentation/btrfstune.asciidoc
index 27100964..992da95d 100644
--- a/Documentation/btrfstune.asciidoc
+++ b/Documentation/btrfstune.asciidoc
@@ -30,6 +30,9 @@ Enable seeding on a given device. Value 1 will enable seeding, 0 will disable it
 A seeding filesystem is forced to be mounted read-only. A new device can be added
 to the filesystem and will capture all writes keeping the seeding device intact.
 
+-s::
+Print whether or not seeding is enabled for a given device.
+
 -r::
 (since kernel: 3.7)
 +
diff --git a/btrfstune.c b/btrfstune.c
index 1e378ba1..603242b7 100644
--- a/btrfstune.c
+++ b/btrfstune.c
@@ -73,6 +73,15 @@ static int update_seeding_flag(struct btrfs_root *root, int set_flag)
 	return ret;
 }
 
+static void check_seeding_flag(struct btrfs_root *root)
+{
+	struct btrfs_super_block *disk_super = root->fs_info->super_copy;
+	u64 super_flags = btrfs_super_flags(disk_super);
+
+	printf("Seeding flag is currently %sset\n",
+	       (super_flags & BTRFS_SUPER_FLAG_SEEDING ? "" : "un"));
+}
+
 static int set_super_incompat_flags(struct btrfs_root *root, u64 flags)
 {
 	struct btrfs_trans_handle *trans;
@@ -374,6 +383,7 @@ static void print_usage(void)
 {
 	printf("usage: btrfstune [options] device\n");
 	printf("\t-S value\tpositive value will enable seeding, zero to disable, negative is not allowed\n");
+	printf("\t-s \t\tcheck whether seeding is enabled\n");
 	printf("\t-r \t\tenable extended inode refs\n");
 	printf("\t-x \t\tenable skinny metadata extent refs\n");
 	printf("\t-n \t\tenable no-holes feature (more efficient sparse file representation)\n");
@@ -390,6 +400,7 @@ int main(int argc, char *argv[])
 	int total = 0;
 	int seeding_flag = 0;
 	u64 seeding_value = 0;
+	int check_seeding = 0;
 	int random_fsid = 0;
 	char *new_fsid_str = NULL;
 	int ret;
@@ -401,7 +412,7 @@ int main(int argc, char *argv[])
 			{ "help", no_argument, NULL, GETOPT_VAL_HELP},
 			{ NULL, 0, NULL, 0 }
 		};
-		int c = getopt_long(argc, argv, "S:rxfuU:n", long_options, NULL);
+		int c = getopt_long(argc, argv, "S:srxfuU:n", long_options, NULL);
 
 		if (c < 0)
 			break;
@@ -410,6 +421,9 @@ int main(int argc, char *argv[])
 			seeding_flag = 1;
 			seeding_value = arg_strtou64(optarg);
 			break;
+		case 's':
+			check_seeding = 1;
+			break;
 		case 'r':
 			super_flags |= BTRFS_FEATURE_INCOMPAT_EXTENDED_IREF;
 			break;
@@ -448,7 +462,12 @@ int main(int argc, char *argv[])
 		error("random fsid can't be used with specified fsid");
 		return 1;
 	}
-	if (!super_flags && !seeding_flag && !(random_fsid || new_fsid_str)) {
+	if (seeding_flag && check_seeding) {
+		error("check seeding can't be used alongside set seeding");
+		return 1;
+	}
+	if (!super_flags && !seeding_flag && !check_seeding &&
+	    !(random_fsid || new_fsid_str)) {
 		error("at least one option should be specified");
 		print_usage();
 		return 1;
@@ -512,6 +531,12 @@ int main(int argc, char *argv[])
 		total++;
 	}
 
+	if (check_seeding) {
+		check_seeding_flag(root);
+		success++;
+		total++;
+	}
+
 	if (super_flags) {
 		ret = set_super_incompat_flags(root, super_flags);
 		if (!ret)
-- 
2.13.7

