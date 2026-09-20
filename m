Received: from mail-pz2-f41.google.com (mail-pz2-f41.google.com [74.125.228.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 300C14334D0
	for <linux-btrfs@vger.kernel.org>; Sun, 20 Sep 2026 12:12:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789906337; cv=none; b=dsj95FNFgeP93q0uXqVdF7QT0fB9PcFvv4L1AI44FgB+WnSLfHRmM8K/lqSk790NwMFiIYQkcCZ9aOKTjUIjyo+p3MDK4/LWLaNhP77MJrLdmmqPBN4E0olMAG7rotMYEwnQuLVG9z6f3ld3MwGEO5x5VpT57ixTjYp+o6J05TI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789906337; c=relaxed/simple;
	bh=FLQaCojTIYKtZz9lp1iUllvaUMlIpuLdOcCsbKSuhF4=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:Content-Type; b=JEEjQZF5YwPZcxcZ5+5EtaI/9k9auw1PMxHw2IvWFeHUeFGk8n0Ar1A3XYCJbF3cbxlTCTIaiR6tnhV4X9czqYYk1rJ4O1tNMSyfomQEiwQEX/SiIKUSak8lxLhNZvY33mTwaddK/TCQzZT6T9usbNckZ0qiz/r68rZJubprYLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Eeqscdg4; arc=none smtp.client-ip=74.125.228.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Eeqscdg4"
Received: by mail-pz2-f41.google.com with SMTP id 41be03b00d2f7-cc50b9e8a45so1203887a12.2
        for <linux-btrfs@vger.kernel.org>; Sun, 20 Sep 2026 05:12:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789906322; x=1790511122; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:content-language
         :subject:from:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=Ogh9Mk3f/m0St1QHerxCwh0l+xtJUuv7NoYjKrMImpo=;
        b=Eeqscdg4HuAx8yvcDHBVOjRRDY4VHG4/DSicgnxCNLNQvMROnKSycdkDlKiMUA+Lxr
         Zf0kxZrHLlHkanHDi4NTYgSWN2kWdRSncamqWe9prJwj+lXfKSxR/EJ+YWM/q5TfGEL3
         aWsTpwn9OQ7rKEC5eV+oH8+WayvfksQ0tZcrfeCxCIqi3FrzAGfSbsQ8yYKUS0IkegxU
         eVr6tqcW023uuWs/L3LkEzOQi8YIDe0XkwYi397E7iDPH4JDHYQeY03rkiOZ91Kc4KaE
         nUE87fvABWM+U0ohE0/1pHwkqCdHlCPuhx0AmTDMdN3TRkZSo3btFPH2pjM6wyCKOifP
         MDwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789906322; x=1790511122;
        h=content-transfer-encoding:content-type:cc:to:content-language
         :subject:from:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Ogh9Mk3f/m0St1QHerxCwh0l+xtJUuv7NoYjKrMImpo=;
        b=HboywdseodQGHWAy9cQdy1s2VdIudz+CPYc4PCUgmrg+ZBSLG4JWDN4lqQ4OVhR5ot
         k5221p7ZVQ0jPmII4pA18qL3VlNACPJeVeKz6FfIgSvDnfFpPXNGY5E33PYaQ//MbfPw
         wAqAIJqkmKXg2FPikfxkam53cpDpMmLPbFWDYj1bezmmWIAPxga5GyZTzkFsvXRoNsZA
         Lb64jBPEH1U7bQ8DKR0Gu+rprYuqBsP3WCCuaZBdK6Qf8+ATjFwJ+dyHFO6Okfaa6KNC
         kZ/aFuDHu083rjtGWYb21QqS2FN9cfk7oDm5+sngdzUM923vF2sqlAtT5mYuw3H1AC1/
         VpTA==
X-Gm-Message-State: AFuF++n5cxdHUH36sJ20NidW0mdku9i8BWk2EDPAJB4m+Q5OlHaybvI3
	iuAJARkyIj3c+MN+dXGylAQtPVZbD1dNGQumwdhNk4bRyOgYEtF22VibJYmdfePy4YA=
X-Gm-Gg: AYBFou10dR9//LB4cYj5MA8xlNEzNwtJDxPjMZCrcv3TaqIH9hosnqftnlpbSrPw4rl
	Rk1ACCRY8CQSvMX3IsmQ/lRx6CQNo2mty6b91LLUa+11MKFK5/mMDXbg3RUubZQob6MysShsr6N
	kn0dsydrPWAtVilRDrKRZynnR+7xAU9d4zH8PHeHkcZY3nfWw2LMdpCNI6Bbx/Ra+WRL8cjSzDi
	uQVehAnehBMHdEDlB3nq6sYaeAmuzjCYSdm1OuCT31DgcZdOmQuBhbNsrWVb/UEgCqVX33wSI6K
	xHU8a6yOKnP52e3O1DUNX4nu/Z6zcQ1oWZfqEDciT+nIIhX/lBoCuDOL/u9N4ctjiJ/N1CwdYPn
	I8/I4MkCEQ9J6XHfxFpQM8E4thHSdPW2clU9H3kewAcdbTJt4O5jxgwNuM564H9J1bupT6lOjNr
	jjy8QHXK01H9/xPCalDnUGgDE0FoqEVLWAJ9NdPeMhyHYBK4eBPXJ8LxINIlioRq9kdoxnM4QkR
	HHslbIYO84VZC9RNcLIPHHnokzMubpGGvNLx7x06nNeg6Am
X-Received: by 2002:a17:902:f546:b0:2dd:c053:82f2 with SMTP id d9443c01a7336-2ddc0538461mr69955255ad.41.1789906321781;
        Sun, 20 Sep 2026 05:12:01 -0700 (PDT)
Received: from ?IPV6:2406:7400:56:e503:ad72:fda5:83e8:be95? ([2406:7400:56:e503:ad72:fda5:83e8:be95])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-33c331b0d6esm10230618eec.27.2026.09.20.05.11.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 20 Sep 2026 05:12:01 -0700 (PDT)
Message-ID: <d8930005-39c7-405f-96ac-ea0530e9b2c1@gmail.com>
Date: Sun, 20 Sep 2026 17:41:56 +0530
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Dhruva G <goledhruva@gmail.com>
Subject: [PATCH v2] btrfs: test defrag --nocomp converts compressed extents to
 uncompressed
Content-Language: en-US
To: linux-btrfs@vger.kernel.org, kernel-team@fb.com, fstests@vger.kernel.org
Cc: Boris Burkov <boris@bur.io>, Anand Jain <asj@kernel.org>,
 goledhruva@gmail.com, Qu Wenruo <quwenruo.btrfs@gmx.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

"btrfs filesystem defragment --nocomp" rewrites already compressed file
data as uncompressed data. The kernel flag was added by commit
009b2056cb25 ("btrfs: defrag: add flag to force no-compression") in
v6.17, and the userspace option shipped in btrfs-progs v6.16. There is
no test for it.

Add a test that writes compressible data in 128K blocks on a filesystem
mounted with compress=zlib, runs defragment with --nocomp, and uses the
FIEMAP encoded flag to verify that no extent remains compressed. Also
verify that the file contents are unchanged after a remount. Keeping
compression enabled throughout the test confirms that the defrag ioctl
takes precedence over the mount option.

Regular defrag deliberately leaves maximum-sized compressed extents
alone, as asserted by btrfs/259. Creating maximum-sized compressed
extents therefore ensures that an implementation which silently treats
--nocomp as regular defrag fails the test.

Check support in two stages: first require btrfs-progs to advertise
--nocomp, then invoke it on a 10-byte file to verify that the kernel
accepts the flag. Kernels with the unknown-flag validation from commit
173431b274a9 return EOPNOTSUPP when NOCOMPRESS is unavailable. Kernels
predating that validation may silently ignore the flag and fail the
semantic checks instead of skipping.

Signed-off-by: Dhruva Gole <goledhruva@gmail.com>
---

Link to v1:
https://lore.kernel.org/linux-btrfs/d17a93e6-1613-4113-a75a-8ea89efb2bdb@gmail.com/

Changes since v1:
- Use FIEMAP's encoded flag instead of dump-tree to identify compressed
  extents.
- Write in 128K blocks so the test reliably creates maximum-sized compressed
  extents, even under memory pressure.
- Fold the initial sync into the xfs_io write command.

---

 tests/btrfs/354     | 75 +++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/354.out |  2 ++
 2 files changed, 77 insertions(+)
 create mode 100755 tests/btrfs/354
 create mode 100644 tests/btrfs/354.out

diff --git a/tests/btrfs/354 b/tests/btrfs/354
new file mode 100755
index 00000000..8a19b7c3
--- /dev/null
+++ b/tests/btrfs/354
@@ -0,0 +1,75 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2026 Meta Platforms, Inc.  All Rights Reserved.
+#
+# FS QA Test 354
+#
+# Make sure "btrfs filesystem defragment --nocomp" rewrites compressed extents
+# as uncompressed ones, even though the filesystem is mounted with compression
+# enabled, and without changing the file contents.
+#
+# Note that regular defrag deliberately skips compressed extents that are
+# already at their maximum size (see btrfs/259), so a broken --nocomp that
+# simply does nothing would go unnoticed without this test.
+#
+. ./common/preamble
+_begin_fstest auto quick defrag fiemap compress
+
+. ./common/filter
+. ./common/punch # for _filter_fiemap_flags
+
+# real QA test starts here
+
+_require_scratch
+_require_xfs_io_command "fiemap"
+_require_btrfs_command filesystem defragment --nocomp
+
+_wants_kernel_commit 009b2056cb25 \
+	"btrfs: defrag: add flag to force no-compression"
+
+_scratch_mkfs >> $seqres.full 2>&1 || _fail "mkfs failed"
+_scratch_mount -o compress=zlib
+
+# Probe kernel support separately from the userspace check above. Kernels
+# without the flag reject it with EOPNOTSUPP when unknown-flag validation is
+# available.
+$XFS_IO_PROG -f -c "pwrite 0 10" "$SCRATCH_MNT/probe" >> $seqres.full
+$BTRFS_UTIL_PROG filesystem defragment --nocomp "$SCRATCH_MNT/probe" \
+	>> $seqres.full 2>&1 || _notrun "defrag --nocomp not supported"
+
+# Default xfs_io pattern is highly compressible. Use a 128K block size so the
+# file lands as maximum-size compressed extents even under memory pressure,
+# and sync so that fiemap below observes stable extents.
+$XFS_IO_PROG -f -c "pwrite -b 128K 0 1m" -c "sync" \
+	"$SCRATCH_MNT/foo" >> $seqres.full
+
+# fiemap reports compressed extents with the ENCODED (0x8) flag, printed as
+# "encoded" by _filter_fiemap_flags (see btrfs/280, btrfs/281).
+$XFS_IO_PROG -c "fiemap -v" "$SCRATCH_MNT/foo" | \
+	_filter_fiemap_flags 1 > $tmp.before
+cat $tmp.before >> $seqres.full
+grep -q "encoded" $tmp.before || \
+	echo "file has no compressed extents before --nocomp defrag"
+
+csum_before=$(_md5_checksum "$SCRATCH_MNT/foo")
+
+$BTRFS_UTIL_PROG filesystem defragment --nocomp "$SCRATCH_MNT/foo" \
+	>> $seqres.full 2>&1
+
+# Should no longer be compressed, despite the compress mount option: no
+# extent of the file may still carry the ENCODED flag.
+$XFS_IO_PROG -c "fiemap -v" "$SCRATCH_MNT/foo" | \
+	_filter_fiemap_flags 1 > $tmp.after
+cat $tmp.after >> $seqres.full
+grep -q "encoded" $tmp.after && \
+	echo "file still has compressed extents after --nocomp defrag"
+
+# Contents must survive the rewrite, read back from disk and not page cache
+_scratch_cycle_mount "compress=zlib"
+csum_after=$(_md5_checksum "$SCRATCH_MNT/foo")
+[ "$csum_before" = "$csum_after" ] || echo "file content changed"
+
+echo "Silence is golden"
+
+# success, all done
+_exit 0
diff --git a/tests/btrfs/354.out b/tests/btrfs/354.out
new file mode 100644
index 00000000..8bc7ecf6
--- /dev/null
+++ b/tests/btrfs/354.out
@@ -0,0 +1,2 @@
+QA output created by 354
+Silence is golden
-- 
2.43.0
