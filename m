Return-Path: <SRS0=yZnd=N7=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70F04C18E01
	for <linux-btrfs@archiver.kernel.org>; Tue, 20 Nov 2018 12:51:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8DEBE206BB
	for <linux-btrfs@archiver.kernel.org>; Tue, 20 Nov 2018 12:51:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8DEBE206BB
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728170AbeKTXUR (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 20 Nov 2018 18:20:17 -0500
Received: from mx2.suse.de ([195.135.220.15]:44654 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728130AbeKTXUR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 20 Nov 2018 18:20:17 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id A6A53AF9C
        for <linux-btrfs@vger.kernel.org>; Tue, 20 Nov 2018 12:51:17 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 82C3FDA7C9; Tue, 20 Nov 2018 13:50:59 +0100 (CET)
From:   David Sterba <dsterba@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>
Subject: [PATCH 1/4] btrfs: reada: reorder dev-replace locks before radix tree preload
Date:   Tue, 20 Nov 2018 13:50:59 +0100
Message-Id: <f1539c9e96bbf5f2888286728aa342df030bfae1.1542717531.git.dsterba@suse.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <cover.1542717531.git.dsterba@suse.com>
References: <cover.1542717531.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

The read lock is going to use rw semaphore that might sleep, this is not
possible in the radix tree preload section. The lock nesting is now:

* device replace
  * radix tree preload
    * readahead spinlock

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/reada.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/reada.c b/fs/btrfs/reada.c
index dec14b739b10..6c4fdd98582d 100644
--- a/fs/btrfs/reada.c
+++ b/fs/btrfs/reada.c
@@ -376,26 +376,28 @@ static struct reada_extent *reada_find_extent(struct btrfs_fs_info *fs_info,
 		goto error;
 	}
 
+	/* insert extent in reada_tree + all per-device trees, all or nothing */
+	btrfs_dev_replace_read_lock(&fs_info->dev_replace);
 	ret = radix_tree_preload(GFP_KERNEL);
-	if (ret)
+	if (ret) {
+		btrfs_dev_replace_read_unlock(&fs_info->dev_replace);
 		goto error;
+	}
 
-	/* insert extent in reada_tree + all per-device trees, all or nothing */
-	btrfs_dev_replace_read_lock(&fs_info->dev_replace);
 	spin_lock(&fs_info->reada_lock);
 	ret = radix_tree_insert(&fs_info->reada_tree, index, re);
 	if (ret == -EEXIST) {
 		re_exist = radix_tree_lookup(&fs_info->reada_tree, index);
 		re_exist->refcnt++;
 		spin_unlock(&fs_info->reada_lock);
-		btrfs_dev_replace_read_unlock(&fs_info->dev_replace);
 		radix_tree_preload_end();
+		btrfs_dev_replace_read_unlock(&fs_info->dev_replace);
 		goto error;
 	}
 	if (ret) {
 		spin_unlock(&fs_info->reada_lock);
-		btrfs_dev_replace_read_unlock(&fs_info->dev_replace);
 		radix_tree_preload_end();
+		btrfs_dev_replace_read_unlock(&fs_info->dev_replace);
 		goto error;
 	}
 	radix_tree_preload_end();
-- 
2.19.1

