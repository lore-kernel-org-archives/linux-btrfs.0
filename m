Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:44698 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756278Ab3IDMLV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 4 Sep 2013 08:11:21 -0400
Message-ID: <52272365.8070909@hurleysoftware.com>
Date: Wed, 04 Sep 2013 08:11:17 -0400
From: Peter Hurley <peter@hurleysoftware.com>
MIME-Version: 1.0
To: Josef Bacik <jbacik@fusionio.com>
CC: Michel Lespinasse <walken@google.com>, linux-btrfs@vger.kernel.org,
        mingo@elte.hu, akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rwsem: add rwsem_is_contended
References: <1377872041-390-1-git-send-email-jbacik@fusionio.com> <CANN689Gz-g=_0ErGkB1WZhJUxg+op2=DAPr3GMYwiXFeT9NmGw@mail.gmail.com> <20130903154710.GB15634@localhost.localdomain>
In-Reply-To: <20130903154710.GB15634@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09/03/2013 11:47 AM, Josef Bacik wrote:
> On Sun, Sep 01, 2013 at 01:32:36AM -0700, Michel Lespinasse wrote:
>> Hi Josef,
>>
>> On Fri, Aug 30, 2013 at 7:14 AM, Josef Bacik <jbacik@fusionio.com> wrote:
>>> Btrfs uses an rwsem to control access to its extent tree.  Threads will hold a
>>> read lock on this rwsem while they scan the extent tree, and if need_resched()
>>> they will drop the lock and schedule.  The transaction commit needs to take a
>>> write lock for this rwsem for a very short period to switch out the commit
>>> roots.  If there are a lot of threads doing this caching operation we can starve
>>> out the committers which slows everybody out.  To address this we want to add
>>> this functionality to see if our rwsem has anybody waiting to take a write lock
>>> so we can drop it and schedule for a bit to allow the commit to continue.
>>> Thanks,
>>>
>>> Signed-off-by: Josef Bacik <jbacik@fusionio.com>
>>
>> FYI, I once tried to introduce something like this before, but my use
>> case was pretty weak so it was not accepted at the time. I don't think
>> there were any objections to the API itself though, and I think it's
>> potentially a good idea if you use case justifies it.
>>
>> Two comments:
>>
>> - Note that there are two rwsem implementations - if you are going to
>> add functionality to rwsem.h you want to add the same functionality in
>> rwsem-spinlock.h as well.
>>
>
> Sure thing.
>
>> - I would prefer if you could avoid taking the wait_lock in your
>> rwsem.h implementation. In your use case (read lock is known to be
>> held), checking for sem->count < 0 would be sufficient to indicate a
>> writer is queued (or getting onto the queue). In the general case,
>> some architectures have the various values set up so that
>> RWSEM_WAITING_BIAS != RWSEM_ACTIVE_WRITE_BIAS - for these
>> architectures at least, you can check for waiters by looking if the
>> lowest bit of RWSEM_WAITING_BIAS is set in sem->count.
>
> Question about this one, I can't just do
>
> if (sem->count < 0)
>
> since each arch has their own atomic way of looking at count, so I'd have to add
> something to do just a normal read of count for each arch and call that wouldn't
> I?

Reading sem->count is atomic.

For that matter, in your particular use case (which is more heuristic), you
could perform the list_empty() check without acquiring the wait_lock.

Regards,
Peter Hurley



