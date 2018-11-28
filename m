Return-Path: <SRS0=CI8N=OH=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97A4AC04EB8
	for <linux-btrfs@archiver.kernel.org>; Wed, 28 Nov 2018 08:55:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5E9772086B
	for <linux-btrfs@archiver.kernel.org>; Wed, 28 Nov 2018 08:55:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5E9772086B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.de
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727683AbeK1Tz5 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 28 Nov 2018 14:55:57 -0500
Received: from mx2.suse.de ([195.135.220.15]:44814 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727667AbeK1Tz5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 28 Nov 2018 14:55:57 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 8B9E7AD52
        for <linux-btrfs@vger.kernel.org>; Wed, 28 Nov 2018 08:55:04 +0000 (UTC)
From:   Johannes Thumshirn <jthumshirn@suse.de>
To:     David Sterba <dsterba@suse.com>
Cc:     Linux BTRFS Mailinglist <linux-btrfs@vger.kernel.org>,
        Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH v2 3/3] btrfs: document extent mapping assumptions in checksum
Date:   Wed, 28 Nov 2018 09:54:56 +0100
Message-Id: <20181128085456.5702-4-jthumshirn@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20181128085456.5702-1-jthumshirn@suse.de>
References: <20181128085456.5702-1-jthumshirn@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Document why map_private_extent_buffer() cannot return '1' (i.e. the map
spans two pages) for the csum_tree_block() case.

The current algorithm for detecting a page boundary crossing in
map_private_extent_buffer() will return a '1' *IFF* the extent buffer's
offset in the page + the offset passed in by csum_tree_block() and the
minimal length passed in by csum_tree_block() - 1 are bigger than
PAGE_SIZE.

We always pass BTRFS_CSUM_SIZE (32) as offset and a minimal length of 32
and the current extent buffer allocator always guarantees page aligned
extends, so the above condition can't be true.

Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>

---
Changes to v1:
* Changed wording of the commit message according to Noah's suggestion
---
 fs/btrfs/disk-io.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 4bc270ef29b4..14d355d0cb7a 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -279,6 +279,12 @@ static int csum_tree_block(struct btrfs_fs_info *fs_info,
 
 	len = buf->len - offset;
 	while (len > 0) {
+		/*
+		 * Note: we don't need to check for the err == 1 case here, as
+		 * with the given combination of 'start = BTRFS_CSUM_SIZE (32)'
+		 * and 'min_len = 32' and the currently implemented mapping
+		 * algorithm we cannot cross a page boundary.
+		 */
 		err = map_private_extent_buffer(buf, offset, 32,
 					&kaddr, &map_start, &map_len);
 		if (err)
-- 
2.16.4

