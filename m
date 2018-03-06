Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym01.jp.fujitsu.com ([211.128.242.40]:43432 "EHLO
        mgwym01.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752861AbeCFIfi (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 6 Mar 2018 03:35:38 -0500
Received: from g01jpfmpwkw02.exch.g01.fujitsu.local (g01jpfmpwkw02.exch.g01.fujitsu.local [10.0.193.56])
        by yt-mxauth.gw.nic.fujitsu.com (Postfix) with ESMTP id D0A7AAC00CB
        for <linux-btrfs@vger.kernel.org>; Tue,  6 Mar 2018 17:35:34 +0900 (JST)
Received: from g01jpexchkw38.g01.fujitsu.local (unknown [10.0.193.4])
        by g01jpfmpwkw02.exch.g01.fujitsu.local (Postfix) with ESMTP id 090FB3286F9
        for <linux-btrfs@vger.kernel.org>; Tue,  6 Mar 2018 17:35:34 +0900 (JST)
Subject: [RFC PATCH 4/7] btrfs-progs: fallback to open without O_NOATIME flag
 in, find_mount_root()
From: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
References: <94a0bad6-d696-a72e-ba7b-287d1d442997@jp.fujitsu.com>
Message-ID: <18bb819b-ada1-d0cc-c32d-4a7be63fd306@jp.fujitsu.com>
Date: Tue, 6 Mar 2018 17:35:30 +0900
MIME-Version: 1.0
In-Reply-To: <94a0bad6-d696-a72e-ba7b-287d1d442997@jp.fujitsu.com>
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

