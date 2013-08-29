Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:52546 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755152Ab3H2SKA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 29 Aug 2013 14:10:00 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id E8CA37C0696
	for <linux-btrfs@vger.kernel.org>; Thu, 29 Aug 2013 12:09:59 -0600 (MDT)
Received: from CAS1.int.fusionio.com (cas1.int.fusionio.com [10.101.1.40]) by mx2.fusionio.com with ESMTP id WBXsxDPpZQL7zL0G (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Thu, 29 Aug 2013 12:09:59 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: add support for asserts V2
Date: Thu, 29 Aug 2013 14:09:57 -0400
Message-ID: <1377799797-9738-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

One of the complaints we get a lot is how many BUG_ON()'s we have.  So to help
with this I'm introducing a kconfig option to enable/disable a new ASSERT()
mechanism much like what XFS does.  This will allow us developers to still get
our nice panics but allow users/distros to compile them out.  With this we can
go through and convert any BUG_ON()'s that we have to catch actual programming
mistakes to the new ASSERT() and then fix everybody else to return errors.  This
will also allow developers to leave sanity checks in their new code to make sure
we don't trip over problems while testing stuff and vetting new features.
Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
V1->V2:
- changed unlikely() to likely()
- use CONFIG_BTRFS_ASSERT instead of BTRFS_ASSERT
- spell line properly
 fs/btrfs/Kconfig |    9 +++++++++
 fs/btrfs/ctree.h |   16 ++++++++++++++++
 2 files changed, 25 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/Kconfig b/fs/btrfs/Kconfig
index 2b3b832..398cbd5 100644
--- a/fs/btrfs/Kconfig
+++ b/fs/btrfs/Kconfig
@@ -72,3 +72,12 @@ config BTRFS_DEBUG
 	  performance, or export extra information via sysfs.
 
 	  If unsure, say N.
+
+config BTRFS_ASSERT
+	bool "Btrfs assert support"
+	depends on BTRFS_FS
+	help
+	  Enable run-time assertion checking.  This will result in panics if
+	  any of the assertions trip.  This is meant for btrfs developers only.
+
+	  If unsure, say N.
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index c90be01..1f3fd58 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3814,6 +3814,22 @@ void btrfs_printk(const struct btrfs_fs_info *fs_info, const char *fmt, ...)
 #define btrfs_debug(fs_info, fmt, args...) \
 	btrfs_printk(fs_info, KERN_DEBUG fmt, ##args)
 
+#ifdef CONFIG_BTRFS_ASSERT
+
+static inline void assfail(char *expr, char *file, int line)
+{
+	printk(KERN_ERR "BTRFS assertion failed: %s, file: %s, line: %d",
+	       expr, file, line);
+	BUG();
+}
+
+#define ASSERT(expr)	\
+	(likely(expr) ? (void)0 : assfail(#expr, __FILE__, __LINE__))
+#else
+#define ASSERT(expr)	((void)0)
+#endif
+
+#define btrfs_assert()
 __printf(5, 6)
 void __btrfs_std_error(struct btrfs_fs_info *fs_info, const char *function,
 		     unsigned int line, int errno, const char *fmt, ...);
-- 
1.7.7.6

