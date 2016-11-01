Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:33020 "EHLO song.cn.fujitsu.com"
        rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1167893AbcKAIC1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 1 Nov 2016 04:02:27 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: [PATCH v3 1/4] btrfs-progs: utils: Introduce function to escape characters
Date: Tue,  1 Nov 2016 16:01:43 +0800
Message-Id: <20161101080147.13163-2-quwenruo@cn.fujitsu.com>
In-Reply-To: <20161101080147.13163-1-quwenruo@cn.fujitsu.com>
References: <20161101080147.13163-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Introduce new function, escape_string_inplace(), to escape specified
characters in place.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 utils.c | 17 +++++++++++++++++
 utils.h |  2 ++
 2 files changed, 19 insertions(+)

diff --git a/utils.c b/utils.c
index 3f54245..69faae1 100644
--- a/utils.c
+++ b/utils.c
@@ -4251,3 +4251,20 @@ unsigned int rand_range(unsigned int upper)
 	 */
 	return (unsigned int)(jrand48(rand_seed) % upper);
 }
+
+void string_escape_inplace(char *restrict string, char *restrict escape_chars)
+{
+	int i, j;
+
+	for (i = 0; i < strlen(escape_chars); i++) {
+		j = 0;
+		while (j < strlen(string)) {
+			if (string[j] == escape_chars[i]) {
+				memmove(string + j, string + j + 1,
+					strlen(string) -j);
+				continue;
+			}
+			j++;
+		}
+	}
+}
diff --git a/utils.h b/utils.h
index 1a2dbcd..b36d411 100644
--- a/utils.h
+++ b/utils.h
@@ -457,4 +457,6 @@ unsigned int rand_range(unsigned int upper);
 /* Also allow setting the seed manually */
 void init_rand_seed(u64 seed);
 
+void string_escape_inplace(char *restrict string, char *restrict escape_chars);
+
 #endif
-- 
2.10.1



