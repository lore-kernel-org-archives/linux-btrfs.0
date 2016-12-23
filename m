Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45552 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750730AbcLWOrp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 23 Dec 2016 09:47:45 -0500
Date: Fri, 23 Dec 2016 15:47:39 +0100
From: Michal Hocko <mhocko@kernel.org>
To: Nils Holland <nholland@tisys.org>, Mel Gorman <mgorman@suse.de>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.cz>,
        linux-btrfs@vger.kernel.org
Subject: [RFC PATCH] mm, memcg: fix (Re: OOM: Better, but still there on)
Message-ID: <20161223144738.GB23117@dhcp22.suse.cz>
References: <20161217210646.GA11358@boerne.fritz.box>
 <20161219134534.GC5164@dhcp22.suse.cz>
 <20161220020829.GA5449@boerne.fritz.box>
 <20161221073658.GC16502@dhcp22.suse.cz>
 <20161222101028.GA11105@ppc-nas.fritz.box>
 <20161222191719.GA19898@dhcp22.suse.cz>
 <20161222214611.GA3015@boerne.fritz.box>
 <20161223105157.GB23109@dhcp22.suse.cz>
 <20161223121851.GA27413@ppc-nas.fritz.box>
 <20161223125728.GE23109@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20161223125728.GE23109@dhcp22.suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

[Add Mel, Johannes and Vladimir - the email thread started here
http://lkml.kernel.org/r/20161215225702.GA27944@boerne.fritz.box
The long story short, the zone->node reclaim change has broken active
list aging for lowmem requests when memory cgroups are enabled. More
details below.

On Fri 23-12-16 13:57:28, Michal Hocko wrote:
> On Fri 23-12-16 13:18:51, Nils Holland wrote:
> > On Fri, Dec 23, 2016 at 11:51:57AM +0100, Michal Hocko wrote:
> > > TL;DR
> > > drop the last patch, check whether memory cgroup is enabled and retest
> > > with cgroup_disable=memory to see whether this is memcg related and if
> > > it is _not_ then try to test with the patch below
> > 
> > Right, it seems we might be looking in the right direction! So I
> > removed the previous patch from my kernel and verified if memory
> > cgroup was enabled, and indeed, it was. So I booted with
> > cgroup_disable=memory and ran my ordinary test again ... and in fact,
> > no ooms!
> 
> OK, thanks for confirmation. I could have figured that earlier. The
> pagecache differences in such a short time should have raised the red
> flag and point towards memcgs...
> 
> [...]
> > > I would appreciate to stick with your setup to not pull new unknows into
> > > the picture.
> > 
> > No problem! It's just likely that I won't be able to test during the
> > following days until Dec 27th, but after that I should be back to
> > normal and thus be able to run further tests in a timely fashion. :-)
> 
> no problem at all. I will try to cook up a patch in the mean time.

So here is my attempt. Only compile tested so be careful, it might eat
your kittens or do more harm. I would appreciate other guys to have a
look to see whether this is sane. There are probably other places which
would need some tweaks. I think that get_scan_count needs some tweaks
as well because we should only consider eligible zones when counting the
number of pages to scan. This would be for a separate patch which I will
send later. I just want to fix this one first.

Nils, even though this is still highly experimental, could you give it a
try please?
---
>From a66fd89d43e9fd8ca9afa7e6c7252ab73d22b686 Mon Sep 17 00:00:00 2001
From: Michal Hocko <mhocko@suse.com>
Date: Fri, 23 Dec 2016 15:11:54 +0100
Subject: [PATCH] mm, memcg: fix the active list aging for lowmem requests when
 memcg is enabled

