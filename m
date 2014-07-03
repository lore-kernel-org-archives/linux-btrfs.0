Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:53247 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754578AbaGCCMI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 2 Jul 2014 22:12:08 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s632C5e6013412
	for <linux-btrfs@vger.kernel.org>; Thu, 3 Jul 2014 10:12:05 +0800
From: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Subject: [PATCH] btrfs-progs: prevent select invalid dev super after dev replace
Date: Thu, 3 Jul 2014 10:06:35 +0800
Message-ID: <1404353196-10914-3-git-send-email-guihc.fnst@cn.fujitsu.com>
In-Reply-To: <1404353196-10914-1-git-send-email-guihc.fnst@cn.fujitsu.com>
References: <1404353196-10914-1-git-send-email-guihc.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

After dev replace, we should not select the superblock of the
replaced dev. Otherwise, all the superblokcs will be overwritten
by this invalid superblock.

To prevent this case, let btrfs-select-super check the first
superblock on the selected dev. If the magic doesn't match,
then the dev is a replaced dev and error message will show up.

Signed-off-by: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
---
 btrfs-select-super.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/btrfs-select-super.c b/btrfs-select-super.c
index d7cd187..cba3414 100644
--- a/btrfs-select-super.c
+++ b/btrfs-select-super.c
@@ -45,6 +45,9 @@ int main(int ac, char **av)
 	int ret;
 	u64 num = 0;
 	u64 bytenr = 0;
+	int fd;
+	u8 buf[BTRFS_SUPER_INFO_SIZE];
+	struct btrfs_super_block *sb = (struct btrfs_super_block *)buf;
 
 	while(1) {
 		int c;
@@ -86,6 +89,26 @@ int main(int ac, char **av)
 		return -EBUSY;
 	}
 
+	/*
+	 * After dev replace, the first super block of replaced dev will be cleared,
+	 * don't select that dev.
+	 */
+	fd = open(av[optind], O_RDONLY, 0666);
+	if (fd < 0)
+		return -errno;
+
+	ret = pread64(fd, buf, sizeof(buf), BTRFS_SUPER_INFO_OFFSET);
+	if (ret < sizeof(buf)) {
+		close(fd);
+		return -errno;
+	}
+
+	if (sb->magic != cpu_to_le64(BTRFS_MAGIC)) {
+		fprintf(stderr, "Cannot select an invalid super block.\n");
+		close(fd);
+		return 1;
+	}
+
 	root = open_ctree(av[optind], bytenr, 1);
 
 	if (!root) {
-- 
1.8.1.4

