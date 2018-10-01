Return-Path: <SRS0=adn4=MN=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29DF7C43143
	for <linux-btrfs@archiver.kernel.org>; Mon,  1 Oct 2018 14:46:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EBC0A20C0A
	for <linux-btrfs@archiver.kernel.org>; Mon,  1 Oct 2018 14:46:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EBC0A20C0A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729561AbeJAVYm (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 1 Oct 2018 17:24:42 -0400
Received: from mx2.suse.de ([195.135.220.15]:42396 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729540AbeJAVYj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 1 Oct 2018 17:24:39 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 10D64AF12
        for <linux-btrfs@vger.kernel.org>; Mon,  1 Oct 2018 14:46:28 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 09/10] btrfs-progs: tests: Test for FST corruption detection/repair
Date:   Mon,  1 Oct 2018 17:46:20 +0300
Message-Id: <1538405181-25231-10-git-send-email-nborisov@suse.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1538405181-25231-1-git-send-email-nborisov@suse.com>
References: <1538405181-25231-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Simple test case which preps a filesystem, then corrupts the FST and
finally repairs it. Tests both extent based and bitmap based FSTs.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 tests/fsck-tests/036-freespacetree-repair/test.sh | 76 +++++++++++++++++++++++
 1 file changed, 76 insertions(+)
 create mode 100755 tests/fsck-tests/036-freespacetree-repair/test.sh

diff --git a/tests/fsck-tests/036-freespacetree-repair/test.sh b/tests/fsck-tests/036-freespacetree-repair/test.sh
new file mode 100755
index 000000000000..8c91ce9dedbc
--- /dev/null
+++ b/tests/fsck-tests/036-freespacetree-repair/test.sh
@@ -0,0 +1,76 @@
+#!/bin/bash
+# Corrupt a filesystem that is using freespace tree and then ensure that
+# btrfs check is able to repair it. This tests correct detection/repair of
+# both a FREE_SPACE_EXTENT based FST and a FREE_SPACE_BITMAP based FST.
+
+source "$TEST_TOP/common"
+
+# wrapper for btrfs-corrupt-item
+# $1: Type of item we want to corrupt - extent or bitmap
+corrupt_fst_item()
+{
+	local type
+	local objectid
+	local offset
+	type="$1"
+
+	if [[ $type == "bitmap" ]]; then
+		type=200
+		objectid=$("$TOP/btrfs" inspect-internal dump-tree -t 10 "$TEST_DEV" | \
+			grep -o "[[:digit:]]* FREE_SPACE_BITMAP [[:digit:]]*" | \
+			cut -d' ' -f1 | tail -2 | head -1)
+		offset=$("$TOP/btrfs" inspect-internal dump-tree -t 10 "$TEST_DEV" | \
+			grep -o "[[:digit:]]* FREE_SPACE_BITMAP [[:digit:]]*" | \
+			cut -d' ' -f3 |tail -2 | head -1)
+		echo "Corrupting $objectid,FREE_SPACE_BITMAP,$offset" >> "$RESULTS"
+	elif [[ $type == "extent" ]]; then
+		type=199
+		objectid=$("$TOP/btrfs" inspect-internal dump-tree -t 10 "$TEST_DEV" | \
+			grep -o "[[:digit:]]* FREE_SPACE_EXTENT [[:digit:]]*" | \
+			cut -d' ' -f1 | tail -2 | head -1)
+		offset=$("$TOP/btrfs" inspect-internal dump-tree -t 10 "$TEST_DEV" | \
+			grep -o "[[:digit:]]* FREE_SPACE_EXTENT [[:digit:]]*" | \
+			cut -d' ' -f3 | tail -2 | head -1)
+		echo "Corrupting $objectid,FREE_SPACE_EXTENT,$offset" >> "$RESULTS"
+	else
+		_fail "Unknown item type for corruption"
+	fi
+
+	run_check "$TOP/btrfs-corrupt-block" -r 10 -K "$objectid,$type,$offset" \
+		-f offset "$TEST_DEV"
+}
+
+check_prereq btrfs
+check_prereq mkfs.btrfs
+check_global_prereq grep
+check_global_prereq tail
+check_global_prereq head
+check_global_prereq cut
+
+setup_root_helper
+prepare_test_dev 256M
+
+run_check "$TOP/mkfs.btrfs" -n 4k -f "$TEST_DEV"
+run_check_mount_test_dev -oclear_cache,space_cache=v2
+
+#create files which will populate the FST
+for i in {1..3000}; do
+	fallocate -l 4k "$TEST_MNT/file.$i"
+done
+
+run_check_umount_test_dev
+
+#now corrupt one of the bitmap items
+corrupt_fst_item "bitmap"
+check_image "$TEST_DEV"
+
+# change the freespace such that we now have at least one free_space_extent
+# object
+run_check_mount_test_dev
+rm -rf "$TEST_MNT/file.*"
+fallocate -l 50m "$TEST_MNT/file"
+run_check_umount_test_dev
+
+#now corrupt an extent
+corrupt_fst_item "extent"
+check_image "$TEST_DEV"
-- 
2.7.4

