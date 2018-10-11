Return-Path: <SRS0=9zVn=MX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28BCAC677D7
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 15:04:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EA7382075C
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 15:04:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EA7382075C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728132AbeJKWbo (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 11 Oct 2018 18:31:44 -0400
Received: from mx2.suse.de ([195.135.220.15]:50066 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728120AbeJKWbn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Oct 2018 18:31:43 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 43FF9B030
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Oct 2018 15:04:09 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 8/8] btrfs-progs: Directly pass root to change_devices_uuid
Date:   Thu, 11 Oct 2018 18:04:04 +0300
Message-Id: <1539270244-27076-9-git-send-email-nborisov@suse.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1539270244-27076-1-git-send-email-nborisov@suse.com>
References: <1539270244-27076-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This function currently takes an fs_info only to reference the chunk
root. Just pass the root directly. No functional changes.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 btrfstune.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/btrfstune.c b/btrfstune.c
index d093d26f288c..81af11e9be60 100644
--- a/btrfstune.c
+++ b/btrfstune.c
@@ -310,9 +310,8 @@ static int change_device_uuid(struct extent_buffer *eb, int slot,
 	return ret;
 }
 
-static int change_devices_uuid(struct btrfs_fs_info *fs_info, uuid_t new_fsid)
+static int change_devices_uuid(struct btrfs_root *root, uuid_t new_fsid)
 {
-	struct btrfs_root *root = fs_info->chunk_root;
 	struct btrfs_path path;
 	struct btrfs_key key = {0, 0, 0};
 	int ret = 0;
@@ -439,7 +438,7 @@ static int change_uuid(struct btrfs_fs_info *fs_info, const char *new_fsid_str)
 
 	/* Then devices */
 	printf("Change fsid on devices\n");
-	ret = change_devices_uuid(fs_info, new_fsid);
+	ret = change_devices_uuid(fs_info->chunk_root, new_fsid);
 	if (ret < 0) {
 		error("failed to change UUID of devices: %d", ret);
 		goto out;
-- 
2.7.4

