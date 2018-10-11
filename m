Return-Path: <SRS0=9zVn=MX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F719C32788
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 15:04:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4E3802075C
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 15:04:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4E3802075C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728110AbeJKWbm (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 11 Oct 2018 18:31:42 -0400
Received: from mx2.suse.de ([195.135.220.15]:50024 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727370AbeJKWbl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Oct 2018 18:31:41 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 351DDB030
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Oct 2018 15:04:07 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 1/8] btrfstune: Remove fs_info arg from change_device_uuid
Date:   Thu, 11 Oct 2018 18:03:57 +0300
Message-Id: <1539270244-27076-2-git-send-email-nborisov@suse.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1539270244-27076-1-git-send-email-nborisov@suse.com>
References: <1539270244-27076-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This function already takes an extent buffer that contains a reference
to the fs_info. Use that and reduce argument count. No functional
changes.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 btrfstune.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/btrfstune.c b/btrfstune.c
index 889b931c55d8..723317a00f3a 100644
--- a/btrfstune.c
+++ b/btrfstune.c
@@ -179,10 +179,10 @@ static int change_extents_uuid(struct btrfs_fs_info *fs_info)
 	return ret;
 }
 
-static int change_device_uuid(struct btrfs_fs_info *fs_info, struct extent_buffer *eb,
-			      int slot)
+static int change_device_uuid(struct extent_buffer *eb, int slot)
 {
 	struct btrfs_dev_item *di;
+	struct btrfs_fs_info *fs_info = eb->fs_info;
 	int ret = 0;
 
 	di = btrfs_item_ptr(eb, slot, struct btrfs_dev_item);
@@ -217,7 +217,7 @@ static int change_devices_uuid(struct btrfs_fs_info *fs_info)
 		if (key.type != BTRFS_DEV_ITEM_KEY ||
 		    key.objectid != BTRFS_DEV_ITEMS_OBJECTID)
 			goto next;
-		ret = change_device_uuid(fs_info, path.nodes[0], path.slots[0]);
+		ret = change_device_uuid(path.nodes[0], path.slots[0]);
 		if (ret < 0)
 			goto out;
 next:
-- 
2.7.4

