Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:38274 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752348AbbJLNYy (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 12 Oct 2015 09:24:54 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t9CDOO3Z026220
	for <linux-btrfs@vger.kernel.org>; Mon, 12 Oct 2015 21:24:24 +0800
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH 11/11] btrfs-progs: fragments: use btrfs_open_dir for btrfs-fragments command
Date: Mon, 12 Oct 2015 21:23:04 +0800
Message-ID: <828b6c2088223c9ce42111c32977c85c774615bb.1444655800.git.zhaolei@cn.fujitsu.com>
In-Reply-To: <cover.1444655800.git.zhaolei@cn.fujitsu.com>
References: <cover.1444655800.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We can use btrfs_open_dir() to check whether target dir is
in btrfs's mount point before open, instead of checking it in
deeper code, and return fuzzy error message.

Before patch:
  ./btrfs-fragments -o 123 /mnt/tmp1
  ERROR: can't perform the search

After patch:
  # ./btrfs-fragments -o 123 /mnt/tmp1
  ERROR: not a btrfs filesystem: /mnt/tmp1

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 btrfs-fragments.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/btrfs-fragments.c b/btrfs-fragments.c
index d742f60..17768c3 100644
--- a/btrfs-fragments.c
+++ b/btrfs-fragments.c
@@ -436,11 +436,9 @@ int main(int argc, char **argv)
 
 	path = argv[optind++];
 
-	fd = open_file_or_dir(path, &dirstream);
-	if (fd < 0) {
-		fprintf(stderr, "ERROR: can't access '%s'\n", path);
+	fd = btrfs_open_dir(path, &dirstream, 1);
+	if (fd < 0)
 		exit(1);
-	}
 
 	if (flags == 0)
 		flags = BTRFS_BLOCK_GROUP_DATA | BTRFS_BLOCK_GROUP_METADATA;
-- 
1.8.5.1

