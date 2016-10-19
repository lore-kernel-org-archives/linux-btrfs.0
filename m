Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym01.jp.fujitsu.com ([211.128.242.40]:36640 "EHLO
        mgwym01.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756109AbcJSCgB (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 18 Oct 2016 22:36:01 -0400
Received: from m3051.s.css.fujitsu.com (m3051.s.css.fujitsu.com [10.134.21.209])
        by yt-mxoi2.gw.nic.fujitsu.com (Postfix) with ESMTP id BB476AC009C
        for <linux-btrfs@vger.kernel.org>; Wed, 19 Oct 2016 11:35:53 +0900 (JST)
Received: from WIN-5MHF4RKU941.jp.fujitsu.com (unknown [10.124.102.163])
        by m3051.s.css.fujitsu.com (Postfix) with SMTP id AB90D417
        for <linux-btrfs@vger.kernel.org>; Wed, 19 Oct 2016 11:35:53 +0900 (JST)
Message-Id: <201610190235.AA00003@WIN-5MHF4RKU941.jp.fujitsu.com>
From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Date: Wed, 19 Oct 2016 11:35:40 +0900
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 3/3] btrfs-progs: send: fix handling of -c option
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When two or more -c options are specified, cannot find a suitable
parent. So, output stream is bigger than correct one.

[before]
# btrfs send -f /tmp/data1 -c Snap0 -c ../SnapX Snap[12] ../SnapY
At subvol Snap1
At subvol Snap2
At subvol ../SnapY
# ls -l /tmp/data1
-rw------- 1 root root 3153 Oct 19 10:37 /tmp/data1
#

[after]
# btrfs send -f /tmp/data1 -c Snap0 -c ../SnapX Snap[12] ../SnapY
At subvol Snap1
At subvol Snap2
At subvol ../SnapY
# ls -l /tmp/data1
-rw------- 1 root root 1492 Oct 19 10:39 /tmp/data1
#

Signed-off-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
---
 cmds-send.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/cmds-send.c b/cmds-send.c
index 2a8a697..b93a667 100644
--- a/cmds-send.c
+++ b/cmds-send.c
@@ -651,6 +651,18 @@ int cmd_send(int argc, char **argv)
 		}
 
 		if (!full_send && root_id) {
+			ret = init_root_path(&send, subvol);
+			if (ret < 0)
+				goto out;
+
+			ret = get_root_id(&send,
+				subvol_strip_mountpoint(send.root_path, subvol),
+				&root_id);
+			if (ret < 0) {
+				error("cannot resolve rootid for %s", subvol);
+				goto out;
+			}
+
 			ret = find_good_parent(&send, root_id, &parent_root_id);
 			if (ret < 0) {
 				error("parent determination failed for %lld",
-- 
2.9.3
