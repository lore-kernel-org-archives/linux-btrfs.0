Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym01.jp.fujitsu.com ([211.128.242.40]:27094 "EHLO
        mgwym01.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751567AbcKOIQ4 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 15 Nov 2016 03:16:56 -0500
Received: from m3051.s.css.fujitsu.com (m3051.s.css.fujitsu.com [10.134.21.209])
        by yt-mxq.gw.nic.fujitsu.com (Postfix) with ESMTP id E949BAC005E
        for <linux-btrfs@vger.kernel.org>; Tue, 15 Nov 2016 17:16:51 +0900 (JST)
Received: from WIN-5MHF4RKU941.jp.fujitsu.com (unknown [10.124.102.163])
        by m3051.s.css.fujitsu.com (Postfix) with SMTP id D581245E
        for <linux-btrfs@vger.kernel.org>; Tue, 15 Nov 2016 17:16:51 +0900 (JST)
Message-Id: <201611150816.AA00015@WIN-5MHF4RKU941.jp.fujitsu.com>
From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Date: Tue, 15 Nov 2016 17:16:27 +0900
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs-progs: send: fix failure of xfstests btrfs/038
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The following patch was imperfect, so xfstests btrfs/038 was failed.

  6d4fb3d  btrfs-progs: send: fix handling of multiple snapshots (-p option)

[before]
| # ./check btrfs/038
| FSTYP         -- btrfs
| PLATFORM      -- Linux/x86_64 luna 4.9.0-rc5
| MKFS_OPTIONS  -- /dev/sdb3
| MOUNT_OPTIONS -- /dev/sdb3 /test6
|
| btrfs/038 1s ... [failed, exit status 1] - output mismatch (see /For_RT/xfstests2/results//btrfs/038.out.bad)
|     --- tests/btrfs/038.out     2015-08-04 16:09:38.000000000 +0900
|     +++ /For_RT/xfstests2/results//btrfs/038.out.bad    2016-11-15 13:39:48.589435290 +0900
|     @@ -7,3 +7,5 @@
|      XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
|      wrote 10000/10000 bytes at offset 300000
|      XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
|     +failed: '/usr/local/bin/btrfs send -p /test6/mysnap1 -c /test6/clones_snap /test6/mysnap2 -f /tmp/tmp.aLpvAC7lsx/2.snap'
|     +(see /For_RT/xfstests2/results//btrfs/038.full for details)
|     ...
|     (Run 'diff -u tests/btrfs/038.out /For_RT/xfstests2/results//btrfs/038.out.bad'  to see the entire diff)
| Ran: btrfs/038
| Failures: btrfs/038

[after]
| # ./check btrfs/038
| FSTYP         -- btrfs
| PLATFORM      -- Linux/x86_64 luna 4.9.0-rc5
| MKFS_OPTIONS  -- /dev/sdb3
| MOUNT_OPTIONS -- /dev/sdb3 /test6
| 
| btrfs/038 1s ... 1s
| Ran: btrfs/038
| Passed all 1 tests

Signed-off-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
---
 cmds-send.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/cmds-send.c b/cmds-send.c
index 7aa4b36..1ca4b8e 100644
--- a/cmds-send.c
+++ b/cmds-send.c
@@ -686,7 +686,7 @@ int cmd_send(int argc, char **argv)
 			goto out;
 		}
 
-		if (!full_send && root_id) {
+		if (!full_send && !snapshot_parent) {
 			ret = set_root_info(&send, subvol, &root_id);
 			if (ret < 0)
 				goto out;
@@ -713,7 +713,7 @@ int cmd_send(int argc, char **argv)
 		if (ret < 0)
 			goto out;
 
-		if (!full_send && root_id) {
+		if (!full_send && !snapshot_parent) {
 			/* done with this subvol, so add it to the clone sources */
 			ret = add_clone_source(&send, root_id);
 			if (ret < 0) {
-- 
2.9.3
