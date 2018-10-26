Return-Path: <SRS0=9Rtw=NG=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E28CECDE44
	for <linux-btrfs@archiver.kernel.org>; Fri, 26 Oct 2018 11:43:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6C343205F4
	for <linux-btrfs@archiver.kernel.org>; Fri, 26 Oct 2018 11:43:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6C343205F4
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727595AbeJZUUL (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 26 Oct 2018 16:20:11 -0400
Received: from mx2.suse.de ([195.135.220.15]:33546 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727491AbeJZUUL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 26 Oct 2018 16:20:11 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 1C5D5AEB7
        for <linux-btrfs@vger.kernel.org>; Fri, 26 Oct 2018 11:43:24 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 3/5] btrfs: Remove superfluous check form btrfs_remove_chunk
Date:   Fri, 26 Oct 2018 14:43:19 +0300
Message-Id: <1540554201-11305-4-git-send-email-nborisov@suse.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1540554201-11305-1-git-send-email-nborisov@suse.com>
References: <1540554201-11305-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

It's unnecessary to check map->stripes[i].dev for NULL given its value
is already set and dereferenced above the the check. No functional changes.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/volumes.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index dc53d94a62aa..f0db43d08456 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2797,13 +2797,11 @@ int btrfs_remove_chunk(struct btrfs_trans_handle *trans, u64 chunk_offset)
 			mutex_unlock(&fs_info->chunk_mutex);
 		}
 
-		if (map->stripes[i].dev) {
-			ret = btrfs_update_device(trans, map->stripes[i].dev);
-			if (ret) {
-				mutex_unlock(&fs_devices->device_list_mutex);
-				btrfs_abort_transaction(trans, ret);
-				goto out;
-			}
+		ret = btrfs_update_device(trans, device);
+		if (ret) {
+			mutex_unlock(&fs_devices->device_list_mutex);
+			btrfs_abort_transaction(trans, ret);
+			goto out;
 		}
 	}
 	mutex_unlock(&fs_devices->device_list_mutex);
-- 
2.7.4

