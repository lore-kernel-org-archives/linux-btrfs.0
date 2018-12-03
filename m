Return-Path: <SRS0=i+cT=OM=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C62BC04EB9
	for <linux-btrfs@archiver.kernel.org>; Mon,  3 Dec 2018 04:40:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EAEE820881
	for <linux-btrfs@archiver.kernel.org>; Mon,  3 Dec 2018 04:40:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EAEE820881
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725811AbeLCEkF (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 2 Dec 2018 23:40:05 -0500
Received: from mx2.suse.de ([195.135.220.15]:58766 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725806AbeLCEkF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 2 Dec 2018 23:40:05 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 895D2AD7A
        for <linux-btrfs@vger.kernel.org>; Mon,  3 Dec 2018 04:40:00 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs-progs: fsck-tests: Move reloc tree images to 020-extent-ref-cases
Date:   Mon,  3 Dec 2018 12:39:57 +0800
Message-Id: <20181203043957.17455-1-wqu@suse.com>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

For reloc tree, despite of its short lifespan, it's still the backref,
where reloc tree root backref points back to itself, makes it special.

So it's more approriate to put them into 020-extent-ref-cases.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 tests/fsck-tests/015-tree-reloc-tree/test.sh    |  16 ----------------
 tests/fsck-tests/020-extent-ref-cases/test.sh   |   5 +++++
 .../tree_reloc_for_data_reloc.img.xz            | Bin
 .../tree_reloc_for_fs_tree.img.xz               | Bin
 4 files changed, 5 insertions(+), 16 deletions(-)
 delete mode 100755 tests/fsck-tests/015-tree-reloc-tree/test.sh
 rename tests/fsck-tests/{015-tree-reloc-tree => 020-extent-ref-cases}/tree_reloc_for_data_reloc.img.xz (100%)
 rename tests/fsck-tests/{015-tree-reloc-tree => 020-extent-ref-cases}/tree_reloc_for_fs_tree.img.xz (100%)

diff --git a/tests/fsck-tests/015-tree-reloc-tree/test.sh b/tests/fsck-tests/015-tree-reloc-tree/test.sh
deleted file mode 100755
index 5d9d5122fd06..000000000000
--- a/tests/fsck-tests/015-tree-reloc-tree/test.sh
+++ /dev/null
@@ -1,16 +0,0 @@
-#!/bin/bash
-# Make sure btrfs check won't report any false alerts for valid image with
-# reloc tree.
-#
-# Also due to the short life span of reloc tree, save the as dump example for
-# later usage.
-
-source "$TEST_TOP/common"
-
-check_prereq btrfs
-
-check_image() {
-	run_check "$TOP/btrfs" check "$1"
-}
-
-check_all_images
diff --git a/tests/fsck-tests/020-extent-ref-cases/test.sh b/tests/fsck-tests/020-extent-ref-cases/test.sh
index a1bf75b14486..2f5a05cca4d4 100755
--- a/tests/fsck-tests/020-extent-ref-cases/test.sh
+++ b/tests/fsck-tests/020-extent-ref-cases/test.sh
@@ -14,6 +14,11 @@
 #   Containing a block group and its first extent at
 #   the beginning of leaf.
 #   Which caused false alert for lowmem mode.
+#
+# Special cases with some rare backref type
+# * reloc tree
+#   For both fs tree and data reloc tree.
+#   Special for its backref pointing to itself and its short life span.
 
 source "$TEST_TOP/common"
 
diff --git a/tests/fsck-tests/015-tree-reloc-tree/tree_reloc_for_data_reloc.img.xz b/tests/fsck-tests/020-extent-ref-cases/tree_reloc_for_data_reloc.img.xz
similarity index 100%
rename from tests/fsck-tests/015-tree-reloc-tree/tree_reloc_for_data_reloc.img.xz
rename to tests/fsck-tests/020-extent-ref-cases/tree_reloc_for_data_reloc.img.xz
diff --git a/tests/fsck-tests/015-tree-reloc-tree/tree_reloc_for_fs_tree.img.xz b/tests/fsck-tests/020-extent-ref-cases/tree_reloc_for_fs_tree.img.xz
similarity index 100%
rename from tests/fsck-tests/015-tree-reloc-tree/tree_reloc_for_fs_tree.img.xz
rename to tests/fsck-tests/020-extent-ref-cases/tree_reloc_for_fs_tree.img.xz
-- 
2.19.2

