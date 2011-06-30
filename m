From: Arne Jansen <sensille@gmx.net>
Subject: Re: [PATCH v4 4/7] btrfs: initial readahead code and prototypes
Date: Thu, 30 Jun 2011 16:01:23 +0200
Message-ID: <4E0C81B3.8030709@gmx.net>
References: <cover.1309375866.git.sensille@gmx.net> <1b900522e83d47aab3d44703804482f839d7543a.1309375866.git.sensille@gmx.net> <4E0B9E04.4010409@redhat.com> <4E0C27A0.7040002@gmx.net> <4E0C70C3.1000307@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E0C70C3.1000307@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 30.06.2011 14:49, Josef Bacik wrote:
> On 06/30/2011 03:37 AM, Arne Jansen wrote:
>> On 29.06.2011 23:49, Josef Bacik wrote:
>>> On 06/29/2011 04:10 PM, Arne Jansen wrote:
> 
>>
>>>
>>>> +    struct kref        refcnt;
>>>> +    wait_queue_head_t    wait;
>>>> +};
>>>> +
>>>> +struct reada_extctl {
>>>> +    struct list_head    list;
>>>> +    struct reada_control    *rc;
>>>> +    u64            generation;
>>>> +};
>>>> +
>>>
>>> This is completely useless, kill this struct and just put the generation
>>> and the list into reada_control.
>>
>> This struct is the link between reada_extent and reada_control.
>> In case more than one readahead is running, each reada_extent
>> can point to multiple reada_controls, so I need this link struct.
>>
> 
> And this is where I get confused.  Why would we need multiple
> reada_control's for the same extent?  Can't we just say "Oh hey there's
> already a reada control outstanding for this extent, take a ref on the
> control and wait for that"?

Each readahead request allocates a single reada_control, which basically
records the range and the tree to preload.
For each reqested extent a reada_extent is allocated, but only one, even
if there are more than one readaheads waiting for it. When the extent
arrives, we have to check the extent (e.g. an intermediate node) against
all waiting reada_controls to see which links we have to follow and
which not. For this, we have to attach links to each reada_control to
the extent. As the list differs from extent to extent, I build each
list with the help of these stub structs.

> 
> 

[snip]

>>>> +
>>>> +static void __reada_start_machine(struct btrfs_fs_info *fs_info)
>>>> +{
>>>> +    struct btrfs_device *device;
>>>> +    struct btrfs_fs_devices *fs_devices = fs_info->fs_devices;
>>>> +    u64 enqueued;
>>>> +    u64 total = 0;
>>>> +    int i;
>>>> +
>>>> +    do {
>>>> +        enqueued = 0;
>>>> +        list_for_each_entry(device,&fs_devices->devices, dev_list) {
>>>> +            if (atomic_read(&device->reada_in_flight)<
>>>> +                MAX_IN_FLIGHT)
>>>> +                enqueued += reada_start_machine_dev(fs_info,
>>>> +                                    device);
>>>> +        }
>>>> +        total += enqueued;
>>>> +    } while (enqueued&&  total<  10000);
>>>> +
>>>
>>> What is this?  Are we doing this so that the worker stays alive so it
>>> can continue to process new requests coming in?  If thats the case we
>>> need to have a proper kthread that doesn't exit until we unmount or
>>> something, not this weirdness.
>>
>> Hopefully the comment below explains what the intention is. Maybe I
>> should move it up to answer the question before it arises :) A kthread
>> is not enough, as I want parallelism here.
>>
>> I'll kill the FIXME as it is done already.
>>
> 
> Yeah the comment wasn't and still isn't clear to me.  You are using the
> workers here, which means we already have a thread per cpu running here,
> so we don't need to do things to artificially keep one of them running,
> we just give it work to do and the worker threads will dispatch a thread
> to do the work, we have built in parallelism, so this is just confusing
> and unnecessary.

We only have builtin parallelism in case we actually read from disk. In
case everything is already in RAM, the loop is broken in smaller parts,
and 2 new workers are kicked off every 10000.
In the case where most of the tree has to be read from disk, this case
will never be hit.

> 
>>>
>>>> +    if (enqueued == 0)
>>>> +        return;
>>>> +
>>>> +    /*
>>>> +     * If everything is already in the cache, this is effectively
>>>> single
>>>> +     * threaded. To a) not hold the caller for too long and b) to
>>>> utilize
>>>> +     * more cores, we broke the loop above after 10000 iterations
>>>> and now
>>>> +     * enqueue to workers to finish it. This will distribute the
>>>> load to
>>>> +     * the cores.
>>>> +     * FIXME we might need our own workqueue here, with an idle
>>>> threshold
>>>> +     * of one. Also these worker are relatively long-running.
>>>> +     */
>>>> +    for (i = 0; i<  2; ++i)
>>>> +        reada_start_machine(fs_info);
>>>> +}
>>>> +
>>>> +static void reada_start_machine(struct btrfs_fs_info *fs_info)
>>>> +{
>>>> +    struct reada_machine_work *rmw;
>>>> +
>>>> +    rmw = kzalloc(sizeof(*rmw), GFP_NOFS);
>>>> +    if (!rmw) {
>>>> +        /* FIXME we cannot handle this properly right now */
>>>> +        BUG();
>>>
>>> Yes you can, everywhere that calls this can handle failures, so make
>>> this return an int and have it return -ENOMEM if it fails.
>>
>> Just passing up the error isn't enough. We also need to signal the error
>> to all waiters and clean up all data structures. Maybe it's easier to
>> just keep a small cache of these struct, maybe #CPUs, so we can never
>> fail here.
> 
> Well this is just used to add the current readahead work right?  We can
> fail here with no problems, it just means the person wanting to add the
> readahead work failed, there is no reason to stop any of the other
> workers who may already have work going on.  Thanks,

No, this is to trigger more of the enqueued requests. If we don't
trigger them, they will hang forever, and with them the requester of
the readahead. This code is already called in worker context.
The only real problem arises when the this is the last running worker
and no I/O requests are outstanding. In this case ignoring the failure
would just keep the machine hanging forever. So in theory we would only
need to keep one spare struct to keep things running.

-Arne

> 
> Josef
