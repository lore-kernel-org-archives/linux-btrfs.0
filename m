Return-Path: <SRS0=/9qN=MK=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EC89C43382
	for <linux-btrfs@archiver.kernel.org>; Fri, 28 Sep 2018 02:04:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EE057216E3
	for <linux-btrfs@archiver.kernel.org>; Fri, 28 Sep 2018 02:04:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EE057216E3
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726505AbeI1I0M (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 28 Sep 2018 04:26:12 -0400
Received: from mx2.suse.de ([195.135.220.15]:58256 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726118AbeI1I0M (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 28 Sep 2018 04:26:12 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 34A87ABB1
        for <linux-btrfs@vger.kernel.org>; Fri, 28 Sep 2018 02:04:51 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH v2 1/6] btrfs-progs: print-tree: Skip deprecated blockptr / nodesize output
Date:   Fri, 28 Sep 2018 10:04:41 +0800
Message-Id: <20180928020446.21467-2-wqu@suse.com>
X-Mailer: git-send-email 2.19.0
In-Reply-To: <20180928020446.21467-1-wqu@suse.com>
References: <20180928020446.21467-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

When printing tree nodes, we output slots like:
key (EXTENT_TREE ROOT_ITEM 0) block 73625600 (17975) gen 16

The number in the parentheses is blockptr / nodesize.

However this number doesn't really do any thing useful.
And in fact for unaligned metadata block group (block group start bytenr
is not aligned to 16K), the number doesn't even make sense as it's
rounded down.

In factor kernel doesn't ever output such divided result in its
print-tree.c

Remove it so later reader won't wonder what the number means.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 print-tree.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/print-tree.c b/print-tree.c
index a09ecfbb28f0..31f6fa12522f 100644
--- a/print-tree.c
+++ b/print-tree.c
@@ -1420,9 +1420,8 @@ void btrfs_print_tree(struct extent_buffer *eb, int follow)
 		btrfs_disk_key_to_cpu(&key, &disk_key);
 		printf("\t");
 		btrfs_print_key(&disk_key);
-		printf(" block %llu (%llu) gen %llu\n",
+		printf(" block %llu gen %llu\n",
 		       (unsigned long long)blocknr,
-		       (unsigned long long)blocknr / eb->len,
 		       (unsigned long long)btrfs_node_ptr_generation(eb, i));
 		fflush(stdout);
 	}
-- 
2.19.0

