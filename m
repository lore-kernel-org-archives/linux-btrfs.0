Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f41.google.com ([209.85.160.41]:64411 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751269AbaESFkp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 19 May 2014 01:40:45 -0400
Received: by mail-pb0-f41.google.com with SMTP id uo5so5340509pbc.14
        for <linux-btrfs@vger.kernel.org>; Sun, 18 May 2014 22:40:45 -0700 (PDT)
From: Adam Buchbinder <abuchbinder@google.com>
To: linux-btrfs@vger.kernel.org
Cc: dave@jikos.cz, Adam Buchbinder <abuchbinder@google.com>
Subject: [PATCH] btrfs-image: Fix a data race in build_chunk_tree.
Date: Sun, 18 May 2014 22:40:42 -0700
Message-Id: <1400478042-19837-1-git-send-email-abuchbinder@google.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

A mdrestore_struct was being written to without its mutex being held.
This race was found with ThreadSanitizer; the relevant part of the report
looks like this:

WARNING: ThreadSanitizer: data race (pid=18828)
  Write of size 8 at 0x7fffffc3d088 by main thread:
    #0 build_chunk_tree .../btrfs-progs/btrfs-image.c:2233
    #1 __restore_metadump .../btrfs-progs/btrfs-image.c:2294
    #2 restore_metadump .../btrfs-progs/btrfs-image.c:2345
    #3 main .../btrfs-progs/btrfs-image.c:2545

  Previous read of size 8 at 0x7fffffc3d088 by thread T1 (mutexes: write M0):
    #0 restore_worker .../btrfs-progs/btrfs-image.c:1636

  Location is stack of main thread.

  Mutex M0 created at:
    #0 pthread_mutex_init ??:0
    #1 mdrestore_init .../btrfs-progs/btrfs-image.c:1766
    #2 __restore_metadump .../btrfs-progs/btrfs-image.c:2286
    #3 restore_metadump .../btrfs-progs/btrfs-image.c:2345
    #4 main .../btrfs-progs/btrfs-image.c:2545

  Thread T1 (tid=18830, running) created by main thread at:
    #0 pthread_create ??:0
    #1 mdrestore_init .../btrfs-progs/btrfs-image.c:1784
    #2 __restore_metadump .../btrfs-progs/btrfs-image.c:2286
    #3 restore_metadump .../btrfs-progs/btrfs-image.c:2345
    #4 main .../btrfs-progs/btrfs-image.c:2545
---
 btrfs-image.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/btrfs-image.c b/btrfs-image.c
index cc8627c..017ab1d 100644
--- a/btrfs-image.c
+++ b/btrfs-image.c
@@ -2228,6 +2228,7 @@ static int build_chunk_tree(struct mdrestore_struct *mdres,
 		buffer = tmp;
 	}
 
+	pthread_mutex_lock(&mdres->mutex);
 	super = (struct btrfs_super_block *)buffer;
 	chunk_root_bytenr = btrfs_super_chunk_root(super);
 	mdres->leafsize = btrfs_super_leafsize(super);
@@ -2236,6 +2237,7 @@ static int build_chunk_tree(struct mdrestore_struct *mdres,
 		       BTRFS_UUID_SIZE);
 	mdres->devid = le64_to_cpu(super->dev_item.devid);
 	free(buffer);
+	pthread_mutex_unlock(&mdres->mutex);
 
 	return search_for_chunk_blocks(mdres, chunk_root_bytenr, 0);
 }
-- 
1.9.1.423.g4596e3a

