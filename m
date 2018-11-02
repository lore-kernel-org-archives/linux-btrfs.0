Return-Path: <SRS0=Mp4+=NN=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,T_DKIMWL_WL_MED,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94FF3C32789
	for <linux-btrfs@archiver.kernel.org>; Fri,  2 Nov 2018 21:30:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 52EB22082D
	for <linux-btrfs@archiver.kernel.org>; Fri,  2 Nov 2018 21:30:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=osandov-com.20150623.gappssmtp.com header.i=@osandov-com.20150623.gappssmtp.com header.b="CWkXexCu"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 52EB22082D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=osandov.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728326AbeKCGjF (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 3 Nov 2018 02:39:05 -0400
Received: from mail-it1-f196.google.com ([209.85.166.196]:38465 "EHLO
        mail-it1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728322AbeKCGjF (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 3 Nov 2018 02:39:05 -0400
Received: by mail-it1-f196.google.com with SMTP id k141-v6so3261637itk.3
        for <linux-btrfs@vger.kernel.org>; Fri, 02 Nov 2018 14:30:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=osandov-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6cGVZs5ipFV2C2zFWLLEGyUdHu2+6/U98A9UMPDkDlM=;
        b=CWkXexCu7Bxl4UHPiobq1boVMFwt+q+3IhdZxivEj+AWnzI8i2yE0NM5dEelZmqdo+
         yldrsugjhek2RocQkoFCC/I7pR8VGzRZNFCuuSQ4oIjUyDCgiArkAoZMM1Hveb3iF6l7
         eFvb76X7y6eShj6iISgzX8CPpuNU7GxfT1qG1Ut2JoQrgz8Nk8GVmS9uVoCa4UvWFTv3
         nqMBN+GvsuD5IFgRag44imZwW1WJyaQvhsZmvUs9tXBQ23peYX/sPAPmSCJHIUBU6pHs
         ohs5vK1x5vlqZoKvZbOY1CIAYjabdUu2vRL7+0z+X+NgzFYhoJMN45GOEWAd/LyLiju5
         0Y+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6cGVZs5ipFV2C2zFWLLEGyUdHu2+6/U98A9UMPDkDlM=;
        b=Z4390ni2NpoYf9jXLQ4SHDkZPHdm+/4Rz6iDLTek2FpPyjJU0VsH6J1W9JmjYvyOv3
         iBqfGH0NUBmv90f2Q2xmJqWTOgqqUUZ4edRoTSwE2yG26SbGBzJOvMcaiT0eVVOurcic
         RgsovXHo1AzpglAXJq+5ZbHUqq/uQpEM18MoGMCXrMAmomaO8gMRMKO9KdITAkIrqKbr
         xM2ILFhIUKpQ5oA+mbZaNOkCBa/x3DPhghYWMc4iJLJY+xRQnaeBYOqgaM38CVjVvi7o
         NTH0Z1pX++YomJMAs5qMUfDZ/KBt0FE/eilFTFcj6JBBHfzQAvuPPCpAP96aC9G6TG7e
         mYWQ==
X-Gm-Message-State: AGRZ1gK7GIoWAlatI4SLhizTHPyHMXYiOazF1dY8S/IhJ3+e1JtI2PpS
        stHbfqmtQlmUbEBsH9VjVVyLoEzG1RE=
X-Google-Smtp-Source: AJdET5f0lXUgq0BvIyCfrZ2t0kSoskfrI4h/VpwB/RwYqTkVdMc8y222QAIhxBEVyq+5rUmCTJx6NA==
X-Received: by 2002:a02:b699:: with SMTP id i25-v6mr12087120jam.117.1541194217901;
        Fri, 02 Nov 2018 14:30:17 -0700 (PDT)
Received: from vader.thefacebook.com ([2620:10d:c090:200::4:e24f])
        by smtp.gmail.com with ESMTPSA id n130-v6sm929419itb.36.2018.11.02.14.30.16
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 02 Nov 2018 14:30:17 -0700 (PDT)
From:   Omar Sandoval <osandov@osandov.com>
To:     fstests@vger.kernel.org
Cc:     kernel-team@fb.com, linux-btrfs@vger.kernel.org
Subject: [PATCH 7/7] btrfs: test balance and resize with an active swap file
Date:   Fri,  2 Nov 2018 14:29:42 -0700
Message-Id: <e6656ec218c973d548803ed50a45c8d3f81fe388.1541193856.git.osandov@fb.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <cover.1541193856.git.osandov@fb.com>
References: <cover.1541193856.git.osandov@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Omar Sandoval <osandov@fb.com>

Make sure we don't shrink the device past an active swap file, but allow
shrinking otherwise, as well as growing and balance.

Signed-off-by: Omar Sandoval <osandov@fb.com>
---
 tests/btrfs/177     | 64 +++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/177.out |  6 +++++
 tests/btrfs/group   |  1 +
 3 files changed, 71 insertions(+)
 create mode 100755 tests/btrfs/177
 create mode 100644 tests/btrfs/177.out

diff --git a/tests/btrfs/177 b/tests/btrfs/177
new file mode 100755
index 00000000..12dad8fc
--- /dev/null
+++ b/tests/btrfs/177
@@ -0,0 +1,64 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2018 Facebook.  All Rights Reserved.
+#
+# FS QA Test 177
+#
+# Test relocation (balance and resize) with an active swap file.
+#
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+	cd /
+	rm -f $tmp.*
+}
+
+. ./common/rc
+. ./common/filter
+. ./common/btrfs
+
+rm -f $seqres.full
+
+# Modify as appropriate.
+_supported_fs generic
+_supported_os Linux
+_require_scratch_swapfile
+
+swapfile="$SCRATCH_MNT/swap"
+
+# First, create a 1GB filesystem and fill it up.
+_scratch_mkfs_sized $((1024 * 1024 * 1024)) >> $seqres.full 2>&1
+_scratch_mount
+dd if=/dev/zero of="$SCRATCH_MNT/fill" bs=1024k >> $seqres.full 2>&1
+# Now add more space and create a swap file. We know that the first 1GB of the
+# filesystem was used, so the swap file must be in the new part of the
+# filesystem.
+$BTRFS_UTIL_PROG filesystem resize 2G "$SCRATCH_MNT" | _filter_scratch
+_format_swapfile "$swapfile" $((32 * 1024 * 1024))
+swapon "$swapfile"
+# Add even more space which we know is unused.
+$BTRFS_UTIL_PROG filesystem resize 3G "$SCRATCH_MNT" | _filter_scratch
+# Free up the first 1GB of the filesystem.
+rm -f "$SCRATCH_MNT/fill"
+# Get rid of empty block groups and also make sure that balance skips block
+# groups containing active swap files.
+_run_btrfs_balance_start "$SCRATCH_MNT"
+# Shrink away the unused space.
+$BTRFS_UTIL_PROG filesystem resize 2G "$SCRATCH_MNT" | _filter_scratch
+# Try to shrink away the area occupied by the swap file, which should fail.
+$BTRFS_UTIL_PROG filesystem resize 1G "$SCRATCH_MNT" 2>&1 | grep -o "Text file busy"
+swapoff "$swapfile"
+# It should work again after swapoff.
+$BTRFS_UTIL_PROG filesystem resize 1G "$SCRATCH_MNT" | _filter_scratch
+_scratch_unmount
+
+status=0
+exit
diff --git a/tests/btrfs/177.out b/tests/btrfs/177.out
new file mode 100644
index 00000000..6ced01da
--- /dev/null
+++ b/tests/btrfs/177.out
@@ -0,0 +1,6 @@
+QA output created by 177
+Resize 'SCRATCH_MNT' of '2G'
+Resize 'SCRATCH_MNT' of '3G'
+Resize 'SCRATCH_MNT' of '2G'
+Text file busy
+Resize 'SCRATCH_MNT' of '1G'
diff --git a/tests/btrfs/group b/tests/btrfs/group
index 3562420b..0b62e58a 100644
--- a/tests/btrfs/group
+++ b/tests/btrfs/group
@@ -179,3 +179,4 @@
 174 auto quick swap
 175 auto quick swap
 176 auto quick swap
+177 auto quick swap
-- 
2.19.1

