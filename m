Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:62927 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752974AbdGNCwu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 13 Jul 2017 22:52:50 -0400
Subject: Re: Containers, Btrfs vs Btrfs + overlayfs
To: Sargun Dhillon <sargun@sargun.me>
Cc: Chris Murphy <lists@colorremedies.com>, bo.li.liu@oracle.com,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <CAJCQCtQiCcWZXhXo1nDt0qeGHr=WQH1cs8Syrbc9cXwez8ENjg@mail.gmail.com>
 <20170713223205.GB6181@lim.localdomain>
 <CAJCQCtSpJkVzH=jL7+1J2jHncCBxwFS_eDNs_q+q6uUdTG8DAQ@mail.gmail.com>
 <9a73851d-e4c7-f395-285e-5cf3e835c2b7@gmx.com>
 <CAMp4zn8YUdVShFibUKCXtwZTZpicCbmm7zSYMn7+K5CNt-cxGA@mail.gmail.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <04d2fb90-1e6d-22f5-4943-2f16298e9cc4@gmx.com>
Date: Fri, 14 Jul 2017 10:52:37 +0800
MIME-Version: 1.0
In-Reply-To: <CAMp4zn8YUdVShFibUKCXtwZTZpicCbmm7zSYMn7+K5CNt-cxGA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2017年07月14日 10:24, Sargun Dhillon wrote:
> On Thu, Jul 13, 2017 at 7:01 PM, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
>>
>>
>> On 2017年07月14日 07:26, Chris Murphy wrote:
>>>
>>> On Thu, Jul 13, 2017 at 4:32 PM, Liu Bo <bo.li.liu@oracle.com> wrote:
>>>>
>>>> On Thu, Jul 13, 2017 at 02:49:27PM -0600, Chris Murphy wrote:
>>>>>
>>>>> Has anyone been working with Docker and Btrfs + overlayfs? It seems
>>>>> superfluous or unnecessary to use overlayfs, but the shared page cache
>>>>> aspect and avoiding some of the problems with large numbers of Btrfs
>>>>> snapshots, might make it a useful combination. But I'm not finding
>>>>> useful information with searches. Typically it's Btrfs alone vs
>>>>> ext4/XFS + overlayfs.
>>>>>
>>>>> ?
> We've been running Btrfs with Docker at appreciable scale for a few
> months now (100-200k containers  / day ). We originally looked at the
> Overlay FS route, but it turns out that one of the downsides the
> shared page cache is it breaks cgroup accounting. If you want to
> properly allow people to ensure their container never touches disk, it
> may get complicated.
>>>>
>>>>
>>>> Is there a reproducer for problems with large number of btrfs
>>>> snapshots?
>>>
>>>
>>> No benchmarking comparison but it's known that deletion of snapshots
>>> gets more expensive when there are many snapshots due to backref
>>> search and metadata updates. I have no idea how it compares to
>>> overlayfs. But then also some use cases I guess it's non-trivial
>>> benefit to leverage a shared page cache.
> We churn through ~80 containers per instance (over a day or so), and
> each container's image has 20 layers. The deletion if very expensive,

Well, the subvolume deletion itself has already been optimized.

Instead of deleting items one by one and triggering tree re-balance (not 
btrfs balance) everytime, it skips tree re-balance and delete leaf by 
leaf, which speeds up the whole thing.

> and it would be nice to be able to throttle it, but ~100GB subvolumes
> (on SSD) with 10000+ files are typically removed in <5s. Qgroups turn

Thanks for mentioning the underlying storage.
SSD makes FUA overhead smaller, so with SSD the metadata CoW is less 
obvious.

Anyway such benefit is not obvious when concurrency rise.

> out to have a lot of overhead here -- even with a single level.  At
> least in our testing, even with qgroups, there's lower latency for I/O
> and metadata during build jobs (Java or C compilation) as compared to
> OverlayFS on BtrFS or AUFS on ZFS (on Linux). Without qgroups, it's

