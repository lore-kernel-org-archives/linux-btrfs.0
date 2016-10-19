Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwkm04.jp.fujitsu.com ([202.219.69.171]:40748 "EHLO
        mgwkm04.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752481AbcJSDqT (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 18 Oct 2016 23:46:19 -0400
Received: from m3050.s.css.fujitsu.com (msm.b.css.fujitsu.com [10.134.21.208])
        by kw-mxauth.gw.nic.fujitsu.com (Postfix) with ESMTP id CBFC5AC0185
        for <linux-btrfs@vger.kernel.org>; Wed, 19 Oct 2016 12:46:12 +0900 (JST)
Received: from WIN-5MHF4RKU941.jp.fujitsu.com (unknown [10.124.102.163])
        by m3050.s.css.fujitsu.com (Postfix) with SMTP id AFF35446
        for <linux-btrfs@vger.kernel.org>; Wed, 19 Oct 2016 12:46:12 +0900 (JST)
Message-Id: <201610190345.AA00004@WIN-5MHF4RKU941.jp.fujitsu.com>
From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Date: Wed, 19 Oct 2016 12:45:57 +0900
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 1/3] btrfs-progs: send: remove unnecessary code
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Some unnecessary codes are deleted.

 - the setting of subvol is double.
 - read only check was already done by previous loop.

Signed-off-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
---
v2: description was changed
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
