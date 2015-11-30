Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:58984 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753251AbbK3MoM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 30 Nov 2015 07:44:12 -0500
Subject: Re: [RFC] Btrfs device and pool management (wip)
To: Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org,
        Qu Wenruo <quwenruo@cn.fujitsu.com>
References: <565C01F1.5030108@oracle.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <565C448A.7050601@gmx.com>
Date: Mon, 30 Nov 2015 20:43:54 +0800
MIME-Version: 1.0
In-Reply-To: <565C01F1.5030108@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 11/30/2015 03:59 PM, Anand Jain wrote:
> (fixed alignment)
>
>
> ------------
>   Data center systems are generally aligned with the RAS (Reliability,
> Availability and Serviceability) attributes. When it comes to Storage,
> RAS applies even more because its matter of trust. In this context, one
> of the primary area that a typical volume manager should be well tested
> is, how well RAS attributes are maintained in the context of device
> failure, and its further reporting.
>
>   But, identifying a failed device is not a straight forward code. If
> you look at some statistics performed on failed and returned disks,
> most of the disks ends up being classified as NTF (No Trouble Found).
> That is, host failed-and-replaced a disk even before it has actually
> failed. This is not good for a cost effective setup who would want to
> stretch the life of an intermittently failing device to its maximum
> tenure and would want to replace only when it has confirmed dead.
>
>   Also on the other hand, some of the data center admins would like to
> mitigate the risk (of low performance at peak of their business
> productions) of a potential failure, and prefer to pro-actively replace
> the disk at their low business/workload hours, or they may choose to
> replace a device even for read errors (mainly due to performance
> reasons).
>
>   In short a large variant of real MTF (Mean Time to Failure) for the
> devices across the industries/users.
>
>
> Consideration:
>
>   - Have user-tunable to support different context of usages, which
> should be applied on top of a set of disk IO errors, and its out come
> will be to know if the disk can be failed.

I'm overall OK with your *current* hot-spare implement.
It's quite small and straightforward.
Just hope some more more easy-to-implement features, like hot-remove 
instead of replace. (for degradable case, it would case less IO).
And more test-cases.

And per-filesystem hot-spare device. Global one has its limitation, like 
no priority or choose less proper device.
(use a TB device to replace a GB device, eating up the pool quite easily)
It should be not hard to do, maybe add fsid into hot-spare device 
superblock and modify kernel/user-progs a little.



But if your ultimate goal of *in-kernel* hot-spare is to do such 
complicated *in-kernel police*, I would say *NO* right now before things 
get messed up.
(Yeah, maybe another "discussion" just like feature auto-align)

Kernel should provide *mechanisim*, not *policy*.
(Pretty sure most of us should hear it in one form or another).

In this case, btrfs supports for *replace* is a mechanism. (not 
automatically replace)
But *when* to replace a bad device, is *policy*.


But if you just want to get to that goal, *not restricted to in-kernel 
implement*, it would be much easier to do.

1) Implement a API(maybe sysfs as you suggested) to allow user-space 
programs get informed when a btrfs device get sick(including missing or 
number of IO errors hit a threshold)

2) Write a user-space program listening with that API

3) Trigger a action when device get failed.
    Maybe replace, maybe remove, or just do nothing, fully *tunable* and
    much *easier* to implement.

If use above method, kernel part should be as easy as the following:
1) A new API for user-progs to listen

2) (Optional) Tuning interface for that API
    E.g, threshold of IO error before informing user space

3) Kernel fallback behavior for such error
    Even no need to trigger replace from kernel, but just put the
    filesystem into degraded will be good enough.

3) A user daemon, maybe in btrfs-progs or another project.
    Easy to debug, easy to implement, and you will be the
    maintainer/leader/author of the new project!!

Now all the policy is moved to user-space, kernel is kept small and clean.

>
>   - Distinguish real disk failure (failed state) VS IO errors due to
> intermittent transport errors (offline state). (I am not sure how to do
> that yet, basically in some means, block layer could help?, RFC ?).
>
>   - A sysfs offline interface, so as to udev update the kernel, when
> disk is pulled out.

Yes, that's very *demanding* feature, and if implement correctly, you 
don't ever need to do in-kernel hot-replace.(only need to fallback to 
auto-degrade)
That's the core feature which may keep kernel small and clean.

I am eager to see it before in-kernel hot-spare.

>
>   - Because even to fail a device it depends on the user requirements,
> btrfs IO completion threads instead of directly reacting on an IO
> error, it will continue to just report the IO error into device error
> statistics, and a spooler up on errors will apply user/system
> criticalness as provided by the user on the top, which will decide if
> the device has to be marked as failed OR if it can continue to be in
> online.
>
>   - A FS load pattern (mostly outside of btrfs-kernel or with in btrfs-
> kernel) may pick the right time to replace the failed device, or to run
> other FS maintenance activities (balance, scrub) automatically.

