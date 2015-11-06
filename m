Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50770 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031116AbbKFDP2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 5 Nov 2015 22:15:28 -0500
Date: Thu, 5 Nov 2015 19:15:26 -0800
From: Mark Fasheh <mfasheh@suse.de>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: Stefan Priebe <s.priebe@profihost.ag>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        jbacik@fb.com, Chris Mason <clm@fb.com>
Subject: Re: Regression in: [PATCH 4/4] btrfs: qgroup: account shared subtree
 during snapshot delete
Message-ID: <20151106031526.GJ15575@wotan.suse.de>
Reply-To: Mark Fasheh <mfasheh@suse.de>
References: <56367AE8.9030509@profihost.ag>
 <5636BDA0.4020200@cn.fujitsu.com>
 <20151103192625.GE15575@wotan.suse.de>
 <563958F0.6030904@cn.fujitsu.com>
 <20151105192346.GI15575@wotan.suse.de>
 <563BFC15.4070705@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <563BFC15.4070705@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Nov 06, 2015 at 09:02:13AM +0800, Qu Wenruo wrote:
> >The same exact code ran in either case before and after your patches, so my
> >guess is that the issue is actually inside the qgroup code that shouldn't
> >have been run. I wonder if we even just filled up his memory but never
> >cleaned the objects. The only other thing I can think of is if
> >account_leaf_items() got run in a really tight loop for some reason.
> >
> >Kmalloc in the way we are using it is not usually a performance issue,
> >especially if we've been reading off disk in the same process. Ask yourself
> >this - your own patch series does the same kmalloc for every qgroup
> >operation. Did you notice a complete and massive performance slowdown like
> >the one Stefan reported?
> 
> You're right, such memory allocation may impact performance but not
> so noticeable, compared to other operations which may kick disk IO,
> like btrfs_find_all_roots().
> 
> But at least, enabling qgroup will impact performance.
> 
> Yeah, this time I has test data now.
> In a environment with 100 different snapshot, sysbench shows an
> overall performance drop about 5%, and in some case, up to 7%, with
> qgroup enabled.
> 
> Not sure about the kmalloc impact, maybe less than 1% or maybe 2~3%,
> but at least it's worthy trying to use kmem cache.

Ok cool, what'd you do to generate the snapshots? I can try a similar test
on one of my machines and see what I get. I'm not surprised that the
overhead is noticable, and I agree it's easy enough to try things like
replacing the allocation once we have a test going.

Thanks,
	--Mark

--
Mark Fasheh
