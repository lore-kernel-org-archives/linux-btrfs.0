From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: return error if the range we want to map is bogus
Date: Tue, 15 Mar 2011 14:54:57 -0400
Message-ID: <1300215297-1846-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Currently if we have corrupt metadata map_extent_buffer will complain about it,
but not return an error so the caller has no idea a problem was hit.  Fix this.
Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/extent_io.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 714adc4..1bbd26b 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -3690,6 +3690,7 @@ int map_private_extent_buffer(struct extent_buffer *eb, unsigned long start,
 		       "wanted %lu %lu\n", (unsigned long long)eb->start,
 		       eb->len, start, min_len);
 		WARN_ON(1);
+		return -EINVAL;
 	}
 
 	p = extent_buffer_page(eb, i);
-- 
1.7.2.3

