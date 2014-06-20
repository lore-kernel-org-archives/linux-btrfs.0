Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:16560 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S965558AbaFTLNT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 20 Jun 2014 07:13:19 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s5KBDEej017032
	for <linux-btrfs@vger.kernel.org>; Fri, 20 Jun 2014 19:13:14 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs-progs: fsck: reduce memory usage for extents check
Date: Fri, 20 Jun 2014 19:09:07 +0800
Message-ID: <1403262547-11963-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Steps to reproduce:

 # mkfs.btrfs -f /dev/sda9 -b 2g
 # mount /dev/sda9 /mnt
 # dd if=/dev/zero of=/mnt/data bs=4k oflag=direct
 # btrfs file df /mnt

    Data, single: total=1.66GiB, used=1.66GiB
    System, single: total=4.00MiB, used=16.00KiB
    Metadata, single: total=200.00MiB, used=67.88MiB

For a filesystem without snapshots, 70M metadata, extent
checking eats max memory about 110M, this is a nightmare
for some system with low memory.

It is very likely that extent record can be freed quickly
for a filesystem without snapshots, improve this by trying
if it can free memory after adding data/tree backrefs.

This patch reduces max memory cost from 110M to 40M for
extents checking for the above case.

Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
---
 cmds-check.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/cmds-check.c b/cmds-check.c
index 26baab0..ac97e48 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -2980,6 +2980,7 @@ static int add_tree_backref(struct cache_tree *extent_cache, u64 bytenr,
 		}
 		back->node.found_extent_tree = 1;
 	}
+	maybe_free_extent_rec(extent_cache, rec);
 	return 0;
 }
 
@@ -3046,6 +3047,7 @@ static int add_data_backref(struct cache_tree *extent_cache, u64 bytenr,
 		back->num_refs = num_refs;
 		back->node.found_extent_tree = 1;
 	}
+	maybe_free_extent_rec(extent_cache, rec);
 	return 0;
 }
 
-- 
1.9.0

