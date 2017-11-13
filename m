Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-db5eur01on0060.outbound.protection.outlook.com ([104.47.2.60]:16787
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751095AbdKMBSF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 12 Nov 2017 20:18:05 -0500
Subject: Re: Theoretical Question about commit=n
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, Robert White <rwhite@pobox.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <b845c5b3-1241-723d-c7a9-ddfe4a550d8d@pobox.com>
 <dacaa3b1-d6c1-44d3-4fef-28db73af3e90@mendix.com>
 <c768fcf7-f206-2667-ce0e-b7f5deaff1e4@gmx.com>
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Message-ID: <98b94ef2-4744-7481-8866-cd0f2b8a9d68@mendix.com>
Date: Mon, 13 Nov 2017 02:17:57 +0100
MIME-Version: 1.0
In-Reply-To: <c768fcf7-f206-2667-ce0e-b7f5deaff1e4@gmx.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 11/13/2017 01:41 AM, Qu Wenruo wrote:
> 
> On 2017年11月13日 06:01, Hans van Kranenburg wrote:
>> On 11/12/2017 09:58 PM, Robert White wrote:
>>> Is the commit interval monotonic, or is it seconds after sync?
>>>
>>> What I mean is that if I manually call sync(2) does the commit timer
>>> reset? I'm thinking it does not, but I can imagine a workload where it
>>> ideally would.
>>
>> The magic happens inside the transaction kernel thread:
>>
>> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/fs/btrfs/disk-io.c?h=v4.14#n1925
>>
>> You can see the delay being computed:
>>     delay = HZ * fs_info->commit_interval;
>>
>> Almost at the end of the function, you see:
>>     schedule_timeout(delay)
>>
>> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/kernel/time/timer.c?h=v4.14#n1676
>>
>> This schedule_timeout function sets a timer and then the thread goes to
>> sleep. If nothing happens, the kernel will wake up the thread after the
>> timer expires (can be later, but not earlier) and then it will redo the
>> loop.
>>
>> If something else wakes up the transaction thread, the timer is
>> discarded if it's not expired yet.
> 
> So far so good.
> 
>>
>> So it works like you would want.
> 
> Not exactly.

Ah, interesting.

> Sync or commit_transaction won't wake up transaction_kthread.
> 
> transaction_kthread will mostly be woken by trans error, remount or
> under certain case of btrfs_end_transaction.
> 
> So manually sync will not (at least not always) interrupt commit interval.

The fun thing is, when I just do sync, I see that the time it takes for
a next generation bump to happen is reset (while doing something simple
like touch x in a loop in another terminal).

> And even more, transaction_kthread will only commit transaction, which
> means it will only ensure metadata consistent.
> 
> It won't ensure buffered write to reach disk if its extent is not
> allocated yet (delalloc).

Hm, I have seen things like that in BTRFS_IOC_SYNC...

Actually, I first responded on the timer reset question, because that
one was easy to answer. I don't know if I want to descend the path
further into (f)sync. I heard it can get really messy down there. :]

> 
> Thanks,
> Qu
>>
>> You can test this yourself by looking at the "generation" number of your
>> filesystem. It's in the output of btrfs inspect dump-super:
>>
>> This is the little test filesystem I just used:
>>
>> -# btrfs inspect dump-super /dev/dorothy/mekker | grep ^generation
>> generation		35
>>
>> If you print the number in a loop, like every second, you can see it
>> going up after a transaction happened. Now play around with other things
>> and see when it changes.
>>
>>> (Again, this is purely theoretical, I have no such workload as I am
>>> about to describe.)
>>>
>>> So suppose I have some sort of system, like a database, that I know will
>>> do scattered writes and extends through some files and then call some
>>> variant of sync(2). And I know that those sync() calls will be every
>>> forty-to-sixty seconds because of reasons. It would be "neat" to be able
>>> to set the commit=n to some high value, like 90, and then "normally" the
>>> sync() behaviours would follow the application instead of the larger
>>> commit interval.
>>>
>>> The value would be that the file system would tend _not_ to go into sync
>>> while the application was still skittering about in the various files.
>>>
>>> Of course any other applications could call sync from their own contexts
>>> for their own reasons. And there's an implicit fsync() on just about any
>>> close() (at least if everything is doing its business "correctly")
>>>
>>> It may be a strange idea but I can think of some near realtime
>>> applications might be able to leverage a modicum of control over the
>>> sync event. There is no API, and not strong reason to desire one, for
>>> controlling the commit via (low privelege) applications.
>>>
>>> But if the plumbing exists, then having a mode where sync() or fsync()
>>> (which I think causes a general sync because of the journal) resets the
>>> commit timer could be really interesting.
>>>
>>> With any kind of delayed block choice/mapping it could actually reduce
>>> the entropy of the individual files for repeated random small writes.
>>> The application would have to be reasonably aware, of course.
>>>
>>> Since something is causing a sync() the commit=N guarantee is still
>>> being met for the whole system for any N, but applications could tend to
>>> avoid mid-write commits by planing their sync()s.
>>>
>>> Just a thought.
>>
>>


-- 
Hans van Kranenburg
