Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwkm02.jp.fujitsu.com ([202.219.69.169]:17680 "EHLO
        mgwkm02.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751413AbeCOIOu (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 15 Mar 2018 04:14:50 -0400
Received: from g01jpfmpwyt03.exch.g01.fujitsu.local (g01jpfmpwyt03.exch.g01.fujitsu.local [10.128.193.57])
        by kw-mxoi1.gw.nic.fujitsu.com (Postfix) with ESMTP id 5462BAC00CE
        for <linux-btrfs@vger.kernel.org>; Thu, 15 Mar 2018 17:14:46 +0900 (JST)
Received: from G01JPEXCHYT15.g01.fujitsu.local (G01JPEXCHYT15.g01.fujitsu.local [10.128.194.54])
        by g01jpfmpwyt03.exch.g01.fujitsu.local (Postfix) with ESMTP id 717AF46E636
        for <linux-btrfs@vger.kernel.org>; Thu, 15 Mar 2018 17:14:45 +0900 (JST)
Subject: [RFC PATCH v2 5/8] btrfs-progs: fallback to open without O_NOATIME
 flag in find_mount_root()
From: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
References: <226b6805-c5aa-c40d-4ea6-f81dc1b7de20@jp.fujitsu.com>
Message-ID: <82afdd65-2918-0dae-fd2e-7e540f22b754@jp.fujitsu.com>
Date: Thu, 15 Mar 2018 17:14:42 +0900
MIME-Version: 1.0
In-Reply-To: <226b6805-c5aa-c40d-4ea6-f81dc1b7de20@jp.fujitsu.com>
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


