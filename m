Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:36537 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751472AbbIKI13 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 11 Sep 2015 04:27:29 -0400
Date: Fri, 11 Sep 2015 10:27:27 +0200
From: Michal Hocko <mhocko@kernel.org>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Chris Mason <clm@fb.com>, linux-btrfs@vger.kernel.org,
        Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.cz>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] btrfs: fortification for GFP_NOFS allocations
Message-ID: <20150911082726.GC3417@dhcp22.suse.cz>
References: <1439986661-15896-1-git-send-email-mhocko@kernel.org>
 <20150819181736.GA23654@ret.DHCP.TheFacebook.com>
 <55F05AB3.70706@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <55F05AB3.70706@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed 09-09-15 18:13:39, Vlastimil Babka wrote:
> On 08/19/2015 08:17 PM, Chris Mason wrote:
> >On Wed, Aug 19, 2015 at 02:17:39PM +0200, mhocko@kernel.org wrote:
> >>Hi,
> >>these two patches were sent as a part of a larger RFC which aims at
> >>allowing GFP_NOFS allocations to fail to help sort out memory reclaim
> >>issues bound to the current behavior
> >>(http://marc.info/?l=linux-mm&m=143876830616538&w=2).
> >>
> >>It is clear that move to the GFP_NOFS behavior change is a long term
> >>plan but these patches should be good enough even with that change in
> >>place. It also seems that Chris wasn't opposed and would be willing to
> >>take them http://marc.info/?l=linux-mm&m=143991792427165&w=2 so here we
> >>come. I have rephrased the changeslogs to not refer to the patch which
> >>changes the NOFS behavior.
> >>
> >>Just to clarify. These two patches allowed my particular testcase
> >>(mentioned in the cover referenced above) to survive it doesn't mean
> >>that the failing GFP_NOFS are OK now. I have seen some other places
> >>where GFP_NOFS allocation is followed by BUG_ON(ALLOC_FAILED). I have
> >>not encountered them though.
> >>
> >>Let me know if you would prefer other changes.
> >
> >My plan is to start with these two and take more as required.
> 
> I've previously noticed in __set_extent_bit() things like:
> 
>         if (!prealloc && (mask & __GFP_WAIT)) {
>                 prealloc = alloc_extent_state(mask);
>                 BUG_ON(!prealloc);
>         }
> 
> and later:
> 
>                 prealloc = alloc_extent_state_atomic(prealloc);
>                 BUG_ON(!prealloc);

Yes. I have noticed also many other places:
$ git grep "BUG_ON.*ENOMEM" -- fs/btrfs/ | wc -l
47

I have talked to David Sterba and he said this is on his todo list.
So this will likely take some more time but it is definitely good to
sort out.
-- 
Michal Hocko
SUSE Labs
