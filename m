Return-Path: <SRS0=j6ri=4T=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9250CC3F2D2
	for <linux-btrfs@archiver.kernel.org>; Mon,  2 Mar 2020 04:55:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 65F5724697
	for <linux-btrfs@archiver.kernel.org>; Mon,  2 Mar 2020 04:55:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726845AbgCBEzQ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 1 Mar 2020 23:55:16 -0500
Received: from mx2.suse.de ([195.135.220.15]:41224 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726758AbgCBEzQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 1 Mar 2020 23:55:16 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 9CF29AEE9
        for <linux-btrfs@vger.kernel.org>; Mon,  2 Mar 2020 04:55:14 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH v2] btrfs-progs: disk-io: Kill the BUG_ON()s in write_and_map_eb()
Date:   Mon,  2 Mar 2020 12:55:09 +0800
Message-Id: <20200302045509.38573-1-wqu@suse.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

All callers of write_and_map_eb(), except btrfs-corrupt-block, have
handled error, but inside write_and_map_eb() itself, the only error handling
is BUG_ON().

This patch will kill all the BUG_ON()s inside write_and_map_eb(), and
enhance the the caller in btrfs-corrupt-block() to handle the error.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
Changelog:
v2:
- Remove one unrelated test hunk
- Fix the patch prefix
---
 btrfs-corrupt-block.c |  9 ++++++++-
 disk-io.c             | 26 +++++++++++++++++++++++---
 2 files changed, 31 insertions(+), 4 deletions(-)

diff --git a/btrfs-corrupt-block.c b/btrfs-corrupt-block.c
index 95df871a7822..3c236e146176 100644
--- a/btrfs-corrupt-block.c
+++ b/btrfs-corrupt-block.c
@@ -771,8 +771,15 @@ static int corrupt_metadata_block(struct btrfs_fs_info *fs_info, u64 block,
 		u64 bogus = generate_u64(orig);
 
 		btrfs_set_header_generation(eb, bogus);
-		write_and_map_eb(fs_info, eb);
+		ret = write_and_map_eb(fs_info, eb);
 		free_extent_buffer(eb);
+		if (ret < 0) {
+			errno = -ret;
+			fprintf(stderr,
+				"failed to write extent buffer at %llu: %m",
+				eb->start);
+			return ret;
+		}
 		break;
 		}
 	case BTRFS_METADATA_BLOCK_SHIFT_ITEMS:
diff --git a/disk-io.c b/disk-io.c
index e8a2e4afa93a..9ff62fcd54d1 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -487,20 +487,40 @@ int write_and_map_eb(struct btrfs_fs_info *fs_info, struct extent_buffer *eb)
 	length = eb->len;
 	ret = btrfs_map_block(fs_info, WRITE, eb->start, &length,
 			      &multi, 0, &raid_map);
+	if (ret < 0) {
+		errno = -ret;
+		error("failed to map bytenr %llu length %u: %m",
+			eb->start, eb->len);
+		goto out;
+	}
 
 	if (raid_map) {
 		ret = write_raid56_with_parity(fs_info, eb, multi,
 					       length, raid_map);
-		BUG_ON(ret);
+		if (ret < 0) {
+			errno = -ret;
+			error(
+		"failed to write raid56 stripe for bytenr %llu length %llu: %m",
+				eb->start, length);
+			goto out;
+		}
 	} else while (dev_nr < multi->num_stripes) {
-		BUG_ON(ret);
 		eb->fd = multi->stripes[dev_nr].dev->fd;
 		eb->dev_bytenr = multi->stripes[dev_nr].physical;
 		multi->stripes[dev_nr].dev->total_ios++;
 		dev_nr++;
 		ret = write_extent_to_disk(eb);
-		BUG_ON(ret);
+		if (ret < 0) {
+			errno = -ret;
+			error(
+"failed to write bytenr %llu length %u devid %llu dev_bytenr %llu: %m",
+				eb->start, eb->len,
+				multi->stripes[dev_nr].dev->devid,
+				eb->dev_bytenr);
+			goto out;
+		}
 	}
+out:
 	kfree(raid_map);
 	kfree(multi);
 	return 0;
-- 
2.25.1

