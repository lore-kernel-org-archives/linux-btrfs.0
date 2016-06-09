Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwkm02.jp.fujitsu.com ([202.219.69.169]:47224 "EHLO
	mgwkm02.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161745AbcFIBYh (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 8 Jun 2016 21:24:37 -0400
Received: from m3050.s.css.fujitsu.com (msm.b.css.fujitsu.com [10.134.21.208])
	by kw-mxq.gw.nic.fujitsu.com (Postfix) with ESMTP id B5113AC029E
	for <linux-btrfs@vger.kernel.org>; Thu,  9 Jun 2016 10:24:32 +0900 (JST)
Received: from WIN-5MHF4RKU941.jp.fujitsu.com (unknown [10.124.102.163])
	by m3050.s.css.fujitsu.com (Postfix) with SMTP id 7F2C5112
	for <linux-btrfs@vger.kernel.org>; Thu,  9 Jun 2016 10:24:32 +0900 (JST)
Message-Id: <201606090123.AA00000@WIN-5MHF4RKU941.jp.fujitsu.com>
From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Date: Thu, 09 Jun 2016 10:23:15 +0900
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs-progs: add the error message when open fails
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When open in btrfs_open_devices failed, only the following message is
displayed. Therefore the user doesn't understand the reason why open
failed.

  # btrfs check /dev/sdb8
  Couldn't open file system

This patch adds the error message when open fails.

Signed-off-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
---
 volumes.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/volumes.c b/volumes.c
index ccfa732..80d61cf 100644
--- a/volumes.c
+++ b/volumes.c
@@ -227,6 +227,8 @@ int btrfs_open_devices(struct btrfs_fs_devices *fs_devices, int flags)
 		fd = open(device->name, flags);
 		if (fd < 0) {
 			ret = -errno;
+			error("cannot open '%s': %s", device->name,
+			      strerror(errno));
 			goto fail;
 		}
 
-- 
2.8.1
