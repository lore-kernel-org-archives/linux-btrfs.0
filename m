Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45953 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750957AbeEROMm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 18 May 2018 10:12:42 -0400
Subject: Re: [PATCH] Btrfs: fix the corruption by reading stale btree blocks
To: dsterba@suse.cz, Liu Bo <bo.liu@linux.alibaba.com>,
        linux-btrfs@vger.kernel.org
References: <1526405857-88702-1-git-send-email-bo.liu@linux.alibaba.com>
 <880e75c4-10fa-8487-7bed-29c7c8c380fc@suse.com>
 <20180516141221.GA6649@twin.jikos.cz>
 <20180518131515.n23ysksu5x24kchb@US-160370MP2.local>
 <20180518140616.GO6649@twin.jikos.cz>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <54226e5c-bdcc-374a-1cef-cea182ef1fbe@suse.com>
Date: Fri, 18 May 2018 17:12:38 +0300
MIME-Version: 1.0
In-Reply-To: <20180518140616.GO6649@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 18.05.2018 17:06, David Sterba wrote:
> On Fri, May 18, 2018 at 09:15:16PM +0800, Liu Bo wrote:
>>>> Doesn't this warrant a stable tag and
>>>> Fixes: 5bdd3536cbbe ("Btrfs: Fix block generation verification race")
>>>
>>> The patch will not apply to < 4.16 as it depends on the addition of
>>> &first_key check from 581c1760415c4, but yes we need it for stable.
>>
>> True, we can easily fix the conflicts by removing @first_key, can't
>> we?
> 
> Yes the backport is easy but still needs to be done manually and we
> can't and don't expect the stable maintainers to resolve the conflicts
> but rather send a adapter version ourselves. Nikolay promised to do
> that.

Once the patch gets sent to Linus I will backport it for 4.4/4.9 and 4.14

> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
