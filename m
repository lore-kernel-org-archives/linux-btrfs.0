Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:27447 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754314AbbLAAoK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 30 Nov 2015 19:44:10 -0500
Subject: Re: [RFC] Btrfs device and pool management (wip)
To: Austin S Hemmelgarn <ahferroin7@gmail.com>,
        Anand Jain <anand.jain@oracle.com>, <linux-btrfs@vger.kernel.org>
References: <565C01F1.5030108@oracle.com> <565C625C.7060503@gmail.com>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <565CED3E.5080402@cn.fujitsu.com>
Date: Tue, 1 Dec 2015 08:43:42 +0800
MIME-Version: 1.0
In-Reply-To: <565C625C.7060503@gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Austin S Hemmelgarn wrote on 2015/11/30 09:51 -0500:
> On 2015-11-30 02:59, Anand Jain wrote:
>>   Data center systems are generally aligned with the RAS (Reliability,
>> Availability and Serviceability) attributes. When it comes to Storage,
>> RAS applies even more because its matter of trust. In this context, one
>> of the primary area that a typical volume manager should be well tested
>> is, how well RAS attributes are maintained in the context of device
>> failure, and its further reporting.
>>
>>   But, identifying a failed device is not a straight forward code. If
>> you look at some statistics performed on failed and returned disks,
>> most of the disks ends up being classified as NTF (No Trouble Found).
>> That is, host failed-and-replaced a disk even before it has actually
>> failed. This is not good for a cost effective setup who would want to
>> stretch the life of an intermittently failing device to its maximum
>> tenure and would want to replace only when it has confirmed dead.
>>
>>   Also on the other hand, some of the data center admins would like to
>> mitigate the risk (of low performance at peak of their business
>> productions) of a potential failure, and prefer to pro-actively replace
>> the disk at their low business/workload hours, or they may choose to
>> replace a device even for read errors (mainly due to performance
>> reasons).
>>
>>   In short a large variant of real MTF (Mean Time to Failure) for the
>> devices across the industries/users.
>>
>>
>> Consideration:
>>
>>   - Have user-tunable to support different context of usages, which
>> should be applied on top of a set of disk IO errors, and its out come
>> will be to know if the disk can be failed.
> General thoughts on this:
> 1. If there's a write error, we fail unconditionally right now.  It
> would be nice to have a configurable number of retries before failing.
> 2. Similar for read errors, possibly with the ability to ignore them
> below some threshold.

Already stated by Chris Murphy, it's better to let user tune this behavior.
Based on pure counter or counter during a time.

Btrfs has already have counter based one as "btrfs device status", but 
seems not working all the time.

> 3. Kernel initiated link resets should probably be treated differently
> from regular read/write errors, they can indicate other potential
> problems (usually an issue in either the disk electronics or the storage
> controller).

This one seems a little hard to distinguish for btrfs.
As it can only get result from bio layer.
But if we have above threshold interface, it would be configurable to 
workaround it.

> 4. Almost all of this is policy, and really should be configurable from
> userspace and have sane defaults (probably just keeping current behavior).

Can't agree any more!!

> 5. Properly differentiating between a media error, a transport error, or
> some other error (such as in the disk electronics or storage controller)
> is not reliably possible with the current state of the block layer and
> the ATA spec (it might be possible with SCSI, but I don't know enough
> about SCSI to be certain).

The same multi-layer problem, this involve bio layer and even driver layer.
Btrfs doesn't has such good judgment, as it only knows whether a bio 
operation is done correctly.

At least for btrfs, it may only be able to do read/write error count 
threshold.

But it may be possible for user-space daemon to handle them, e.g a btrfs 
daemon watching not only the "btrfs dev status" data, but also lower 
level info(such as driver log or something like that).

And it may be better than completely relying on btrfs.

>>
>>   - Distinguish real disk failure (failed state) VS IO errors due to
>> intermittent transport errors (offline state). (I am not sure how to do
>> that yet, basically in some means, block layer could help?, RFC ?).
> This gets really tricky.  Ideally, this is really something that needs
> to be done at least partly in userspace, unless we want to teach the
> kernel about SMART attributes and how to query the disk's own idea of
> how healthy it is.  We should also take into consideration the
> possibility of the storage controller failing.
>>
>>   - A sysfs offline interface, so as to udev update the kernel, when
>> disk is pulled out.
> This needs proper support in the block layer.  As of now, it assumes
> that if something has an open reference to a block device, that device
> will not be removed.  This simplifies things there, but has undesirable
> implications for stuff like BTRFS or iSCSI/ATAoE/NBD.

What about user daemon listen on the device offline interface provided 
by block layer?

Btrfs may not be able to detect such thing, but if user-space detect it 
and trigger a replace/remove, I think it won't be a big problem.

Thanks,
Qu

