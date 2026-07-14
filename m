Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8713C47D94A
	for <linux-btrfs@vger.kernel.org>; Tue, 14 Jul 2026 16:11:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784045485; cv=none; b=Z26a2tmLhfaGHzaOQx3Tau8CV3ufW8h5+nxtfj0pGH1zXRiO1J8wLS9t0AnwI310C9/OrwIGMHEEe0ALFZB22UIu6zaOA1yiyqXYCWDHcZsrXufW3DMns7dTnJyAUelZFkyGTZHjX3BM+5KSL2Ic2sMDmzSijMDxnjLtrkHdR+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784045485; c=relaxed/simple;
	bh=+TFYhRNR4sYWL12dCRbjZG2Sx9acI9+CTe/ELY3nut4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=GrPGDNSJFi+9uZcTuexiG9uSolfVKwj9hc7Cj9ZNYK0F6MYQsckJ6G+Z4lydRgtR3QxKkwkDu//jh6C1sWKNpm2kRPBJT6WSzFxGA5+EpH1AzC88Gl+5brplOwFdanFjHlUMKPJaIhs+eGx0zwMrBZyaQbilAOVmLPAnCpcICQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nXJc/p0W; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nXJc/p0W"
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-8423f236418so1070788b3a.1
        for <linux-btrfs@vger.kernel.org>; Tue, 14 Jul 2026 09:11:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784045484; x=1784650284; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=c46Y7wImNBTVm5JDUvX6497nRUQHo8d1HA5FFYk4Zkg=;
        b=nXJc/p0WqGdRYtwh48fWonDlcRsoYXhpFTF8/0gUYXHvaRNb77FFYy3/JB6L1+Gw6g
         CgkscpiBmD4JIe+4nsP3H5wSDrThm5rjCnrBVfFLDm9rJW2xkfl02oGA4jTdjB4uM7SA
         xx5w3kOLa3MPJjQ1v9C0vyaku7oJi6uhhesfhGXUIrieqUy8ChSmyX6/G5C3q3IRjE/Y
         olfvcnCZlBoW60+1i+nmiRP6bjzKePK0mQS8S0JORuOyfTgcuIQ8Ehuitckx/2OvhNJu
         2DCoQrDAr2vyO6oPiPA7lIH/Qmi7uu6lH6IosMLCssrFF4EunrKAbhT39HjxlPyeju9r
         G1Qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784045484; x=1784650284;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=c46Y7wImNBTVm5JDUvX6497nRUQHo8d1HA5FFYk4Zkg=;
        b=nnjKHyllctp9x5o7bnVQ5sc/sCj2yzcN8iEYZQDZ/qDEcNWe9zeEFlY2/vuZ3C7wFH
         RwyOEKAMbPmofktGknpX71RQtwF1R7W3llNjOE4NJ1YZzLBYKCT2bQp3xYYUoEphmlNq
         E5WGdGGEK61+jQaM4rLxXFlkqfvl76J/lH6KEoCPlAuTRGUsvhOj1yQjKk5xxf9rOStZ
         90M9mQZwuALfziDI4IgLlh2TvYbGL3ukh8uuifDpCuSwyGjYwwrbBp4Yz0vsduJO/DeQ
         a9ta48VPGUalGxGsGZ9qPTPs310ypx4nhsi0dnQ/mFTmOoneOp1UMoQX6/0bM806wZle
         B5Vg==
X-Gm-Message-State: AOJu0YyCZIfBYkAmNuKSLAo3GtHKIgxCRUih+T2JmNvwSMrCNWcmZRZf
	8ta2S3jHfAVbK1ygVLZFSoRsedJxADwWlNjij8dEXxbxb/XFJxJF7aWgMx/sBQ==
X-Gm-Gg: AfdE7ckT+o9j1QYeOiDTXBe8eWLDT+c1yVFERjHDSTmg4QqXl8XJBNQuv0wDwulB/dp
	1U4zNynreP3hpkjxXHNzm4IunqsQJVhZ8eewJdpTgY+PQkWyW+KoHmn19Ul3uVD/7mg36ZHM/ua
	HY3DkRdrckwymqUSpfHuCuhJRRSlttZKEQEekcW2EZijKYbbhN5FXChe3XlIW08JSlBruayxoac
	JBS5rZ6I8Y7wogzX3lmu7GjVfRcQn2HM71rcJLbgRutmdA+nw8dcQ1XfDNzErRYsdRSrQPj/c6K
	p0+1f1I7JLwjTk7MJHTsz9jg9BO7tAWmEwIOOMpS8gUsOxvF0d+qzrg1dSfugPhykCn3A9OQqBS
	NU/UwVOH58aZR+RklvaD1IuFBQ2fbVGGA+hUW1k7N3g2L5ZKbQuPVG5JmsSiq7Zhm0exSBxFLT7
	mnxTrUT/gQfcV0meorUCgrrubr6k5sXEzEljA4d8sukNhRl5Mnrm1IwM/tY7fQEp5VAb54x+mmv
	q+1YTqYkiXr5GVWlg==
