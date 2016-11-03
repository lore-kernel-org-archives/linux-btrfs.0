Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:51486 "EHLO song.cn.fujitsu.com"
        rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1751589AbcKCEIM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 3 Nov 2016 00:08:12 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: [PATCH v4 1/4] btrfs-progs: utils: Introduce function to escape characters
Date: Thu,  3 Nov 2016 12:07:31 +0800
Message-Id: <20161103040734.8098-2-quwenruo@cn.fujitsu.com>
In-Reply-To: <20161103040734.8098-1-quwenruo@cn.fujitsu.com>
References: <20161103040734.8098-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Introduce new function, escape_string_inplace(), to escape specified
characters in place.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 utils.c | 24 ++++++++++++++++++++++++
 utils.h | 14 ++++++++++++++
 2 files changed, 38 insertions(+)

diff --git a/utils.c b/utils.c
index 3f54245..3c50d84 100644
--- a/utils.c
+++ b/utils.c
@@ -4251,3 +4251,27 @@ unsigned int rand_range(unsigned int upper)
 	 */
 	return (unsigned int)(jrand48(rand_seed) % upper);
 }
+
+static void escape_one_char(char *restrict string, char escape)
+{
+	int i = 0;
+	int j = 0;
+
+	while (string[j] != '\0') {
+		if (string[j] != escape) {
+			string[i] = string[j];
+			i++;
+		}
+		j++;
+	}
+	/* pend the finishing '\0' */
+	string[i] = '\0';
+}
+
+void string_escape_inplace(char *restrict string, char *restrict escape_chars)
+{
+	int i;
+
+	for (i = 0; i < strlen(escape_chars); i++)
+		escape_one_char(string, escape_chars[i]);
+}
diff --git a/utils.h b/utils.h
index 1a2dbcd..dae8db4 100644
--- a/utils.h
+++ b/utils.h
@@ -457,4 +457,18 @@ unsigned int rand_range(unsigned int upper);
 /* Also allow setting the seed manually */
 void init_rand_seed(u64 seed);
 
+void string_escape_inplace(char *restrict string, char *restrict escape_chars);
+
+static inline char* string_escape(char *restrict src,
+				  char *restrict escape_chars)
+{
+	char *ret;
+
+	ret = malloc(strlen(src) + 1);
+	if (!ret)
+		return NULL;
+	string_escape_inplace(ret, escape_chars);
+	return ret;
+}
+
 #endif
-- 
2.10.1



