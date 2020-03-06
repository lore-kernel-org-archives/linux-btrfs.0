Return-Path: <SRS0=UWtY=4X=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0683C3F2D2
	for <linux-btrfs@archiver.kernel.org>; Fri,  6 Mar 2020 01:03:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BB6932073B
	for <linux-btrfs@archiver.kernel.org>; Fri,  6 Mar 2020 01:03:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=osandov-com.20150623.gappssmtp.com header.i=@osandov-com.20150623.gappssmtp.com header.b="C7Gww0GO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726359AbgCFBD2 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 5 Mar 2020 20:03:28 -0500
Received: from mail-pj1-f66.google.com ([209.85.216.66]:36742 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726173AbgCFBD2 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 5 Mar 2020 20:03:28 -0500
Received: by mail-pj1-f66.google.com with SMTP id l41so344584pjb.1
        for <linux-btrfs@vger.kernel.org>; Thu, 05 Mar 2020 17:03:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=osandov-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vA+SpwUYxV6vRuQ+sUl9N1NLNNbuEQF9yqQFgqr7THM=;
        b=C7Gww0GOzSj3xOmSTOh4izW4a5HkhOpgQuiZ8CtGAxGQ+b2XXL36MPgP5JJD1NixKA
         dVS4G4qBR6iKc1paTcLWSaqCQd/rkcR+zS9+DfrKL3MZ9LtHWYCXGOB3pB55zd9Yfsfy
         olgykuLveoAftsMWh8Nd56J4TSFteRKdEAqsx4miXh3vXRRa9Ss2lO5x5/hsTd3et9g1
         vXpgwJ4F62xDFU+uY9LEh4bWN2G947VeGzCI84ocypo05Gm0cYV96Z6g40AXE9ybj2vO
         s97zc1RUmjJxwvO/Urfk9l2SKEHp6/rTO3RNiGRnKavMVyDu7p/fCEpxeSIaCwXyFONZ
         fEwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vA+SpwUYxV6vRuQ+sUl9N1NLNNbuEQF9yqQFgqr7THM=;
        b=Og+ZZpjFDCKetRor0aw1anKKJUAPNAYVR5Srs9LYIUbfPlzmXAv1WtPwqy+YCrAh3T
         JNrQSNnjsQU6eAvH1M2yZQlQ69dl66XIKmqi1GsSSN4+0V9FN+v3jnNnsKTwkDdqMn4D
         oxzGlpxyPucmTFTk7FRuKa10+kMGY068g690wqRWKocp4K8bSG5xROdSemeG1xtS58XM
         lj/Skghrm1EzWDKKl224Y+yqIAdQn1mGPEzFJR4CkwJT4XHeidD8PQqCboT961BU4wRd
         Od6vlk5EK3qRmBCfKAtJffAFuXfa5G/qI8wHQWm4WAwQ7+4myrRM61ZYhB6nUXJluLne
         S75Q==
X-Gm-Message-State: ANhLgQ23pKmNYHA7srnxqOLSEeegBlq4+6ziU+tOJGEy2nss4SrLfbha
        VCnZrgkiU1pJ3zrMLbqAKmPvuOQ0cYE=
X-Google-Smtp-Source: ADFU+vsBZQWMQ8luyVx3nmTxCXxm1em3yc2F3s+TbbOziCV3EawqwE/wh7Tq9aWaRIcYA7c++mfhqg==
X-Received: by 2002:a17:902:8509:: with SMTP id bj9mr513698plb.123.1583456607128;
        Thu, 05 Mar 2020 17:03:27 -0800 (PST)
Received: from vader.tfbnw.net ([2620:10d:c090:400::5:7c97])
        by smtp.gmail.com with ESMTPSA id b64sm14863153pfa.94.2020.03.05.17.03.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Mar 2020 17:03:26 -0800 (PST)
From:   Omar Sandoval <osandov@osandov.com>
To:     fstests@vger.kernel.org, linux-btrfs@vger.kernel.org
Cc:     kernel-team@fb.com, Josef Bacik <josef@toxicpanda.com>
Subject: [PATCH v2] btrfs: add test for large direct I/O w/ RAID
Date:   Thu,  5 Mar 2020 17:03:12 -0800
Message-Id: <e55e1550e89c36dec53b487d7e0a73d6ece900e6.1583456541.git.osandov@fb.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Omar Sandoval <osandov@fb.com>

Apparently we don't have any tests which exercise the code path in Btrfs
that has to split up direct I/Os for RAID stripes. Add one to catch the
bug fixed by "btrfs: fix RAID direct I/O reads with alternate csums".

Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Omar Sandoval <osandov@fb.com>
---
Changes from v1 -> v2:

- Also test direct I/O writes.
- Add Josef's reviewed-by

 tests/btrfs/207     | 62 +++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/207.out |  2 ++
 tests/btrfs/group   |  3 ++-
 3 files changed, 66 insertions(+), 1 deletion(-)
 create mode 100755 tests/btrfs/207
 create mode 100644 tests/btrfs/207.out

diff --git a/tests/btrfs/207 b/tests/btrfs/207
new file mode 100755
index 00000000..d4467401
--- /dev/null
+++ b/tests/btrfs/207
@@ -0,0 +1,62 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2020 Facebook.  All Rights Reserved.
+#
+# FS QA Test 207
+#
+# Test large DIO reads and writes with various profiles. Regression test for
+# patch "btrfs: fix RAID direct I/O reads with alternate csums".
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
+_supported_fs btrfs
+_supported_os Linux
+# we check scratch dev after each loop
+_require_scratch_nocheck
+_require_scratch_dev_pool 4
+_btrfs_get_profile_configs
+
+for mkfs_opts in "${_btrfs_profile_configs[@]}"; do
+	echo "Test $mkfs_opts" >>$seqres.full
+	_scratch_pool_mkfs $mkfs_opts >>$seqres.full 2>&1
+	_scratch_mount >>$seqres.full 2>&1
+
+	dd if=/dev/urandom of="$SCRATCH_MNT/$seq" \
+		bs=1M count=64 conv=fsync status=none
+	dd if="$SCRATCH_MNT/$seq" of="$SCRATCH_MNT/$seq.dioread" \
+		bs=1M iflag=direct status=none
+	dd if="$SCRATCH_MNT/$seq" of="$SCRATCH_MNT/$seq.diowrite" \
+		bs=1M oflag=direct status=none
+	diff -q "$SCRATCH_MNT/$seq" "$SCRATCH_MNT/$seq.dioread" |
+		tee -a $seqres.full
+	diff -q "$SCRATCH_MNT/$seq" "$SCRATCH_MNT/$seq.diowrite" |
+		tee -a $seqres.full
+
+	_scratch_unmount
+	_check_scratch_fs
+done
+
+echo "Silence is golden"
+
+status=0
+exit
diff --git a/tests/btrfs/207.out b/tests/btrfs/207.out
new file mode 100644
index 00000000..cb8e0e2b
--- /dev/null
+++ b/tests/btrfs/207.out
@@ -0,0 +1,2 @@
+QA output created by 207
+Silence is golden
diff --git a/tests/btrfs/group b/tests/btrfs/group
index e3ad347b..c87a042e 100644
--- a/tests/btrfs/group
+++ b/tests/btrfs/group
@@ -208,4 +208,5 @@
 203 auto quick send clone
 204 auto quick punch
 205 auto quick clone compress
-204 auto quick log replay
+206 auto quick log replay
+207 auto quick rw raid
-- 
2.25.1

