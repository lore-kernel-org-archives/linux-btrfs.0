Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym04.jp.fujitsu.com ([211.128.242.43]:60713 "EHLO
        mgwym04.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755218AbeCSHcY (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 19 Mar 2018 03:32:24 -0400
Received: from g01jpfmpwkw03.exch.g01.fujitsu.local (g01jpfmpwkw03.exch.g01.fujitsu.local [10.0.193.57])
        by yt-mxq.gw.nic.fujitsu.com (Postfix) with ESMTP id 13C70AC0082
        for <linux-btrfs@vger.kernel.org>; Mon, 19 Mar 2018 16:32:18 +0900 (JST)
Received: from g01jpexchkw37.g01.fujitsu.local (unknown [10.0.193.4])
        by g01jpfmpwkw03.exch.g01.fujitsu.local (Postfix) with ESMTP id 35BE6BD64E9
        for <linux-btrfs@vger.kernel.org>; Mon, 19 Mar 2018 16:32:17 +0900 (JST)
Subject: [RFC PATCH v3 4/7] btrfs-progs: fallback to open without O_NOATIME
 flag in find_mount_root()
From: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
References: <a1089ceb-6642-0b20-9690-6cf961efe42e@jp.fujitsu.com>
Message-ID: <a996fe03-5a3b-5b78-2841-32f0cf7520b4@jp.fujitsu.com>
Date: Mon, 19 Mar 2018 16:32:14 +0900
MIME-Version: 1.0
In-Reply-To: <a1089ceb-6642-0b20-9690-6cf961efe42e@jp.fujitsu.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

O_NOATIME flag requires effective UID of process matches file's owner
or has CAP_FOWNER capabilities. Fallback to open without O_NOATIME flag
so that normal user can also call find_mount_root().

This is a preparation work to allow normal user to call "subvolume show".

Signed-off-by: Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>
---
 utils.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/utils.c b/utils.c
index 81c54faa..acea70a5 100644
--- a/utils.c
+++ b/utils.c
@@ -2045,6 +2045,9 @@ int find_mount_root(const char *path, char **mount_root)
 	char *longest_match = NULL;
 
 	fd = open(path, O_RDONLY | O_NOATIME);
+	if (fd < 0 && errno == EPERM)
+		fd = open(path, O_RDONLY);
+
 	if (fd < 0)
 		return -errno;
 	close(fd);
-- 
2.14.3


