Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46860 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752510AbcL3Kko (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 30 Dec 2016 05:40:44 -0500
Date: Fri, 30 Dec 2016 11:40:38 +0100
From: Michal Hocko <mhocko@kernel.org>
To: Minchan Kim <minchan@kernel.org>
Cc: Nils Holland <nholland@tisys.org>, Mel Gorman <mgorman@suse.de>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Vladimir Davydov <vdavydov.dev@gmail.com>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.cz>,
        linux-btrfs@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [RFC PATCH] mm, memcg: fix (Re: OOM: Better, but still there on)
Message-ID: <20161230104038.GA13657@dhcp22.suse.cz>
References: <20161223105157.GB23109@dhcp22.suse.cz>
 <20161223121851.GA27413@ppc-nas.fritz.box>
 <20161223125728.GE23109@dhcp22.suse.cz>
 <20161223144738.GB23117@dhcp22.suse.cz>
 <20161223222559.GA5568@teela.multi.box>
 <20161226124839.GB20715@dhcp22.suse.cz>
 <20161227155532.GI1308@dhcp22.suse.cz>
 <20161229012026.GB15541@bbox>
 <20161229090432.GE29208@dhcp22.suse.cz>
 <20161230020522.GC4184@bbox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20161230020522.GC4184@bbox>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri 30-12-16 11:05:22, Minchan Kim wrote:
> On Thu, Dec 29, 2016 at 10:04:32AM +0100, Michal Hocko wrote:
> > On Thu 29-12-16 10:20:26, Minchan Kim wrote:
> > > On Tue, Dec 27, 2016 at 04:55:33PM +0100, Michal Hocko wrote:
[...]
> > > > + * given zone_idx
> > > > + */
> > > > +static unsigned long lruvec_lru_size_zone_idx(struct lruvec *lruvec,
> > > > +		enum lru_list lru, int zone_idx)
> > > 
> > > Nit:
> > > 
> > > Although there is a comment, function name is rather confusing when I compared
> > > it with lruvec_zone_lru_size.
> > 
> > I am all for a better name.
> > 
> > > lruvec_eligible_zones_lru_size is better?
> > 
> > this would be too easy to confuse with lruvec_eligible_zone_lru_size.
> > What about lruvec_lru_size_eligible_zones?
> 
> Don't mind.

I will go with lruvec_lru_size_eligible_zones then.

> > > Nit:
> > > 
> > > With this patch, inactive_list_is_low can use lruvec_lru_size_zone_idx rather than
> > > own custom calculation to filter out non-eligible pages. 
> > 
> > Yes, that would be possible and I was considering that. But then I found
> > useful to see total and reduced numbers in the tracepoint
> > http://lkml.kernel.org/r/20161228153032.10821-8-mhocko@kernel.org
> > and didn't want to call lruvec_lru_size 2 times. But if you insist then
> > I can just do that.
> 
> I don't mind either but I think we need to describe the reason if you want to
> go with your open-coded version. Otherwise, someone will try to fix it.

OK, I will go with the follow up patch on top of the tracepoints series.
I was hoping that the way how tracing is full of macros would allow us
to evaluate arguments only when the tracepoint is enabled but this
doesn't seem to be the case. Let's CC Steven. Would it be possible to
define a tracepoint in such a way that all given arguments are evaluated
only when the tracepoint is enabled?
---
>From 9a561d652f91f3557db22161600f10ca2462c74f Mon Sep 17 00:00:00 2001
From: Michal Hocko <mhocko@suse.com>
Date: Fri, 30 Dec 2016 11:28:20 +0100
Subject: [PATCH] mm, vmscan: cleanup up inactive_list_is_low

inactive_list_is_low is effectively duplicating logic implemented by
lruvec_lru_size_eligibe_zones. Let's use the dedicated function to
get the number of eligible pages on the lru list and ask use
lruvec_lru_size to get the total LRU lize only when the tracing is
really requested. We are still iterating over all LRUs two times in that
case but a) inactive_list_is_low is not a hot path and b) this can be
addressed at the tracing layer and only evaluate arguments only when the
tracing is enabled in future if that ever matters.

Signed-off-by: Michal Hocko <mhocko@suse.com>
---
 mm/vmscan.c | 38 ++++++++++----------------------------
 1 file changed, 10 insertions(+), 28 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 137bc85067d3..a9c881f06c0e 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2054,11 +2054,10 @@ static bool inactive_list_is_low(struct lruvec *lruvec, bool file,
 						struct scan_control *sc, bool trace)
 {
 	unsigned long inactive_ratio;
-	unsigned long total_inactive, inactive;
-	unsigned long total_active, active;
+	unsigned long inactive, active;
+	enum lru_list inactive_lru = file * LRU_FILE;
+	enum lru_list active_lru = file * LRU_FILE + LRU_ACTIVE;
 	unsigned long gb;
-	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
-	int zid;
 
 	/*
 	 * If we don't have swap space, anonymous page deactivation
@@ -2067,27 +2066,8 @@ static bool inactive_list_is_low(struct lruvec *lruvec, bool file,
 	if (!file && !total_swap_pages)
 		return false;
 
-	total_inactive = inactive = lruvec_lru_size(lruvec, file * LRU_FILE);
-	total_active = active = lruvec_lru_size(lruvec, file * LRU_FILE + LRU_ACTIVE);
-
-	/*
-	 * For zone-constrained allocations, it is necessary to check if
-	 * deactivations are required for lowmem to be reclaimed. This
-	 * calculates the inactive/active pages available in eligible zones.
-	 */
-	for (zid = sc->reclaim_idx + 1; zid < MAX_NR_ZONES; zid++) {
-		struct zone *zone = &pgdat->node_zones[zid];
-		unsigned long inactive_zone, active_zone;
-
-		if (!managed_zone(zone))
-			continue;
-
-		inactive_zone = lruvec_zone_lru_size(lruvec, file * LRU_FILE, zid);
-		active_zone = lruvec_zone_lru_size(lruvec, (file * LRU_FILE) + LRU_ACTIVE, zid);
-
-		inactive -= min(inactive, inactive_zone);
-		active -= min(active, active_zone);
-	}
+	inactive = lruvec_lru_size_eligibe_zones(lruvec, inactive_lru, sc->reclaim_idx);
+	active = lruvec_lru_size_eligibe_zones(lruvec, active_lru, sc->reclaim_idx);
 
 	gb = (inactive + active) >> (30 - PAGE_SHIFT);
 	if (gb)
@@ -2096,10 +2076,12 @@ static bool inactive_list_is_low(struct lruvec *lruvec, bool file,
 		inactive_ratio = 1;
 
 	if (trace)
-		trace_mm_vmscan_inactive_list_is_low(pgdat->node_id,
+		trace_mm_vmscan_inactive_list_is_low(lruvec_pgdat(lruvec)->node_id,
 				sc->reclaim_idx,
-				total_inactive, inactive,
-				total_active, active, inactive_ratio, file);
+				lruvec_lru_size(lruvec, inactive_lru), inactive,
+				lruvec_lru_size(lruvec, active_lru), active,
+				inactive_ratio, file);
+
 	return inactive * inactive_ratio < active;
 }
 
-- 
2.10.2

-- 
Michal Hocko
SUSE Labs
