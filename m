Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from nbl-ex10-fe01.nebula.fi ([188.117.32.121]:27642 "EHLO
	ex10.nebula.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753626AbaCLNn2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 12 Mar 2014 09:43:28 -0400
Date: Wed, 12 Mar 2014 15:43:24 +0200
From: Rakesh Pandit <rakesh@tuxera.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs-progs: mkfs: let user known when forcing mixed
 metadata/data groups
Message-ID: <20140312134322.GA28005@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

While formatting multiple devics (and user doesn't specify -M) if one
of them has block count or size less then 1 GiB, mkfs doesn't tell
user, on which one mixed metadata/data was forced. This patch updates
message to print device name.

Signed-off-by: Rakesh Pandit <rakesh@tuxera.com>
---
 mkfs.c  | 3 ++-
 utils.c | 2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/mkfs.c b/mkfs.c
index 2dc90c2..621c869 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -1372,7 +1372,8 @@ int main(int ac, char **av)
 	ssd = is_ssd(file);
 
 	if (is_vol_small(file)) {
-		printf("SMALL VOLUME: forcing mixed metadata/data groups\n");
+		printf("SMALL VOLUME %s: forcing mixed metadata/data groups\n",
+			file);
 		mixed = 1;
 	}
 
diff --git a/utils.c b/utils.c
index 37ec6e5..00dde0f 100644
--- a/utils.c
+++ b/utils.c
@@ -597,7 +597,7 @@ int btrfs_prepare_device(int fd, char *file, int zero_end, u64 *block_count_ret,
 	zero_end = 1;
 
 	if (block_count < 1024 * 1024 * 1024 && !(*mixed)) {
-		printf("SMALL VOLUME: forcing mixed metadata/data groups\n");
+		printf("SMALL VOLUME %s: forcing mixed metadata/data groups\n", file);
 		*mixed = 1;
 	}
 
-- 
1.8.5.3

