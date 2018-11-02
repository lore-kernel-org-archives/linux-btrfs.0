Return-Path: <SRS0=Mp4+=NN=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,T_DKIMWL_WL_MED,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48A40C32789
	for <linux-btrfs@archiver.kernel.org>; Fri,  2 Nov 2018 21:30:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 112032082D
	for <linux-btrfs@archiver.kernel.org>; Fri,  2 Nov 2018 21:30:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=osandov-com.20150623.gappssmtp.com header.i=@osandov-com.20150623.gappssmtp.com header.b="d+cSrvbH"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 112032082D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=osandov.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728321AbeKCGjE (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 3 Nov 2018 02:39:04 -0400
Received: from mail-it1-f195.google.com ([209.85.166.195]:54686 "EHLO
        mail-it1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728294AbeKCGjE (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 3 Nov 2018 02:39:04 -0400
Received: by mail-it1-f195.google.com with SMTP id d6so5094395itl.4
        for <linux-btrfs@vger.kernel.org>; Fri, 02 Nov 2018 14:30:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=osandov-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ScrOuE0sHGud3TqjIk0wYm9JjwuLoYRgwGBWLEeghFQ=;
        b=d+cSrvbHunhqHHGIahRtY49sC9QMS4d52bivA0NfglmWHW/eSfwytswNx0Eytij7fS
         qjFIeWkE5PNaZzqw3rvGbU6707BE6bK5TUlVCf7zHr7IBqOr0Tdt2npfsvmpQ+DcD7Zu
         BSQAPC3r63MhHjZEMfGIaEW2at6Cxvx8HDBRUxu5+37mcfE40MOK/dv+PPM4UheSCwte
         oDOcrtiDoZ9QJgLLBTPikVjeKRNh9qIsbZnpmH2hhIesO2lDHAOWnfMXIZAF24gsJJgl
         EffcFHHYoN2g2+2vBLM6XXqR/Ir3a1rFlyuk/krE/1o/OviPw9cE6c4cpLN412ptB7og
         mQrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ScrOuE0sHGud3TqjIk0wYm9JjwuLoYRgwGBWLEeghFQ=;
        b=U2g3XH2mFCxtAkoy30+1Z7eonzADMQfQG7v5zKNksImh5yYkkZ8K9BoJ9czilXd5lh
         /HApXNZO9OxOqLAPGLkAW0Mub7gI562YTsNFcugD9Y/2ivXPgnLKnX1sIKhLdzbiMhz7
         q4FyShgHqmKMZ6EUf9pBNy81LR5NDQi+WsrJZuHMHS74klAnGz1UV/0/sP/Fz48fDIlh
         zpDCgmLUe3kVRHJoEFqRiectwMpWp2qUPZoUjhR4NVkuHKlpu3BygYUHknJB1dUJd92S
         qj8k40PiaSES1EqF0k0/XLpUhGNjSYM2mMDud8kIsMVIV+zVAwyxqs+lzSJCKQIBpMAs
         CK+g==
X-Gm-Message-State: AGRZ1gLro/mfxBHqG+lPqjV/r5hMQA9SvAyOq6BuaaZm0WeDe2mVZ4JK
        YrqjfUC6uS4AsDU7nG5+w97fxQ==
X-Google-Smtp-Source: AJdET5e2xsxdPh0B0fmkBe5iKF6aPbKWWpdxFQwGsnvTow2ARj+0uP0Xa0U12mA8+29FiprLWlTlYA==
X-Received: by 2002:a02:c8d8:: with SMTP id q24-v6mr12384724jao.20.1541194216748;
        Fri, 02 Nov 2018 14:30:16 -0700 (PDT)
Received: from vader.thefacebook.com ([2620:10d:c090:200::4:e24f])
        by smtp.gmail.com with ESMTPSA id n130-v6sm929419itb.36.2018.11.02.14.30.15
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 02 Nov 2018 14:30:16 -0700 (PDT)
From:   Omar Sandoval <osandov@osandov.com>
To:     fstests@vger.kernel.org
Cc:     kernel-team@fb.com, linux-btrfs@vger.kernel.org
Subject: [PATCH 6/7] btrfs: test device add/remove/replace with an active swap file
Date:   Fri,  2 Nov 2018 14:29:41 -0700
Message-Id: <e25fbb2fa868368febd346598a395fbe1f56f8e7.1541193856.git.osandov@fb.com>
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

Make sure that we don't remove or replace a device with an active swap
file but can add, remove, and replace other devices.

Signed-off-by: Omar Sandoval <osandov@fb.com>
---
 tests/btrfs/176     | 82 +++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/176.out |  5 +++
 tests/btrfs/group   |  1 +
 3 files changed, 88 insertions(+)
 create mode 100755 tests/btrfs/176
 create mode 100644 tests/btrfs/176.out

diff --git a/tests/btrfs/176 b/tests/btrfs/176
new file mode 100755
index 00000000..1e576149
--- /dev/null
+++ b/tests/btrfs/176
@@ -0,0 +1,82 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2018 Facebook.  All Rights Reserved.
+#
+# FS QA Test 176
+#
+# Test device remove/replace with an active swap file.
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
+_require_scratch_dev_pool 3
+_require_scratch_swapfile
+
+# We check the filesystem manually because we move devices around.
+rm -f "${RESULT_DIR}/require_scratch"
+
+scratch_dev1="$(echo "${SCRATCH_DEV_POOL}" | awk '{ print $1 }')"
+scratch_dev2="$(echo "${SCRATCH_DEV_POOL}" | awk '{ print $2 }')"
+scratch_dev3="$(echo "${SCRATCH_DEV_POOL}" | awk '{ print $3 }')"
+
+echo "Remove device"
+_scratch_mkfs >> $seqres.full 2>&1
+_scratch_mount
+_format_swapfile "$SCRATCH_MNT/swap" $(($(get_page_size) * 10))
+$BTRFS_UTIL_PROG device add -f "$scratch_dev2" "$SCRATCH_MNT"
+swapon "$SCRATCH_MNT/swap" 2>&1 | _filter_scratch
+# We know the swap file is on device 1 because we added device 2 after it was
+# already created.
+$BTRFS_UTIL_PROG device delete "$scratch_dev1" "$SCRATCH_MNT" 2>&1 | grep -o "Text file busy"
+# Deleting/readding device 2 should still work.
+$BTRFS_UTIL_PROG device delete "$scratch_dev2" "$SCRATCH_MNT"
+$BTRFS_UTIL_PROG device add -f "$scratch_dev2" "$SCRATCH_MNT"
+swapoff "$SCRATCH_MNT/swap" > /dev/null 2>&1
+# Deleting device 1 should work again after swapoff.
+$BTRFS_UTIL_PROG device delete "$scratch_dev1" "$SCRATCH_MNT"
+_scratch_unmount
+_check_scratch_fs "$scratch_dev2"
+
+echo "Replace device"
+_scratch_mkfs >> $seqres.full 2>&1
+_scratch_mount
+_format_swapfile "$SCRATCH_MNT/swap" $(($(get_page_size) * 10))
+$BTRFS_UTIL_PROG device add -f "$scratch_dev2" "$SCRATCH_MNT"
+swapon "$SCRATCH_MNT/swap" 2>&1 | _filter_scratch
+# Again, we know the swap file is on device 1.
+$BTRFS_UTIL_PROG replace start -fB "$scratch_dev1" "$scratch_dev3" "$SCRATCH_MNT" 2>&1 | grep -o "Text file busy"
+# Replacing device 2 should still work.
+$BTRFS_UTIL_PROG replace start -fB "$scratch_dev2" "$scratch_dev3" "$SCRATCH_MNT"
+swapoff "$SCRATCH_MNT/swap" > /dev/null 2>&1
+# Replacing device 1 should work again after swapoff.
+$BTRFS_UTIL_PROG replace start -fB "$scratch_dev1" "$scratch_dev2" "$SCRATCH_MNT"
+_scratch_unmount
+_check_scratch_fs "$scratch_dev2"
+
+# success, all done
+status=0
+exit
diff --git a/tests/btrfs/176.out b/tests/btrfs/176.out
new file mode 100644
index 00000000..5c99e0fd
--- /dev/null
+++ b/tests/btrfs/176.out
@@ -0,0 +1,5 @@
+QA output created by 176
+Remove device
+Text file busy
+Replace device
+Text file busy
diff --git a/tests/btrfs/group b/tests/btrfs/group
index b6160b72..3562420b 100644
--- a/tests/btrfs/group
+++ b/tests/btrfs/group
@@ -178,3 +178,4 @@
 173 auto quick swap
 174 auto quick swap
 175 auto quick swap
+176 auto quick swap
-- 
2.19.1

