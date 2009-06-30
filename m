From: TARUISI Hiroaki <taruishi.hiroak@jp.fujitsu.com>
Subject: [Patch] btrfsck.c typo?
Date: Tue, 30 Jun 2009 14:20:12 +0900
Message-ID: <4A49A08C.1060204@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,
Recently, I've red btrfsck.c of btrfs-progs to study the internal of btrfs.
However, I may find typo in pick_next_pending() of btrfsck.c

The first index of bits[] which is initialized should be 0, I think.

Signed-off-by: TARUISI Hiroaki <taruishi.hiroak@jp.fujitsu.com>
---

diff --git a/btrfsck.c b/btrfsck.c
index 40c90f8..f961c9b 100644
--- a/btrfsck.c
+++ b/btrfsck.c
@@ -1920,7 +1920,7 @@ static int pick_next_pending(struct cache_tree *pending,
        cache = find_first_cache_extent(reada, 0);
        if (cache) {
                bits[0].start = cache->start;
-               bits[1].size = cache->size;
+               bits[0].size = cache->size;
                *reada_bits = 1;
                return 1;
        }

-- 
taruisi

