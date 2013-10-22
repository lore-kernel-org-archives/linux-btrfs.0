Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:44032 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753513Ab3JVOKY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Oct 2013 10:10:24 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 50FF57C06A5
	for <linux-btrfs@vger.kernel.org>; Tue, 22 Oct 2013 08:10:24 -0600 (MDT)
Received: from CAS1.int.fusionio.com (cas1.int.fusionio.com [10.101.1.40]) by mx2.fusionio.com with ESMTP id P6ABAyf7an8BWl8x (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Tue, 22 Oct 2013 08:10:23 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs-progs: make pretty_sizes take u64 instead of a double
Date: Tue, 22 Oct 2013 10:10:21 -0400
Message-ID: <1382451021-16745-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This got changed to a double but all the callers still use a u64, which causes
us to segfault sometimes because of some weird C voodoo that I had to have
explained to me.  Apparently because we're using a double the compiler will use
the floating point registers to hold our argument which ends up not being
aligned properly if you don't actually give it a double so it will cause
problems for other things, in our case it was screwing up str_bytes so it was
larger than the actual size of the str.  This patch fixes the segfault.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 utils.c | 2 +-
 utils.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/utils.c b/utils.c
index 69ae21f..f8bc94f 100644
--- a/utils.c
+++ b/utils.c
@@ -1190,7 +1190,7 @@ out:
 }
 
 static char *size_strs[] = { "", "KiB", "MiB", "GiB", "TiB", "PiB", "EiB"};
-int pretty_size_snprintf(double size, char *str, size_t str_bytes)
+int pretty_size_snprintf(u64 size, char *str, size_t str_bytes)
 {
 	int num_divs = 0;
 	float fraction;
diff --git a/utils.h b/utils.h
index 7a74826..32e0542 100644
--- a/utils.h
+++ b/utils.h
@@ -49,7 +49,7 @@ int check_mounted_where(int fd, const char *file, char *where, int size,
 int btrfs_device_already_in_root(struct btrfs_root *root, int fd,
 				 int super_offset);
 
-int pretty_size_snprintf(double size, char *str, size_t str_bytes);
+int pretty_size_snprintf(u64 size, char *str, size_t str_bytes);
 #define pretty_size(size) 						\
 	({								\
 		static __thread char _str[24];				\
-- 
1.8.3.1