>>
>>   - Because even to fail a device it depends on the user requirements,
>> btrfs IO completion threads instead of directly reacting on an IO
>> error, it will continue to just report the IO error into device error
>> statistics, and a spooler up on errors will apply user/system
>> criticalness as provided by the user on the top, which will decide if
>> the device has to be marked as failed OR if it can continue to be in
>> online.
> This is debatably a policy decision, and while it would be wonderful to
> have stuff in the kernel to help userspace with this, it probably
> belongs in userspace.
>>
>>   - A FS load pattern (mostly outside of btrfs-kernel or with in btrfs-
>> kernel) may pick the right time to replace the failed device, or to run
>> other FS maintenance activities (balance, scrub) automatically.
> This is entirely a policy decision, and as such does not belong in the
> kernel.
>>
>>   - Sysfs will help user land scripts which may want to bring device to
>> offline or failed.
>>
>>
>>
>> Device State flow:
>>
>>    A device in the btrfs kernel can be in any one of following state:
>>
>>    Online
>>       A normal healthy device
>>
>>    Missing
>>       Device wasn't found that the time of mount OR device scan.
>>
>>    Offline (disappeared)
>>       Device was present at some point in time after the FS was mounted,
>>       however offlined by user or block layer or hot unplug or device
>>       experienced transport error. Basically due to any error other than
>>       media error.
>>       The device in offline state are not candidate for the replace.
>>       Since still there is a hope that device may be restored to online
>>       at some point in time, by user or transport-layer error recovery.
>>       For device pulled out, there will be udev script which will call
>>       offline through sysfs. In the long run, we would also need to know
>>       the block layer to distinguish from the transient write errors
>>       like writes failing  due to transport error, vs write errors which
>>       are confirmed as target-device/device-media failure.
> It may be useful to have the ability to transition a device from offline
> to failed after some configurable amount of time.
>>
>>    Failed
>>       Device has confirmed a write/flush failure for at least a block.
>>       (In general the disk/storage FW will try to relocate the bad block
>>       on write, it happens automatically and transparent even to the
>>       block layer. Further there might have been few retry from the block
>>       layer. And here btrfs assumes that such an attempt has also
>>       failed). Or it might set device as failed for extensive read
>>       errors if the user tuned profile demands it.
>>
>>
>> A btrfs pool can be in one of the state:
>>
>> Online:
>>    All the chunks are as configured.
>>
>> Degraded:
>>    One or more logical-chunks does not meet the redundancy level that
>>    user requested / configured.
>>
>> Failed:
>>    One or more logical-chunk is incomplete. FS will be in a RO mode Or
>>    panic -dump as configured.
>>
>>
>> Flow diagram (also include pool states BTRFS_POOL_STATE_xx along with
>> device state BTRFS_DEVICE_STATE_xx):
>>
>>
>>                      [1]
>>                      BTRFS_DEVICE_STATE_ONLINE,
>>                       BTRFS_POOL_STATE_ONLINE
>>                                  |
>>                                  |
>>                                  V
>>                            new IO error
>>                                  |
>>                                  |
>>                                  V
>>                     check with block layer to know
>>                    if confirmed media/target:- failed
>>                  or fix-able transport issue:- offline.
>>                        and apply user config.
>>              can be ignored ?  --------------yes->[1]
>>                                  |
>>                                  |no
>>          _______offline__________/\______failed________
>>          |                                             |
>>          |                                             |
>>          V                                             V
>> (eg: transport issue [*], disk is good)     (eg: write media error)
>>          |                                             |
>>          |                                             |
>>          V                                             V
>> BTRFS_DEVICE_STATE_OFFLINE                BTRFS_DEVICE_STATE_FAILED
>>          |                                             |
>>          |                                             |
>>          |______________________  _____________________|
>>                                 \/
>>                                  |
>>                          Missing chunk ? --NO--> goto [1]
>>                                  |
>>                                  |
>>                           Tolerable? -NO-> FS ERROR. RO.
>>                                       BTRFS_POOL_STATE_FAILED->remount?
>>                                  |
>>                                  |yes
>>                                  V
>>                        BTRFS_POOL_STATE_DEGRADED --> rebalance -> [1]
>>                                  |
>>          ______offline___________|____failed_________
>>          |                                           |
>>          |                                      check priority
>>          |                                           |
>>          |                                           |
>>          |                                      hot spare ?
>>          |                                    replace --> goto [1]
>>          |                                           |
>>          |                                           | no
>>          |                                           |
>>          |                                       spare-add
>> (user/sys notify issue is fixed,         (manual-replace/dev-delete)
>>    trigger scrub/balance)                            |
>>          |______________________  ___________________|
>>                                 \/
>>                                  |
>>                                  V
>>                                 [1]
>>
>>
>> Code status:
>>   Part-1: Provided device transitions from online to failed/offline,
>>           hot spare and auto replace.
>>           [PATCH 00/15] btrfs: Hot spare and Auto replace
>>
>>   Next,
>>    . Add sysfs part on top of
>>      [PATCH] btrfs: Introduce device pool sysfs attributes
>>    . POOL_STATE flow and reporting
>>    . Device transactions from Offline to Online
>>    . Btrfs-progs mainly to show device and pool states
>>    . Apply user tolerance level to the IO errors
>
>


