Return-Path: <SRS0=9zVn=MX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C22DAC32788
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 15:04:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 903F22075C
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 15:04:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 903F22075C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728078AbeJKWbm (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 11 Oct 2018 18:31:42 -0400
Received: from mx2.suse.de ([195.135.220.15]:50030 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727579AbeJKWbm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Oct 2018 18:31:42 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 77A0DB0C4
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Oct 2018 15:04:07 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 2/8] btrfstune: Rename change_header_uuid to change_buffer_header_uuid
Date:   Thu, 11 Oct 2018 18:03:58 +0300
Message-Id: <1539270244-27076-3-git-send-email-nborisov@suse.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1539270244-27076-1-git-send-email-nborisov@suse.com>
References: <1539270244-27076-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Rename the function so its name falls in line with the rest of btrfs
nomenclature. So when we change the uuid of the header it's in fact
of the buffer header. Also remove the root argument since it's used
solely to take a reference to fs_info which can be done via the
mandatory eb argument. No functional changes.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 btrfstune.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/btrfstune.c b/btrfstune.c
index 723317a00f3a..3745a00c46ae 100644
--- a/btrfstune.c
+++ b/btrfstune.c
@@ -91,9 +91,9 @@ static int set_super_incompat_flags(struct btrfs_root *root, u64 flags)
 	return ret;
 }
 
-static int change_header_uuid(struct btrfs_root *root, struct extent_buffer *eb)
+static int change_buffer_header_uuid(struct extent_buffer *eb)
 {
-	struct btrfs_fs_info *fs_info = root->fs_info;
+	struct btrfs_fs_info *fs_info = eb->fs_info;
 	int same_fsid = 1;
 	int same_chunk_tree_uuid = 1;
 	int ret;
@@ -157,7 +157,7 @@ static int change_extents_uuid(struct btrfs_fs_info *fs_info)
 			ret = PTR_ERR(eb);
 			goto out;
 		}
-		ret = change_header_uuid(root, eb);
+		ret = change_buffer_header_uuid(eb);
 		free_extent_buffer(eb);
 		if (ret < 0) {
 			error("failed to change uuid of tree block: %llu",
-- 
2.7.4