Nils Holland has reported unexpected OOM killer invocations with 32b
kernel starting with 4.8 kernels

	kworker/u4:5 invoked oom-killer: gfp_mask=0x2400840(GFP_NOFS|__GFP_NOFAIL), nodemask=0, order=0, oom_score_adj=0
	kworker/u4:5 cpuset=/ mems_allowed=0
	CPU: 1 PID: 2603 Comm: kworker/u4:5 Not tainted 4.9.0-gentoo #2
	[...]
	Mem-Info:
	active_anon:58685 inactive_anon:90 isolated_anon:0
	 active_file:274324 inactive_file:281962 isolated_file:0
	 unevictable:0 dirty:649 writeback:0 unstable:0
	 slab_reclaimable:40662 slab_unreclaimable:17754
	 mapped:7382 shmem:202 pagetables:351 bounce:0
	 free:206736 free_pcp:332 free_cma:0
	Node 0 active_anon:234740kB inactive_anon:360kB active_file:1097296kB inactive_file:1127848kB unevictable:0kB isolated(anon):0kB isolated(file):0kB mapped:29528kB dirty:2596kB writeback:0kB shmem:0kB shmem_thp: 0kB shmem_pmdmapped: 184320kB anon_thp: 808kB writeback_tmp:0kB unstable:0kB pages_scanned:0 all_unreclaimable? no
	DMA free:3952kB min:788kB low:984kB high:1180kB active_anon:0kB inactive_anon:0kB active_file:7316kB inactive_file:0kB unevictable:0kB writepending:96kB present:15992kB managed:15916kB mlocked:0kB slab_reclaimable:3200kB slab_unreclaimable:1408kB kernel_stack:0kB pagetables:0kB bounce:0kB free_pcp:0kB local_pcp:0kB free_cma:0kB
	lowmem_reserve[]: 0 813 3474 3474
	Normal free:41332kB min:41368kB low:51708kB high:62048kB active_anon:0kB inactive_anon:0kB active_file:532748kB inactive_file:44kB unevictable:0kB writepending:24kB present:897016kB managed:836248kB mlocked:0kB slab_reclaimable:159448kB slab_unreclaimable:69608kB kernel_stack:1112kB pagetables:1404kB bounce:0kB free_pcp:528kB local_pcp:340kB free_cma:0kB
	lowmem_reserve[]: 0 0 21292 21292
	HighMem free:781660kB min:512kB low:34356kB high:68200kB active_anon:234740kB inactive_anon:360kB active_file:557232kB inactive_file:1127804kB unevictable:0kB writepending:2592kB present:2725384kB managed:2725384kB mlocked:0kB slab_reclaimable:0kB slab_unreclaimable:0kB kernel_stack:0kB pagetables:0kB bounce:0kB free_pcp:800kB local_pcp:608kB free_cma:0kB

the oom killer is clearly pre-mature because there there is still a
lot of page cache in the zone Normal which should satisfy this lowmem
request. Further debugging has shown that the reclaim cannot make any
forward progress because the page cache is hidden in the active list
which doesn't get rotated because inactive_list_is_low is not memcg
aware.
It simply subtracts per-zone highmem counters from the respective
memcg's lru sizes which doesn't make any sense. We can simply end up
always seeing the resulting active and inactive counts 0 and return
false. This issue is not limited to 32b kernels but in practice the
effect on systems without CONFIG_HIGHMEM would be much harder to notice
because we do not invoke the OOM killer for allocations requests
targeting < ZONE_NORMAL.

Fix the issue by tracking per zone lru page counts in mem_cgroup_per_node
and subtract per-memcg highmem counts when memcg is enabled. Introduce
helper lruvec_zone_lru_size which redirects to either zone counters or
mem_cgroup_get_zone_lru_size when appropriate.

