Return-Path: <SRS0=S1wN=N3=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D7D8C43441
	for <linux-btrfs@archiver.kernel.org>; Fri, 16 Nov 2018 07:54:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 030B4208E7
	for <linux-btrfs@archiver.kernel.org>; Fri, 16 Nov 2018 07:54:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 030B4208E7
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389417AbeKPSGA (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 16 Nov 2018 13:06:00 -0500
Received: from mx2.suse.de ([195.135.220.15]:46204 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727380AbeKPSGA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 16 Nov 2018 13:06:00 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 6D589ABDC
        for <linux-btrfs@vger.kernel.org>; Fri, 16 Nov 2018 07:54:44 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 7/9] btrfs-progs: Fix Wmaybe-uninitialized warning
Date:   Fri, 16 Nov 2018 15:54:24 +0800
Message-Id: <20181116075426.4142-8-wqu@suse.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20181116075426.4142-1-wqu@suse.com>
References: <20181116075426.4142-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

The only location is the following code:

	int level = path->lowest_level + 1;
 	BUG_ON(path->lowest_level + 1 >= BTRFS_MAX_LEVEL);
 	while(level < BTRFS_MAX_LEVEL) {
		slot = path->slots[level] + 1;
		...
	}
	path->slots[level] = slot;

Again, it's the stupid compiler needs some hint for the fact that
we will always enter the while loop for at least once, thus @slot should
always be initialized.

Fix it by assign level after the BUG_ON(), so the stupid compiler knows
we will always go into the while loop.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 ctree.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/ctree.c b/ctree.c
index 46e2ccedc0bf..9c9cb0dfdbf2 100644
--- a/ctree.c
+++ b/ctree.c
@@ -2961,11 +2961,12 @@ int btrfs_next_sibling_tree_block(struct btrfs_fs_info *fs_info,
 				  struct btrfs_path *path)
 {
 	int slot;
-	int level = path->lowest_level + 1;
+	int level;
 	struct extent_buffer *c;
 	struct extent_buffer *next = NULL;
 
 	BUG_ON(path->lowest_level + 1 >= BTRFS_MAX_LEVEL);
+	level = path->lowest_level + 1;
 	while(level < BTRFS_MAX_LEVEL) {
 		if (!path->nodes[level])
 			return 1;
-- 
2.19.1

