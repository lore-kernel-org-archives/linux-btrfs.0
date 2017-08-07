Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51258 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751398AbdHGPas (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 7 Aug 2017 11:30:48 -0400
Subject: Re: Btrfs umount hang
To: Angel Shtilianov <kernel@kyup.com>, linux-btrfs@vger.kernel.org
References: <CAJM9R-JxTptrU6GZzrMwvugpOqsmhu09Q8RAcA+TviOaK1RY4Q@mail.gmail.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <e2651f60-e113-327b-115c-b29f5adecfee@suse.com>
Date: Mon, 7 Aug 2017 18:30:46 +0300
MIME-Version: 1.0
In-Reply-To: <CAJM9R-JxTptrU6GZzrMwvugpOqsmhu09Q8RAcA+TviOaK1RY4Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On  7.08.2017 17:12, Angel Shtilianov wrote:
> Hi there,
> I'm investigating sporadic hanging during btrfs umount. The FS is
> contained in a loop mounted file.
> I have no reproduction scenario and the issue may happen once a day or
> once a month. It is rare, but frustrating.
> I have a crashdump (the server has been manually crashed and collected
> a crashdump), so I could take look through the data structures.
> What happens is that umount is getting in D state and a the kernel
> complains about hung tasks. We are using kernel 4.4.y The actual back
> trace is from 4.4.70, but this happens with all the 4.4 kernels I've
> used (4.4.30 through 4.4.70).
> Tasks like:
> INFO: task kworker/u32:9:27574 blocked for more than 120 seconds.
> INFO: task kworker/u32:12:27575 blocked for more than 120 seconds.
> INFO: task btrfs-transacti:31625 blocked for more than 120 seconds.
> are getting blocked waiting for btrfs_tree_read_lock, which is owned
> by task umount:31696 (which is also blocked for more than 120 seconds)
> regarding the lock debug.
> 
> umount is hung in "cache_block_group", see the '>' mark:
>        while (cache->cached == BTRFS_CACHE_FAST) {
>                 struct btrfs_caching_control *ctl;
> 
>                 ctl = cache->caching_ctl;
>                 atomic_inc(&ctl->count);
>                 prepare_to_wait(&ctl->wait, &wait, TASK_UNINTERRUPTIBLE);
>                 spin_unlock(&cache->lock);
> 
>>                schedule();
> 
>                 finish_wait(&ctl->wait, &wait);
>                 put_caching_control(ctl);
>                 spin_lock(&cache->lock);
>         }
> 
> The complete backtraces could be found in the attached log.
> 
> Do you have any ideas ?
> Any help will be greatly appreciated.

So by the looks of it while writing dirty bgs and requiring a free block
for the CoW process, cache_block_group() kicks off a caching thread
which should just go and read in the respective block group. So the
newly spawned caching_thread should actually wake up cache_block_group
either due to success, if it manages to find 2megs:
if (total_found > (1024 * 1024 * 2)) {

or in case of failure after the out label. But in both cases it will set
cache->cached to something different than BTRFS_CACHE_FAST and it ought
to exit the loop.


But from your description of the issue I take it the process never comes
back from the schedule, meaning it missed the wakeup from caching_thread
and atm I cannot see how this could happen. Can you print the state of
the 'cache' parameter of cache_block_group ?
> 
> Best regards,
> Angel Shtilianov
> 
