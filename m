From: Arne Jansen <sensille@gmx.net>
Subject: Re: [PATCH v3 3/6] btrfs: add scrub code and prototypes
Date: Thu, 17 Mar 2011 00:10:57 +0100
Message-ID: <4D814381.9070105@gmx.net>
References: <cover.1299941055.git.sensille@gmx.net>	<7ccafb5250b72ca706369a8d5b45f06e8d5a4f8a.1299941055.git.sensille@gmx.net> <m2mxkulnx3.fsf@firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: linux-btrfs@vger.kernel.org
To: Andi Kleen <andi@firstfloor.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <m2mxkulnx3.fsf@firstfloor.org>
List-ID: <linux-btrfs.vger.kernel.org>

On 16.03.2011 23:07, Andi Kleen wrote:
> Arne Jansen<sensille@gmx.net>  writes:
>> +	 */
>> +	mutex_lock(&fs_info->scrub_lock);
>> +	atomic_inc(&fs_info->scrubs_running);
>> +	mutex_unlock(&fs_info->scrub_lock);
> It seems odd to protect an atomic_inc with a mutex.
> Is that done for some side effect? Otherwise you either
> don't need atomic or don't need the lock.
>
The reason it is atomic is because it is checked inside a wait_event,
where I can't hold a lock. The mutex is there to protect the check
in btrfs_scrub_pause and btrfs_scrub_cancel. But, now that I think
of it, there is still a race condition left. I'll rethink the locking there
and see if I can eliminate some of the mutex_locks.
> That seems to be all over the source file.
>
>> +int btrfs_scrub_pause(struct btrfs_root *root)
>> +{
>> +	struct btrfs_fs_info *fs_info = root->fs_info;
>> +	mutex_lock(&fs_info->scrub_lock);
>
> As I understand it you take that mutex on every transaction
> commit, which is a fast path for normal IO.
>
A transaction commit only happens every 30 seconds. At this point,
all outstanding data gets flushed and the super blocks written. I only
pause the scrub in a very late phase during commit. At this point,
the commit is already single threaded.

Apart from that you can be sure that scrub will have an impact on the
performance, as it keeps the disks at 100% busy.
To mitigate this, all scrub activity happens inside ioctls. The idea is that
this way the user can control the impact of the scrub using ionice.

--Arne

> For me that looks like a scalability problem with enough
> cores. Did you do any performance testing of this on a system
> with a reasonable number of cores?
>
> btrfs already has enough scalability problems, please don't
> add new ones.
>
> -Andi
>

