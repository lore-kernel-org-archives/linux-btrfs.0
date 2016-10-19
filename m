Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym03.jp.fujitsu.com ([211.128.242.42]:26413 "EHLO
        mgwym03.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754588AbcJSCfD (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 18 Oct 2016 22:35:03 -0400
Received: from m3050.s.css.fujitsu.com (msm.b.css.fujitsu.com [10.134.21.208])
        by yt-mxq.gw.nic.fujitsu.com (Postfix) with ESMTP id 96AE2AC00C0
        for <linux-btrfs@vger.kernel.org>; Wed, 19 Oct 2016 11:34:47 +0900 (JST)
Received: from WIN-5MHF4RKU941.jp.fujitsu.com (unknown [10.124.102.163])
        by m3050.s.css.fujitsu.com (Postfix) with SMTP id 7794F450
        for <linux-btrfs@vger.kernel.org>; Wed, 19 Oct 2016 11:34:47 +0900 (JST)
Message-Id: <201610190234.AA00001@WIN-5MHF4RKU941.jp.fujitsu.com>
From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Date: Wed, 19 Oct 2016 11:34:25 +0900
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/3] btrfs-progs: send: remove unnecessary code
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Some unnecessary codes is deleted.

Signed-off-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
---
 cmds-send.c | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/cmds-send.c b/cmds-send.c
index 74d0128..dfdfe01 100644
--- a/cmds-send.c
+++ b/cmds-send.c
@@ -564,8 +564,6 @@ int cmd_send(int argc, char **argv)
 	}
 
 	/* use first send subvol to determine mount_root */
-	subvol = argv[optind];
-
 	subvol = realpath(argv[optind], NULL);
 	if (!subvol) {
 		ret = -errno;
@@ -661,15 +659,6 @@ int cmd_send(int argc, char **argv)
 			}
 		}
 
-		ret = is_subvol_ro(&send, subvol);
-		if (ret < 0)
-			goto out;
-		if (!ret) {
-			ret = -EINVAL;
-			error("subvolume %s is not read-only", subvol);
-			goto out;
-		}
-
 		if (new_end_cmd_semantic) {
 			/* require new kernel */
 			is_first_subvol = (i == optind);
-- 
2.9.3