Fixes: f8d1a31163fc ("mm: consider whether to decivate based on eligible zones inactive ratio")
Cc: stable # 4.8+
Reported-by: Nils Holland <nholland@tisys.org>
Signed-off-by: Michal Hocko <mhocko@suse.com>
---
 include/linux/memcontrol.h | 26 +++++++++++++++++++++++---
 include/linux/mm_inline.h  |  2 +-
 mm/memcontrol.c            | 11 ++++++-----
 mm/vmscan.c                | 26 ++++++++++++++++----------
 4 files changed, 46 insertions(+), 19 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 61d20c17f3b7..002cb08b0f3e 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -120,7 +120,7 @@ struct mem_cgroup_reclaim_iter {
  */
 struct mem_cgroup_per_node {
 	struct lruvec		lruvec;
-	unsigned long		lru_size[NR_LRU_LISTS];
+	unsigned long		lru_zone_size[MAX_NR_ZONES][NR_LRU_LISTS];
 
 	struct mem_cgroup_reclaim_iter	iter[DEF_PRIORITY + 1];
 
@@ -432,7 +432,7 @@ static inline bool mem_cgroup_online(struct mem_cgroup *memcg)
 int mem_cgroup_select_victim_node(struct mem_cgroup *memcg);
 
 void mem_cgroup_update_lru_size(struct lruvec *lruvec, enum lru_list lru,
-		int nr_pages);
+		int zid, int nr_pages);
 
 unsigned long mem_cgroup_node_nr_lru_pages(struct mem_cgroup *memcg,
 					   int nid, unsigned int lru_mask);
@@ -441,9 +441,23 @@ static inline
 unsigned long mem_cgroup_get_lru_size(struct lruvec *lruvec, enum lru_list lru)
 {
 	struct mem_cgroup_per_node *mz;
+	unsigned long nr_pages = 0;
+	int zid;
 
 	mz = container_of(lruvec, struct mem_cgroup_per_node, lruvec);
-	return mz->lru_size[lru];
+	for (zid = 0; zid < MAX_NR_ZONES; zid++)
+		nr_pages += mz->lru_zone_size[zid][lru];
+	return nr_pages;
+}
+
+static inline
+unsigned long mem_cgroup_get_zone_lru_size(struct lruvec *lruvec, enum lru_list lru,
+					   int zone_idx)
+{
+	struct mem_cgroup_per_node *mz;
+
+	mz = container_of(lruvec, struct mem_cgroup_per_node, lruvec);
+	return mz->lru_zone_size[zone_idx][lru];
 }
 
 void mem_cgroup_handle_over_high(void);
@@ -671,6 +685,12 @@ mem_cgroup_get_lru_size(struct lruvec *lruvec, enum lru_list lru)
 {
 	return 0;
 }
+static inline
+unsigned long mem_cgroup_get_zone_lru_size(struct lruvec *lruvec, enum lru_list lru,
+					   int zone_idx)
+{
+	return 0;
+}
 
 static inline unsigned long
 mem_cgroup_node_nr_lru_pages(struct mem_cgroup *memcg,
diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
index 71613e8a720f..41d376e7116d 100644
--- a/include/linux/mm_inline.h
+++ b/include/linux/mm_inline.h
@@ -39,7 +39,7 @@ static __always_inline void update_lru_size(struct lruvec *lruvec,
 {
 	__update_lru_size(lruvec, lru, zid, nr_pages);
 #ifdef CONFIG_MEMCG
-	mem_cgroup_update_lru_size(lruvec, lru, nr_pages);
+	mem_cgroup_update_lru_size(lruvec, lru, zid, nr_pages);
 #endif
 }
 
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 91dfc7c5ce8f..f4e9c4d49df3 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -625,8 +625,8 @@ static void mem_cgroup_charge_statistics(struct mem_cgroup *memcg,
 unsigned long mem_cgroup_node_nr_lru_pages(struct mem_cgroup *memcg,
 					   int nid, unsigned int lru_mask)
 {
+	struct lruvec *lruvec = mem_cgroup_lruvec(NODE_DATA(nid), memcg);
 	unsigned long nr = 0;
-	struct mem_cgroup_per_node *mz;
 	enum lru_list lru;
 
 	VM_BUG_ON((unsigned)nid >= nr_node_ids);
@@ -634,8 +634,7 @@ unsigned long mem_cgroup_node_nr_lru_pages(struct mem_cgroup *memcg,
 	for_each_lru(lru) {
 		if (!(BIT(lru) & lru_mask))
 			continue;
-		mz = mem_cgroup_nodeinfo(memcg, nid);
-		nr += mz->lru_size[lru];
+		nr += mem_cgroup_get_lru_size(lruvec, lru);
 	}
 	return nr;
 }
@@ -1002,6 +1001,7 @@ struct lruvec *mem_cgroup_page_lruvec(struct page *page, struct pglist_data *pgd
  * mem_cgroup_update_lru_size - account for adding or removing an lru page
  * @lruvec: mem_cgroup per zone lru vector
  * @lru: index of lru list the page is sitting on
+ * @zid: zone id of the accounted pages
  * @nr_pages: positive when adding or negative when removing
  *
  * This function must be called under lru_lock, just before a page is added
@@ -1009,7 +1009,7 @@ struct lruvec *mem_cgroup_page_lruvec(struct page *page, struct pglist_data *pgd
  * so as to allow it to check that lru_size 0 is consistent with list_empty).
  */
 void mem_cgroup_update_lru_size(struct lruvec *lruvec, enum lru_list lru,
-				int nr_pages)
+				int zid, int nr_pages)
 {
 	struct mem_cgroup_per_node *mz;
 	unsigned long *lru_size;
@@ -1020,7 +1020,7 @@ void mem_cgroup_update_lru_size(struct lruvec *lruvec, enum lru_list lru,
 		return;
 
 	mz = container_of(lruvec, struct mem_cgroup_per_node, lruvec);
-	lru_size = mz->lru_size + lru;
+	lru_size = &mz->lru_zone_size[zid][lru];
 	empty = list_empty(lruvec->lists + lru);
 
 	if (nr_pages < 0)
@@ -1036,6 +1036,7 @@ void mem_cgroup_update_lru_size(struct lruvec *lruvec, enum lru_list lru,
 
 	if (nr_pages > 0)
 		*lru_size += nr_pages;
+	mz->lru_zone_size[zid][lru] += nr_pages;
 }
 
 bool task_in_mem_cgroup(struct task_struct *task, struct mem_cgroup *memcg)
diff --git a/mm/vmscan.c b/mm/vmscan.c
index c4abf08861d2..c98b1a585992 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -242,6 +242,15 @@ unsigned long lruvec_lru_size(struct lruvec *lruvec, enum lru_list lru)
 	return node_page_state(lruvec_pgdat(lruvec), NR_LRU_BASE + lru);
 }
 
+unsigned long lruvec_zone_lru_size(struct lruvec *lruvec, enum lru_list lru, int zone_idx)
+{
+	if (!mem_cgroup_disabled())
+		return mem_cgroup_get_zone_lru_size(lruvec, lru, zone_idx);
+
+	return zone_page_state(&lruvec_pgdat(lruvec)->node_zones[zone_idx],
+			       NR_ZONE_LRU_BASE + lru);
+}
+
 /*
  * Add a shrinker callback to be called from the vm.
  */
@@ -1382,8 +1391,7 @@ int __isolate_lru_page(struct page *page, isolate_mode_t mode)
  * be complete before mem_cgroup_update_lru_size due to a santity check.
  */
 static __always_inline void update_lru_sizes(struct lruvec *lruvec,
-			enum lru_list lru, unsigned long *nr_zone_taken,
-			unsigned long nr_taken)
+			enum lru_list lru, unsigned long *nr_zone_taken)
 {
 	int zid;
 
@@ -1392,11 +1400,11 @@ static __always_inline void update_lru_sizes(struct lruvec *lruvec,
 			continue;
 
 		__update_lru_size(lruvec, lru, zid, -nr_zone_taken[zid]);
-	}
-
 #ifdef CONFIG_MEMCG
-	mem_cgroup_update_lru_size(lruvec, lru, -nr_taken);
+		mem_cgroup_update_lru_size(lruvec, lru, zid, -nr_zone_taken[zid]);
 #endif
+	}
+
 }
 
 /*
@@ -1501,7 +1509,7 @@ static unsigned long isolate_lru_pages(unsigned long nr_to_scan,
 	*nr_scanned = scan;
 	trace_mm_vmscan_lru_isolate(sc->reclaim_idx, sc->order, nr_to_scan, scan,
 				    nr_taken, mode, is_file_lru(lru));
-	update_lru_sizes(lruvec, lru, nr_zone_taken, nr_taken);
+	update_lru_sizes(lruvec, lru, nr_zone_taken);
 	return nr_taken;
 }
 
@@ -2047,10 +2055,8 @@ static bool inactive_list_is_low(struct lruvec *lruvec, bool file,
 		if (!managed_zone(zone))
 			continue;
 
-		inactive_zone = zone_page_state(zone,
-				NR_ZONE_LRU_BASE + (file * LRU_FILE));
-		active_zone = zone_page_state(zone,
-				NR_ZONE_LRU_BASE + (file * LRU_FILE) + LRU_ACTIVE);
+		inactive_zone = lruvec_zone_lru_size(lruvec, file * LRU_FILE, zid);
+		active_zone = lruvec_zone_lru_size(lruvec, (file * LRU_FILE) + LRU_ACTIVE, zid);
 
 		inactive -= min(inactive, inactive_zone);
 		active -= min(active, active_zone);
-- 
2.10.2


-- 
Michal Hocko
SUSE Labs
