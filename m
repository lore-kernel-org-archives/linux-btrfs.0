Return-Path: <SRS0=cccy=PZ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31719C43387
	for <linux-btrfs@archiver.kernel.org>; Thu, 17 Jan 2019 07:49:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F3B6120855
	for <linux-btrfs@archiver.kernel.org>; Thu, 17 Jan 2019 07:49:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727143AbfAQHtP (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 17 Jan 2019 02:49:15 -0500
Received: from mx2.suse.de ([195.135.220.15]:54894 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725954AbfAQHtO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 17 Jan 2019 02:49:14 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id BF8CCAEC8;
        Thu, 17 Jan 2019 07:49:13 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Leonard Lausen <leonard@lausen.nl>
Subject: [PATCH 5/5] btrfs: Do mandatory tree block check before submitting bio
Date:   Thu, 17 Jan 2019 15:48:55 +0800
Message-Id: <20190117074855.24818-6-wqu@suse.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190117074855.24818-1-wqu@suse.com>
References: <20190117074855.24818-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

There are at least 2 reports about memory bit flip sneaking into on-disk
data.

Currently we only have a relaxed check triggered at
btrfs_mark_buffer_dirty() time, as it's not mandatory, only for
CONFIG_BTRFS_FS_CHECK_INTEGRITY enabled build.

This patch will address the hole by triggering comprehensive check on
tree blocks before writing it back to disk.

The timing is set to csum_tree_block() where @verify == 0.
At that timing, we're generation csum for tree blocks before submitting
the metadata bio, so we could avoid all the unnecessary calls at
btrfs_mark_buffer_dirty(), but still catch enough error.

The example error output will be something like:
  BTRFS critical (device dm-3): corrupt leaf: root=2 block=1350630375424 slot=68, bad key order, prev (10510212874240 169 0) current (1714119868416 169 0)
  BTRFS error (device dm-3): write time tree block corruption detected
  BTRFS critical (device dm-3): corrupt leaf: root=2 block=1350630375424 slot=68, bad key order, prev (10510212874240 169 0) current (1714119868416 169 0)
  BTRFS error (device dm-3): write time tree block corruption detected
  BTRFS: error (device dm-3) in btrfs_commit_transaction:2220: errno=-5 IO failure (Error while writing out transaction)
  BTRFS info (device dm-3): forced readonly
  BTRFS warning (device dm-3): Skipping commit of aborted transaction.
  BTRFS: error (device dm-3) in cleanup_transaction:1839: errno=-5 IO failure
  BTRFS info (device dm-3): delayed_refs has NO entry

Reported-by: Leonard Lausen <leonard@lausen.nl>
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/disk-io.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index bc2379cb2091..d95716847870 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -313,6 +313,15 @@ static int csum_tree_block(struct btrfs_fs_info *fs_info,
 			return -EUCLEAN;
 		}
 	} else {
+		if (btrfs_header_level(buf))
+			err = btrfs_check_node(fs_info, buf);
+		else
+			err = btrfs_check_leaf_full(fs_info, buf);
+		if (err < 0) {
+			btrfs_err(fs_info,
+				  "write time tree block corruption detected");
+			return err;
+		}
 		write_extent_buffer(buf, result, 0, csum_size);
 	}
 
-- 
2.20.1

