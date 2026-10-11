Received: from mail-dy1-f171.google.com (mail-dy1-f171.google.com [74.125.82.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B30BF451986
	for <linux-btrfs@vger.kernel.org>; Sun, 11 Oct 2026 19:40:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791747647; cv=none; b=NfGFwF8lNiOCTLMr29CRhBHhoRE2rfQaeDyflCShJb4cG3AUhywHx36YGKaxVu/X6w00BPrGzcDbTT1i6HePTGp1fcJbNuRoE+HjxoMWwc/AInlEwfreB2TjdtfoYdZPAmeQ8CCXB4N0bEgzwtt/fO5CfTdjWLVM/knD1qYtmNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791747647; c=relaxed/simple;
	bh=+vGWaFXbaoJoA4p5C4mfwfDAXJjqa2mutmk1FhJC5uU=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=taZzpJwyrgYBtEuPGESUw6icVGTdPmQNFeKE2vFH3NjtTlsJ/f6L8SHSDyXgDYjGp6RqC5Vb1beHnOSsdywi/4jJ0bBvghs4d1gyLityWnAqM9lRSyOi3SeJbTknIcoHp9h2yxpb2k7ua7i+CjC0Vhkj/x/Qv4z4C8YD/+rqASY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GG7p8Ye1; arc=none smtp.client-ip=74.125.82.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GG7p8Ye1"
Received: by mail-dy1-f171.google.com with SMTP id 5a478bee46e88-3550c917fd3so1896566eec.0
        for <linux-btrfs@vger.kernel.org>; Sun, 11 Oct 2026 12:40:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791747645; x=1792352445; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:cc:to:subject:from:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=OLwEBcjUHQd7DKUmZ8kTQHV1NUa7SX06QFw8Dxzfm7M=;
        b=GG7p8Ye1dyLpy9UjBsdLlnsVQeUiKQEw8eHO4PVSgiksAOwmG7gh/3MMUhmDTdGs8J
         x2gAA3eJ/mIpUh6Adli8bEXsmadMwGaFJU+BKk5RTsco/M6T+wnCXCgnNOunRrOWtVnG
         Qo1WiuFh9ojz/zskw2+rJxVGJj4yDMiJE7A4+ylfg24VWS549CJqDMMoek70hGJOApkW
         cgA5VW/7G6DJ3H4FW7aVAYi8RpchnJubadyan59bV/jFr9UQDICsNXS7RG9yJ+/wwI8a
         Ut8KSQOhD0TTMJAR7SA7ZyX5KU0sAHUNhW1cv5qzoOWleI7NU2qqHv+2uVvrNwZ+X1Gq
         r3Cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791747645; x=1792352445;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:cc:to:subject:from:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=OLwEBcjUHQd7DKUmZ8kTQHV1NUa7SX06QFw8Dxzfm7M=;
        b=hyCSKXt4j7dOn+2HvA/Bdsgdw5feCZAk9G5caernj5sSrm7E7AtyjC/LWLAvYnxtN+
         /LEzozs5GZ5w72k2sdlL8/MCpSlpmyz59C5S+xvt7lnm6udX+Ra6xbhjS06UQWC6kidL
         Yhf4Uf/R1S/+GlWcOEnSrN2wOQOTTtCQYmY3pFoS5VaiPEOqLOm5Mb4Wlxxi0kYw50vm
         f7ftafMm6zPDFD7Ll/C3ACJwJNouNv1B0Lbe6P3ufsTNvZ72zzjp3N4h/7TdW3BmEmjn
         ivogFAevciO+EGM1jypn9HsBjYFn1UIll4bLqHM1CbZPnDDXCoXo1VhTLsp0aRhjxga0
         Kfnw==
X-Forwarded-Encrypted: i=1; AKwUvByiTSyRT5v28+qpt7e8hHbxNXycTKNSOac7a6pJ1GJJXdqKBC19T81Y4pZsoGJdlLOztDF9RwFnQeubKg==@vger.kernel.org
X-Gm-Message-State: AFq9FYIa3mQS2hy/HlhsGguytwWGMWCDBCA7uCtKfpKAzv5/x/HwmJY6
	LsIQGjbaWf4IlhRkokwGcF9qtIJY+U28YFe5ZJYOl4a9aee1Zrt/0MD2TzfseeEXsk0=
X-Gm-Gg: AYBFou0UFKHBiGp0UzzVamsaDkRAlxPd7wrQQACvVla7KjO674PQpw2Y7u0cNcuqRle
	zFNFGRs2VuHNWqX1sj5lTb2SbPtYfaNWqR0AGNCROaztF1H4MP/8qajwwVhF3ZG3tBggvP0E7+F
	muPb4HpNbpQ1hcIpnPUW3CjXRgkpyHq0zITLf4tM40lRP9KdtaJGblA5+vPvA7ijnvR+oPot4yR
	mJ2n8c91eY89Evk7Ws5WZlWuhUQi0SU7/rWL98IB1UYjEYzYQZGkMjDMiDzvcOgdbrOk0IQuIC3
	+zakWs/ZlDZXsmOA7fNO0YmA3uWJH7F7b0YkgSO15oI2TOSIrU47swyL6VgDL3pz8xj1MlI57lF
	9NZnIYZYlfl69NCqF9NahYLq2mp0JTq07YSBWF8bjrtBxq7sEmY97LAMi9yQuMUg6rNX8aFywbD
	P81K7/bOA8xLpRABCapsPX4p5+S9Oc7uebBtSMjK2nu4lMriNKWzB0ojgSP97q3PB6IW+fVMAUd
	Ce4FCW6ks+Gjw2IzHFvDemG9gIzpwNGz3ueeG/ZChl9Fgjj
X-Received: by 2002:a05:7301:fd17:b0:359:62d4:82c0 with SMTP id 5a478bee46e88-35962d48511mr4006940eec.41.1791747644396;
        Sun, 11 Oct 2026 12:40:44 -0700 (PDT)
Received: from ?IPV6:2406:7400:56:97af:bd42:ace4:1245:4b57? ([2406:7400:56:97af:bd42:ace4:1245:4b57])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3537cab27d5sm29691364eec.17.2026.10.11.12.40.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 11 Oct 2026 12:40:43 -0700 (PDT)
Message-ID: <b99615bd-9b7c-48b6-ac70-d450a606388c@gmail.com>
Date: Mon, 12 Oct 2026 01:10:39 +0530
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Dhruva G <goledhruva@gmail.com>
Subject: [PATCH 1/3] btrfs: exercise NOCOMPRESS range and EOF handling
To: fstests@vger.kernel.org
Cc: Anand Jain <asj@kernel.org>, Filipe Manana <fdmanana@suse.com>,
 Zorro Lang <zlang@kernel.org>, linux-btrfs@vger.kernel.org,
 Qu Wenruo <quwenruo.btrfs@gmx.com>
References: <cover.1791395660.git.goledhruva@gmail.com>
Content-Language: en-US
In-Reply-To: <cover.1791395660.git.goledhruva@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Check that a bounded --nocomp request rewrites compressed extents in the
selected range while distant untouched regions still point to their
original compressed storage.
Cover a partial final sector, zero length, a length extending past EOF,
start at EOF, and the empty-file no-op. Preserve contents and sizes across
the conversion and a remount.

Add shared FIEMAP and integrity helpers for the NOCOMPRESS tests. Require
full mapping coverage and inspect every overlapping extent so holes and
partly converted ranges cannot pass. Include a small ioctl helper to
probe kernel support and check errno without btrfs-progs translation.

Signed-off-by: Dhruva Gole <goledhruva@gmail.com>
---
 .gitignore                |   1 +
 common/btrfs_nocomp       | 134 ++++++++++++++++++++++++++++++++++++++
 src/Makefile              |   2 +-
 src/btrfs_defrag_nocomp.c |  63 ++++++++++++++++++
 tests/btrfs/355           |  80 +++++++++++++++++++++++
 tests/btrfs/355.out       |   2 +
 6 files changed, 281 insertions(+), 1 deletion(-)
 create mode 100644 common/btrfs_nocomp
 create mode 100644 src/btrfs_defrag_nocomp.c
 create mode 100755 tests/btrfs/355
 create mode 100644 tests/btrfs/355.out

diff --git a/.gitignore b/.gitignore
index 0b6b9452..1bfa12ef 100644
--- a/.gitignore
+++ b/.gitignore
@@ -216,6 +216,7 @@ tags
 /src/truncate
 /src/t_btrfs_received_uuid_ioctl
 /src/btrfs_ioctl
+/src/btrfs_defrag_nocomp
 
 # Symlinked files
 /tests/generic/035.out
diff --git a/common/btrfs_nocomp b/common/btrfs_nocomp
new file mode 100644
index 00000000..7e2111e1
--- /dev/null
+++ b/common/btrfs_nocomp
@@ -0,0 +1,134 @@
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) Meta Platforms, Inc. and affiliates.
+# Helpers for BTRFS_DEFRAG_RANGE_NOCOMPRESS tests.
+
+_nc_require()
+{
+	_require_scratch
+	_require_test_program btrfs_defrag_nocomp
+	_require_xfs_io_command fiemap ranged
+	_require_btrfs_command filesystem defragment --nocomp
+	_require_btrfs_no_nodatacow
+	_require_btrfs_no_nodatasum
+	_require_btrfs_no_autodefrag
+	_require_btrfs_support_sectorsize 4096
+	_wants_kernel_commit 009b2056cb25 \
+		"btrfs: defrag: add flag to force no-compression"
+}
+
+_nc_write()
+{
+	$XFS_IO_PROG -f -c "pwrite -S $4 -b 128K $2 $3" -c fsync "$1" \
+		>> "$seqres.full" 2>&1 || _fail "write failed: $1"
+}
+
+_nc_probe()
+{
+	local result
+
+	_nc_write "$SCRATCH_MNT/probe" 0 131072 0x5a
+	result=$($here/src/btrfs_defrag_nocomp "$SCRATCH_MNT/probe" 0 131072) ||
+		_fail "NOCOMPRESS probe failed"
+	case "$result" in
+	OK) ;;
+	EOPNOTSUPP|ENOTTY) _notrun "kernel does not support NOCOMPRESS" ;;
+	*) _fail "unexpected NOCOMPRESS probe result: $result" ;;
+	esac
+	rm -f "$SCRATCH_MNT/probe"
+}
+
+_nc_defrag()
+{
+	local file="${@: -1}"
+
+	$BTRFS_UTIL_PROG filesystem defragment --nocomp "$@" \
+		>> "$seqres.full" 2>&1 || _fail "NOCOMPRESS defrag failed"
+	$XFS_IO_PROG -c fsync "$file" >> "$seqres.full" 2>&1 ||
+		_fail "fsync after defrag failed"
+}
+
+_nc_map()
+{
+	$XFS_IO_PROG -c "fiemap -v $2 $3" "$1" > "$tmp.nc-map" \
+		2>> "$seqres.full" || _fail "fiemap failed: $1"
+	cat "$tmp.nc-map" >> "$seqres.full"
+}
+
+# FIEMAP prints logical offsets in 512-byte units. Check every overlapping
+# extent and complete coverage, so a hole or a partly converted range fails.
+# The caller supplies byte offsets and lengths, including a partial EOF sector.
+_nc_check_range()
+{
+	_nc_map "$1" "$2" "$3"
+	$AWK_PROG -v start="$2" -v len="$3" -v mode="$4" '
+	BEGIN {
+		first = int(start / 512)
+		end = int((start + len + 511) / 512)
+		next_block = first
+	}
+	$1 ~ /^[0-9]+:$/ && $5 ~ /^0x/ {
+		gsub(/[^0-9]/, " ", $2)
+		split($2, logical)
+		lo = logical[1] + 0
+		hi = logical[2] + 1
+		if (hi <= first || lo >= end)
+			next
+		if (mode == "hole") {
+			bad = 1
+			next
+		}
+		flags = strtonum($5)
+		encoded = and(flags, 0x8) != 0
+		unwritten = and(flags, 0x800) != 0
+		inline = and(flags, 0x200) != 0
+		if (and(flags, 0x6) || lo > next_block)
+			bad = 1
+		if (mode == "compressed" && (!encoded || unwritten || inline))
+			bad = 1
+		if (mode == "regular" && (encoded || unwritten || inline))
+			bad = 1
+		if (mode == "inline" && (!encoded || unwritten || !inline))
+			bad = 1
+		if (mode == "prealloc" && (encoded || !unwritten || inline))
+			bad = 1
+		if (hi > next_block)
+			next_block = hi
+	}
+	END { exit bad || (mode != "hole" && next_block < end) }
+	' "$tmp.nc-map" || _fail "unexpected $4 mapping: $1 ($2, $3)"
+}
+
+# Ignore flags such as LAST, which may change when another range is rewritten.
+_nc_mapping()
+{
+	_nc_map "$1" "$2" "$3"
+	_filter_xfs_io_fiemap < "$tmp.nc-map" | \
+		$AWK_PROG '{ print $1, $2, $3, $4 }'
+}
+
+_nc_save_file()
+{
+	md5sum "$1" >> "$tmp.nc-checksums" || _fail "checksum failed: $1"
+	stat -c '%s %n' "$1" >> "$tmp.nc-sizes" || _fail "stat failed: $1"
+}
+
+_nc_verify_files()
+{
+	local size file actual
+
+	md5sum -c "$tmp.nc-checksums" >> "$seqres.full" 2>&1 ||
+		_fail "file contents changed"
+	while read -r size file; do
+		actual=$(stat -c %s "$file") || _fail "stat failed: $file"
+		[ "$actual" = "$size" ] || _fail "file size changed: $file"
+	done < "$tmp.nc-sizes"
+}
+
+_nc_raw_expect()
+{
+	local expected="$1" result
+	shift
+	result=$($here/src/btrfs_defrag_nocomp "$@") || _fail "raw ioctl failed"
+	[ "$result" = "$expected" ] ||
+		_fail "expected $expected, got $result"
+}
diff --git a/src/Makefile b/src/Makefile
index 76cf50c3..07bf681d 100644
--- a/src/Makefile
+++ b/src/Makefile
@@ -36,7 +36,7 @@ LINUX_TARGETS = xfsctl bstat t_mtab getdevicesize preallo_rw_pattern_reader \
 	fscrypt-crypt-util bulkstat_null_ocount splice-test chprojid_fail \
 	detached_mounts_propagation ext4_resize t_readdir_3 splice2pipe \
 	uuid_ioctl t_snapshot_deleted_subvolume fiemap-fault min_dio_alignment \
