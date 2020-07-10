Return-Path: <SRS0=n2qC=AV=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85F1CC433E1
	for <linux-btrfs@archiver.kernel.org>; Fri, 10 Jul 2020 00:55:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 62E9E206A1
	for <linux-btrfs@archiver.kernel.org>; Fri, 10 Jul 2020 00:55:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="T9/vNilW";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="vgKHFjYR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726872AbgGJAzu (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 9 Jul 2020 20:55:50 -0400
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:33131 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726323AbgGJAzt (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 9 Jul 2020 20:55:49 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id 88BE5938;
        Thu,  9 Jul 2020 20:55:48 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Thu, 09 Jul 2020 20:55:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=from
        :to:cc:subject:date:message-id:mime-version
        :content-transfer-encoding; s=fm1; bh=ZwlewgXhWSiaDpDkNI0jbvccEq
        2hzhmG0lfnXLa2ewY=; b=T9/vNilW0gB4q/QQufCuLoY+g1EIWJJIkOblpfSi0T
        95ZdhCNm5NfblnuzL7XSTCLSEUYjuM9oQI7MCIRV4LdC10NI98QRnCCkT43vGpQ4
        uv2peplbIDYkevZxi2A+3w+pt2A69hS7EXNC6KT6HMFcZ8GExKEIblC6fAUo4oLv
        ggtxMaY93F8QH1v3Z4phc0A7Z2XePE8KN/nHTGNohsxRcoNkO48l0ICdIEU/TQC6
        4yOcx9NDXJwq4YZPCjNpsyQQbBbI8c5RukcqkkWmC10CoBzDAyVK0+KDf91WjIUo
        Z90Ks+oTKSS+Tz+eXAjyj8u7EQ0q5Ev5Zqyioiv1eD1A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=ZwlewgXhWSiaDpDkN
        I0jbvccEq2hzhmG0lfnXLa2ewY=; b=vgKHFjYRGQYcsXNPqWOOMLtkGgaJ7+TR1
        Bg/m9BuDf2jgaES0nLJWE0DQMzD8b07hxiNcGkz12RNRZIgVVqXFsrNTrdKw7+CZ
        jYiN65iZr6o3YpAyCx3bgz5mphBX8qsKP/eHUwS+aT47g/EAhdBlPpuxnB8+zdsG
        OA4vj1EPk4J5ABncighJcSmSTZGm1bf5etZC9j3dg9AWFFozW0n8VYIIMch0nabZ
        +c8ijNqUb5o8juM8D6KPkimjACIo4yFD2BVQp9BRNFTnustdNqJbJ1SUiUGOECfX
        nVE+iAl1xFDZhdENEOF+lDzOppIIP1p5TrTpZyNCE/+bLUG8rNO/w==
X-ME-Sender: <xms:k7wHX6rW6IwauGWVxVZM0mnmU71iwUBIKkFhTsLo3UEkYVlr-R-mdw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrvddtgdegtdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffoggfgsedtkeertdertd
    dtnecuhfhrohhmpeeuohhrihhsuceuuhhrkhhovhcuoegsohhrihhssegsuhhrrdhioheq
    necuggftrfgrthhtvghrnhepudeitdelueeijeefleffveelieefgfejjeeigeekuddute
    efkefffeethfdvjeevnecukfhppeduieefrdduudegrddufedvrdefnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepsghorhhishessghurhdrih
    ho
X-ME-Proxy: <xmx:k7wHX4o-rsgYoq5_wa_Qe2rkQxT6ltr8NbMoqMv0lhAU7FTVFo9_Xg>
    <xmx:k7wHX_P0-EhoaaHGpDv8LJNWGU1D-bczJ131v19OdiBqX3hIvcl5kA>
    <xmx:k7wHX54J-owz85sN7lWK8hv-1hfYL0JTaNCPBqJLfBMVFbRkS4xg-w>
    <xmx:lLwHX7GsOfCwe8-M2rdl6DPCyGxrff9_sfDYV9bQdGgJM1OzTlQb4w>
Received: from localhost (unknown [163.114.132.3])
        by mail.messagingengine.com (Postfix) with ESMTPA id 8E822328005D;
        Thu,  9 Jul 2020 20:55:47 -0400 (EDT)
From:   Boris Burkov <boris@bur.io>
To:     fstests@vger.kernel.org
Cc:     linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: add a test for umount racing mount
Date:   Thu,  9 Jul 2020 17:55:45 -0700
Message-Id: <20200710005545.1276395-1-boris@bur.io>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Test if dirtying many inodes, which delays the umount in `evict_inodes`,
then umounting and quickly mounting again causes the mount to fail.

This race is fixed by the patch:
"btrfs: fix mount failure caused by race with umount"

Signed-off-by: Boris Burkov <boris@bur.io>
---
 tests/btrfs/215     | 52 +++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/215.out |  2 ++
 tests/btrfs/group   |  1 +
 3 files changed, 55 insertions(+)
 create mode 100755 tests/btrfs/215
 create mode 100644 tests/btrfs/215.out

diff --git a/tests/btrfs/215 b/tests/btrfs/215
new file mode 100755
index 00000000..b142c2d6
--- /dev/null
+++ b/tests/btrfs/215
@@ -0,0 +1,52 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2020 YOUR NAME HERE.  All Rights Reserved.
+#
+# FS QA Test 215
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
+	do
+		  dd if=/dev/zero of="$SCRATCH_MNT/$i" bs=1M count=1 > /dev/null 2>&1
+		  done
+		  _scratch_unmount&
+		  _scratch_mount
+
+echo "Silence is golden"
+
+# success, all done
+status=0
+exit
diff --git a/tests/btrfs/215.out b/tests/btrfs/215.out
new file mode 100644
index 00000000..0a11773b
--- /dev/null
+++ b/tests/btrfs/215.out
@@ -0,0 +1,2 @@
+QA output created by 215
+Silence is golden
diff --git a/tests/btrfs/group b/tests/btrfs/group
index 505665b5..dda0763e 100644
--- a/tests/btrfs/group
+++ b/tests/btrfs/group
@@ -217,3 +217,4 @@
 212 auto balance dangerous
 213 auto balance dangerous
 214 auto quick send snapshot
+215 auto quick
-- 
2.24.1

