From: Alexandre Oliva <oliva@lsd.ic.unicamp.br>
Subject: [PATCH] Btrfs: initialize new bitmaps' list
Date: Mon, 28 Nov 2011 12:04:43 -0200
Message-ID: <orlir0s5qc.fsf@livre.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
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
---
 fs/btrfs/free-space-cache.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index 33fa4bb..4642c42 100644
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

-- 
Alexandre Oliva, freedom fighter    http://FSFLA.org/~lxoliva/
You must be the change you wish to see in the world. -- Gandhi
Be Free! -- http://FSFLA.org/   FSF Latin America board member
Free Software Evangelist      Red Hat Brazil Compiler Engineer
