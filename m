Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailout63.mail01.mtsvc.net ([216.70.64.127]:33929 "EHLO
	mailout63.mail01.mtsvc.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758880Ab3IBSku (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 2 Sep 2013 14:40:50 -0400
Received: from mailout39.mail01.mtsvc.net ([216.70.64.83] helo=n12.mail01.mtsvc.net)
	by mailout63.mail01.mtsvc.net with esmtps (TLSv1:AES256-SHA:256)
	(Exim 4.72)
	(envelope-from <peter@hurleysoftware.com>)
	id 1VGXm3-0001p5-AV
	for linux-btrfs@vger.kernel.org; Mon, 02 Sep 2013 13:18:47 -0400
Message-ID: <5224C850.2060103@hurleysoftware.com>
Date: Mon, 02 Sep 2013 13:18:08 -0400
From: Peter Hurley <peter@hurleysoftware.com>
MIME-Version: 1.0
To: Michel Lespinasse <walken@google.com>
CC: Josef Bacik <jbacik@fusionio.com>, linux-btrfs@vger.kernel.org,
        mingo@elte.hu, akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rwsem: add rwsem_is_contended
References: <1377872041-390-1-git-send-email-jbacik@fusionio.com> <CANN689Gz-g=_0ErGkB1WZhJUxg+op2=DAPr3GMYwiXFeT9NmGw@mail.gmail.com>
In-Reply-To: <CANN689Gz-g=_0ErGkB1WZhJUxg+op2=DAPr3GMYwiXFeT9NmGw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09/01/2013 04:32 AM, Michel Lespinasse wrote:
> Hi Josef,
>
> On Fri, Aug 30, 2013 at 7:14 AM, Josef Bacik <jbacik@fusionio.com> wrote:
>> Btrfs uses an rwsem to control access to its extent tree.  Threads will hold a
>> read lock on this rwsem while they scan the extent tree, and if need_resched()
>> they will drop the lock and schedule.  The transaction commit needs to take a
>> write lock for this rwsem for a very short period to switch out the commit
>> roots.  If there are a lot of threads doing this caching operation we can starve
>> out the committers which slows everybody out.  To address this we want to add
>> this functionality to see if our rwsem has anybody waiting to take a write lock
>> so we can drop it and schedule for a bit to allow the commit to continue.
>> Thanks,
>>
>> Signed-off-by: Josef Bacik <jbacik@fusionio.com>
>
> FYI, I once tried to introduce something like this before, but my use
> case was pretty weak so it was not accepted at the time. I don't think
> there were any objections to the API itself though, and I think it's
> potentially a good idea if you use case justifies it.

Exactly, I'm concerned about the use case: readers can't starve writers.
Of course, lots of existing readers can temporarily prevent a writer from
acquiring, but those readers would already have the lock. Any new readers
wouldn't be able to prevent a waiting writer from obtaining the lock.

Josef,
Could you be more explicit, maybe with some detailed numbers about the
condition you report?

I say that because a subtle bug that could mistakenly wait a reader
existed in the rwsem implementation until relatively recently. Is there
some other lurking problem?

> Two comments:
>
> - Note that there are two rwsem implementations - if you are going to
> add functionality to rwsem.h you want to add the same functionality in
> rwsem-spinlock.h as well.
>
> - I would prefer if you could avoid taking the wait_lock in your
> rwsem.h implementation. In your use case (read lock is known to be
> held), checking for sem->count < 0 would be sufficient to indicate a
> writer is queued (or getting onto the queue). In the general case,
> some architectures have the various values set up so that
> RWSEM_WAITING_BIAS != RWSEM_ACTIVE_WRITE_BIAS - for these
> architectures at least, you can check for waiters by looking if the
> lowest bit of RWSEM_WAITING_BIAS is set in sem->count.

Michel,

I'm glad you point out a much better approach --- but why are we
considering open-coding down_read_trylock()/down_write_trylock?

Regards,
Peter Hurley

