Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:16327 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750856AbcEYEOX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 25 May 2016 00:14:23 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH 1/2] btrfs-progs: utils: Introduce new pseudo random API
Date: Wed, 25 May 2016 12:14:04 +0800
Message-Id: <1464149645-4308-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

David has reported some quite chaos usage of pseudo random numbers.
Like using static srand seed, or even calling rand() without setting
seed correctly.

The new pseudo random API will initialize the random seed on its first
calling and use uniformly distributed pseudo random number generator as
backend.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 utils.c | 36 ++++++++++++++++++++++++++++++++++++
 utils.h | 36 ++++++++++++++++++++++++++++++++++++
 2 files changed, 72 insertions(+)

diff --git a/utils.c b/utils.c
index 7761165..c0e860a 100644
--- a/utils.c
+++ b/utils.c
@@ -54,9 +54,11 @@
 #define BLKDISCARD	_IO(0x12,119)
 #endif
 
+static int seed_initlized = 0;
 static int btrfs_scan_done = 0;
 
 static char argv0_buf[ARGV0_BUF_SIZE] = "btrfs";
+static unsigned short seeds[3];
 
 const char *get_argv0_buf(void)
 {
@@ -4051,3 +4053,37 @@ out:
 
 	return ret;
 }
+
+void rand_seed(u64 seed)
+{
+	int i;
+	/* only use the last 48 bits */
+	for (i = 0; i < 3; i++) {
+		seeds[i] = (unsigned short)(seed ^ (unsigned short)(-1));
+		seed >>= 16;
+	}
+	seed_initlized = 1;
+}
+
+u32 rand_u32(void)
+{
+	struct timeval tv;
+
+	if (seed_initlized)
+		return nrand48(seeds);
+
+	/*
+	 * It's possible to use /dev/random, but we don't need that true
+	 * random number nor want to wait for entropy,
+	 * since we're only using random API to do corruption to test.
+	 * Time and pid/ppid based seed would be good enough, and won't
+	 * cause sleep for entropy pool.
+	 */
+	gettimeofday(&tv, 0);
+	seeds[0] = getpid() ^ (tv.tv_sec & 0xFFFF);
+	seeds[1] = getppid() ^ (tv.tv_usec & 0xFFFF);
+	seeds[2] = (tv.tv_sec ^ tv.tv_usec) >> 16;
+	seed_initlized = 1;
+
+	return (u32)nrand48(seeds);
+}
diff --git a/utils.h b/utils.h
index ebe6d61..0977262 100644
--- a/utils.h
+++ b/utils.h
@@ -362,4 +362,40 @@ static inline int error_on(int condition, const char *fmt, ...)
 	return 1;
 }
 
+/* pseudo random number generator wrappers */
+u32 rand_u32(void);
+
+static inline int rand_int(void)
+{
+	return (int)(rand_u32());
+}
+
+static inline u64 rand_u64(void)
+{
+	u64 ret = 0;
+
+	ret += rand_u32();
+	ret <<= 32;
+	ret += rand_u32();
+	return ret;
+}
+
+static inline u16 rand_u16(void)
+{
+	return (u16)(rand_u32());
+}
+
+static inline u8 rand_u8(void)
+{
+	return (u8)(rand_u32());
+}
+
+/* Return random number in range [0, limit) */
+static inline unsigned int rand_range(unsigned int up)
+{
+	return (unsigned int)(rand_u32() % up);
+}
+
+/* Also allow setting seeds manually */
+void rand_seed(u64 seed);
 #endif
-- 
2.8.2



