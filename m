Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54945 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753595AbeDPT6M (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 16 Apr 2018 15:58:12 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id D6FD8AE85
        for <linux-btrfs@vger.kernel.org>; Mon, 16 Apr 2018 19:58:10 +0000 (UTC)
Subject: Re: [PATCH 4/4] btrfs: Rewrite retry logic in do_chunk_alloc
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
References: <1523434880-7799-1-git-send-email-nborisov@suse.com>
 <1523434880-7799-5-git-send-email-nborisov@suse.com>
 <20180416185321.GW21272@twin.jikos.cz>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <bc3249bb-dc9a-beef-4085-f02368a39d54@suse.com>
Date: Mon, 16 Apr 2018 22:58:09 +0300
MIME-Version: 1.0
In-Reply-To: <20180416185321.GW21272@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 16.04.2018 21:53, David Sterba wrote:
> On Wed, Apr 11, 2018 at 11:21:20AM +0300, Nikolay Borisov wrote:
>> do_chunk_alloc implements logic to detect whether there is currently
>> pending chunk allocation  (by means of space_info->chunk_alloc being
>> set) and if so it loops around to the 'again' label. Additionally,
>> based on the state of the space_info (e.g. whether it's full or not)
>> and the return value of should_alloc_chunk() it decides whether this
>> is a "hard" error (ENOSPC) or we can just return 0.
>>
>> This patch refactors all of this:
>>
>> 1. Put order to the scattered ifs handling the various cases in an
>> easy-to-read if {} else if{} branches. This makes clear the various
>> cases we are interested in handling.
>>
>> 2. Call should_alloc_chunk only once and use the result in the
>> if/else if constructs. All of this is done under space_info->lock, so
>> even before multiple calls of should_alloc_chunk were unnecessary.
>>
>> 3. Rewrite the "do {} while()" loop currently implemented via label
>> into an explicit loop construct.
>>
>> 4. Move the mutex locking outside of the while loop and remove the
>> comment. The comment in fact was misleading since in the old code if the
>> mutex is acquired and we don't need to loop again (wait_for_alloc) is
>> 0 then we don't recheck if we need to allocate (the comment was stating
>> the opposite).
> 
> The comment seems correct to me. It is referring to the actual
> allocation that happens in paralell (a few lines below calling
> btrfs_alloc_chunk). So the first part attempts to determine if we should
> wait, and if yes, then take the mutex and block until the other
> allocation finishes.
> 
> This is completely mising in the new code so the loop is only blocking
> on the space info spinlock, but not going to sleep. Busy looping.

With your explanation the code now makes a bit more sense and indeed
I've missed that. Will send an updated patch.

> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
