Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:51907 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752326AbeFHOVM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 8 Jun 2018 10:21:12 -0400
Subject: Re: [PATCH 00/15] Add delayed-refs support to btrfs-progs
To: Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
References: <1528462078-24490-1-git-send-email-nborisov@suse.com>
 <e5b7b849-7d31-b563-0285-919b5732fc04@gmx.com>
 <1fe286cc-af72-86e4-743e-1bfb4bff1028@suse.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <3498190a-58e7-1c1d-aa24-3ddbccb8e85d@gmx.com>
Date: Fri, 8 Jun 2018 22:21:00 +0800
MIME-Version: 1.0
In-Reply-To: <1fe286cc-af72-86e4-743e-1bfb4bff1028@suse.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2018年06月08日 22:08, Nikolay Borisov wrote:
> 
> 
> On  8.06.2018 16:50, Qu Wenruo wrote:
>>  details?
>> Personally speaking, I'd like to avoid introducing complex delayed-ref
>> into btrfs-progs if possible.
>>
>> And in my (possibly wrong) understanding, the main purpose of
>> delayed-ref is to reduce the race on extent tree, thus to improve
>> performance.
>> However in btrfs-progs, it's the least important aspect.
>>
>> So extra comment on this is appreciated.
> 
> So in order to have freespace tree repair code working I needed to hook
> up its add_to_free_space_tree/remove_from_free_space_tree to
> alloc_reserved_tree_block/__free_extent. In my testing this lead to a
> very deep recursion - it crashed on 58k call frames. So the idea was to
> have delayed refs which would record and accumulate modifications and
> then the freespace tree freeing code would piggy back on them to rely on
> correct operation.

In fact, I have a pretty nasty idea on this problem.
Mark one or more metadata chunks without free space tree cache.

Then at least recursion could be easily resolved (although need extra
extent allocation hook to handle fst allocation)

> 
> I guess I could try and debug the freespace code and see why I was going
> into this infinite recursion so to speak.
> 
> Also the delayed refs code in progs is actually a lot simpler than the
> kernel counterpart due to the lack of locking.

Right.
And no need to do the async delayed ref execution should also makes
things easier.

> One more benefit of
> having this code in progs is the fact one can go through it with a
> debugger and really inspect/understand how it works

Indeed, this makes a lot of sense.

I'll take some time to do more review on this patchset, and dig deeper
into delayed-ref facility.

Thanks,
Qu

> - i.e addition of
> refs, selection of refs etc. Furthermore, it at least unifies the logic
> between kernel and userspace, since right now there is code which mimics
> the delayed refs - check the code being removed in the last patch.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
