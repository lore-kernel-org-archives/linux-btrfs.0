Return-Path: <SRS0=Mp4+=NN=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,T_DKIMWL_WL_MED,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0039BC32789
	for <linux-btrfs@archiver.kernel.org>; Fri,  2 Nov 2018 21:30:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BC8B42082D
	for <linux-btrfs@archiver.kernel.org>; Fri,  2 Nov 2018 21:30:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=osandov-com.20150623.gappssmtp.com header.i=@osandov-com.20150623.gappssmtp.com header.b="J0jh2ZCO"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BC8B42082D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=osandov.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728280AbeKCGjA (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 3 Nov 2018 02:39:00 -0400
Received: from mail-it1-f194.google.com ([209.85.166.194]:51318 "EHLO
        mail-it1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728221AbeKCGi7 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 3 Nov 2018 02:38:59 -0400
Received: by mail-it1-f194.google.com with SMTP id h13so5119365itl.1
        for <linux-btrfs@vger.kernel.org>; Fri, 02 Nov 2018 14:30:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=osandov-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gjAp51U3ifmg7JidLZjofYnOVIERTT3c+O16DBDrf0o=;
        b=J0jh2ZCOaUtghrsSdyyeE3/taEK5VVjiNqgcTWboUZCLEUjezqnPASvTCDw4qahvtH
         hnYfH0169xpE7/77kAJjPLp118ym5eptgAetkVNOdp1Z2btrJVoZHWDicgAEEYOAr8LG
         aIwHyMzpkH3RktRtr0TcOmtaVh1+/fk7Ez+zl8orEiSxrrpbP+PFaPtHWee0slMsyEBD
         5xyN1lwoS2HPh943ZExr+RU70jzac+IpavUPDYoCJC4lB1U00f9r1O0iADOXpOe4D6qP
         HyQP9g2Uhd6RszY5kgrGB84e1nc1e17mmtpH9FHEt1ifVcY+z6OdMy8/INMadMXB9RVb
         jEYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gjAp51U3ifmg7JidLZjofYnOVIERTT3c+O16DBDrf0o=;
        b=EMotESNvL+wpX1NyQ9qYBnv50fFhT4MD+y7YNToXKK31q3QnwzCvMqlIzYjOJ5oJtu
         oR3srPJofRdy7yxLllCAkjdqsisKaK7GFU8YB0MuB3YhauaWINJI1s5KtJwWAeBtMlQP
         bMVH3L0Fn9WPtP39jPYwSBJrxCwEqnnbvsP/hjknjU52D1L1ZYVsEs/YjkxAtN0K8l4c
         Vak6cVM1s5bqdqDufb16T9aPaPvLaYpQqkK8hAvbB7K3owT7gDRS8y+Q9o6aAUcVYneF
         pWg1dskSA798gR7Pr1jpNazHs8hkoZlMbRi78CgfPxvRFSeuwAs/MAp3rltfdqrejVHE
         h1ZA==
X-Gm-Message-State: AGRZ1gJU+oCtvOn/f2LMmNSw3eO7F9BEi68zhreuxThs/KpOx+a9t3nG
        DtTOx2FjLh8/UN7H03cGxwojlYNr7b4=
X-Google-Smtp-Source: AJdET5dGuckXyhnDFdOYsNPE3hwpvpg6laqhCPgseJ+50pWta0afgjy3oQB9jEa3qMMfFSiFHvCZfQ==
X-Received: by 2002:a05:660c:611:: with SMTP id i17mr270580itk.117.1541194212701;
        Fri, 02 Nov 2018 14:30:12 -0700 (PDT)
Received: from vader.thefacebook.com ([2620:10d:c090:200::4:e24f])
        by smtp.gmail.com with ESMTPSA id n130-v6sm929419itb.36.2018.11.02.14.30.11
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 02 Nov 2018 14:30:12 -0700 (PDT)
From:   Omar Sandoval <osandov@osandov.com>
To:     fstests@vger.kernel.org
Cc:     kernel-team@fb.com, linux-btrfs@vger.kernel.org
Subject: [PATCH 3/7] btrfs: test swap file activation restrictions
Date:   Fri,  2 Nov 2018 14:29:38 -0700
Message-Id: <9eeea2eecff0b9fad27f49c082e987232edb40c0.1541193856.git.osandov@fb.com>
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

Swap files on Btrfs have some restrictions not applicable to other
filesystems.

Signed-off-by: Omar Sandoval <osandov@fb.com>
---
 tests/btrfs/173     | 55 +++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/173.out |  5 +++++
 tests/btrfs/group   |  1 +
 3 files changed, 61 insertions(+)
 create mode 100755 tests/btrfs/173
 create mode 100644 tests/btrfs/173.out

diff --git a/tests/btrfs/173 b/tests/btrfs/173
new file mode 100755
index 00000000..665bec39
--- /dev/null
+++ b/tests/btrfs/173
@@ -0,0 +1,55 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2018 Facebook.  All Rights Reserved.
+#
+# FS QA Test 173
+#
+# Test swap file activation restrictions specific to Btrfs.
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
+echo "COW file"
+# We can't use _format_swapfile because we don't want chattr +C, and we can't
+# unset it after the swap file has been created.
+rm -f "$SCRATCH_MNT/swap"
+touch "$SCRATCH_MNT/swap"
+chmod 0600 "$SCRATCH_MNT/swap"
+_pwrite_byte 0x61 0 $(($(get_page_size) * 10)) "$SCRATCH_MNT/swap" >> $seqres.full
+mkswap "$SCRATCH_MNT/swap" >> $seqres.full
+swapon "$SCRATCH_MNT/swap" 2>&1 | _filter_scratch
+swapoff "$SCRATCH_MNT/swap" >/dev/null 2>&1
+
+echo "Compressed file"
+rm -f "$SCRATCH_MNT/swap"
+_format_swapfile "$SCRATCH_MNT/swap" $(($(get_page_size) * 10))
+$CHATTR_PROG +c "$SCRATCH_MNT/swap"
+swapon "$SCRATCH_MNT/swap" 2>&1 | _filter_scratch
+swapoff "$SCRATCH_MNT/swap" >/dev/null 2>&1
+
+status=0
+exit
diff --git a/tests/btrfs/173.out b/tests/btrfs/173.out
new file mode 100644
index 00000000..6d7856bf
--- /dev/null
+++ b/tests/btrfs/173.out
@@ -0,0 +1,5 @@
+QA output created by 173
+COW file
+swapon: SCRATCH_MNT/swap: swapon failed: Invalid argument
+Compressed file
+swapon: SCRATCH_MNT/swap: swapon failed: Invalid argument
diff --git a/tests/btrfs/group b/tests/btrfs/group
index a490d7eb..3525014f 100644
--- a/tests/btrfs/group
+++ b/tests/btrfs/group
@@ -175,3 +175,4 @@
 170 auto quick snapshot
 171 auto quick qgroup
 172 auto quick punch
+173 auto quick swap
-- 
2.19.1

