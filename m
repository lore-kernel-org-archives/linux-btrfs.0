Return-Path: <SRS0=/x7k=OG=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD49FC04EBA
	for <linux-btrfs@archiver.kernel.org>; Tue, 27 Nov 2018 16:00:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 757F9208E4
	for <linux-btrfs@archiver.kernel.org>; Tue, 27 Nov 2018 16:00:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 757F9208E4
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.de
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730434AbeK1C6n (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 27 Nov 2018 21:58:43 -0500
Received: from mx2.suse.de ([195.135.220.15]:54480 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730421AbeK1C6n (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 27 Nov 2018 21:58:43 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id BA9BAAF8A
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Nov 2018 16:00:20 +0000 (UTC)
From:   Johannes Thumshirn <jthumshirn@suse.de>
To:     David Sterba <dsterba@suse.com>
Cc:     Linux BTRFS Mailinglist <linux-btrfs@vger.kernel.org>,
        Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH 3/3] btrfs: document extent mapping assumptions in checksum
Date:   Tue, 27 Nov 2018 17:00:10 +0100
Message-Id: <20181127160010.18123-4-jthumshirn@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20181127160010.18123-1-jthumshirn@suse.de>
References: <20181127160010.18123-1-jthumshirn@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Document why map_private_extent_buffer() cannot return '1' (i.e. the map
spans two pages) for the csum_tree_block() case.

The current algorithm for detecting a page boundary crossing in
map_private_extent_buffer() will return a '1' *IFF* the product of the
extent buffer's offset in the page + the offset passed in by
csum_tree_block() and the minimal length passed in by csum_tree_block() - 1
are bigger than PAGE_SIZE.

We always pass BTRFS_CSUM_SIZE (32) as offset and a minimal length of 32
and the current extent buffer allocator always guarantees page aligned
extends, so the above condition can't be true.

Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
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

