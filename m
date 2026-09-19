Received: from mail-pj2-f13.google.com (mail-pj2-f13.google.com [74.125.227.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 024E83655ED
	for <linux-btrfs@vger.kernel.org>; Sat, 19 Sep 2026 18:22:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789842172; cv=none; b=P1wAZB4GofkYHtx0SAhJv7uMJtplVzZf+gPhz9LLpm1MLZ2d6H3pSOUgLCLeepGWPwBtnzoT2T+VA76RMIoLA9633am/cZD71r3ge309dubvuyy3wjZoZY+z5gw3UAIv4u2hjLe9SOXNfyEL393sJmhaAljLdk0cgFg/VrPqpp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789842172; c=relaxed/simple;
	bh=j4eVMt0xX8WdTr/XFGIM2pyQEfehniqsmIBGkwZtdto=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:Content-Type; b=j5BgdGjWlq9Xo9N6+YGnUNdDBtEzlcR2HJIvQLCJKKvKTcBwTkqQv1fgWnwYH7V5i64gA+4MtqG+45VC61L1GlKEhuvjfL9xL+5UioMIbtF4z9eo1IXGDyZhsi9rd9bbAtoDsLEcR9iS5pKK+9w2cETrY4SNlsBkkLF2oBo3xDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iM6t9lya; arc=none smtp.client-ip=74.125.227.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iM6t9lya"
Received: by mail-pj2-f13.google.com with SMTP id 98e67ed59e1d1-396cccbba91so1230383a91.1
        for <linux-btrfs@vger.kernel.org>; Sat, 19 Sep 2026 11:22:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789842168; x=1790446968; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:content-language:to
         :subject:from:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=tgeT4moy9rnjm0QOxiAHtGEo0t/Lgs3fgkPHzzd9pgM=;
        b=iM6t9lyattrVZifhLBNMaMjHJ8aeKVyDroz/1be5VU8viz91GLOhch23z9Z283dqux
         dvd7S6xnmp+ei+O0SPO/R2yATzeb9bmvdO17oaca5/B+wl8oGHWKyxUFF2BaD3Z0i7CA
         T4I1WW7Pa5GUhLAxdFFgal6cLEgbxB/qL5Ad1e3Q1VH68CE3bbIJexYNqe7JJFCby6ql
         vN3yDuPRsmRoeGbQTXTCpu5p6vaLnzLUIrCUeT7ki8kr7JvIT3muJ9ge5FRYYERWXP0k
         NCfq94RFPiA7YK3nGfU9gD0oag7xXG0egjZl4Q486WfM6SG+qh3Ann2zhwjFvoyYDsC1
         a0zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789842168; x=1790446968;
        h=content-transfer-encoding:content-type:cc:content-language:to
         :subject:from:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=tgeT4moy9rnjm0QOxiAHtGEo0t/Lgs3fgkPHzzd9pgM=;
        b=nkXxLK0iN3+1gfBWrR5hYx3bmrHUJ39O8zM/+WRo/zjwDAWQmKKwx7sVZK+FO+Cdl3
         EL+POVaMZhsZPbLtp61KkjTDokOAtXfrN1r/7liGUkzNLePRSHeY9YbXMpU+ZH4tMsJe
         V+eJxb9XctTQLstg+yYRrdVHGr5DTnwzqn3vwHF8BZCLlr6bDfBWUQSz3EkzviWjCt+c
         /2EbJmQVnSnLoFkIQZYAjZxeyqMR8/pC5HurODP/7LJOzRA+DZ9d32w0a2qh/0U6UUU2
         jbHQTwMiiz8ObatwALwL5BctDnygRWMjIgBJ8sf65KSKeYhev0aDXGfc9SoPrXvpMwFj
         NzzA==
X-Gm-Message-State: AFuF++kpTPlNnsa2yAtVDjEW+hKruFK2R91qRIfm5Yrs6kXb5i19TIdk
	eTSfzR2aPsrOiB7iyOLTsjcjayZZv30R1HsRKAxhYbFh5FsZPgGCVfw0nqhqN/j/iCk=
X-Gm-Gg: AYBFou0oexwoudVgKIgHgnOQgMW3LdiAcEG7gmHr0hXo7/pFDjZBkyJ74uTuivVyCgj
	aO+wyr+wanmTQjtb58LpI499HsWK4yxgFkOHiN9fkN05rlxNf5YNFlCSDgNl+xWq0RNyFVBRnsU
	TCAbRCt4zp8HFDqVOn0TQhCg6Tb2QTAKSRSgGEdX810t9r4R3lYrfPVPtu/TORJ7CwEX/tO+mYR
	HgEZ6bP6ZUyMSmFo0pxyI7tkX/CUhS2X/H67JLwN6tAmTBY5d2uDzZhsvMO0yHKoOybUBb28J+D
	9D65qkc68mYd9aSSEMmrzhXnbKghnHu+kdXbGhrVjfhTIUBexCqwtRFWhAka2wVbMqTLJiXinRD
	xbcnaQl9ovKCE1eVWqk2mv7w4QYH9AYttVJg/p2wZwxtnk/I1yphoJ0nkwmv+ertJN0xGU9BE3Q
	EBiyoMXWZVFTytGGjjo0A2FjNE3OclD5xbgvmwlvk0uwFeUHfuEQC/lPrl55+G3IpvYrXaD6bCK
	XjnrSrR2i72XCj2zR6XdjVPifqYctc4a4rJWZgbV8McNdKL
X-Received: by 2002:a17:90a:e7cd:b0:39e:4c81:6c5f with SMTP id 98e67ed59e1d1-39e54d5ca0emr10653302a91.26.1789842168156;
        Sat, 19 Sep 2026 11:22:48 -0700 (PDT)
Received: from ?IPV6:2406:7400:56:e503:ad72:fda5:83e8:be95? ([2406:7400:56:e503:ad72:fda5:83e8:be95])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-33c3314313esm7666793eec.14.2026.09.19.11.22.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 19 Sep 2026 11:22:47 -0700 (PDT)
Message-ID: <d17a93e6-1613-4113-a75a-8ea89efb2bdb@gmail.com>
Date: Sat, 19 Sep 2026 23:52:38 +0530
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Dhruva G <goledhruva@gmail.com>
Subject: [PATCH] btrfs: test defrag --nocomp converts comp extents to uncomp
To: linux-btrfs@vger.kernel.org, kernel-team@fb.com, fstests@vger.kernel.org
Content-Language: en-US
Cc: Boris Burkov <boris@bur.io>, Anand Jain <asj@kernel.org>,
 goledhruva@gmail.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

"btrfs filesystem defragment --nocomp" rewrites already compressed file
data as uncompressed data. The kernel flag was added by commit
009b2056cb25 ("btrfs: defrag: add flag to force no-compression") in
v6.17, and the userspace option shipped in btrfs-progs v6.16. There is
no test for it.

Add a test that writes compressible data on a filesystem mounted with
compression enabled, runs defragment with --nocomp, and verifies that no
extent remains compressed while the file contents are unchanged across a
remount. The filesystem stays mounted with compress=zlib for the whole
test, which also covers that the defrag ioctl takes precedence over mount
options.

Regular defrag deliberately leaves maximum-sized compressed extents alone,
as asserted by btrfs/259. A --nocomp implementation that silently behaves
like regular defrag therefore requires a dedicated test.

Check support in two stages: first require btrfs-progs to advertise
--nocomp, then invoke it on a 10-byte file to verify that the kernel
accepts the flag. Kernels with the unknown-flag validation from commit
173431b274a9 return EOPNOTSUPP when NOCOMPRESS is unavailable. Kernels
predating that validation may silently ignore the flag and fail the
semantic checks instead of skipping.

Signed-off-by: Dhruva Gole <goledhruva@gmail.com>
---

Logs/ compatibility matrix:
https://gist.github.com/DhruvaG2000/62101a37f5e53e41883b4b3181250724

---

 tests/btrfs/354     | 92 +++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/354.out |  2 +
 2 files changed, 94 insertions(+)
 create mode 100755 tests/btrfs/354
 create mode 100644 tests/btrfs/354.out

diff --git a/tests/btrfs/354 b/tests/btrfs/354
new file mode 100755
index 00000000..fae8f47e
--- /dev/null
+++ b/tests/btrfs/354
@@ -0,0 +1,92 @@
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
+_begin_fstest auto quick defrag compress
+
+# real QA test starts here
+
+_require_scratch
+_require_btrfs_command inspect-internal dump-tree
+_require_btrfs_command filesystem defragment --nocomp
+
+_wants_kernel_commit 009b2056cb25 \
+	"btrfs: defrag: add flag to force no-compression"
+
+# Same helper as btrfs/260: btrfs specific extent attributes are only
+# available from dump-tree, not from fiemap.
+#
+# NOTE: At the moment this only works if the file is on a filesystem on top of
+#       the scratch device and the file is in the default subvolume (tree id 5).
+check_file_extent()
+{
+	local file="$1"
+	local offset="$2"
+	local expected="$3"
+	local ino=$(stat -c "%i" "$file")
+
+	echo "=== file extent at file '$file' offset $offset ===" >> $seqres.full
+	$BTRFS_UTIL_PROG inspect-internal dump-tree -t 5 $SCRATCH_DEV |\
+		grep -A4 "($ino EXTENT_DATA $offset)" > $tmp.output
+	cat $tmp.output >> $seqres.full
+	grep -q "$expected" $tmp.output ||\
+		echo "file \"$file\" offset $offset doesn't have expected string" \
+		     "\"$expected\""
+}
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
+# Default xfs_io pattern is highly compressible, so every extent of this file
+# ends up compressed and at the 128K maximum compressed extent size.
+$XFS_IO_PROG -f -c "pwrite 0 1m" "$SCRATCH_MNT/foo" >> $seqres.full
+$BTRFS_UTIL_PROG filesystem sync $SCRATCH_MNT
+
+# Should be zlib compressed
+check_file_extent "$SCRATCH_MNT/foo" 0 "compression 1"
+
+csum_before=$(_md5_checksum "$SCRATCH_MNT/foo")
+
+$BTRFS_UTIL_PROG filesystem defragment --nocomp "$SCRATCH_MNT/foo" \
+	>> $seqres.full 2>&1
+
+# Need to commit the transaction or dump-tree won't grab the new
+# metadata on-disk.
+$BTRFS_UTIL_PROG filesystem sync $SCRATCH_MNT
+
+# Should no longer be compressed, despite the compress mount option
+check_file_extent "$SCRATCH_MNT/foo" 0 "compression 0"
+
+# No extent of this inode may remain compressed
+ino=$(stat -c "%i" "$SCRATCH_MNT/foo")
+$BTRFS_UTIL_PROG inspect-internal dump-tree -t 5 $SCRATCH_DEV |
+	grep -A4 "($ino EXTENT_DATA " | grep -q "compression [^0]" &&
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