-	rw_hint fs-monitor btrfs_ioctl
+	rw_hint fs-monitor btrfs_ioctl btrfs_defrag_nocomp
 
 EXTRA_EXECS = dmerror fill2attr fill2fs fill2fs_check scaleread.sh \
 	      btrfs_crc32c_forged_name.py popdir.pl popattr.py \
diff --git a/src/btrfs_defrag_nocomp.c b/src/btrfs_defrag_nocomp.c
new file mode 100644
index 00000000..4b066418
--- /dev/null
+++ b/src/btrfs_defrag_nocomp.c
@@ -0,0 +1,63 @@
+// SPDX-License-Identifier: GPL-2.0
+// Copyright (c) Meta Platforms, Inc. and affiliates.
+/* Issue NOCOMPRESS requests without userspace range/error translation. */
+#include <errno.h>
+#include <fcntl.h>
+#include <linux/btrfs.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/ioctl.h>
+#include <unistd.h>
+
+#ifndef BTRFS_DEFRAG_RANGE_NOCOMPRESS
+#define BTRFS_DEFRAG_RANGE_NOCOMPRESS (1ULL << 3)
+#endif
+
+static unsigned long long number(const char *s)
+{
+	char *end;
+	unsigned long long value;
+
+	errno = 0;
+	value = strtoull(s, &end, 0);
+	if (errno || *end || end == s || *s == '-') {
+		fprintf(stderr, "invalid number: %s\n", s);
+		exit(2);
+	}
+	return value;
+}
+
+int main(int argc, char **argv)
+{
+	struct btrfs_ioctl_defrag_range_args range = { 0 };
+	int fd, err = 0;
+	const char *result;
+
+	if (argc != 4) {
+		fprintf(stderr, "usage: %s file start len\n", argv[0]);
+		return 2;
+	}
+	range.flags = BTRFS_DEFRAG_RANGE_NOCOMPRESS;
+	range.start = number(argv[2]);
+	range.len = number(argv[3]);
+	fd = open(argv[1], O_RDONLY | O_CLOEXEC);
+	if (fd < 0) {
+		perror("open");
+		return 2;
+	}
+	if (ioctl(fd, BTRFS_IOC_DEFRAG_RANGE, &range) < 0)
+		err = errno;
+	close(fd);
+	switch (err) {
+	case 0: result = "OK"; break;
+	case EINVAL: result = "EINVAL"; break;
+	case EOPNOTSUPP: result = "EOPNOTSUPP"; break;
+	case ENOTTY: result = "ENOTTY"; break;
+	default:
+		fprintf(stderr, "unexpected errno %d (%s)\n", err, strerror(err));
+		return 1;
+	}
+	puts(result);
+	return 0;
+}
diff --git a/tests/btrfs/355 b/tests/btrfs/355
new file mode 100755
index 00000000..12befb91
--- /dev/null
+++ b/tests/btrfs/355
@@ -0,0 +1,80 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) Meta Platforms, Inc. and affiliates.
+#
+# FS QA Test 355
+#
+# Verify bounded NOCOMPRESS conversion and EOF range handling.
+#
+. ./common/preamble
+_begin_fstest auto quick defrag compress fiemap
+
+. ./common/filter
+. ./common/btrfs_nocomp
+
+_nc_require
+_scratch_mkfs -s 4k >> "$seqres.full" 2>&1 || _fail "mkfs failed"
+_scratch_mount -o compress=zlib
+_nc_probe
+
+file="$SCRATCH_MNT/range"
+_nc_write "$file" 0 4194304 0x5a
+_nc_save_file "$file"
+_nc_check_range "$file" 0 4194304 compressed
+_nc_mapping "$file" 0 131072 > "$tmp.prefix"
+_nc_mapping "$file" 4063232 131072 > "$tmp.suffix"
+
+_nc_defrag -s 1M -l 512K "$file"
+_nc_check_range "$file" 1048576 524288 regular
+_nc_check_range "$file" 0 1048576 compressed
+_nc_check_range "$file" 1572864 2621440 compressed
+_nc_mapping "$file" 0 131072 > "$tmp.prefix-after"
+_nc_mapping "$file" 4063232 131072 > "$tmp.suffix-after"
+cmp -s "$tmp.prefix" "$tmp.prefix-after" || _fail "prefix mapping changed"
+cmp -s "$tmp.suffix" "$tmp.suffix-after" || _fail "suffix mapping changed"
+
+# The two-sector tail can be compressed, unlike a single-sector tail on a
+# 4K filesystem. First convert a one-byte range, then use an unaligned start
+# and end the request at EOF, one byte into the final 4K sector.
+tail="$SCRATCH_MNT/partial"
+_nc_write "$tail" 0 135169 0x39
+_nc_save_file "$tail"
+_nc_check_range "$tail" 131072 4097 compressed
+_nc_defrag -s 128K -l 1 "$tail"
+_nc_check_range "$tail" 131072 4096 regular
+_nc_defrag -s 131073 -l 4096 "$tail"
+_nc_check_range "$tail" 131072 4097 regular
+
+# Zero length means to EOF; a length extending past EOF must be clamped.
+for mode in zero huge; do
+	f="$SCRATCH_MNT/$mode"
+	_nc_write "$f" 0 262144 0x38
+	_nc_save_file "$f"
+	_nc_check_range "$f" 0 262144 compressed
+	case "$mode" in
+	zero) _nc_defrag -s 128K -l 0 "$f" ;;
+	huge) _nc_defrag -s 128K -l 16M "$f" ;;
+	esac
+	_nc_check_range "$f" 0 131072 compressed
+	_nc_check_range "$f" 131072 131072 regular
+done
+
+# A nonempty file rejects start == EOF, but an empty file is a no-op.
+_nc_raw_expect EINVAL "$file" 4194304 4096
+touch "$SCRATCH_MNT/empty" || _fail "create empty file failed"
+_nc_save_file "$SCRATCH_MNT/empty"
+_nc_raw_expect OK "$SCRATCH_MNT/empty" 0 0
+_nc_verify_files
+_scratch_cycle_mount compress=zlib
+_nc_verify_files
+_nc_check_range "$file" 1048576 524288 regular
+_nc_check_range "$file" 0 1048576 compressed
+_nc_check_range "$file" 1572864 2621440 compressed
+_nc_check_range "$tail" 131072 4097 regular
+for mode in zero huge; do
+	_nc_check_range "$SCRATCH_MNT/$mode" 0 131072 compressed
+	_nc_check_range "$SCRATCH_MNT/$mode" 131072 131072 regular
+done
+
+echo "Silence is golden"
+_exit 0
diff --git a/tests/btrfs/355.out b/tests/btrfs/355.out
new file mode 100644
index 00000000..4e4c5e98
--- /dev/null
+++ b/tests/btrfs/355.out
@@ -0,0 +1,2 @@
+QA output created by 355
+Silence is golden
-- 
2.43.0
