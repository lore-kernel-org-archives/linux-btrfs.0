Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from lsd-gw.ic.unicamp.br ([143.106.7.165]:45767 "EHLO
	boneca.lsd.ic.unicamp.br" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755184Ab1K1Tdt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 28 Nov 2011 14:33:49 -0500
Received: from freie.oliva.athome.lsd.ic.unicamp.br (gw-to-emilia.oliva.athome.lsd.ic.unicamp.br [172.31.160.17] (may be forged))
	by boneca.lsd.ic.unicamp.br (8.14.5/8.14.5) with ESMTP id pASJWUJh020783
	for <linux-btrfs@vger.kernel.org>; Mon, 28 Nov 2011 17:32:31 -0200
Received: from livre.localdomain (livre-to-gw.oliva.athome.lsd.ic.unicamp.br [172.31.160.19])
	by freie.oliva.athome.lsd.ic.unicamp.br (8.14.4/8.14.4) with ESMTP id pASJWRO1012380
	for <linux-btrfs@vger.kernel.org>; Mon, 28 Nov 2011 17:32:27 -0200
Received: from livre.localdomain (aoliva@localhost.localdomain [127.0.0.1])
	by livre.localdomain (8.14.3/8.14.3/Debian-5+lenny1) with ESMTP id pASJWRoM020324
	for <linux-btrfs@vger.kernel.org>; Mon, 28 Nov 2011 17:32:27 -0200
Received: (from aoliva@localhost)
	by livre.localdomain (8.14.3/8.14.3/Submit) id pASJWQMl020323
	for linux-btrfs@vger.kernel.org; Mon, 28 Nov 2011 17:32:26 -0200
Message-Id: <f4751f56cf4767cb60306605fd13ee2573f3cf67.1322507825.git.oliva@lsd.ic.unicamp.br>
In-Reply-To: <cover.1322507825.git.oliva@lsd.ic.unicamp.br>
References: <cover.1322507825.git.oliva@lsd.ic.unicamp.br>
From: Alexandre Oliva <oliva@lsd.ic.unicamp.br>
Date: Mon, 28 Nov 2011 11:52:17 -0200
Subject: [PATCH 02/20] Btrfs: initialize new bitmaps' list
To: linux-btrfs@vger.kernel.org
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We're failing to create clusters with bitmaps because
setup_cluster_no_bitmap checks that the list is empty before inserting
the bitmap entry in the list for setup_cluster_bitmap, but the list
field is only initialized when it is restored from the on-disk free
space cache, or when it is written out to disk.

Besides a potential race condition due to the multiple use of the list
field, filesystem performance severely degrades over time: as we use
up all non-bitmap free extents, the try-to-set-up-cluster dance is
done at every metadata block allocation.  For every block group, we
fail to set up a cluster, and after failing on them all up to twice,
we fall back to the much slower unclustered allocation.

To make matters worse, before the unclustered allocation, we try to
create new block groups until we reach the 1% threshold, which
introduces additional bitmaps and thus block groups that we'll iterate
over at each metadata block request.

Signed-off-by: Alexandre Oliva <oliva@lsd.ic.unicamp.br>
---
 fs/btrfs/free-space-cache.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index 6e5b7e4..ff179b1 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -1470,6 +1470,7 @@ static void add_new_bitmap(struct btrfs_free_space_ctl *ctl,
 {
 	info->offset = offset_to_bitmap(ctl, offset);
 	info->bytes = 0;
+	INIT_LIST_HEAD(&info->list);
 	link_free_space(ctl, info);
 	ctl->total_bitmaps++;
 
-- 
1.7.4.4

