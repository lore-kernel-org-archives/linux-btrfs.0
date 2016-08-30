Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:57662 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752187AbcH3HW2 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 30 Aug 2016 03:22:28 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Lukas Lueg <lukas.lueg@gmail.com>
Subject: [PATCH 5/5] btrfs-progs: fuzz-test: Add test case for unaligned extent item
Date: Tue, 30 Aug 2016 15:22:17 +0800
Message-ID: <20160830072217.8599-6-quwenruo@cn.fujitsu.com>
In-Reply-To: <20160830072217.8599-1-quwenruo@cn.fujitsu.com>
References: <20160830072217.8599-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Lukas Lueg <lukas.lueg@gmail.com>

Signed-off-by: Lukas Lueg <lukas.lueg@gmail.com>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 tests/fuzz-tests/images/unaligned-extent-item.raw.txt |   8 ++++++++
 tests/fuzz-tests/images/unaligned-extent-item.raw.xz  | Bin 0 -> 3684 bytes
 2 files changed, 8 insertions(+)
 create mode 100644 tests/fuzz-tests/images/unaligned-extent-item.raw.txt
 create mode 100644 tests/fuzz-tests/images/unaligned-extent-item.raw.xz

diff --git a/tests/fuzz-tests/images/unaligned-extent-item.raw.txt b/tests/fuzz-tests/images/unaligned-extent-item.raw.txt
new file mode 100644
index 0000000..7f0b804
--- /dev/null
+++ b/tests/fuzz-tests/images/unaligned-extent-item.raw.txt
@@ -0,0 +1,8 @@
+URL: https://bugzilla.kernel.org/show_bug.cgi?id=155181
+Lukas Lueg 2016-08-28 10:52:32 UTC
+
+Created attachment 230891 [details]
+BTRFS-image that reaches abort() in btrfsck
+
+More news from the fuzzer. The attached image causes btrfsck to reach abort()
+in in cmds-check.c:add_tree_backref(); using btrfs-progs v4.7-42-g56e9586.
diff --git a/tests/fuzz-tests/images/unaligned-extent-item.raw.xz b/tests/fuzz-tests/images/unaligned-extent-item.raw.xz
new file mode 100644
index 0000000000000000000000000000000000000000..c401f2e575467fd33118e3e0dacc2e35636065f2
GIT binary patch
literal 3684
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

literal 0
HcmV?d00001

-- 
2.9.3



