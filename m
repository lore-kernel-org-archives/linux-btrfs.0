Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:58757 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762453Ab3IDLrC (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 4 Sep 2013 07:47:02 -0400
Message-ID: <52271DB0.8030305@hurleysoftware.com>
Date: Wed, 04 Sep 2013 07:46:56 -0400
From: Peter Hurley <peter@hurleysoftware.com>
MIME-Version: 1.0
To: Josef Bacik <jbacik@fusionio.com>
CC: Michel Lespinasse <walken@google.com>, linux-btrfs@vger.kernel.org,
        mingo@elte.hu, akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rwsem: add rwsem_is_contended
References: <1377872041-390-1-git-send-email-jbacik@fusionio.com> <CANN689Gz-g=_0ErGkB1WZhJUxg+op2=DAPr3GMYwiXFeT9NmGw@mail.gmail.com> <5224C850.2060103@hurleysoftware.com> <20130903131805.GA15634@localhost.localdomain>
In-Reply-To: <20130903131805.GA15634@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09/03/2013 09:18 AM, Josef Bacik wrote:
> On Mon, Sep 02, 2013 at 01:18:08PM -0400, Peter Hurley wrote:
>> On 09/01/2013 04:32 AM, Michel Lespinasse wrote:
>>> Hi Josef,
>>>
>>> On Fri, Aug 30, 2013 at 7:14 AM, Josef Bacik <jbacik@fusionio.com> wrote:
>>>> Btrfs uses an rwsem to control access to its extent tree.  Threads will hold a
>>>> read lock on this rwsem while they scan the extent tree, and if need_resched()
>>>> they will drop the lock and schedule.  The transaction commit needs to take a
>>>> write lock for this rwsem for a very short period to switch out the commit
>>>> roots.  If there are a lot of threads doing this caching operation we can starve
>>>> out the committers which slows everybody out.  To address this we want to add
>>>> this functionality to see if our rwsem has anybody waiting to take a write lock
>>>> so we can drop it and schedule for a bit to allow the commit to continue.
>>>> Thanks,
>>>>
>>>> Signed-off-by: Josef Bacik <jbacik@fusionio.com>
>>>
>>> FYI, I once tried to introduce something like this before, but my use
>>> case was pretty weak so it was not accepted at the time. I don't think
>>> there were any objections to the API itself though, and I think it's
>>> potentially a good idea if you use case justifies it.
>>
>> Exactly, I'm concerned about the use case: readers can't starve writers.
>> Of course, lots of existing readers can temporarily prevent a writer from
>> acquiring, but those readers would already have the lock. Any new readers
>> wouldn't be able to prevent a waiting writer from obtaining the lock.
>>
>> Josef,
>> Could you be more explicit, maybe with some detailed numbers about the
>> condition you report?
>>
>
> Sure, this came from a community member
>
> http://article.gmane.org/gmane.comp.file-systems.btrfs/28081
>
> With the old approach we could block between 1-2 seconds waiting for this rwsem,
> and with the new approach where we allow many more of these caching threads we
> were staving out the writer for 80 seconds.
>
> So what happens is these threads will scan our extent tree to put together the
> free space cache, and they'll hold this lock while they are doing the scanning.
> The only way they will drop this lock is if we hit need_resched(), but because
> these threads are going to do quite a bit of IO I imagine we're not ever being
> flagged with need_resched() because we schedule while waiting for IO.  So these
> threads will hold onto this lock for bloody ever without giving it up so the
> committer can take the write lock.  His patch to "fix" the problem was to have
> an atomic that let us know somebody was waiting for a write lock and then we'd
> drop the reader lock and schedule.

Thanks for the additional clarification.

> So really we're just using a rwsem in a really mean way for writers.  I'm open
> to other suggestions but I think this probably the cleanest way.

Is there substantial saved state at the point where the caching thread is
checking need_resched() that precludes dropping and reacquiring the
extent_commit_sem (or before find_next_key())?  Not that it's a cleaner
solution; just want to understand better the situation.

Regards,
Peter Hurley
