Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:52481 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750978AbbHSSRn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 19 Aug 2015 14:17:43 -0400
Date: Wed, 19 Aug 2015 14:17:36 -0400
From: Chris Mason <clm@fb.com>
To: <mhocko@kernel.org>
CC: <linux-btrfs@vger.kernel.org>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.cz>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] btrfs: fortification for GFP_NOFS allocations
Message-ID: <20150819181736.GA23654@ret.DHCP.TheFacebook.com>
References: <1439986661-15896-1-git-send-email-mhocko@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1439986661-15896-1-git-send-email-mhocko@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Aug 19, 2015 at 02:17:39PM +0200, mhocko@kernel.org wrote:
> Hi,
> these two patches were sent as a part of a larger RFC which aims at
> allowing GFP_NOFS allocations to fail to help sort out memory reclaim
> issues bound to the current behavior
> (http://marc.info/?l=linux-mm&m=143876830616538&w=2).
> 
> It is clear that move to the GFP_NOFS behavior change is a long term
> plan but these patches should be good enough even with that change in
> place. It also seems that Chris wasn't opposed and would be willing to
> take them http://marc.info/?l=linux-mm&m=143991792427165&w=2 so here we
> come. I have rephrased the changeslogs to not refer to the patch which
> changes the NOFS behavior.
> 
> Just to clarify. These two patches allowed my particular testcase
> (mentioned in the cover referenced above) to survive it doesn't mean
> that the failing GFP_NOFS are OK now. I have seen some other places
> where GFP_NOFS allocation is followed by BUG_ON(ALLOC_FAILED). I have
> not encountered them though.
> 
> Let me know if you would prefer other changes.

My plan is to start with these two and take more as required.

-chris
