Return-Path: <SRS0=oOJ3=QZ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C63DC43381
	for <linux-btrfs@archiver.kernel.org>; Mon, 18 Feb 2019 10:29:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 184EB20C01
	for <linux-btrfs@archiver.kernel.org>; Mon, 18 Feb 2019 10:29:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729765AbfBRK3C (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 18 Feb 2019 05:29:02 -0500
Received: from mx2.suse.de ([195.135.220.15]:38984 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727307AbfBRK3B (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 18 Feb 2019 05:29:01 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 991C8AAA9;
        Mon, 18 Feb 2019 10:29:00 +0000 (UTC)
From:   Johannes Thumshirn <jthumshirn@suse.de>
To:     David Sterba <dsterba@suse.com>
Cc:     Linux BTRFS Mailinglist <linux-btrfs@vger.kernel.org>,
        Nikolay Borisov <nborisov@suse.com>, Qu Wenruo <wqu@suse.com>,
        Hans van Kranenburg <Hans.van.Kranenburg@mendix.com>,
        Johannes Thumshirn <jthumshirn@suse.de>,
        Liu Bo <obuil.liubo@gmail.com>
Subject: [PATCH v2.1] btrfs: ensure that a DUP or RAID1 block group has exactly two stripes
Date:   Mon, 18 Feb 2019 11:28:37 +0100
Message-Id: <20190218102837.15219-1-jthumshirn@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <210585b9-99e9-1548-f2b1-66445ab179bb@suse.de>
References: <210585b9-99e9-1548-f2b1-66445ab179bb@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

We recently had a customer issue with a corrupted filesystem. When trying
to mount this image btrfs panicked with a division by zero in
calc_stripe_length().

The corrupt chunk had a 'num_stripes' value of 1. calc_stripe_length()
takes this value and divides it by the number of copies the RAID profile is
expected to have to calculate the amount of data stripes. As a DUP profile
is expected to have 2 copies this division resulted in 1/2 = 0. Later then
the 'data_stripes' variable is used as a divisor in the stripe length
calculation which results in a division by 0 and thus a kernel panic.

When encountering a filesystem with a DUP block group and a 'num_stripes'
value unequal to 2, refuse mounting as the image is corrupted and will lead
to unexpected behaviour.

Code inspection showed a RAID1 block group has the same issues.

Fixes: e06cd3dd7cea ("Btrfs: add validadtion checks for chunk loading")
Cc: Liu Bo <obuil.liubo@gmail.com>
Reviewed-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: Nikolay Borisov <nborisov@suse.com>
Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
---
Changes to v2:
- Really use 2 stripes not 1 (Hans)
Changes to v1:
- Also add the check for RAID1 (Hans)
---
 fs/btrfs/volumes.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 03f223aa7194..9024eee889b9 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -6791,10 +6791,10 @@ static int btrfs_check_chunk_valid(struct btrfs_fs_info *fs_info,
 	}
 
 	if ((type & BTRFS_BLOCK_GROUP_RAID10 && sub_stripes != 2) ||
-	    (type & BTRFS_BLOCK_GROUP_RAID1 && num_stripes < 1) ||
+	    (type & BTRFS_BLOCK_GROUP_RAID1 && num_stripes != 2) ||
 	    (type & BTRFS_BLOCK_GROUP_RAID5 && num_stripes < 2) ||
 	    (type & BTRFS_BLOCK_GROUP_RAID6 && num_stripes < 3) ||
-	    (type & BTRFS_BLOCK_GROUP_DUP && num_stripes > 2) ||
+	    (type & BTRFS_BLOCK_GROUP_DUP && num_stripes != 2) ||
 	    ((type & BTRFS_BLOCK_GROUP_PROFILE_MASK) == 0 &&
 	     num_stripes != 1)) {
 		btrfs_err(fs_info,
-- 
2.16.4

