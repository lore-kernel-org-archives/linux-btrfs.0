Received: from mail-dl1-f53.google.com (mail-dl1-f53.google.com [74.125.82.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97B452E1746
	for <linux-btrfs@vger.kernel.org>; Sun, 11 Oct 2026 19:41:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791747714; cv=none; b=PvkcfCjXnY2X10o9FajVL1oYOp6r3a5vd4uAfGLtSQHK2l5jNKGQcObKhq9LP7PYwX1MQfhUVCLGoRF2PxSifxWIr9sUx9CaXAN++mM1QrsVSplWlm7JfEcVu4tqMbYkIdl/cVpArFQni3mqhuHotFi7sYzlm2kfI4nyBOD41mg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791747714; c=relaxed/simple;
	bh=Rhx6P2cQyIBn30NQTWk0if+lTEE+UGQ/7ic2Vnou+z8=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=uhT86/Mm9J+iYddgkWR+FNyrJ6EKdqdibVa2NWXwtAS/uAJQ2maFZNbIIlV6zjIARWlqQcTfWlHlnJMMOLCRiyjKt1nFwJKGn2DO5WXqLXOi015Q/wtwtpUnCIR5bgBgNEpRd8967Ls14lHBpTZd2w9v7uR0c2dwxgPer2Py5M8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ocGDSRPB; arc=none smtp.client-ip=74.125.82.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ocGDSRPB"
Received: by mail-dl1-f53.google.com with SMTP id a92af1059eb24-15756f82e8aso3011448c88.1
        for <linux-btrfs@vger.kernel.org>; Sun, 11 Oct 2026 12:41:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791747713; x=1792352513; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:cc:to:subject:from:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=0QWIy+E8kq1ytUirl1aTo4BviuYYcSNIquVKTIFJ5+4=;
        b=ocGDSRPBEbb2ntAOTwYzXOfhCWlE9Xi6BgttLrp/EEpmUUGezWjhdFoVPDKcZG0skB
         XGNUUEW7ko/QoQ8yj1JB+vh0LV5mAUn+eokaiK7MjMgMfPfCqcmeJtesd16teHS9xS7R
         sduzYN7gUhlkzcBOTCajDhqIUt1O17KsXbISR++YoWKD4I1Ke4Fitli2qwkX4l53kh0K
         2GDMxXWOtjc65VT9xtX6W7pa7vnhUKZLW7Un/rJLPQ8t4HVo/vYZQfS9fthmMmUQ7O7P
         jCVHXSt+157hLB5kO3IVrdUn02c9Cky47jap6r1BYItOB5hx6ielJyNhEfGgLmxxhYd+
         +qWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791747713; x=1792352513;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:cc:to:subject:from:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=0QWIy+E8kq1ytUirl1aTo4BviuYYcSNIquVKTIFJ5+4=;
        b=VMMNzC/tRBOUZtRaJEtHk8vWleoSWb4QnQk4anAkIcorJnYb/G48LW5JpDLjz4S/P3
         9rCHUdPuEurezbpVJxYUNhYloQDvEgczIR+QWHPDobRwB4HxrmWElSU7nRzvJB8YbgVR
         jEyrFDvFyzRIR1sqoS5I778Otv/ysqa6z/5XqOdvsIimqyRj44DGlStIJjA3j5ZW29BD
         +ssF2f4cxwNBLkq6PEdQbjm0quAS3fwrH07O0aabvgSfl5p+n5NX5QVHcoUtbT9RP+El
         TRw1frFr5Os2UAuLYgOscKOafsbvl8mKY5zF/hgFO9xZDyNYem7sJOCMtTGY/58czbkJ
         +S/Q==
X-Forwarded-Encrypted: i=1; AKwUvBwfTnJWYjRrPRpEs48mTsRtJbJnuRW4DSnBaOwvDlhKi5sJry76HbB5LfuV7pfaBX4OvL2PCw0S/jzXaw==@vger.kernel.org
X-Gm-Message-State: AFq9FYK9JgFBeQBa5EiKH9dtk3Rd8M4OAEMHoXjvnYtywnqKsnX7MnfA
	o9uoJg2Jmv+e3sB29seVkRa3vKYMmLJHFYgz7xtJiRsWugNFpz3e2y/P
X-Gm-Gg: AYBFou1YrnZT7YSyaNyIYb695KtTmA5jLTCWugyTJZAMw4dzOawWLS/3m7QW+82jtbp
	TQBokC3kNCGBm9bebpM/8GDMeV3+/SgFah0oRVQ45BfAIHVHiux17GWc2/e/bJCX7Q7O9fbGpOU
	UeMT2wVM6RIEm5I3PlqdVjC94gUDeT5oyCDK/SMChZOc20DeZgbAF/D4B3QUIopHr4ArSkmL6l2
	RvqriT6XpaLHS5RZM007CLJPwselI2Ifdgg+ypydRnEP3BeB9dLQmTDKc+mM7F9HnvJ4HMpLZVz
	DBeIqyTUNj6p1wdzOQq0uFOdjj4tMbtc5Ok6J3mn4N9/ImlgWrMdfXwBXvA6vzT8JIbZlL2u7pm
	ZX2rTqxLXq+Tofv1ecsJx8OYzzs03W20y/UVHJ2nKTJQkW+4MgWNy3jkTLLVWu137vHEtEDOZWy
	Tl5HY6bXNU7sOwtXHmNDiGjm3Hzq+56qr8wUgQwh3LjOjYh6iOBLsBuPfuu84ipWlcJURD/gz0f
	yMeLAKNtf1TkbIuz5aK64Io35MV9+MjrXns0DrJf5I4eIgw
X-Received: by 2002:a05:701b:4284:10b0:146:84fd:7b58 with SMTP id a92af1059eb24-16a10f2a74fmr10799353c88.9.1791747712614;
        Sun, 11 Oct 2026 12:41:52 -0700 (PDT)
Received: from ?IPV6:2406:7400:56:97af:bd42:ace4:1245:4b57? ([2406:7400:56:97af:bd42:ace4:1245:4b57])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-169a442ac67sm37218715c88.18.2026.10.11.12.41.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 11 Oct 2026 12:41:52 -0700 (PDT)
Message-ID: <11049c99-ddd9-4495-a46e-34d830e6a15d@gmail.com>
Date: Mon, 12 Oct 2026 01:11:47 +0530
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Dhruva G <goledhruva@gmail.com>
Subject: [PATCH 3/3] btrfs: cover NOCOMPRESS inline eligibility and short
 tails
To: fstests@vger.kernel.org
Cc: Anand Jain <asj@kernel.org>, Filipe Manana <fdmanana@suse.com>,
 Zorro Lang <zlang@kernel.org>, linux-btrfs@vger.kernel.org,
 Qu Wenruo <quwenruo.btrfs@gmx.com>
References: <cover.1791395660.git.goledhruva@gmail.com>
Content-Language: en-US
In-Reply-To: <cover.1791395660.git.goledhruva@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Check that --nocomp preserves a compressed inline extent while it remains
eligible under max_inline, including after a remount. Lower max_inline to
zero and require the same extent to become regular, uncompressed data.

Exercise one-byte, sector-minus-one, sector-plus-one, and
maximum-compressed-extent-plus-one file sizes. Check every mapped byte
range for regular uncompressed data after defrag, and verify all file
contents, sizes, and converted mappings again after a remount.

Use FIEMAP INLINE and ENCODED flags instead of parsing dump-tree output,
and skip configurations without inline extent creation support.

Signed-off-by: Dhruva Gole <goledhruva@gmail.com>
---
 tests/btrfs/357     | 59 +++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/357.out |  2 ++
 2 files changed, 61 insertions(+)
 create mode 100755 tests/btrfs/357
 create mode 100644 tests/btrfs/357.out

diff --git a/tests/btrfs/357 b/tests/btrfs/357
new file mode 100755
index 00000000..0d7b1e33
--- /dev/null
+++ b/tests/btrfs/357
@@ -0,0 +1,59 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) Meta Platforms, Inc. and affiliates.
+#
+# FS QA Test 357
+#
+# Verify NOCOMPRESS inline eligibility and short EOF tails.
+#
+. ./common/preamble
+_begin_fstest auto quick defrag compress fiemap
+
+. ./common/filter
+. ./common/btrfs_nocomp
+
+_nc_require
+_require_btrfs_inline_extents_creation
+_scratch_mkfs -s 4k >> "$seqres.full" 2>&1 || _fail "mkfs failed"
+_scratch_mount -o compress=zlib,max_inline=4096
+_nc_probe
+
+file="$SCRATCH_MNT/inline"
+_nc_write "$file" 0 2048 0x34
+_nc_save_file "$file"
+_nc_check_range "$file" 0 2048 inline
+_nc_defrag "$file"
+_nc_check_range "$file" 0 2048 inline
+_nc_verify_files
+_scratch_cycle_mount compress=zlib,max_inline=4096
+_nc_check_range "$file" 0 2048 inline
+_nc_verify_files
+
+# Lowering max_inline makes the same extent eligible for conversion.
+_scratch_cycle_mount compress=zlib,max_inline=0
+_nc_defrag "$file"
+_nc_check_range "$file" 0 2048 regular
+_nc_verify_files
+
+for length in 1 4095 4097 131073; do
+	f="$SCRATCH_MNT/tail-$length"
+	_nc_write "$f" 0 "$length" 0x36
+	_nc_save_file "$f"
+	# One-sector files cannot save a sector through compression. The larger
+	# fixtures must contain compressed data before testing conversion.
+	if [ "$length" -gt 4096 ]; then
+		_nc_check_range "$f" 0 4096 compressed
+	fi
+	_nc_defrag "$f"
+	_nc_check_range "$f" 0 "$length" regular
+done
+_nc_verify_files
+_scratch_cycle_mount compress=zlib,max_inline=0
+_nc_verify_files
+_nc_check_range "$file" 0 2048 regular
+for length in 1 4095 4097 131073; do
+	_nc_check_range "$SCRATCH_MNT/tail-$length" 0 "$length" regular
+done
+
+echo "Silence is golden"
+_exit 0
diff --git a/tests/btrfs/357.out b/tests/btrfs/357.out
new file mode 100644
index 00000000..25875c6d
--- /dev/null
+++ b/tests/btrfs/357.out
@@ -0,0 +1,2 @@
+QA output created by 357
+Silence is golden
-- 
2.43.0
