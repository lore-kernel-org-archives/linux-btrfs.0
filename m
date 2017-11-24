Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwkm04.jp.fujitsu.com ([202.219.69.171]:39325 "EHLO
        mgwkm04.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750715AbdKXFYe (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 24 Nov 2017 00:24:34 -0500
Received: from g01jpfmpwyt03.exch.g01.fujitsu.local (g01jpfmpwyt03.exch.g01.fujitsu.local [10.128.193.57])
        by kw-mxoi2.gw.nic.fujitsu.com (Postfix) with ESMTP id DE2A4AC0128
        for <linux-btrfs@vger.kernel.org>; Fri, 24 Nov 2017 14:24:29 +0900 (JST)
Received: from g01jpexchyt38.g01.fujitsu.local (unknown [10.128.193.4])
        by g01jpfmpwyt03.exch.g01.fujitsu.local (Postfix) with ESMTP id 294EE46E810
        for <linux-btrfs@vger.kernel.org>; Fri, 24 Nov 2017 14:24:29 +0900 (JST)
To: linux-btrfs <linux-btrfs@vger.kernel.org>
From: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>
Subject: [PATCH] btrfs-progs: mkfs: fix verbose value
Message-ID: <668fba55-de0e-33d4-647d-44d6bec27aed@jp.fujitsu.com>
Date: Fri, 24 Nov 2017 14:24:17 +0900
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The value of 'verbose' is either 1 (default) or 0 (-q)
and "verbose >= 2" will not be true.

After fix this, we get something like:
 adding device /dev/sde id 2
 adding device /dev/sdf id 3
during mkfs time when multiple devices are used.

Signed-off-by: Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>
---
 mkfs/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mkfs/main.c b/mkfs/main.c
index e405e5a2..c07cc1e1 100644
--- a/mkfs/main.c
+++ b/mkfs/main.c
@@ -1861,7 +1861,7 @@ int main(int argc, char **argv)
 			error("unable to add %s to filesystem: %d", file, ret);
 			goto out;
 		}
-		if (verbose >= 2) {
+		if (verbose) {
 			struct btrfs_device *device;
 
 			device = container_of(fs_info->fs_devices->devices.next,
-- 
2.13.6

