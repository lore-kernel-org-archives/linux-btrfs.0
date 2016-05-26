Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:62491 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753048AbcEZC5A (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 25 May 2016 22:57:00 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: noah.massey@gmail.com, dsterba@suse.cz, ahferroin7@gmail.com,
        hugo@carfax.org.uk
Subject: [PATCH v2 1/2] btrfs-progs: utils: Introduce new pseudo random API
Date: Thu, 26 May 2016 10:56:50 +0800
Message-Id: <1464231411-13261-1-git-send-email-quwenruo@cn.fujitsu.com>
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
changelog:
v2:
  Use jrand48() to make all 32bits random. nrand48() will leave the highest
  bit 0.

  Minor fixes from Noah Massey

  Use urandom as primary seed, with time/pid/ppid as fallback.

  Split rand_range() to fully use all 32bits to mod.

---
 utils.c | 62 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 utils.h | 33 +++++++++++++++++++++++++++++++++
 2 files changed, 95 insertions(+)

diff --git a/utils.c b/utils.c
index 7761165..2cfecfb 100644
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
@@ -4051,3 +4053,63 @@ out:
 
 	return ret;
 }
+
+void rand_seed(u64 seed)
+{
+	int i;
+
+	/* only use the last 48 bits */
+	for (i = 0; i < 3; i++) {
+		seeds[i] = (unsigned short)(seed ^ (unsigned short)(-1));
+		seed >>= 16;
+	}
+	seed_initlized = 1;
+}
+
+static void init_seeds(void)
+{
+	struct timeval tv;
+	int ret;
+	int fd;
+
+	if(seed_initlized)
+		return;
+	/* Use urandom as primary seed source. */
+	fd = open("/dev/urandom", O_RDONLY);
+	if (fd >= 0) {
+		ret = read(fd, seeds, sizeof(seeds));
+		close(fd);
+		if (ret < sizeof(seeds))
+			goto fallback;
+	} else {
+fallback:
+		/* Use time and pid as fallback seed */
+		warning("failed to read /dev/urandom, use time and pid as random seed");
+		gettimeofday(&tv, 0);
+		seeds[0] = getpid() ^ (tv.tv_sec & 0xFFFF);
+		seeds[1] = getppid() ^ (tv.tv_usec & 0xFFFF);
+		seeds[2] = (tv.tv_sec ^ tv.tv_usec) >> 16;
+	}
+	seed_initlized = 1;
+}
+
+u32 rand_u32(void)
+{
+	init_seeds();
+	/*
+	 * Don't use nrand48, its range is [0,2^31)
+	 * The highest bit will alwasy be 0.
+	 * Use jrand48 to include the highest bit.
+	 */
+	return (u32)jrand48(seeds);
+}
+
+unsigned int rand_range(unsigned int up)
+{
+	init_seeds();
+	/*
+	 * Use the full 48bits to mod, which would be more uniformly
+	 * distributed
+	 */
+	return (unsigned int)(jrand48(seeds) % up);
+}
diff --git a/utils.h b/utils.h
index ebe6d61..6ceeac5 100644
--- a/utils.h
+++ b/utils.h
@@ -362,4 +362,37 @@ static inline int error_on(int condition, const char *fmt, ...)
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
+unsigned int rand_range(unsigned int up);
+
+/* Also allow setting seeds manually */
+void rand_seed(u64 seed);
 #endif
-- 
2.8.2



