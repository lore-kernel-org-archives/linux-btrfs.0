Return-Path: <SRS0=58CB=R4=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9654FC43381
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Mar 2019 18:46:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 71AEA20700
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Mar 2019 18:46:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730455AbfCYSqK (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 25 Mar 2019 14:46:10 -0400
Received: from mx2.suse.de ([195.135.220.15]:39256 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729478AbfCYSqI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 25 Mar 2019 14:46:08 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id BC638AF94
        for <linux-btrfs@vger.kernel.org>; Mon, 25 Mar 2019 18:46:07 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 3150ADA98F; Mon, 25 Mar 2019 19:47:21 +0100 (CET)
From:   David Sterba <dsterba@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>
Subject: [PATCH 29/30] btrfs: get fs_info from eb in read_one_chunk
Date:   Mon, 25 Mar 2019 19:47:21 +0100
Message-Id: <5cb373da86a6eb891d7607f650570ce2e95ecf76.1553539114.git.dsterba@suse.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <cover.1553539114.git.dsterba@suse.com>
References: <cover.1553539114.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

We can read fs_info from extent buffer and can drop it from the
parameters.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/volumes.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index de65029b8ad2..6bccc2ec42dd 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -7000,10 +7000,10 @@ static struct btrfs_fs_devices *open_seed_devices(struct btrfs_fs_info *fs_info,
 	return fs_devices;
 }
 
-static int read_one_dev(struct btrfs_fs_info *fs_info,
-			struct extent_buffer *leaf,
+static int read_one_dev(struct extent_buffer *leaf,
 			struct btrfs_dev_item *dev_item)
 {
+	struct btrfs_fs_info *fs_info = leaf->fs_info;
 	struct btrfs_fs_devices *fs_devices = fs_info->fs_devices;
 	struct btrfs_device *device;
 	u64 devid;
@@ -7333,7 +7333,7 @@ int btrfs_read_chunk_tree(struct btrfs_fs_info *fs_info)
 			struct btrfs_dev_item *dev_item;
 			dev_item = btrfs_item_ptr(leaf, slot,
 						  struct btrfs_dev_item);
-			ret = read_one_dev(fs_info, leaf, dev_item);
+			ret = read_one_dev(leaf, dev_item);
 			if (ret)
 				goto error;
 			total_dev++;
-- 
2.21.0

