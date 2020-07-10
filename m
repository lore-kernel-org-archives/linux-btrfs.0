Return-Path: <SRS0=n2qC=AV=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 988E6C433E2
	for <linux-btrfs@archiver.kernel.org>; Fri, 10 Jul 2020 17:18:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 77CCD2078D
	for <linux-btrfs@archiver.kernel.org>; Fri, 10 Jul 2020 17:18:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="uxBeYh9K";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="JGKIsvys"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727091AbgGJRSo (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 10 Jul 2020 13:18:44 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:43783 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726872AbgGJRSn (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 10 Jul 2020 13:18:43 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 5531F5C00E2;
        Fri, 10 Jul 2020 13:18:40 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Fri, 10 Jul 2020 13:18:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=from
        :to:cc:subject:date:message-id:in-reply-to:references
        :mime-version:content-transfer-encoding; s=fm1; bh=k2V5soKD5wxDi
        XhrpcnHMkghqzAWeYQ0bVgl0fbOtB0=; b=uxBeYh9K0gpr8q0WGj5F3kswJ++FA
        h+Zg26e3X17OeuwyTrJE2XS6yW5F5k1gB+Q4X034V72P4E3Cf7rsvweLiMUv8Ism
        G4fttM53A7r60v8rcGZI0DBWoflYe9TQ+8keL1ylCzMFwxbZcC1rCH2awZ6SUX8i
        euKwqLhC2ToW2BdubU8kPndNqArLRGc4Wxl6GoMcS2+63+9R4tIHIhqkixhgsYIz
        7D6YH8OW1UrRwH22N07peHGH+38u7CSniIUrNwbRHtlgCbTZKtMpAdBVVRxIID6x
        d7RPOXTuXZmH5nDshTNFLwFBDN+134ppSQWuXbPkexuAWNvdRTSPi0ghw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=k2V5soKD5wxDiXhrpcnHMkghqzAWeYQ0bVgl0fbOtB0=; b=JGKIsvys
        hFG6B7DvU9ExJVj+RL4Wo0uFUEYzpKriRUXmO9DgSojVsr3OEYoYeLN7Qn833Bxq
        1OeFg/oL1XFrfBk9rHnmszL2K0cXUhBaCJtfaNeHkfKYgtUMSAdLA0UIgj1OjKAz
        ynjGkPCzy04i117wIg+/h10PDmMC9r1tAeqLGeOVEShF91+F4gFnhMfOyVIZ+TST
        SQLZYl5yibp2mCJeYVEJ4I4/xGuvHWxFp3L5wOWpyslFxfPoSflGshmKiugzCZ9A
        R5zc2m/BtIoHWrJUNyUu6cFxEr7LW+WHzDXowrYzpQvi1y7c2fiYC9t+oAh3Ueyk
        3wCe3zc0krfcxg==
X-ME-Sender: <xms:76IIX2uUQmACsTCao1zkCXQ9n0cZZ7IVjXDlV1BBXOR-Q6OU5zEyUA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrvddugdduudehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhephffvufffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpeeuohhrihhs
    uceuuhhrkhhovhcuoegsohhrihhssegsuhhrrdhioheqnecuggftrfgrthhtvghrnhepie
    euffeuvdeiueejhfehiefgkeevudejjeejffevvdehtddufeeihfekgeeuheelnecukfhp
    peduieefrdduudegrddufedvrdefnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrg
    hmpehmrghilhhfrhhomhepsghorhhishessghurhdrihho
X-ME-Proxy: <xmx:76IIX7dvS7Kd2wUzhHv7CKisJqk08_z6ogHcMegBzVYxJrjAIlxHHg>
    <xmx:76IIXxxTkVYBzFz0xNSlTnOr3kkgzjvwh8J6wp5bfJDiyTyj7zVYVg>
    <xmx:76IIXxP3Ppdjan9vfhsnHLLyA23OVGBhgvgfR6kk9zNkFJb7kqxgjg>
    <xmx:8KIIX3JCUxQsI0d8ouKgyDpPl6CaiBc6NMa7UnYCnOW8sHqS_LFdtA>
Received: from localhost (unknown [163.114.132.3])
        by mail.messagingengine.com (Postfix) with ESMTPA id 313E6328005E;
        Fri, 10 Jul 2020 13:18:39 -0400 (EDT)
From:   Boris Burkov <boris@bur.io>
To:     Josef Bacik <josef@toxicpanda.com>, fstests@vger.kernel.org
Cc:     linux-btrfs@vger.kernel.org
Subject: [PATCH v2] generic: add a test for umount racing mount
Date:   Fri, 10 Jul 2020 10:18:36 -0700
Message-Id: <20200710171836.127889-1-boris@bur.io>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <c8bfc2c7-4c13-72e4-3665-c2e2dec99dd4@toxicpanda.com>
References: <c8bfc2c7-4c13-72e4-3665-c2e2dec99dd4@toxicpanda.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Test if dirtying many inodes (which can delay umount) then
unmounting and quickly mounting again causes the mount to fail.

A race, which breaks the test in btrfs, is fixed by the patch:
"btrfs: fix mount failure caused by race with umount"

Signed-off-by: Boris Burkov <boris@bur.io>
---
 tests/generic/603     | 52 +++++++++++++++++++++++++++++++++++++++++++
 tests/generic/603.out |  2 ++
 tests/generic/group   |  1 +
 3 files changed, 55 insertions(+)
 create mode 100755 tests/generic/603
 create mode 100644 tests/generic/603.out

diff --git a/tests/generic/603 b/tests/generic/603
new file mode 100755
index 00000000..e67899cb
--- /dev/null
+++ b/tests/generic/603
@@ -0,0 +1,52 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2020 Facebook  All Rights Reserved.
+#
+# FS QA Test 603
+#
+# Evicting dirty inodes can take a long time during umount.
+# Check that a new mount racing with such a delayed umount succeeds.
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
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+# remove previous $seqres.full before test
+rm -f $seqres.full
+
+# real QA test starts here
+
+# Modify as appropriate.
+_supported_fs generic
+_supported_os Linux
+_require_test
+
+_scratch_mkfs > /dev/null 2>&1
+_scratch_mount
+for i in $(seq 0 500)
+do
+	dd if=/dev/zero of="$SCRATCH_MNT/$i" bs=1M count=1 > /dev/null 2>&1
+done
+_scratch_unmount &
+_scratch_mount
+
+echo "Silence is golden"
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/603.out b/tests/generic/603.out
new file mode 100644
index 00000000..6810da89
--- /dev/null
+++ b/tests/generic/603.out
@@ -0,0 +1,2 @@
+QA output created by 603
+Silence is golden
diff --git a/tests/generic/group b/tests/generic/group
index d9ab9a31..c0ace35b 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -605,3 +605,4 @@
 600 auto quick quota
 601 auto quick quota
 602 auto quick encrypt
+603 auto quick
-- 
2.24.1

