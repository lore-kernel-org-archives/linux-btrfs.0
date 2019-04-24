Return-Path: <SRS0=IMPl=S2=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF3FAC10F11
	for <linux-btrfs@archiver.kernel.org>; Wed, 24 Apr 2019 07:22:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8828D20685
	for <linux-btrfs@archiver.kernel.org>; Wed, 24 Apr 2019 07:22:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729712AbfDXHW6 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 24 Apr 2019 03:22:58 -0400
Received: from mx2.suse.de ([195.135.220.15]:50268 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725913AbfDXHW6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 24 Apr 2019 03:22:58 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id ECAC1ADE1
        for <linux-btrfs@vger.kernel.org>; Wed, 24 Apr 2019 07:22:56 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: tree-checker: Allow error injection for tree-checker
Date:   Wed, 24 Apr 2019 15:22:53 +0800
Message-Id: <20190424072253.4979-1-wqu@suse.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Allowing error injection for btrfs_check_leaf_full() and
btrfs_check_node() is useful to test the failure path of btrfs write
time tree check.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/tree-checker.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
index b9dd2a6e133f..9c22a1fe38c1 100644
--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -15,6 +15,7 @@
  * carefully reviewed otherwise so it does not prevent mount of valid images.
  */
 
+#include <linux/error-injection.h>
 #include "ctree.h"
 #include "tree-checker.h"
 #include "disk-io.h"
@@ -942,6 +943,7 @@ int btrfs_check_leaf_full(struct extent_buffer *leaf)
 {
 	return check_leaf(leaf, true);
 }
+ALLOW_ERROR_INJECTION(btrfs_check_leaf_full, ERRNO);
 
 int btrfs_check_leaf_relaxed(struct extent_buffer *leaf)
 {
@@ -1005,3 +1007,4 @@ int btrfs_check_node(struct extent_buffer *node)
 out:
 	return ret;
 }
+ALLOW_ERROR_INJECTION(btrfs_check_node, ERRNO);
-- 
2.21.0

