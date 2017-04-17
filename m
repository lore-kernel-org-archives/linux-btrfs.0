Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:62053 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S932558AbdDQD0w (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 16 Apr 2017 23:26:52 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>, <dsterba@suse.cz>
Subject: [PATCH 5/9] btrfs-progs: utils: Introduce new function arg_strtou32
Date: Mon, 17 Apr 2017 11:26:38 +0800
Message-ID: <20170417032642.30770-6-quwenruo@cn.fujitsu.com>
In-Reply-To: <20170417032642.30770-1-quwenruo@cn.fujitsu.com>
References: <20170417032642.30770-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This function is just calling arg_strtou64() and then do extra
UINT32_MAX check.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 utils-lib.c | 15 +++++++++++++++
 utils.h     |  1 +
 2 files changed, 16 insertions(+)

diff --git a/utils-lib.c b/utils-lib.c
index 044f93fc..544f6750 100644
--- a/utils-lib.c
+++ b/utils-lib.c
@@ -44,6 +44,21 @@ u64 arg_strtou64(const char *str)
 }
 
 /*
+ * u32 version of arg_strtou*()
+ */
+u32 arg_strtou32(const char *str)
+{
+	u64 tmp;
+
+	tmp = arg_strtou64(str);
+	if (tmp >= UINT32_MAX) {
+		fprintf(stderr, "ERROR: %s is too large.\n", str);
+		exit(1);
+	}
+	return (u32)tmp;
+}
+
+/*
  * For a given:
  * - file or directory return the containing tree root id
  * - subvolume return its own tree id
diff --git a/utils.h b/utils.h
index 24d0a200..f6deb26c 100644
--- a/utils.h
+++ b/utils.h
@@ -94,6 +94,7 @@ const char *pretty_size_mode(u64 size, unsigned mode);
 u64 parse_size(char *s);
 u64 parse_qgroupid(const char *p);
 u64 arg_strtou64(const char *str);
+u32 arg_strtou32(const char *str);
 int arg_copy_path(char *dest, const char *src, int destlen);
 int open_file_or_dir(const char *fname, DIR **dirstream);
 int open_file_or_dir3(const char *fname, DIR **dirstream, int open_flags);
-- 
2.12.2



