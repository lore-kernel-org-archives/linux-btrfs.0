Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:47085 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752158AbbB0Sh0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 27 Feb 2015 13:37:26 -0500
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>, Anand Jain <Anand.Jain@oracle.com>,
        Zach Brown <zab@zabbo.net>
Subject: [PATCH] btrfs-progs: use less memory for pretty_size_mode buffers
Date: Fri, 27 Feb 2015 19:37:24 +0100
Message-Id: <1425062244-14807-1-git-send-email-dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Anand reports that the static buffers used for pertty size strings cause
a stack overflow on SPARC. Zach proposed to change the printf format to
wrap the number and the suffix into a macro. This would require to
change all callsites of pretty_size* and is not very convienient to
write.

This patch replaces the per-call-site static buffers with a limited
number for slots that would be used on each invokation of pretty_size
and wrap around. The number of array slots shall be 10 for now, in
current codebase there are no more than 2 calls to pretty_size in a
single argument list.

Reported-by: Anand Jain <Anand.Jain@oracle.com>
CC: Zach Brown <zab@zabbo.net>
Signed-off-by: David Sterba <dsterba@suse.cz>
---

Anand, please test on a real SPARC machine.

 utils.c           | 18 ++++++++++++++++++
 utils.h           |  8 ++------
 3 files changed, 21 insertions(+), 6 deletions(-)

--- a/utils.c
+++ b/utils.c
@@ -1366,6 +1366,24 @@ out:
 	return ret;
 }
 
+/*
+ * Note: this function uses a static per-thread buffer. Do not call this
+ * function more than 10 times within one argument list!
+ */
+const char *pretty_size_mode(u64 size, unsigned mode)
+{
+	static __thread int ps_index = 0;
+	static __thread char ps_array[10][32];
+	char *ret;
+
+	ret = ps_array[ps_index];
+	ps_index++;
+	ps_index %= 10;
+	(void)pretty_size_snprintf(size, ret, 32, mode);
+
+	return ret;
+}
+
 static const char* unit_suffix_binary[] =
 	{ "B", "KiB", "MiB", "GiB", "TiB", "PiB", "EiB"};
 static const char* unit_suffix_decimal[] =
diff --git a/utils.h b/utils.h
index 82ab5e82a3ff..539797c705b4 100644
--- a/utils.h
+++ b/utils.h
@@ -103,12 +103,7 @@ int btrfs_device_already_in_root(struct btrfs_root *root, int fd,
 
 int pretty_size_snprintf(u64 size, char *str, size_t str_bytes, unsigned unit_mode);
 #define pretty_size(size) 	pretty_size_mode(size, UNITS_DEFAULT)
-#define pretty_size_mode(size, mode) 					      \
-	({								      \
-		static __thread char _str[32];				      \
-		(void)pretty_size_snprintf((size), _str, sizeof(_str), (mode)); \
-		_str;							      \
-	})
+const char *pretty_size_mode(u64 size, unsigned mode);
 
 int get_mountpt(char *dev, char *mntpt, size_t size);
 int btrfs_scan_block_devices(int run_ioctl);