X-Received: by 2002:a05:6a00:94c8:b0:847:759e:f61c with SMTP id d2e1a72fcca58-848896bacb9mr12252711b3a.47.1784045483864;
        Tue, 14 Jul 2026 09:11:23 -0700 (PDT)
Received: from localhost.localdomain (ec2-13-113-80-70.ap-northeast-1.compute.amazonaws.com. [13.113.80.70])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84a4f26f703sm1825073b3a.17.2026.07.14.09.11.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jul 2026 09:11:23 -0700 (PDT)
From: Zhang Boyang <zhangboyang.id@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@kernel.org>,
	Zhang Boyang <zhangboyang.id@gmail.com>
Subject: [PATCH 2/2] fstests: btrfs/349: test if latest tree-log is choosen at mount time on raid1 profile
Date: Wed, 15 Jul 2026 00:10:44 +0800
Message-Id: <20260714161044.7330-3-zhangboyang.id@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20260714161044.7330-1-zhangboyang.id@gmail.com>
References: <20260714161044.7330-1-zhangboyang.id@gmail.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This test simulate a scenario that tree-log only exists in secondary
device, and test if latest tree-log is choosen at mount time.

Currently, the tree-log in the device with lowest devid is choosen. So
fsync'ed data may loss if tree-log only exists in secondary device.

Signed-off-by: Zhang Boyang <zhangboyang.id@gmail.com>
---
 tests/btrfs/349     | 53 +++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/349.out | 14 ++++++++++++
 2 files changed, 67 insertions(+)
 create mode 100755 tests/btrfs/349
 create mode 100644 tests/btrfs/349.out

diff --git a/tests/btrfs/349 b/tests/btrfs/349
new file mode 100755
index 00000000..40e966c6
--- /dev/null
+++ b/tests/btrfs/349
@@ -0,0 +1,53 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2026 Zhang Boyang.  All Rights Reserved.
+#
+# FS QA Test 349
+#
+# Test if latest tree-log is choosen at mount time on raid1 profile.
+#
+. ./common/preamble
+_begin_fstest auto quick read_repair raid
+
+. ./common/filter
+. ./common/fail_make_request
+
+_require_fail_make_request
+_require_scratch_dev_pool 2
+
+_scratch_dev_pool_get 2
+_check_minimal_fs_size $(( 1024 * 1024 * 1024 ))
+# a strong checksum like sha256 can't protect you
+_scratch_pool_mkfs "-m raid1 -d raid1 -b 1G --csum sha256" >> $seqres.full 2>&1
+dev2=`echo $SCRATCH_DEV_POOL | $AWK_PROG '{print $2}'`
+_allow_fail_make_request
+
+echo "Step 1: prepare filesystem"
+_scratch_mount -o treelog
+$XFS_IO_PROG -f -c "pwrite -W -S 0xaa 0 8" $SCRATCH_MNT/foobar | _filter_xfs_io
+_scratch_unmount
+
+echo "Step 2: simulate failure"
+_scratch_mount -o treelog
+# simulate dev1 disappears before writing anything
+_bdev_fail_make_request $SCRATCH_DEV 1
+# this write should success
+$XFS_IO_PROG -f -c "pwrite -W -S 0xbb 0 8" $SCRATCH_MNT/foobar | _filter_xfs_io
+# simulate dev2 disappears after writing TREE_LOG
+_bdev_fail_make_request $dev2 1
+_scratch_unmount
+_bdev_fail_make_request $SCRATCH_DEV 0
+_bdev_fail_make_request $dev2 0
+
+echo "Step 3: simulate recovery"
+# this mount should start tree-log replay
+_scratch_mount -o treelog
+echo "Step 4: verify written data"
+# read data should be 0xbb
+$XFS_IO_PROG -c "pread -v 0 8" $SCRATCH_MNT/foobar | _filter_xfs_io_offset
+_scratch_unmount
+
+_disallow_fail_make_request
+_scratch_dev_pool_put
+# success, all done
+_exit 0
diff --git a/tests/btrfs/349.out b/tests/btrfs/349.out
new file mode 100644
index 00000000..1ebf4dc9
--- /dev/null
+++ b/tests/btrfs/349.out
@@ -0,0 +1,14 @@
+QA output created by 349
+Allow global fail_make_request feature
+Step 1: prepare filesystem
+wrote 8/8 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+Step 2: simulate failure
+wrote 8/8 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+Step 3: simulate recovery
+Step 4: verify written data
+XXXXXXXX:  bb bb bb bb bb bb bb bb  ........
+read 8/8 bytes
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+Disallow global fail_make_request feature
-- 
2.53.0

