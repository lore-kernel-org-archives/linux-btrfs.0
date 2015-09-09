Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44148 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752843AbbIIQNl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 9 Sep 2015 12:13:41 -0400
Subject: Re: [PATCH 0/2] btrfs: fortification for GFP_NOFS allocations
To: Chris Mason <clm@fb.com>, mhocko@kernel.org, linux-btrfs@vger.kernel.org,
        Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.cz>,
        linux-kernel@vger.kernel.org
References: <1439986661-15896-1-git-send-email-mhocko@kernel.org>
 <20150819181736.GA23654@ret.DHCP.TheFacebook.com>
From: Vlastimil Babka <vbabka@suse.cz>
Message-ID: <55F05AB3.70706@suse.cz>
Date: Wed, 9 Sep 2015 18:13:39 +0200
MIME-Version: 1.0
In-Reply-To: <20150819181736.GA23654@ret.DHCP.TheFacebook.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 08/19/2015 08:17 PM, Chris Mason wrote:
> On Wed, Aug 19, 2015 at 02:17:39PM +0200, mhocko@kernel.org wrote:
>> Hi,
>> these two patches were sent as a part of a larger RFC which aims at
>> allowing GFP_NOFS allocations to fail to help sort out memory reclaim
>> issues bound to the current behavior
>> (http://marc.info/?l=linux-mm&m=143876830616538&w=2).
>>
>> It is clear that move to the GFP_NOFS behavior change is a long term
>> plan but these patches should be good enough even with that change in
>> place. It also seems that Chris wasn't opposed and would be willing to
>> take them http://marc.info/?l=linux-mm&m=143991792427165&w=2 so here we
>> come. I have rephrased the changeslogs to not refer to the patch which
>> changes the NOFS behavior.
>>
>> Just to clarify. These two patches allowed my particular testcase
>> (mentioned in the cover referenced above) to survive it doesn't mean
>> that the failing GFP_NOFS are OK now. I have seen some other places
>> where GFP_NOFS allocation is followed by BUG_ON(ALLOC_FAILED). I have
>> not encountered them though.
>>
>> Let me know if you would prefer other changes.
>
> My plan is to start with these two and take more as required.

I've previously noticed in __set_extent_bit() things like:

         if (!prealloc && (mask & __GFP_WAIT)) {
                 prealloc = alloc_extent_state(mask);
                 BUG_ON(!prealloc);
         }

and later:

                 prealloc = alloc_extent_state_atomic(prealloc);
                 BUG_ON(!prealloc);

which internally does:

         if (!prealloc)
                 prealloc = alloc_extent_state(GFP_ATOMIC);

The first one could be fixable by adding __GFP_NOFAIL. In fact we've got 
an internal bug report for that one already. Even without GFP_NOFS being 
allowed to fail, allocation can already fail when the thread is marked 
for oom kill, which is likely what happened in that case.

The second case is problematic though, because GFP_ATOMIC | __GFP_NOFAIL 
is not allowed. GFP_ATOMIC will give you access to memory reserves, 
which reduces the chance of hitting the BUG_ON(), but it's not a 
bulletproof solution.

> -chris
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

