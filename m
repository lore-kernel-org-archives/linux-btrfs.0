Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym03.jp.fujitsu.com ([211.128.242.42]:18247 "EHLO
        mgwym03.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S968210AbeFRIiS (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 18 Jun 2018 04:38:18 -0400
Received: from g01jpfmpwkw02.exch.g01.fujitsu.local (g01jpfmpwkw02.exch.g01.fujitsu.local [10.0.193.56])
        by yt-mxauth.gw.nic.fujitsu.com (Postfix) with ESMTP id 7B2BCAC0272
        for <linux-btrfs@vger.kernel.org>; Mon, 18 Jun 2018 17:38:11 +0900 (JST)
Received: from g01jpexchkw33.g01.fujitsu.local (unknown [10.0.193.4])
        by g01jpfmpwkw02.exch.g01.fujitsu.local (Postfix) with ESMTP id AEA803286F5
        for <linux-btrfs@vger.kernel.org>; Mon, 18 Jun 2018 17:38:10 +0900 (JST)
From: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v2 16/20] btrfs-progs: utils: Fallback to open without O_NOATIME flag in find_mount_root():
Date: Mon, 18 Jun 2018 17:41:04 +0900
Message-ID: <fa24e52e0177fff34f82f6eecd328229448eba43.1529310485.git.misono.tomohiro@jp.fujitsu.com>
In-Reply-To: <cover.1529310485.git.misono.tomohiro@jp.fujitsu.com>
References: <cover.1529310485.git.misono.tomohiro@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

O_NOATIME flag requires effective UID of process matches file's owner
or has CAP_FOWNER capabilities. Fallback to open without O_NOATIME flag
so that non-privileged user can also call find_mount_root().

This is a preparation work to allow non-privileged user to call
"subvolume show".

Signed-off-by: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
---
 utils.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/utils.c b/utils.c
index 21de09d3..1a4366e8 100644
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
2.14.4


