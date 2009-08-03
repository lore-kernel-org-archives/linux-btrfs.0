From: Giuseppe Scrivano <gscrivano@gnu.org>
Subject: Re: [PATCH] Btrfs: don't allocate more than max_available bytes when looped
Date: Mon, 03 Aug 2009 22:53:37 +0200
Message-ID: <87prbc62lq.fsf@master.homenet>
References: <87fxc9yhu8.fsf@master.homenet>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <87fxc9yhu8.fsf@master.homenet> (Giuseppe Scrivano's message of
	"Mon, 03 Aug 2009 00:24:47 +0200")
List-ID: <linux-btrfs.vger.kernel.org>

Hi Chris,

Thanks for your comments, I changed the patch according to them.
>From my tests, I can see that it helps to get 10% more usable space on a
256MB partition and 5% on a 750MB one.

Cheers,
Giuseppe


>From 4eff62a7132018f8685cdeff3aa439089c708258 Mon Sep 17 00:00:00 2001
From: Giuseppe Scrivano <gscrivano@gnu.org>
Date: Mon, 3 Aug 2009 22:26:43 +0200
Subject: [PATCH] Btrfs: reduce the default min_stripe_size

The default min_stripe_size used by __btrfs_alloc_chunk was reduced to
32MB for data and 16MB for metadata chunks.

Also, after a failed attempt to alloc data, try again reducing the
minimum size by a factor of 4.  It may help allocating space that
wouldn't otherwise.
---
 fs/btrfs/volumes.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 5dbefd1..a39b651 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2166,10 +2166,10 @@ static int __btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 
 	if (type & BTRFS_BLOCK_GROUP_DATA) {
 		max_chunk_size = 10 * calc_size;
-		min_stripe_size = 64 * 1024 * 1024;
+		min_stripe_size = 32 * 1024 * 1024;
 	} else if (type & BTRFS_BLOCK_GROUP_METADATA) {
 		max_chunk_size = 4 * calc_size;
-		min_stripe_size = 32 * 1024 * 1024;
+		min_stripe_size = 16 * 1024 * 1024;
 	} else if (type & BTRFS_BLOCK_GROUP_SYSTEM) {
 		calc_size = 8 * 1024 * 1024;
 		max_chunk_size = calc_size * 2;
@@ -2190,6 +2190,9 @@ again:
 		map->num_stripes = num_stripes;
 	}
 
+	if (looped)
+		min_stripe_size = min_stripe_size / 4;
+
 	if (calc_size * num_stripes > max_chunk_size) {
 		calc_size = max_chunk_size;
 		do_div(calc_size, num_stripes);
-- 
1.6.3.3

