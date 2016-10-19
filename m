Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym01.jp.fujitsu.com ([211.128.242.40]:36478 "EHLO
        mgwym01.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933120AbcJSCfb (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 18 Oct 2016 22:35:31 -0400
Received: from m3051.s.css.fujitsu.com (m3051.s.css.fujitsu.com [10.134.21.209])
        by yt-mxoi2.gw.nic.fujitsu.com (Postfix) with ESMTP id 3637BAC00AA
        for <linux-btrfs@vger.kernel.org>; Wed, 19 Oct 2016 11:35:19 +0900 (JST)
Received: from WIN-5MHF4RKU941.jp.fujitsu.com (unknown [10.124.102.163])
        by m3051.s.css.fujitsu.com (Postfix) with SMTP id 25DFC43E
        for <linux-btrfs@vger.kernel.org>; Wed, 19 Oct 2016 11:35:19 +0900 (JST)
Message-Id: <201610190235.AA00002@WIN-5MHF4RKU941.jp.fujitsu.com>
From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Date: Wed, 19 Oct 2016 11:35:03 +0900
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/3] btrfs-progs: send: fix handling of multiple snapshots (-p option)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We cannot send multiple snapshots at once by -p option.

[before]
# btrfs send -f /tmp/data0 -p Snap0 Snap[12]
At subvol Snap1
At subvol Snap2
ERROR: parent determination failed for 0
# 

[after]
# btrfs send -f /tmp/data0 -p Snap0 Snap[12]
At subvol Snap1
At subvol Snap2
# 

Signed-off-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
---
 cmds-send.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/cmds-send.c b/cmds-send.c
index dfdfe01..2a8a697 100644
--- a/cmds-send.c
+++ b/cmds-send.c
@@ -650,7 +650,7 @@ int cmd_send(int argc, char **argv)
 			goto out;
 		}
 
-		if (!full_send && !parent_root_id) {
+		if (!full_send && root_id) {
 			ret = find_good_parent(&send, root_id, &parent_root_id);
 			if (ret < 0) {
 				error("parent determination failed for %lld",
@@ -673,7 +673,7 @@ int cmd_send(int argc, char **argv)
 		if (ret < 0)
 			goto out;
 
-		if (!full_send) {
+		if (!full_send && root_id) {
 			/* done with this subvol, so add it to the clone sources */
 			ret = add_clone_source(&send, root_id);
 			if (ret < 0) {
@@ -681,8 +681,6 @@ int cmd_send(int argc, char **argv)
 				goto out;
 			}
 		}
-
-		parent_root_id = 0;
 	}
 
 	ret = 0;
-- 
2.9.3
