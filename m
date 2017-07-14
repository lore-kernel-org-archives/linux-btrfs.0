Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:64931 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752731AbdGNCBx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 13 Jul 2017 22:01:53 -0400
Subject: Re: Containers, Btrfs vs Btrfs + overlayfs
To: Chris Murphy <lists@colorremedies.com>, bo.li.liu@oracle.com
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <CAJCQCtQiCcWZXhXo1nDt0qeGHr=WQH1cs8Syrbc9cXwez8ENjg@mail.gmail.com>
 <20170713223205.GB6181@lim.localdomain>
 <CAJCQCtSpJkVzH=jL7+1J2jHncCBxwFS_eDNs_q+q6uUdTG8DAQ@mail.gmail.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <9a73851d-e4c7-f395-285e-5cf3e835c2b7@gmx.com>
Date: Fri, 14 Jul 2017 10:01:39 +0800
MIME-Version: 1.0
In-Reply-To: <CAJCQCtSpJkVzH=jL7+1J2jHncCBxwFS_eDNs_q+q6uUdTG8DAQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2017年07月14日 07:26, Chris Murphy wrote:
> On Thu, Jul 13, 2017 at 4:32 PM, Liu Bo <bo.li.liu@oracle.com> wrote:
>> On Thu, Jul 13, 2017 at 02:49:27PM -0600, Chris Murphy wrote:
>>> Has anyone been working with Docker and Btrfs + overlayfs? It seems
>>> superfluous or unnecessary to use overlayfs, but the shared page cache
>>> aspect and avoiding some of the problems with large numbers of Btrfs
>>> snapshots, might make it a useful combination. But I'm not finding
>>> useful information with searches. Typically it's Btrfs alone vs
>>> ext4/XFS + overlayfs.
>>>
>>> ?
>>
>> Is there a reproducer for problems with large number of btrfs
>> snapshots?
> 
> No benchmarking comparison but it's known that deletion of snapshots
> gets more expensive when there are many snapshots due to backref
> search and metadata updates. I have no idea how it compares to
> overlayfs. But then also some use cases I guess it's non-trivial
> benefit to leverage a shared page cache.

In fact, except balance and quota, I can't see much extra performance 
impact from backref walk.

And if it's not snapshots, but subvolumes, then more subvolumes means 
smaller subvolume trees, and less race to lock subvolume trees.
So, more (evenly distributed) subvolumes should in fact lead to higher 
performance.

> 
>> Btrfs + overlayfs?  The copy-up coperation in overlayfs can take
>> advantage of btrfs's clone, but this benefit applies for xfs, too.
> 
> Btrfs supports fs shrink, and also multiple device add/remove so it's
> pretty nice for managing its storage in the cloud. And also seed
> device might have uses. Some of it is doable with LVM but it's much
> simpler, faster and safer with Btrfs.

Faster? Not really.
For metadata operation, btrfs is slower than traditional FSes.

Due to metadata CoW, any metadata update will lead to superblock update.
Such extra FUA for superblock is specially obvious for fsync heavy load 
but low concurrency case.
Not to mention its default data CoW will lead to metadata CoW, making 
things even slower.

And race to lock fs/subvolume trees makes metadata operation even 
slower, especially for multi-thread IO.
Unlike other FSes which use one-tree-one-inode, btrfs uses 
one-tree-one-subvoume, which makes race much hotter.

Extent tree used to have the same problem, but delayed-ref (no matter 
you like it or not) did reduce race and improved performance.

IIRC, some postgresql benchmark shows that XFS/Ext4 with LVM-thin 
provide much better performance than Btrfs, even ZFS-on-Linux 
out-performs btrfs.

> 
> And that's why I'm kinda curious about the combination of Btrfs and
> overlayfs. Overlayfs managed by Docker. And Btrfs for simpler and more
> flexible storage management.
Despite the performance problem, (working) btrfs does provide flex and 
unified management.

So implementing shared page cache in btrfs will eliminate the necessary 
for overlayfs. :)
Just kidding, such support need quite a lot of VFS and MM modification, 
and I don't know if we will be able to implement it at all.

Thanks,
Qu

> 
> 
