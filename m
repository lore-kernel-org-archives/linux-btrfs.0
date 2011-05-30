From: Sergei Trofimovich <slyfox@gentoo.org>
Subject: [PATCH 4/9] mkfs.btrfs: return some defined value instead of garbage when lookup checksum
Date: Tue, 31 May 2011 00:19:03 +0300
Message-ID: <1306790348-9553-5-git-send-email-slyfox@gentoo.org>
References: <1306790348-9553-1-git-send-email-slyfox@gentoo.org>
Cc: linux-btrfs@vger.kernel.org, Sergei Trofimovich <slyfox@gentoo.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1306790348-9553-1-git-send-email-slyfox@gentoo.org>
List-ID: <linux-btrfs.vger.kernel.org>

==31873== Command: ./mkfs.btrfs -r /some/root/
==31873== Parent PID: 31872
==31873==
==31873== Conditional jump or move depends on uninitialised value(s)
==31873==    at 0x42C3D0: add_file_items (mkfs.c:792)
==31873==    by 0x42CAB3: traverse_directory (mkfs.c:948)
==31873==    by 0x42CF11: make_image (mkfs.c:1047)
==31873==    by 0x42DE53: main (mkfs.c:1401)
==31873==  Uninitialised value was created by a stack allocation
==31873==    at 0x41B1B1: btrfs_csum_file_block (file-item.c:195)

'ret' value was not initialized for 'found' branch.

The same fix sits in kernel:
> commit 639cb58675ce9b507eed9c3d6b3335488079b21a
> Author: Chris Mason <chris.mason@oracle.com>
> Date:   Thu Aug 28 06:15:25 2008 -0400
>
>     Btrfs: Fix variable init during csum creation
>
>     Signed-off-by: Chris Mason <chris.mason@oracle.com>

Signed-off-by: Sergei Trofimovich <slyfox@gentoo.org>
---
 file-item.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/file-item.c b/file-item.c
index 9732282..47f6ad2 100644
--- a/file-item.c
+++ b/file-item.c
@@ -218,6 +218,7 @@ int btrfs_csum_file_block(struct btrfs_trans_handle *trans,
 	item = btrfs_lookup_csum(trans, root, path, bytenr, 1);
 	if (!IS_ERR(item)) {
 		leaf = path->nodes[0];
+		ret = 0;
 		goto found;
 	}
 	ret = PTR_ERR(item);
-- 
1.7.3.4

