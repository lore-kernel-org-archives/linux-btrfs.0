Received: from mail-dl1-f42.google.com (mail-dl1-f42.google.com [74.125.82.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0E1B38F254
	for <linux-btrfs@vger.kernel.org>; Sun, 11 Oct 2026 19:41:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791747685; cv=none; b=JzPoXDcjHUYZ+8a/MEjX/8jYGocWwP9UIrrQff50i6/AfX89vFSDUgPgcRIOfjxlgqJjHDbye8QvEz/pzqCscuHctE8qbsLEqF7V8Q/JDUt+xU9FarOauhZZK7YWdlekn+XcFhPmDIlzuLTVrL8aAEd+GaoIJQaN9+HRUiArvJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791747685; c=relaxed/simple;
	bh=qxaW5OKIv5w7s/7Tax+iVDcj4okxytxmwYjP8BRlKh8=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=RmCogZS+iPwQ//o7pvSfDvwQM2TOuSEvRs/jpTRjgUDaud1r+VMdDUXjtLlnT3yTdPsLu+WjKCUBCVlhsfGilkfAtWGBgpnAiKhJ5ZBUK+4zwHjTQFdxLLHEfte7E8NWwnDjX52HFRpWrFbWUEQrcQgqlvNIXhA32TJq1bKh4+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NyWvdsn3; arc=none smtp.client-ip=74.125.82.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NyWvdsn3"
Received: by mail-dl1-f42.google.com with SMTP id a92af1059eb24-15168a20b47so784431c88.1
        for <linux-btrfs@vger.kernel.org>; Sun, 11 Oct 2026 12:41:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791747683; x=1792352483; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:cc:to:subject:from:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=6ZOd2QHYy5OTZsLVHh3acUf6GMxhs+2lZfOBKUt378E=;
        b=NyWvdsn3vi9pvLADbnd9urZpWk8tbow7o0EUU0K+IbKMBpl6OVOU4fuyJHR99YaMpM
         6JIwuYPBXyb/BXZ95VCtdWM+Q8Rl6YhtrRDWkWLWzPpgW/wK/guylSqt1orWrMAnwELE
         xZR1lcaFdgQZN5uaKHulqpw6DkXDGOwV5g3fPO29tlY8Q2GwoogJK601q/KOQSVBym4u
         B2q6b1liMgN3mNmq+GRLBXos38fe/djrenM1T7wYdSMpMh3TsRTVfQuzO4GAhMj/OxF7
         u+5z461SNIHPk2zfsBCi+BUUehAwcLBMEPPhpioN127SLIv8gfxo1KON2Es1e+bm9fCy
         MPKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791747683; x=1792352483;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:cc:to:subject:from:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6ZOd2QHYy5OTZsLVHh3acUf6GMxhs+2lZfOBKUt378E=;
        b=Md3kxtPbIpfJLnHLIU4fB+KA8ZSma5vPNoSQjXIGhWlIzpewqin0QYFH+iVn5rowTj
         KN/4WDWKuwGsdhOeTlugMJwcO31kkMnhwSTXiJz08woF+nt1ctSaJ7yW+oZzDKyeQl5+
         bYODkDQ9YhTGUNY2mqWFtJG1s2GBdpPdA6cEuxXEEuzB2tLN/Oxa+gbB/A+anKKG3skZ
         tjm/0sWogtKJak3gfTXnf32CC4O5FCd6eTqv8coTpTvGCKDhFoTO18329EKJdaDpNrSA
         rzUuEzGuQxheOQhfIu3fIw/FPgrw3bgN7dsNqp+QB7JidySuADScq4IKmNUdMzknH7J3
         IFOA==
X-Forwarded-Encrypted: i=1; AKwUvBwxg0yWKNurlvjETXWm8rTO3pbW20e4JrhRoXPKamwYnAK2+iZLxrtCKJDSV2wf1WvFxa2n8CK8GO+HQg==@vger.kernel.org
X-Gm-Message-State: AFq9FYI6vPd1jHYJVJA/bTfSQjmVK9lAxLyw6DFFEa5ufX397posc5GG
	PU9yEDjPlUeE7sHNqNmgO2JL9V9P0NvldudW31q1o4v/cRdg1W+cPSwF
X-Gm-Gg: AYBFou1VNYkO/lyVP45ClzykIVaPErhWXmv5/ywTDO9XuPtQPDGLkx+dwrAzhuP6krq
	zYUXxKOCwvICEKJ5Dvq1exe3BLzN7pVDHBRzfPQ4KWBKXwI51tPYU/mgaedGwuReb/A/Nk+8RAy
	I0ziktXrHlTiAX7o8gn04KTunSzYiPWXMomLOatjekw9z0T47Ja/2BjQO8eD3sjtsOkbEr3rlgN
	78DjmVh373YJK7xSsLtGW/+uqMdTHjvu30FQydW1gn9PNOVizZMnFCUW3vjDcaWq04v4h/njkzi
	UIfhvw8onghcD+Ya2pHOPaXPizqE3odRu2YUG3AMCsR8ZgiJ58Tzk8//WIAn7KWjtC1j9duYPQd
	KShZjs4taj8jtmw37j/H+aA3dDH5lrDGZjdl9svuibQY+0mMeET3vQFG4y0mYMKWF/ji+RT+SJN
	e/RXVnE6LclCCrEit6JBQ5IeyTsPzk6gpVCwx0P7sJVxG2KuyjNF29OAktJHfHh/4tGkV2m5Ad9
	HR2KUn0JKT1KhMurtOWxi89YhMR94TLbKmF9JsAXfyxV1KK
X-Received: by 2002:a05:7022:3b87:b0:14c:e31e:5dd4 with SMTP id a92af1059eb24-16a60ce6e71mr13011010c88.36.1791747682453;
        Sun, 11 Oct 2026 12:41:22 -0700 (PDT)
Received: from ?IPV6:2406:7400:56:97af:bd42:ace4:1245:4b57? ([2406:7400:56:97af:bd42:ace4:1245:4b57])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-16996eac537sm23338358c88.1.2026.10.11.12.41.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 11 Oct 2026 12:41:22 -0700 (PDT)
Message-ID: <17ce825e-5edd-4bdb-8a0b-e4820c23ca80@gmail.com>
Date: Mon, 12 Oct 2026 01:11:17 +0530
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Dhruva G <goledhruva@gmail.com>
Subject: [PATCH 2/3] btrfs: check NOCOMPRESS preserves holes and preallocation
To: fstests@vger.kernel.org
Cc: Anand Jain <asj@kernel.org>, Filipe Manana <fdmanana@suse.com>,
 Zorro Lang <zlang@kernel.org>, linux-btrfs@vger.kernel.org,
 Qu Wenruo <quwenruo.btrfs@gmx.com>
References: <cover.1791395660.git.goledhruva@gmail.com>
Content-Language: en-US
In-Reply-To: <cover.1791395660.git.goledhruva@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Place compressed data islands around holes and preallocated extents,
including a KEEP_SIZE reservation beyond EOF. Defragment the file with
--nocomp and require every data island to become uncompressed.

Check that each hole stays unmapped and both reservations retain their
complete physical mappings and UNWRITTEN state. Verify the layout,
contents, and file size again after remounting with compression enabled.
This extends btrfs/257 to NOCOMPRESS and compressed sparse files.

Signed-off-by: Dhruva Gole <goledhruva@gmail.com>
---
 tests/btrfs/356     | 71 +++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/356.out |  2 ++
 2 files changed, 73 insertions(+)
 create mode 100755 tests/btrfs/356
 create mode 100644 tests/btrfs/356.out

diff --git a/tests/btrfs/356 b/tests/btrfs/356
new file mode 100755
index 00000000..829c6e95
--- /dev/null
+++ b/tests/btrfs/356
@@ -0,0 +1,71 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) Meta Platforms, Inc. and affiliates.
+#
+# FS QA Test 356
+#
+# Verify NOCOMPRESS skips holes and preallocated extents.
+#
+. ./common/preamble
+_begin_fstest auto quick defrag compress prealloc fiemap
+
+. ./common/filter
+. ./common/btrfs_nocomp
+
+_nc_require
+_require_xfs_io_command falloc -k
+_scratch_mkfs -s 4k >> "$seqres.full" 2>&1 || _fail "mkfs failed"
+_scratch_mount -o compress=zlib
+_nc_probe
+
+file="$SCRATCH_MNT/islands"
+_nc_write "$file" 0 131072 0x31
+_nc_write "$file" 524288 131072 0x32
+_nc_write "$file" 1048576 131072 0x33
+for offset in 0 524288 1048576; do
+	_nc_check_range "$file" "$offset" 131072 compressed
+done
+$XFS_IO_PROG -c 'falloc 256K 128K' -c 'falloc -k 1280K 128K' -c fsync \
+	"$file" >> "$seqres.full" 2>&1 || _fail "fallocate failed"
+[ "$(stat -c %s "$file")" = 1179648 ] || _fail "fallocate extended EOF"
+_nc_save_file "$file"
+
+check_layout()
+{
+	local offset
+
+	for offset in 262144 1310720; do
+		_nc_check_range "$file" "$offset" 131072 prealloc
+		_nc_mapping "$file" "$offset" 131072 > "$tmp.prealloc-$offset-now"
+		cmp -s "$tmp.prealloc-$offset" "$tmp.prealloc-$offset-now" ||
+			_fail "prealloc mapping changed at $offset"
+	done
+	_nc_check_range "$file" 131072 131072 hole
+	_nc_check_range "$file" 393216 131072 hole
+	_nc_check_range "$file" 655360 393216 hole
+	_nc_check_range "$file" 1179648 131072 hole
+}
+
+# Include the KEEP_SIZE reservation beyond EOF in the baseline. FIEMAP
+# reports preallocation there even though there are no bytes to read.
+for offset in 262144 1310720; do
+	_nc_check_range "$file" "$offset" 131072 prealloc
+	_nc_mapping "$file" "$offset" 131072 > "$tmp.prealloc-$offset"
+done
+check_layout
+_nc_defrag "$file"
+for offset in 0 524288 1048576; do
+	_nc_check_range "$file" "$offset" 131072 regular
+done
+check_layout
+_nc_verify_files
+
+_scratch_cycle_mount compress=zlib
+_nc_verify_files
+check_layout
+for offset in 0 524288 1048576; do
+	_nc_check_range "$file" "$offset" 131072 regular
+done
+
+echo "Silence is golden"
+_exit 0
diff --git a/tests/btrfs/356.out b/tests/btrfs/356.out
new file mode 100644
index 00000000..78eedd26
--- /dev/null
+++ b/tests/btrfs/356.out
@@ -0,0 +1,2 @@
+QA output created by 356
+Silence is golden
-- 
2.43.0
