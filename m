Return-Path: <SRS0=Mp4+=NN=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,T_DKIMWL_WL_MED,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0F74C65C22
	for <linux-btrfs@archiver.kernel.org>; Fri,  2 Nov 2018 21:30:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7589B2082D
	for <linux-btrfs@archiver.kernel.org>; Fri,  2 Nov 2018 21:30:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=osandov-com.20150623.gappssmtp.com header.i=@osandov-com.20150623.gappssmtp.com header.b="aWZSYusP"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7589B2082D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=osandov.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728312AbeKCGjD (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 3 Nov 2018 02:39:03 -0400
Received: from mail-it1-f194.google.com ([209.85.166.194]:37628 "EHLO
        mail-it1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726100AbeKCGjD (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 3 Nov 2018 02:39:03 -0400
Received: by mail-it1-f194.google.com with SMTP id e74-v6so5076226ita.2
        for <linux-btrfs@vger.kernel.org>; Fri, 02 Nov 2018 14:30:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=osandov-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+0BAr6ugQZBwUjY0CTCqajmOFpD2mjWfzLQIRXf3JXg=;
        b=aWZSYusPimP4lMAJOTR8cxcNMVSVBCBGcme4ZDwyagfKS6zGA757UCj5AM4fCwy87U
         38svtzKKMXvySfb3Cf0P3vtrCnQqdqjlr+BMJGES7kklH1O8tqqnheRvRjCY8wgdwd1b
         8GoLbCJVdtd2cZm4B/MvpioZfTdMWvjnb+A5HbAUXTL0N/0sb0+A0f5mgcA6/l72UVkL
         2k1BdFq3aamjBFrSeNPxcrRrF0N9+ifoDvTGuLVrbJjfrlavOeGuBUYGJ89L/aYMfk3h
         j29AQoSZeKAExOgEOiWM3B/vPq7cTTpjHZOGICEg+gkE9TyMAMJ9bXLll/853TfyWICc
         bKzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+0BAr6ugQZBwUjY0CTCqajmOFpD2mjWfzLQIRXf3JXg=;
        b=TXc1l8GB+KeTu9XU8NEpQpFJYC6MeYjv29rf+Bmbcn/xS41gMaax26ieGxw06H32fW
         nIGKjC27uvorsCWaAg5RbPXIy6Sa+ieus7UELdr2RVbnVG3KwktJz1k/W3Bxq+Rg0YmM
         wwfrpzg7I5kz8zKs0XowHAGlnAgP3JQl544NDR7YzLUSa7EXMy+VRi0EUsHoRpdtlAuT
         e3EkB2YvP/dwlmI9Yqiasd4Y3okovbI7hdg1iK9QtqFTdu+HSReCpZzED2Af+RFl6v+a
         ZqCI97j0lf3OWwYUQpSeHJYVXC35TWWyXK9gNkGICa77Qq072SUjDgC5vTTFILmW8cg/
         dmSA==
X-Gm-Message-State: AGRZ1gJeBmgvsl1Y4nt3yp4S5ofH3txvu6H4c3LkoPtioHwmxuF+EJc3
        5m2mFNPDoM8LxOa3QlwZ1m2xoA==
X-Google-Smtp-Source: AJdET5fAsAp+6sx27PyfCEiRLpWcVbQ3U1jJd7TGibYroltA1DZiW9w1xpTKERZQWvxQFNsFAnb8WQ==
X-Received: by 2002:a02:242c:: with SMTP id f44-v6mr12504787jaa.21.1541194215595;
        Fri, 02 Nov 2018 14:30:15 -0700 (PDT)
Received: from vader.thefacebook.com ([2620:10d:c090:200::4:e24f])
        by smtp.gmail.com with ESMTPSA id n130-v6sm929419itb.36.2018.11.02.14.30.14
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 02 Nov 2018 14:30:15 -0700 (PDT)
From:   Omar Sandoval <osandov@osandov.com>
To:     fstests@vger.kernel.org
Cc:     kernel-team@fb.com, linux-btrfs@vger.kernel.org
Subject: [PATCH 5/7] btrfs: test swap files on multiple devices
Date:   Fri,  2 Nov 2018 14:29:40 -0700
Message-Id: <fdbb983029c8854bcd9eb1ab46450efc167c9bf1.1541193856.git.osandov@fb.com>
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

Swap files currently need to exist on exactly one device in exactly one
place.

Signed-off-by: Omar Sandoval <osandov@fb.com>
---
 tests/btrfs/175     | 73 +++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/175.out |  8 +++++
 tests/btrfs/group   |  1 +
 3 files changed, 82 insertions(+)
 create mode 100755 tests/btrfs/175
 create mode 100644 tests/btrfs/175.out

diff --git a/tests/btrfs/175 b/tests/btrfs/175
new file mode 100755
index 00000000..64afc4f0
--- /dev/null
+++ b/tests/btrfs/175
@@ -0,0 +1,73 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2018 Facebook.  All Rights Reserved.
+#
+# FS QA Test 175
+#
+# Test swap file activation on multiple devices.
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
+_require_scratch_dev_pool 2
+_require_scratch_swapfile
+
+cycle_swapfile() {
+	local sz=${1:-$(($(get_page_size) * 10))}
+	_format_swapfile "$SCRATCH_MNT/swap" "$sz"
+	swapon "$SCRATCH_MNT/swap" 2>&1 | _filter_scratch
+	swapoff "$SCRATCH_MNT/swap" > /dev/null 2>&1
+}
+
+echo "RAID 1"
+_scratch_pool_mkfs -d raid1 -m raid1 >> $seqres.full 2>&1
+_scratch_mount
+cycle_swapfile
+_scratch_unmount
+
+echo "DUP"
+_scratch_pool_mkfs -d dup -m dup >> $seqres.full 2>&1
+_scratch_mount
+cycle_swapfile
+_scratch_unmount
+
+echo "Single on multiple devices"
+_scratch_pool_mkfs -d single -m raid1 -b $((1024 * 1024 * 1024)) >> $seqres.full 2>&1
+_scratch_mount
+# Each device is only 1 GB, so 1.5 GB must be split across multiple devices.
+cycle_swapfile $((3 * 1024 * 1024 * 1024 / 2))
+_scratch_unmount
+
+echo "Single on one device"
+_scratch_mkfs >> $seqres.full 2>&1
+_scratch_mount
+# Create the swap file, then add the device. That way we know it's all on one
+# device.
+_format_swapfile "$SCRATCH_MNT/swap" $(($(get_page_size) * 10))
+scratch_dev2="$(echo "${SCRATCH_DEV_POOL}" | awk '{ print $2 }')"
+$BTRFS_UTIL_PROG device add -f "$scratch_dev2" "$SCRATCH_MNT"
+swapon "$SCRATCH_MNT/swap" 2>&1 | _filter_scratch
+swapoff "$SCRATCH_MNT/swap" > /dev/null 2>&1
+_scratch_unmount
+
+status=0
+exit
diff --git a/tests/btrfs/175.out b/tests/btrfs/175.out
new file mode 100644
index 00000000..ce2e5992
--- /dev/null
+++ b/tests/btrfs/175.out
@@ -0,0 +1,8 @@
+QA output created by 175
+RAID 1
+swapon: SCRATCH_MNT/swap: swapon failed: Invalid argument
+DUP
+swapon: SCRATCH_MNT/swap: swapon failed: Invalid argument
+Single on multiple devices
+swapon: SCRATCH_MNT/swap: swapon failed: Invalid argument
+Single on one device
diff --git a/tests/btrfs/group b/tests/btrfs/group
index 2e10f7df..b6160b72 100644
--- a/tests/btrfs/group
+++ b/tests/btrfs/group
@@ -177,3 +177,4 @@
 172 auto quick punch
 173 auto quick swap
 174 auto quick swap
+175 auto quick swap
-- 
2.19.1

