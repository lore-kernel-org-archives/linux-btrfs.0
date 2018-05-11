Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwkm03.jp.fujitsu.com ([202.219.69.170]:62728 "EHLO
        mgwkm03.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752612AbeEKH1m (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 11 May 2018 03:27:42 -0400
Received: from g01jpfmpwkw02.exch.g01.fujitsu.local (g01jpfmpwkw02.exch.g01.fujitsu.local [10.0.193.56])
        by kw-mxauth.gw.nic.fujitsu.com (Postfix) with ESMTP id 5CE0EAC0133
        for <linux-btrfs@vger.kernel.org>; Fri, 11 May 2018 16:27:37 +0900 (JST)
Received: from g01jpexchkw35.g01.fujitsu.local (unknown [10.0.193.4])
        by g01jpfmpwkw02.exch.g01.fujitsu.local (Postfix) with ESMTP id 5C06A32881C
        for <linux-btrfs@vger.kernel.org>; Fri, 11 May 2018 16:27:36 +0900 (JST)
From: Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 08/11] btrfs-progs: utils: Fallback to open without O_NOATIME flag in find_mount_root():
Date: Fri, 11 May 2018 16:29:46 +0900
Message-ID: <20180511072949.15269-9-misono.tomohiro@jp.fujitsu.com>
In-Reply-To: <20180511072949.15269-1-misono.tomohiro@jp.fujitsu.com>
References: <20180511072949.15269-1-misono.tomohiro@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

O_NOATIME flag requires effective UID of process matches file's owner
or has CAP_FOWNER capabilities. Fallback to open without O_NOATIME flag
so that non-privileged user can also call find_mount_root().

This is a preparation work to allow non-privileged user to call
"subvolume show".

Signed-off-by: Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>
---
 utils.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/utils.c b/utils.c
index d81d4980..84b81311 100644
--- a/utils.c
+++ b/utils.c
@@ -2048,6 +2048,9 @@ int find_mount_root(const char *path, char **mount_root)
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


