Return-Path: <SRS0=Zypw=MJ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E2AFC004D5
	for <linux-btrfs@archiver.kernel.org>; Thu, 27 Sep 2018 06:42:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 265522156E
	for <linux-btrfs@archiver.kernel.org>; Thu, 27 Sep 2018 06:42:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 265522156E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727187AbeI0M7c (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 27 Sep 2018 08:59:32 -0400
Received: from mx2.suse.de ([195.135.220.15]:38044 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727149AbeI0M7b (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 27 Sep 2018 08:59:31 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 609A4B146
        for <linux-btrfs@vger.kernel.org>; Thu, 27 Sep 2018 06:42:50 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH v4 5/7] btrfs: qgroup: Don't trace subtree if we're dropping reloc tree
Date:   Thu, 27 Sep 2018 14:42:33 +0800
Message-Id: <20180927064235.7432-6-wqu@suse.com>
X-Mailer: git-send-email 2.19.0
In-Reply-To: <20180927064235.7432-1-wqu@suse.com>
References: <20180927064235.7432-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Reloc tree doesn't contribute to qgroup numbers, as we have
accounted them at balance time (check replace_path()).

Skip such unneeded subtree trace should reduce some performance
overhead.

[[Benchmark]]
Hardware:
	VM 4G vRAM, 8 vCPUs,
	disk is using 'unsafe' cache mode,
	backing device is SAMSUNG 850 evo SSD.
	Host has 16G ram.

Mkfs parameter:
	--nodesize 4K (To bump up tree size)

Initial subvolume contents:
	4G data copied from /usr and /lib.
	(With enough regular small files)

Snapshots:
	16 snapshots of the original subvolume.
	each snapshot has 3 random files modified.

balance parameter:
	-m

So the content should be pretty similar to a real world root fs layout.

                     | v4.19-rc1    | w/ patchset    | diff (*)
---------------------------------------------------------------
relocated extents    | 22929        | 22900          | -0.1%
qgroup dirty extents | 227757       | 167139         | -26.6%
time (sys)           | 65.253s      | 50.123s        | -23.2%
time (real)          | 74.032s      | 52.551s        | -29.0%

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/extent-tree.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index de6f75f5547b..028d1a80d36f 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -8643,7 +8643,13 @@ static noinline int do_walk_down(struct btrfs_trans_handle *trans,
 			parent = 0;
 		}
 
-		if (need_account) {
+		/*
+		 * Reloc tree doesn't contribute to qgroup numbers, and we have
+		 * already accounted them at merge time (replace_path),
+		 * thus we could skip expensive subtree trace here.
+		 */
+		if (root->root_key.objectid != BTRFS_TREE_RELOC_OBJECTID &&
+		    need_account) {
 			ret = btrfs_qgroup_trace_subtree(trans, next,
 							 generation, level - 1);
 			if (ret) {
-- 
2.19.0

