Return-Path: <SRS0=adn4=MN=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5491CC0044B
	for <linux-btrfs@archiver.kernel.org>; Mon,  1 Oct 2018 14:46:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 25AB720C0A
	for <linux-btrfs@archiver.kernel.org>; Mon,  1 Oct 2018 14:46:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 25AB720C0A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729559AbeJAVYj (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 1 Oct 2018 17:24:39 -0400
Received: from mx2.suse.de ([195.135.220.15]:42386 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729531AbeJAVYj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 1 Oct 2018 17:24:39 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id C1D85AF11
        for <linux-btrfs@vger.kernel.org>; Mon,  1 Oct 2018 14:46:27 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 08/10] btrfs-progs: check: Add support for freespace tree fixing
Date:   Mon,  1 Oct 2018 17:46:19 +0300
Message-Id: <1538405181-25231-9-git-send-email-nborisov@suse.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1538405181-25231-1-git-send-email-nborisov@suse.com>
References: <1538405181-25231-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Now that all the prerequisite code for proper support of free space
tree repair is in, it's time to wire it in. This is achieved by first
hooking the freespace tree to the __free_extent/alloc_reserved_tree_block
functions. And then introducing a wrapper function to contains the
existing check_space_cache and the newly introduced repair code.
Finally, it's important to note that FST repair code first clears the
existing FST in case of any problem found and rebuilds it from scratch.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 check/main.c | 47 ++++++++++++++++++++++++++++++-----------------
 1 file changed, 30 insertions(+), 17 deletions(-)

diff --git a/check/main.c b/check/main.c
index b361cd7e26a0..4daf85aad82c 100644
--- a/check/main.c
+++ b/check/main.c
@@ -5392,14 +5392,6 @@ static int check_space_cache(struct btrfs_root *root)
 	int ret;
 	int error = 0;
 
-	if (btrfs_super_cache_generation(root->fs_info->super_copy) != -1ULL &&
-	    btrfs_super_generation(root->fs_info->super_copy) !=
-	    btrfs_super_cache_generation(root->fs_info->super_copy)) {
-		printf("cache and super generation don't match, space cache "
-		       "will be invalidated\n");
-		return 0;
-	}
-
 	while (1) {
 		ctx.item_count++;
 		cache = btrfs_lookup_first_block_group(root->fs_info, start);
@@ -9417,7 +9409,6 @@ static int do_clear_free_space_cache(struct btrfs_fs_info *fs_info,
 			ret = 1;
 			goto close_out;
 		}
-		printf("Clearing free space cache\n");
 		ret = clear_free_space_cache(fs_info);
 		if (ret) {
 			error("failed to clear free space cache");
@@ -9444,6 +9435,35 @@ static int do_clear_free_space_cache(struct btrfs_fs_info *fs_info,
 	return ret;
 }
 
+static int validate_free_space_cache(struct btrfs_root *root)
+{
+
+	int ret;
+
+	if (btrfs_super_cache_generation(root->fs_info->super_copy) != -1ULL &&
+	    btrfs_super_generation(root->fs_info->super_copy) !=
+	    btrfs_super_cache_generation(root->fs_info->super_copy)) {
+		printf("cache and super generation don't match, space cache "
+		       "will be invalidated\n");
+		return 0;
+	}
+
+	ret = check_space_cache(root);
+	if (ret && btrfs_fs_compat_ro(global_info, FREE_SPACE_TREE)
+	    && repair) {
+		ret = do_clear_free_space_cache(global_info, 2);
+		if (ret)
+			goto out;
+
+		ret = btrfs_create_free_space_tree(global_info);
+		if (ret)
+			error("couldn't repair freespace tree");
+	}
+
+out:
+	return ret ? -EINVAL : 0;
+}
+
 const char * const cmd_check_usage[] = {
 	"btrfs check [options] <device>",
 	"Check structural integrity of a filesystem (unmounted).",
@@ -9877,16 +9897,9 @@ int cmd_check(int argc, char **argv)
 		task_start(ctx.info, &ctx.start_time, &ctx.item_count);
 	}
 
-	ret = check_space_cache(root);
+	ret = validate_free_space_cache(root);
 	task_stop(ctx.info);
 	err |= !!ret;
-	if (ret) {
-		if (is_free_space_tree)
-			error("errors found in free space tree");
-		else
-			error("errors found in free space cache");
-		goto out;
-	}
 
 	/*
 	 * We used to have to have these hole extents in between our real
-- 
2.7.4

