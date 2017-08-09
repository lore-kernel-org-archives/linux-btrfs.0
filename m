Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f41.google.com ([74.125.82.41]:37870 "EHLO
        mail-wm0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752383AbdHIWaL (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 9 Aug 2017 18:30:11 -0400
Received: by mail-wm0-f41.google.com with SMTP id i66so7855878wmg.0
        for <linux-btrfs@vger.kernel.org>; Wed, 09 Aug 2017 15:30:09 -0700 (PDT)
Received: from mail-wr0-f173.google.com (mail-wr0-f173.google.com. [209.85.128.173])
        by smtp.gmail.com with ESMTPSA id a11sm2274082edb.8.2017.08.09.15.30.08
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 09 Aug 2017 15:30:08 -0700 (PDT)
Received: by mail-wr0-f173.google.com with SMTP id c24so23138087wra.1
        for <linux-btrfs@vger.kernel.org>; Wed, 09 Aug 2017 15:30:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <0bea5669-f6de-b14b-4e40-15f144a60976@suse.com>
References: <CAJM9R-JxTptrU6GZzrMwvugpOqsmhu09Q8RAcA+TviOaK1RY4Q@mail.gmail.com>
 <c9fbfedd-1a3b-b6f4-8773-1a7e5f79f18a@suse.com> <1d36851e-6a1c-1c32-ee00-96f43ead55d2@suse.com>
 <CAJM9R-+=ww-7Zz9rgsGuCmiPZFZ+U8zhLHA4bEuzNederH49OQ@mail.gmail.com> <0bea5669-f6de-b14b-4e40-15f144a60976@suse.com>
From: Angel Shtilianov <kernel@kyup.com>
Date: Thu, 10 Aug 2017 01:30:07 +0300
Message-ID: <CAJM9R-JCUkVXg+BAY4ri_w8f39xS0QqMYHv2j6ck_3tpH+3Mxw@mail.gmail.com>
Subject: Re: Btrfs umount hang
To: Jeff Mahoney <jeffm@suse.com>
Cc: Angel Shtilianov <kernel@kyup.com>, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Jeff,
That's exactly what I am observing in the backtraces.
umount reaches cache_block_group passing through btrfs_search_slot,
which looks like got the wr_lock (to be confirmed tomorrow when I'm in
the office) and all other btrfs worker threads are fighting for the
btrfs_tree_read_lock.
Umount is hanging on the cache_block_group wait, all others are
hanging on the read_lock. So caching seems to be the bottleneck,
blocking all others. Good catch! I'll take a look at the commit
tomorrow morning (with large cup of coffee of course).

By the way, looking through the logs I can see one more pattern -
umount after drop snapshot reaches similar state. The common is that
drop snapshot will also call search slot, get the readlock, drop it
and get the write lock. In the same time there is umount causing
fs_sync going concurently. I've seen at least three such hangs today
and I've started the corresponding crashdumps to get copied to my
machine. Tomorrow I'll take a look at them. It seems the common is
that umount again reaches to the same place - cache_block_group and
hangs. Tomorrow I'll take a look at the crash dump for the workers
state.

Thank you,
Angel

On Wed, Aug 9, 2017 at 6:42 PM, Jeff Mahoney <jeffm@suse.com> wrote:
> On 8/8/17 7:30 AM, Angel Shtilianov wrote:
>> crash> bt -f 31625
>> PID: 31625  TASK: ffff88046a833400  CPU: 7   COMMAND: "btrfs-transacti"
>> wants to acquire struct extent_buffer ffff88000460aca0 lock, whose
>> lock_owner is 27574.
>>
>> here is pid 27574:
>> PID: 27574  TASK: ffff88038b469a00  CPU: 4   COMMAND: "kworker/u32:9"
>> which is also is trying to acquire eb lock ffff8802598b6200, and here
>> the owner is 31696.
>>
>> 31696 is
>> PID: 31696  TASK: ffff88044b59ce00  CPU: 5   COMMAND: "umount"
>>
>> So definitely here is a kind of deadlock.
>> umount holds the lock needed by the workers to complete and waits them
>> to complete.
>> Lockdep wouldn't complain about that.
>> I am still about to investigate what has previously triggered/disabled lockdep.
>> I have to obtain the log from the machine, but I need some time to get it.
>>
>> Jeff, you were right.
>> Could you help demystifying how we ended up here?
>
> Hi Angel -
>
> It looks like a regression introduced by 291c7d2f5, but that's a very
> old commit.  As that commit says, it's a rare occurence to hit that
> wait, and that's probably why we haven't seen this issue sooner.
>
> There's potential for this to happen whenever two threads are modifying
> the tree at once and one needs to find a free extent.  I'll need to
> think a bit on how to fix it.
>
> -Jeff
>
>> Best regards,
>> Angel
>>
>> On Mon, Aug 7, 2017 at 9:10 PM, Jeff Mahoney <jeffm@suse.com> wrote:
>>> On 8/7/17 1:19 PM, Jeff Mahoney wrote:
>>>> On 8/7/17 10:12 AM, Angel Shtilianov wrote:
>>>>> Hi there,
>>>>> I'm investigating sporadic hanging during btrfs umount. The FS is
>>>>> contained in a loop mounted file.
>>>>> I have no reproduction scenario and the issue may happen once a day or
>>>>> once a month. It is rare, but frustrating.
>>>>> I have a crashdump (the server has been manually crashed and collected
>>>>> a crashdump), so I could take look through the data structures.
>>>>> What happens is that umount is getting in D state and a the kernel
>>>>> complains about hung tasks. We are using kernel 4.4.y The actual back
>>>>> trace is from 4.4.70, but this happens with all the 4.4 kernels I've
>>>>> used (4.4.30 through 4.4.70).
>>>>> Tasks like:
>>>>> INFO: task kworker/u32:9:27574 blocked for more than 120 seconds.
>>>>> INFO: task kworker/u32:12:27575 blocked for more than 120 seconds.
>>>>> INFO: task btrfs-transacti:31625 blocked for more than 120 seconds.
>>>>> are getting blocked waiting for btrfs_tree_read_lock, which is owned
>>>>> by task umount:31696 (which is also blocked for more than 120 seconds)
>>>>> regarding the lock debug.
>>>>>
>>>>> umount is hung in "cache_block_group", see the '>' mark:
>>>>>        while (cache->cached == BTRFS_CACHE_FAST) {
>>>>>                 struct btrfs_caching_control *ctl;
>>>>>
>>>>>                 ctl = cache->caching_ctl;
>>>>>                 atomic_inc(&ctl->count);
>>>>>                 prepare_to_wait(&ctl->wait, &wait, TASK_UNINTERRUPTIBLE);
>>>>>                 spin_unlock(&cache->lock);
>>>>>
>>>>>>                schedule();
>>>>>
>>>>>                 finish_wait(&ctl->wait, &wait);
>>>>>                 put_caching_control(ctl);
>>>>>                 spin_lock(&cache->lock);
>>>>>         }
>>>>>
>>>>> The complete backtraces could be found in the attached log.
>>>>>
>>>>> Do you have any ideas ?
>>>>
>>>> Hi Angel -
>>>>
>>>> In your log, it says lockdep is disabled.  What tripped it earlier?
>>>> Lockdep really should be catching locking deadlocks in situations like
>>>> this, if that's really the underlying cause.
>>>
>>> Actually, I'm not sure if lockdep would catch this one.  Here's my
>>> hypothesis:
>>>
>>> kworker/u32:9 is waiting on a read lock while reading the free space
>>> cache, which means it owns the cache->cached value and will issue the
>>> wakeup when it completes.
>>>
>>> umount is waiting on for the wakeup from kworker/u32:9 but is holding
>>> some tree locks in write mode.
>>>
>>> If kworker/u32:9 is waiting on the locks that umount holds, we have a
>>> deadlock.
>>>
>>> Can you dump the extent buffer that kworker/u32:9 is waiting on?  Part
>>> of that will contain the PID of the holder, and if matches umount, we
>>> found the cause.
>>>
>>> -Jeff
>>>
>>> --
>>> Jeff Mahoney
>>> SUSE Labs
>>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
>
> --
> Jeff Mahoney
> SUSE Labs
>
