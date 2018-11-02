Return-Path: <SRS0=Mp4+=NN=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,T_DKIMWL_WL_MED,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECE30C32789
	for <linux-btrfs@archiver.kernel.org>; Fri,  2 Nov 2018 21:30:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AEFF32082D
	for <linux-btrfs@archiver.kernel.org>; Fri,  2 Nov 2018 21:30:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=osandov-com.20150623.gappssmtp.com header.i=@osandov-com.20150623.gappssmtp.com header.b="acKuu1FW"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AEFF32082D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=osandov.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728290AbeKCGjB (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 3 Nov 2018 02:39:01 -0400
Received: from mail-it1-f195.google.com ([209.85.166.195]:50232 "EHLO
        mail-it1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726100AbeKCGjB (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 3 Nov 2018 02:39:01 -0400
Received: by mail-it1-f195.google.com with SMTP id k206-v6so5123179ite.0
        for <linux-btrfs@vger.kernel.org>; Fri, 02 Nov 2018 14:30:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=osandov-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7WJ4Yqbj2Id5SCHuIySXT6D3UoIlfHfJgVX+bIhu2CE=;
        b=acKuu1FW1q8iICIi57YZm4lbNU5C1tMQ1KM/JfJVpMgfcGDNpm3SIW8UOQCRrgHgFo
         qszCUyJZeNonZM4akztNJw3q9qpgALqm++CMfF/0oIFbs+nBFpotEYuZGV5QLJbSpElV
         PnILCXHbPXfbl8vs1Gjp1of6lziYumJ0PHo56i4A/4dCQ1UYsc46LP87WKW57VmUTEv4
         BKgaxbZF5x80DFHYIAY0uP7T3rrWeZeWIKdRrI7eG41o53qPnsN4Uw1TAcI/mRHdVwEu
         CBhOGOW+Sz2jbHLDcSJUf1URQVGUBIVzIldG8tTEa02o7XS30EmUCASBBJC9GwxYgoCi
         ihMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7WJ4Yqbj2Id5SCHuIySXT6D3UoIlfHfJgVX+bIhu2CE=;
        b=s7baiZbeBCaFWoU8MUntpUnCnM3IxncE6vr24xRfgdDbEpCBdfV2bl0dmR0wEaZnlz
         WhWG9Hhq51yxB7ujIpeIXAaJkPcpk542x4c+6+keHA7VGx5ptwRnUibVDvzFWMdfFQbP
         kliR8h/2T+sU+39KZf2qFinyT0FtftNkvPyocgizwN4T50IY26Y+rjv2jT9OMOXLB/aA
         qEoRJMDAbZkkEIT2+feSXQClxwXRvP5DbQUEy6cCFyPDFmbNiibdT+N7zxwuM2+OyHoI
         gQpXEgwEYvjEQRiep3PrLLGJWqWDPp1YppIm9KKLEV7O7u3cV/q7aEu+olh+knvmsf6z
         h9VA==
X-Gm-Message-State: AGRZ1gJgE9eKUK97LpWUM5E2uQpdaAY5aoymoRBn2cL4uiZjPKq5Fj9p
        WmiisOyKBDoavysoY7N+GzRoiQ==
X-Google-Smtp-Source: AJdET5cXSIhZPLiJAiJzgJJH1ixD0D4wRC2Ssju9newr+8kwz/LJcq6hQbQXggD6vKQUkWOJ5iJ2ng==
X-Received: by 2002:a02:5c5a:: with SMTP id q87-v6mr11432497jab.36.1541194214501;
        Fri, 02 Nov 2018 14:30:14 -0700 (PDT)
Received: from vader.thefacebook.com ([2620:10d:c090:200::4:e24f])
        by smtp.gmail.com with ESMTPSA id n130-v6sm929419itb.36.2018.11.02.14.30.12
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 02 Nov 2018 14:30:13 -0700 (PDT)
From:   Omar Sandoval <osandov@osandov.com>
To:     fstests@vger.kernel.org
Cc:     kernel-team@fb.com, linux-btrfs@vger.kernel.org
Subject: [PATCH 4/7] btrfs: test invalid operations on a swap file
Date:   Fri,  2 Nov 2018 14:29:39 -0700
Message-Id: <ef3cf56dce9333158dc8e60d914dbbfad8a4dbe8.1541193856.git.osandov@fb.com>
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

Btrfs forbids some operations which should not be done on a swap file.

Signed-off-by: Omar Sandoval <osandov@fb.com>
---
 tests/btrfs/174     | 66 +++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/174.out | 10 +++++++
 tests/btrfs/group   |  1 +
 3 files changed, 77 insertions(+)
 create mode 100755 tests/btrfs/174
 create mode 100644 tests/btrfs/174.out

diff --git a/tests/btrfs/174 b/tests/btrfs/174
new file mode 100755
index 00000000..a26e6669
--- /dev/null
+++ b/tests/btrfs/174
@@ -0,0 +1,66 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2018 Facebook.  All Rights Reserved.
+#
+# FS QA Test 174
+#
+# Test restrictions on operations that can be done on an active swap file
+# specific to Btrfs.
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
+
+rm -f $seqres.full
+
+_supported_fs generic
+_supported_os Linux
+_require_scratch_swapfile
+
+_scratch_mkfs >> $seqres.full 2>&1
+_scratch_mount
+
+$BTRFS_UTIL_PROG subvol create "$SCRATCH_MNT/swapvol" >> $seqres.full
+swapfile="$SCRATCH_MNT/swapvol/swap"
+_format_swapfile "$swapfile" $(($(get_page_size) * 10))
+swapon "$swapfile"
+
+# Turning off nowcow doesn't do anything because the file is not empty, not
+# because the file is a swap file, but make sure this works anyways.
+echo "Disable nocow"
+$CHATTR_PROG -C "$swapfile"
+lsattr -l "$swapfile" | _filter_scratch | _filter_spaces
+
+# Compression we reject outright.
+echo "Enable compression"
+$CHATTR_PROG +c "$swapfile" 2>&1 | grep -o "Text file busy"
+lsattr -l "$swapfile" | _filter_scratch | _filter_spaces
+
+echo "Snapshot"
+$BTRFS_UTIL_PROG subvol snap "$SCRATCH_MNT/swapvol" \
+	"$SCRATCH_MNT/swapsnap" 2>&1 | grep -o "Text file busy"
+
+echo "Defrag"
+# We pass the -c (compress) flag to force defrag even if the file isn't
+# fragmented.
+$BTRFS_UTIL_PROG filesystem defrag -c "$swapfile" 2>&1 | grep -o "Text file busy"
+
+swapoff "$swapfile"
+_scratch_unmount
+
+status=0
+exit
diff --git a/tests/btrfs/174.out b/tests/btrfs/174.out
new file mode 100644
index 00000000..bc24f1fb
--- /dev/null
+++ b/tests/btrfs/174.out
@@ -0,0 +1,10 @@
+QA output created by 174
+Disable nocow
+SCRATCH_MNT/swapvol/swap No_COW
+Enable compression
+Text file busy
+SCRATCH_MNT/swapvol/swap No_COW
+Snapshot
+Text file busy
+Defrag
+Text file busy
diff --git a/tests/btrfs/group b/tests/btrfs/group
index 3525014f..2e10f7df 100644
--- a/tests/btrfs/group
+++ b/tests/btrfs/group
@@ -176,3 +176,4 @@
 171 auto quick qgroup
 172 auto quick punch
 173 auto quick swap
+174 auto quick swap
-- 
2.19.1

