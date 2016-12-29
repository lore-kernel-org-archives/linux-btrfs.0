Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53035 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752110AbcL2Ixd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 29 Dec 2016 03:53:33 -0500
Date: Thu, 29 Dec 2016 09:52:33 +0100
From: Michal Hocko <mhocko@kernel.org>
To: Minchan Kim <minchan@kernel.org>
Cc: Nils Holland <nholland@tisys.org>, Mel Gorman <mgorman@suse.de>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Vladimir Davydov <vdavydov.dev@gmail.com>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.cz>,
        linux-btrfs@vger.kernel.org
Subject: Re: [RFC PATCH] mm, memcg: fix (Re: OOM: Better, but still there on)
Message-ID: <20161229085233.GD29208@dhcp22.suse.cz>
References: <20161222191719.GA19898@dhcp22.suse.cz>
 <20161222214611.GA3015@boerne.fritz.box>
 <20161223105157.GB23109@dhcp22.suse.cz>
 <20161223121851.GA27413@ppc-nas.fritz.box>
 <20161223125728.GE23109@dhcp22.suse.cz>
 <20161223144738.GB23117@dhcp22.suse.cz>
 <20161223222559.GA5568@teela.multi.box>
 <20161226124839.GB20715@dhcp22.suse.cz>
 <20161229003154.GA15160@bbox>
 <20161229004824.GA15541@bbox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20161229004824.GA15541@bbox>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu 29-12-16 09:48:24, Minchan Kim wrote:
> On Thu, Dec 29, 2016 at 09:31:54AM +0900, Minchan Kim wrote:
[...]
> > Acked-by: Minchan Kim <minchan@kernel.org>

Thanks!
 
> Nit:
> 
> WARNING: line over 80 characters
> #53: FILE: include/linux/memcontrol.h:689:
> +unsigned long mem_cgroup_get_zone_lru_size(struct lruvec *lruvec, enum lru_list lru,
> 
> WARNING: line over 80 characters
> #147: FILE: mm/vmscan.c:248:
> +unsigned long lruvec_zone_lru_size(struct lruvec *lruvec, enum lru_list lru, int zone_idx)
> 
> WARNING: line over 80 characters
> #177: FILE: mm/vmscan.c:1446:
> +               mem_cgroup_update_lru_size(lruvec, lru, zid, -nr_zone_taken[zid]);

fixed

> WARNING: line over 80 characters
> #201: FILE: mm/vmscan.c:2099:
> +               inactive_zone = lruvec_zone_lru_size(lruvec, file * LRU_FILE, zid);
> 
> WARNING: line over 80 characters
> #202: FILE: mm/vmscan.c:2100:
> +               active_zone = lruvec_zone_lru_size(lruvec, (file * LRU_FILE) + LRU_ACTIVE, zid);

I would prefer to have those on the same line though. It will make them
easier to follow.

-- 
Michal Hocko
SUSE Labs
