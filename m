Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:8765 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752480AbaLII1o (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 9 Dec 2014 03:27:44 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id sB98RLQc013485
	for <linux-btrfs@vger.kernel.org>; Tue, 9 Dec 2014 16:27:21 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v4 08/13] btrfs-progs: Add count_digit() function to help calculate filename len.
Date: Tue, 9 Dec 2014 16:27:27 +0800
Message-ID: <1418113652-25088-9-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1418113652-25088-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1418113652-25088-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add count_digit() function in utils.h to help calculate filename with
ino suffix.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
Changelog:
v4:
   Newly introduced.
---
 utils.h | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/utils.h b/utils.h
index 289e86b..f68d6d8 100644
--- a/utils.h
+++ b/utils.h
@@ -161,4 +161,22 @@ static inline u64 btrfs_min_dev_size(u32 leafsize)
 
 int find_next_key(struct btrfs_path *path, struct btrfs_key *key);
 
+/*
+ * Get the length of the string converted from a u64 number.
+ *
+ * Result is equal to log10(num) + 1, but without the use of math library.
+ */
+static inline int count_digit(u64 num)
+{
+	int ret = 0;
+
+	if (num == 0)
+		return 1;
+	while (num > 0) {
+		ret++;
+		num /= 10;
+	}
+	return ret;
+}
+
 #endif
-- 
2.1.3

