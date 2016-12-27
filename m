Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41437 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754308AbcL0Pzk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 27 Dec 2016 10:55:40 -0500
Date: Tue, 27 Dec 2016 16:55:33 +0100
From: Michal Hocko <mhocko@kernel.org>
To: Nils Holland <nholland@tisys.org>
Cc: Mel Gorman <mgorman@suse.de>, Johannes Weiner <hannes@cmpxchg.org>,
        Vladimir Davydov <vdavydov.dev@gmail.com>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.cz>,
        linux-btrfs@vger.kernel.org
Subject: Re: [RFC PATCH] mm, memcg: fix (Re: OOM: Better, but still there on)
Message-ID: <20161227155532.GI1308@dhcp22.suse.cz>
References: <20161221073658.GC16502@dhcp22.suse.cz>
 <20161222101028.GA11105@ppc-nas.fritz.box>
 <20161222191719.GA19898@dhcp22.suse.cz>
 <20161222214611.GA3015@boerne.fritz.box>
 <20161223105157.GB23109@dhcp22.suse.cz>
 <20161223121851.GA27413@ppc-nas.fritz.box>
 <20161223125728.GE23109@dhcp22.suse.cz>
 <20161223144738.GB23117@dhcp22.suse.cz>
 <20161223222559.GA5568@teela.multi.box>
 <20161226124839.GB20715@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20161226124839.GB20715@dhcp22.suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,
could you try to run with the following patch on top of the previous
one? I do not think it will make a large change in your workload but
I think we need something like that so some testing under which is known
to make a high lowmem pressure would be really appreciated. If you have
more time to play with it then running with and without the patch with
mm_vmscan_direct_reclaim_{start,end} tracepoints enabled could tell us
whether it make any difference at all.

I would also appreciate if Mel and Johannes had a look at it. I am not
yet sure whether we need the same thing for anon/file balancing in
get_scan_count. I suspect we need but need to think more about that.

Thanks a lot again!
---
>From b51f50340fe9e40b68be198b012f8ab9869c1850 Mon Sep 17 00:00:00 2001
From: Michal Hocko <mhocko@suse.com>
Date: Tue, 27 Dec 2016 16:28:44 +0100
Subject: [PATCH] mm, vmscan: consider eligible zones in get_scan_count

get_scan_count considers the whole node LRU size when
- doing SCAN_FILE due to many page cache inactive pages
- calculating the number of pages to scan

in both cases this might lead to unexpected behavior especially on 32b
systems where we can expect lowmem memory pressure very often.

A large highmem zone can easily distort SCAN_FILE heuristic because
there might be only few file pages from the eligible zones on the node
lru and we would still enforce file lru scanning which can lead to
trashing while we could still scan anonymous pages.

The later use of lruvec_lru_size can be problematic as well. Especially
when there are not many pages from the eligible zones. We would have to
skip over many pages to find anything to reclaim but shrink_node_memcg
would only reduce the remaining number to scan by SWAP_CLUSTER_MAX
at maximum. Therefore we can end up going over a large LRU many times
without actually having chance to reclaim much if anything at all. The
closer we are out of memory on lowmem zone the worse the problem will
be.

Signed-off-by: Michal Hocko <mhocko@suse.com>
---
 mm/vmscan.c | 30 ++++++++++++++++++++++++++++--
 1 file changed, 28 insertions(+), 2 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index c98b1a585992..785b4d7fb8a0 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -252,6 +252,32 @@ unsigned long lruvec_zone_lru_size(struct lruvec *lruvec, enum lru_list lru, int
 }
 
 /*
+ * Return the number of pages on the given lru which are eligibne for the
+ * given zone_idx
+ */
+static unsigned long lruvec_lru_size_zone_idx(struct lruvec *lruvec,
+		enum lru_list lru, int zone_idx)
+{
+	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
+	unsigned long lru_size;
+	int zid;
+
+	lru_size = lruvec_lru_size(lruvec, lru);
+	for (zid = zone_idx + 1; zid < MAX_NR_ZONES; zid++) {
+		struct zone *zone = &pgdat->node_zones[zid];
+		unsigned long size;
+
+		if (!managed_zone(zone))
+			continue;
+
+		size = lruvec_zone_lru_size(lruvec, lru, zid);
+		lru_size -= min(size, lru_size);
+	}
+
+	return lru_size;
+}
+
+/*
  * Add a shrinker callback to be called from the vm.
  */
 int register_shrinker(struct shrinker *shrinker)
@@ -2207,7 +2233,7 @@ static void get_scan_count(struct lruvec *lruvec, struct mem_cgroup *memcg,
 	 * system is under heavy pressure.
 	 */
 	if (!inactive_list_is_low(lruvec, true, sc) &&
-	    lruvec_lru_size(lruvec, LRU_INACTIVE_FILE) >> sc->priority) {
+	    lruvec_lru_size_zone_idx(lruvec, LRU_INACTIVE_FILE, sc->reclaim_idx) >> sc->priority) {
 		scan_balance = SCAN_FILE;
 		goto out;
 	}
@@ -2274,7 +2300,7 @@ static void get_scan_count(struct lruvec *lruvec, struct mem_cgroup *memcg,
 			unsigned long size;
 			unsigned long scan;
 
-			size = lruvec_lru_size(lruvec, lru);
+			size = lruvec_lru_size_zone_idx(lruvec, lru, sc->reclaim_idx);
 			scan = size >> sc->priority;
 
 			if (!scan && pass && force_scan)
-- 
2.10.2

-- 
Michal Hocko
SUSE Labs
