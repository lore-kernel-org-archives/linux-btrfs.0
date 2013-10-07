Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:39223 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753112Ab3JGHZK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 7 Oct 2013 03:25:10 -0400
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH v3 11/12] Btrfs-progs: make pretty_size_snprintf() return len
Date: Mon, 7 Oct 2013 15:21:47 +0800
Message-Id: <1381130508-8458-12-git-send-email-wangsl.fnst@cn.fujitsu.com>
In-Reply-To: <1381130508-8458-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
References: <1381130508-8458-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Sometimes, we need to catch length of snprintf() in pretty_size_snprintf().

Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
---
 utils.c | 9 +++++----
 utils.h | 4 ++--
 2 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/utils.c b/utils.c
index 4ed7405..7b42022 100644
--- a/utils.c
+++ b/utils.c
@@ -1190,13 +1190,13 @@ out:
 }
 
 static char *size_strs[] = { "", "KiB", "MiB", "GiB", "TiB", "PiB", "EiB"};
-void pretty_size_snprintf(u64 size, char *str, size_t str_bytes)
+int pretty_size_snprintf(double size, char *str, size_t str_bytes)
 {
 	int num_divs = 0;
 	float fraction;
 
 	if (str_bytes == 0)
-		return;
+		return 0;
 
 	if( size < 1024 ){
 		fraction = size;
@@ -1212,11 +1212,12 @@ void pretty_size_snprintf(u64 size, char *str, size_t str_bytes)
 
 		if (num_divs >= ARRAY_SIZE(size_strs)) {
 			str[0] = '\0';
-			return;
+			return -1;
 		}
 		fraction = (float)last_size / 1024;
 	}
-	snprintf(str, str_bytes, "%.2f%s", fraction, size_strs[num_divs]);
+	return snprintf(str, str_bytes, "%.2f%s", fraction,
+			size_strs[num_divs]);
 }
 
 int parse_block_size(const char *ch)
diff --git a/utils.h b/utils.h
index 40b662d..240b590 100644
--- a/utils.h
+++ b/utils.h
@@ -48,11 +48,11 @@ int check_mounted_where(int fd, const char *file, char *where, int size,
 int btrfs_device_already_in_root(struct btrfs_root *root, int fd,
 				 int super_offset);
 
-void pretty_size_snprintf(u64 size, char *str, size_t str_bytes);
+int pretty_size_snprintf(double size, char *str, size_t str_bytes);
 #define pretty_size(size) 						\
 	({								\
 		static __thread char _str[24];				\
-		pretty_size_snprintf((size), _str, sizeof(_str));	\
+		(void)pretty_size_snprintf((size), _str, sizeof(_str));	\
 		_str;							\
 	})
 
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-
