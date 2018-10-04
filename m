Return-Path: <SRS0=cN6C=MQ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1C2DC64EB8
	for <linux-btrfs@archiver.kernel.org>; Thu,  4 Oct 2018 21:30:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B2F9C2087D
	for <linux-btrfs@archiver.kernel.org>; Thu,  4 Oct 2018 21:30:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B2F9C2087D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=mendix.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727727AbeJEE0K (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 5 Oct 2018 00:26:10 -0400
Received: from smtp.dpl.mendix.net ([83.96.177.10]:45762 "EHLO
        smtp.dpl.mendix.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727089AbeJEE0K (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 5 Oct 2018 00:26:10 -0400
Received: from mekker.bofh.hq.mendix.net (mekker.bofh.hq.mendix.net [IPv6:2001:828:13c8:10b::21])
        by smtp.dpl.mendix.net (Postfix) with ESMTP id 1A9B82032C
        for <linux-btrfs@vger.kernel.org>; Thu,  4 Oct 2018 23:24:44 +0200 (CEST)
From:   Hans van Kranenburg <hans.van.kranenburg@mendix.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 3/6] btrfs: alloc_chunk: fix more DUP stripe size handling
Date:   Thu,  4 Oct 2018 23:24:40 +0200
Message-Id: <20181004212443.26519-4-hans.van.kranenburg@mendix.com>
X-Mailer: git-send-email 2.19.0.329.g76f2f5c1e3
In-Reply-To: <20181004212443.26519-1-hans.van.kranenburg@mendix.com>
References: <20181004212443.26519-1-hans.van.kranenburg@mendix.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Commit 92e222df7b "btrfs: alloc_chunk: fix DUP stripe size handling"
fixed calculating the stripe_size for a new DUP chunk.

However, the same calculation reappears a bit later, and that one was
not changed yet. The resulting bug that is exposed is that the newly
allocated device extents ('stripes') can have a few MiB overlap with the
next thing stored after them, which is another device extent or the end
of the disk.

The scenario in which this can happen is:
* The block device for the filesystem is less than 10GiB in size.
* The amount of contiguous free unallocated disk space chosen to use for
  chunk allocation is 20% of the total device size, or a few MiB more or
  less.

An example:
- The filesystem device is 7880MiB (max_chunk_size gets set to 788MiB)
- There's 1578MiB unallocated raw disk space left in one contiguous
  piece.

In this case stripe_size is first calculated as 789MiB, (half of
1578MiB).

Since 789MiB (stripe_size * data_stripes) > 788MiB (max_chunk_size), we
enter the if block. Now stripe_size value is immediately overwritten
while calculating an adjusted value based on max_chunk_size, which ends
up as 788MiB.

Next, the value is rounded up to a 16MiB boundary, 800MiB, which is
actually more than the value we had before. However, the last comparison
fails to detect this, because it's comparing the value with the total
amount of free space, which is about twice the size of stripe_size.

In the example above, this means that the resulting raw disk space being
allocated is 1600MiB, while only a gap of 1578MiB has been found. The
second device extent object for this DUP chunk will overlap for 22MiB
with whatever comes next.

The underlying problem here is that the stripe_size is reused all the
time for different things. So, when entering the code in the if block,
stripe_size is immediately overwritten with something else. If later we
decide we want to have the previous value back, then the logic to
compute it was copy pasted in again.

With this change, the value in stripe_size is not unnecessarily
destroyed, so the duplicated calculation is not needed any more.

Signed-off-by: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
---
 fs/btrfs/volumes.c | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 40fa85e68b1f..7045814fc98d 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -4763,19 +4763,16 @@ static int __btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 	/*
 	 * Use the number of data stripes to figure out how big this chunk
 	 * is really going to be in terms of logical address space,
-	 * and compare that answer with the max chunk size
+	 * and compare that answer with the max chunk size. If it's higher,
+	 * we try to reduce stripe_size.
 	 */
 	if (stripe_size * data_stripes > max_chunk_size) {
-		stripe_size = div_u64(max_chunk_size, data_stripes);
-
-		/* bump the answer up to a 16MB boundary */
-		stripe_size = round_up(stripe_size, SZ_16M);
-
-		/*
-		 * But don't go higher than the limits we found while searching
-		 * for free extents
+		/* Reduce stripe_size, round it up to a 16MB boundary
+		 * again and then use it, unless it ends up being even
+		 * bigger than the previous value we had already.
 		 */
-		stripe_size = min(devices_info[ndevs - 1].max_avail,
+		stripe_size = min(round_up(div_u64(max_chunk_size,
+						   data_stripes), SZ_16M),
 				  stripe_size);
 	}
 
-- 
2.19.0.329.g76f2f5c1e3

