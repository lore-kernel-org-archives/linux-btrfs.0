Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36011 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1032788AbeE1Pd1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 28 May 2018 11:33:27 -0400
Subject: Re: [PATCH v2 4/6] Btrfs: remove unused check of skip_locking
To: dsterba@suse.cz, Qu Wenruo <quwenruo.btrfs@gmx.com>,
        Liu Bo <bo.liu@linux.alibaba.com>, linux-btrfs@vger.kernel.org
References: <1526612424-97061-1-git-send-email-bo.liu@linux.alibaba.com>
 <1526612424-97061-5-git-send-email-bo.liu@linux.alibaba.com>
 <36bc953d-f9c7-fb58-d31e-09f610ad90be@gmx.com>
 <20180528142107.GA6649@twin.jikos.cz>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <06f48192-c5c5-f3f2-8828-ff4fc37a6863@suse.com>
Date: Mon, 28 May 2018 18:33:23 +0300
MIME-Version: 1.0
In-Reply-To: <20180528142107.GA6649@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 28.05.2018 17:21, David Sterba wrote:
> On Fri, May 18, 2018 at 01:27:50PM +0800, Qu Wenruo wrote:
>>
>>
>> On 2018年05月18日 11:00, Liu Bo wrote:
>>> The check is superfluous since all of callers who set search_for_commit
>>> also have skip_locking set.
>>>
>>> Signed-off-by: Liu Bo <bo.liu@linux.alibaba.com>
>>
>> Reviewed-by: Qu Wenruo <wqu@suse.com>
>>
>> Although more obvious comment about search_commit_root and skip_locking
>> in ctree.h will be much better.
> 
> Not only a comment but also an ASSERT, this is too easy to get wrong.
> That all currenct callers do search_commit_root + skip_locking will not
> catch any future callers. And there was an example reported.

How about my initial suggestion of setting skip)_locking in
btrfs_search_slot if we see commit_root set? Let's try and make the life
of callers as easier as possible.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
