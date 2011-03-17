From: Arne Jansen <sensille@gmx.net>
Subject: Re: [PATCH v3 3/6] btrfs: add scrub code and prototypes
Date: Thu, 17 Mar 2011 20:02:21 +0100
Message-ID: <4D825ABD.7090108@gmx.net>
References: <cover.1299941055.git.sensille@gmx.net>	<7ccafb5250b72ca706369a8d5b45f06e8d5a4f8a.1299941055.git.sensille@gmx.net> <m2mxkulnx3.fsf@firstfloor.org> <4D814381.9070105@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: linux-btrfs@vger.kernel.org
To: Andi Kleen <andi@firstfloor.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4D814381.9070105@gmx.net>
List-ID: <linux-btrfs.vger.kernel.org>

On 17.03.2011 00:10, Arne Jansen wrote:
> On 16.03.2011 23:07, Andi Kleen wrote:
>> Arne Jansen<sensille@gmx.net>  writes:
>>> +     */
>>> +    mutex_lock(&fs_info->scrub_lock);
>>> +    atomic_inc(&fs_info->scrubs_running);
>>> +    mutex_unlock(&fs_info->scrub_lock);
>> It seems odd to protect an atomic_inc with a mutex.
>> Is that done for some side effect? Otherwise you either
>> don't need atomic or don't need the lock.
>>
> The reason it is atomic is because it is checked inside a wait_event,
> where I can't hold a lock. The mutex is there to protect the check
> in btrfs_scrub_pause and btrfs_scrub_cancel. But, now that I think
> of it, there is still a race condition left. I'll rethink the locking 
> there
> and see if I can eliminate some of the mutex_locks.
On third look I can't find the race condition I thought was there...
Just removing the locks around most inc/dec looks ok.

Thanks,
Arne
