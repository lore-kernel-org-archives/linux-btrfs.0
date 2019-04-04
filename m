Return-Path: <SRS0=iUkD=SG=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7617C4360F
	for <linux-btrfs@archiver.kernel.org>; Thu,  4 Apr 2019 03:47:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C0CF62147C
	for <linux-btrfs@archiver.kernel.org>; Thu,  4 Apr 2019 03:47:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726968AbfDDDrZ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 3 Apr 2019 23:47:25 -0400
Received: from mx2.suse.de ([195.135.220.15]:37332 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726948AbfDDDrZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 3 Apr 2019 23:47:25 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 73519AE7A;
        Thu,  4 Apr 2019 03:47:24 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Leonard Lausen <leonard@lausen.nl>, David Sterba <dsterba@suse.com>
Subject: [PATCH 2/2] btrfs: Do mandatory tree block check before submitting bio
Date:   Thu,  4 Apr 2019 11:47:08 +0800
Message-Id: <20190404034708.3399-3-wqu@suse.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190404034708.3399-1-wqu@suse.com>
References: <20190404034708.3399-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

There are at least 2 reports about a memory bit flip sneaking into
on-disk data.

Currently we only have a relaxed check triggered at
btrfs_mark_buffer_dirty() time, as it's not mandatory and only for
CONFIG_BTRFS_FS_CHECK_INTEGRITY enabled build, it doesn't help users to
detect such problem.

This patch will address the hole by triggering comprehensive check on
tree blocks before writing it back to disk.

The design points are:

- Timing of the check: Tree block write hook
  This timing is chosen to reduce the overhead.
  The comprehensive check should be as expensive as a checksum
  calculation.
  Doing full check at btrfs_mark_buffer_dirty() is too expensive for end
  user.

- Loose empty leaf check
  Originally for an empty leaf, tree-checker will report error if it's
  not a tree root.

  The problem for such check at write time is:
  * False alert for tree root created in current transaction
    In that case, the commit root still needs to be written to disk.
    And since current root can differ from commit root, then it will
    cause false alert.
    This happens for log tree.

  * False alert for relocated tree block
    Relocated tree block can be written to disk due to memory pressure,
    in that case an empty csum tree root can be written to disk and
    cause false alert, since csum root node hasn't been updated.

  Previous patch of removing comprehensive empty leaf owner check has
  paved the way for this patch.

The example error output will be something like:

  BTRFS critical (device dm-3): corrupt leaf: root=2 block=1350630375424 slot=68, bad key order, prev (10510212874240 169 0) current (1714119868416 169 0)
  BTRFS error (device dm-3): block=1350630375424 write time tree block corruption detected
  BTRFS: error (device dm-3) in btrfs_commit_transaction:2220: errno=-5 IO failure (Error while writing out transaction)
  BTRFS info (device dm-3): forced readonly
  BTRFS warning (device dm-3): Skipping commit of aborted transaction.
  BTRFS: error (device dm-3) in cleanup_transaction:1839: errno=-5 IO failure
  BTRFS info (device dm-3): delayed_refs has NO entry

Reported-by: Leonard Lausen <leonard@lausen.nl>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/disk-io.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 0b2b75a7efbd..c2c0640aea55 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -514,6 +514,7 @@ static int csum_dirty_buffer(struct btrfs_fs_info *fs_info, struct page *page)
 	u8 result[BTRFS_CSUM_SIZE];
 	u16 csum_size = btrfs_super_csum_size(fs_info->super_copy);
 	struct extent_buffer *eb;
+	int err;
 
 	eb = (struct extent_buffer *)page->private;
 	if (page != eb->pages[0])
@@ -535,7 +536,19 @@ static int csum_dirty_buffer(struct btrfs_fs_info *fs_info, struct page *page)
 	if (csum_tree_block(eb, result))
 		return -EINVAL;
 
+	if (btrfs_header_level(eb))
+		err = btrfs_check_node(fs_info, eb);
+	else
+		err = btrfs_check_leaf_full(fs_info, eb);
+
+	if (err < 0) {
+		btrfs_err(fs_info,
+		"block=%llu write time tree block corruption detected",
+			  eb->start);
+		return err;
+	}
 	write_extent_buffer(eb, result, 0, csum_size);
+
 	return 0;
 }
 
-- 
2.21.0