Strongly recommend to move out of kernel.
Although I didn't have a good suggestion about user-space IO performance 
detection.
Maybe periodic sar command?
I hope someone can give suggestion on it.

>
>   - Sysfs will help user land scripts which may want to bring device to
> offline or failed.

Of course.

Thanks,
Qu
>
>
>
> Device State flow:
>
>    A device in the btrfs kernel can be in any one of following state:
>
>    Online
>       A normal healthy device
>
>    Missing
>       Device wasn't found that the time of mount OR device scan.
>
>    Offline (disappeared)
>       Device was present at some point in time after the FS was mounted,
>       however offlined by user or block layer or hot unplug or device
>       experienced transport error. Basically due to any error other than
>       media error.
>       The device in offline state are not candidate for the replace.
>       Since still there is a hope that device may be restored to online
>       at some point in time, by user or transport-layer error recovery.
>       For device pulled out, there will be udev script which will call
>       offline through sysfs. In the long run, we would also need to know
>       the block layer to distinguish from the transient write errors
>       like writes failing  due to transport error, vs write errors which
>       are confirmed as target-device/device-media failure.
>
>    Failed
>       Device has confirmed a write/flush failure for at least a block.
>       (In general the disk/storage FW will try to relocate the bad block
>       on write, it happens automatically and transparent even to the
>       block layer. Further there might have been few retry from the block
>       layer. And here btrfs assumes that such an attempt has also
>       failed). Or it might set device as failed for extensive read
>       errors if the user tuned profile demands it.
>
>
> A btrfs pool can be in one of the state:
>
> Online:
>    All the chunks are as configured.
>
> Degraded:
>    One or more logical-chunks does not meet the redundancy level that
>    user requested / configured.
>
> Failed:
>    One or more logical-chunk is incomplete. FS will be in a RO mode Or
>    panic -dump as configured.
>
>
> Flow diagram (also include pool states BTRFS_POOL_STATE_xx along with
> device state BTRFS_DEVICE_STATE_xx):
>
>
>                      [1]
>                      BTRFS_DEVICE_STATE_ONLINE,
>                       BTRFS_POOL_STATE_ONLINE
>                                  |
>                                  |
>                                  V
>                            new IO error
>                                  |
>                                  |
>                                  V
>                     check with block layer to know
>                    if confirmed media/target:- failed
>                  or fix-able transport issue:- offline.
>                        and apply user config.
>              can be ignored ?  --------------yes->[1]
>                                  |
>                                  |no
>          _______offline__________/\______failed________
>          |                                             |
>          |                                             |
>          V                                             V
> (eg: transport issue [*], disk is good)     (eg: write media error)
>          |                                             |
>          |                                             |
>          V                                             V
> BTRFS_DEVICE_STATE_OFFLINE                BTRFS_DEVICE_STATE_FAILED
>          |                                             |
>          |                                             |
>          |______________________  _____________________|
>                                 \/
>                                  |
>                          Missing chunk ? --NO--> goto [1]
>                                  |
>                                  |
>                           Tolerable? -NO-> FS ERROR. RO.
>                                       BTRFS_POOL_STATE_FAILED->remount?
>                                  |
>                                  |yes
>                                  V
>                        BTRFS_POOL_STATE_DEGRADED --> rebalance -> [1]
>                                  |
>          ______offline___________|____failed_________
>          |                                           |
>          |                                      check priority
>          |                                           |
>          |                                           |
>          |                                      hot spare ?
>          |                                    replace --> goto [1]
>          |                                           |
>          |                                           | no
>          |                                           |
>          |                                       spare-add
> (user/sys notify issue is fixed,         (manual-replace/dev-delete)
>    trigger scrub/balance)                            |
>          |______________________  ___________________|
>                                 \/
>                                  |
>                                  V
>                                 [1]
>
>
> Code status:
>   Part-1: Provided device transitions from online to failed/offline,
>           hot spare and auto replace.
>           [PATCH 00/15] btrfs: Hot spare and Auto replace
>
>   Next,
>    . Add sysfs part on top of
>      [PATCH] btrfs: Introduce device pool sysfs attributes
>    . POOL_STATE flow and reporting
>    . Device transactions from Offline to Online
>    . Btrfs-progs mainly to show device and pool states
>    . Apply user tolerance level to the IO errors
> ----------
>
>
> Thanks, Anand
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
