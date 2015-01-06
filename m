Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:63690 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752933AbbAFEnr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 5 Jan 2015 23:43:47 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t064h9Zg028732
	for <linux-btrfs@vger.kernel.org>; Tue, 6 Jan 2015 12:43:09 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] btrfs-progs: Fix a buffer overflow causing segfault in fstests/btrfs/069
Date: Tue, 6 Jan 2015 12:41:40 +0800
Message-ID: <1420519300-30402-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Since BTRFS_IOC_FS_INFO will return num of devices without counting
devid 0 and di_arg is allocated according to it, so when replacing is
running, there is num_devices + 1(0~num_devices) items to be written
into di_args arrary, which causes buffer overflow with the following
segfault.

*** Error in `/usr/local/bin/btrfs': free(): invalid next size (normal):
0x0000000001a95090 ***
======= Backtrace: =========
/lib64/libc.so.6[0x36c9475d9f]
/lib64/libc.so.6[0x36c947d098]
/usr/local/bin/btrfs[0x41342e]
/usr/local/bin/btrfs[0x4135bd]
/usr/local/bin/btrfs(handle_command_group+0x5d)[0x40990f]
/usr/local/bin/btrfs(cmd_scrub+0x15)[0x4135d7]
/usr/local/bin/btrfs(main+0x15d)[0x409a71]
/lib64/libc.so.6(__libc_start_main+0xf5)[0x36c9421d65]
/usr/local/bin/btrfs[0x409629]
======= Memory map: ========
00400000-0047a000 r-xp 00000000 08:08 4866225
/share/local/bin/btrfs
00679000-0067c000 r--p 00079000 08:08 4866225
/share/local/bin/btrfs
0067c000-0067e000 rw-p 0007c000 08:08 4866225
/share/local/bin/btrfs
0067e000-00682000 rw-p 00000000 00:00 0
01a85000-01aa6000 rw-p 00000000 00:00 0
[heap]
3337a00000-3337a04000 r-xp 00000000 08:02 538227
/usr/lib64/libuuid.so.1.3.0
3337a04000-3337c03000 ---p 00004000 08:02 538227
/usr/lib64/libuuid.so.1.3.0
...

Reported-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
Signed-off-by: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
---
 utils.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/utils.c b/utils.c
index af0a8fe..56cadd1 100644
--- a/utils.c
+++ b/utils.c
@@ -2008,7 +2008,12 @@ int get_fs_info(char *path, struct btrfs_ioctl_fs_info_args *fi_args,
 	if (!fi_args->num_devices)
 		goto out;
 
-	di_args = *di_ret = malloc((fi_args->num_devices) * sizeof(*di_args));
+	/*
+	 * Since fi_args doesn't include the dev being replaced,
+	 * we need to plus 1 for devid 0 in case.
+	 */
+	di_args = *di_ret = malloc((fi_args->num_devices + 1) *
+				   sizeof(*di_args));
 	if (!di_args) {
 		ret = -errno;
 		goto out;
-- 
2.2.1