I didn't realize overlayfs could cause extra latency when doing IO.
This indeed provides some interesting result.

> almost certainly "faster". YMMV though, because we're already paying
> the network storage latency cost.
> 
> We've investigating using the blkio controller to isolate I/O per
> container to avoid I/O stalls, and restrict I/O during snapshot
> cleanup, but that's been unsuccessful.
>>
>>
>> In fact, except balance and quota, I can't see much extra performance impact
>> from backref walk.
>>
>> And if it's not snapshots, but subvolumes, then more subvolumes means
>> smaller subvolume trees, and less race to lock subvolume trees.
>> So, more (evenly distributed) subvolumes should in fact lead to higher
>> performance.
>>
>>>
>>>> Btrfs + overlayfs?  The copy-up coperation in overlayfs can take
>>>> advantage of btrfs's clone, but this benefit applies for xfs, too.
>>>
>>>
>>> Btrfs supports fs shrink, and also multiple device add/remove so it's
>>> pretty nice for managing its storage in the cloud. And also seed
>>> device might have uses. Some of it is doable with LVM but it's much
>>> simpler, faster and safer with Btrfs.
>>
>>
>> Faster? Not really.
>> For metadata operation, btrfs is slower than traditional FSes.
>>
>> Due to metadata CoW, any metadata update will lead to superblock update.
>> Such extra FUA for superblock is specially obvious for fsync heavy load but
>> low concurrency case.
>> Not to mention its default data CoW will lead to metadata CoW, making things
>> even slower.
> Since containers are ephemeral, they really shouldn't fsync. One of
> the biggest (recent) problems has been workloads that use O_SYNC, or
> sync after a large number of operations -- this stalls out all of the
> containers (subvolumes) on the machine because the transaction lock is
> under hold. This, in turn, manifests itself in soft lockups, and
> operational trouble. Our plan to work around it is patch the VFS
> layer, and stub out sync for certain cgroups.

This makes sense.

As all fs, even btrfs, they share one superblock and journal per fs.

So fsync/sync will break the resource share and cause performance drop.

> 
>>
>> And race to lock fs/subvolume trees makes metadata operation even slower,
>> especially for multi-thread IO.
>> Unlike other FSes which use one-tree-one-inode, btrfs uses
>> one-tree-one-subvoume, which makes race much hotter.
>>
>> Extent tree used to have the same problem, but delayed-ref (no matter you
>> like it or not) did reduce race and improved performance.
>>
>> IIRC, some postgresql benchmark shows that XFS/Ext4 with LVM-thin provide
>> much better performance than Btrfs, even ZFS-on-Linux out-performs btrfs.
>>
> At least in our testing, AUFS + ZFS-on-Linux did not have lower
> latency than BtrFS. Stability is decent, bar the occasional soft
> lockup, or hung transaction. One of the experiments that I've been
> wanting to run is a custom graph driver which has XFS images in
> snapshots / subvolumes on BtrFS, and mounts them over loopback -- This
> makes things like limiting threads easier, and short-circuiting sync
> logic per container.

Latency wise, the AUFS/Overlayfs seems to be the problem.

BTW, why not just ZFS-on-Linux? As ZFS also supports snapshot, maybe it 
will has similar latency compared to btrfs.

Thanks,
Qu

> 
>>>
>>> And that's why I'm kinda curious about the combination of Btrfs and
>>> overlayfs. Overlayfs managed by Docker. And Btrfs for simpler and more
>>> flexible storage management.
>>
>> Despite the performance problem, (working) btrfs does provide flex and
>> unified management.
>>
>> So implementing shared page cache in btrfs will eliminate the necessary for
>> overlayfs. :)
>> Just kidding, such support need quite a lot of VFS and MM modification, and
>> I don't know if we will be able to implement it at all.
>>
>> Thanks,
>> Qu
>>
>>
>>>
>>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
