Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:35012 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752966AbdGNCdE (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 13 Jul 2017 22:33:04 -0400
Received: by mail-wm0-f68.google.com with SMTP id u23so8373557wma.2
        for <linux-btrfs@vger.kernel.org>; Thu, 13 Jul 2017 19:33:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <9a73851d-e4c7-f395-285e-5cf3e835c2b7@gmx.com>
References: <CAJCQCtQiCcWZXhXo1nDt0qeGHr=WQH1cs8Syrbc9cXwez8ENjg@mail.gmail.com>
 <20170713223205.GB6181@lim.localdomain> <CAJCQCtSpJkVzH=jL7+1J2jHncCBxwFS_eDNs_q+q6uUdTG8DAQ@mail.gmail.com>
 <9a73851d-e4c7-f395-285e-5cf3e835c2b7@gmx.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Thu, 13 Jul 2017 20:33:02 -0600
Message-ID: <CAJCQCtSx6gnzqARjwRz0EV13BiCNZDg=JCYa-U0HN_9UyFn5Sg@mail.gmail.com>
Subject: Re: Containers, Btrfs vs Btrfs + overlayfs
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Chris Murphy <lists@colorremedies.com>, bo.li.liu@oracle.com,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 13, 2017 at 8:01 PM, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
>
>
> On 2017年07月14日 07:26, Chris Murphy wrote:

>> No benchmarking comparison but it's known that deletion of snapshots
>> gets more expensive when there are many snapshots due to backref
>> search and metadata updates. I have no idea how it compares to
>> overlayfs. But then also some use cases I guess it's non-trivial
>> benefit to leverage a shared page cache.
>
>
> In fact, except balance and quota, I can't see much extra performance impact
> from backref walk.
>
> And if it's not snapshots, but subvolumes, then more subvolumes means
> smaller subvolume trees, and less race to lock subvolume trees.
> So, more (evenly distributed) subvolumes should in fact lead to higher
> performance.

Interesting.


>
>>
>>> Btrfs + overlayfs?  The copy-up coperation in overlayfs can take
>>> advantage of btrfs's clone, but this benefit applies for xfs, too.
>>
>>
>> Btrfs supports fs shrink, and also multiple device add/remove so it's
>> pretty nice for managing its storage in the cloud. And also seed
>> device might have uses. Some of it is doable with LVM but it's much
>> simpler, faster and safer with Btrfs.
>
>
> Faster? Not really.
> For metadata operation, btrfs is slower than traditional FSes.

The equivalent of Btrfs multiple device 'btrfs dev delete' to remove a
device, and migrate bg's to remaining devices, is really slow on LVM
using pvmove. Plus you are allowed to delete devices that haven't had
pvmove applied, so data loss is possible (user induced data loss).


> Due to metadata CoW, any metadata update will lead to superblock update.
> Such extra FUA for superblock is specially obvious for fsync heavy load but
> low concurrency case.
> Not to mention its default data CoW will lead to metadata CoW, making things
> even slower.
>
> And race to lock fs/subvolume trees makes metadata operation even slower,
> especially for multi-thread IO.
> Unlike other FSes which use one-tree-one-inode, btrfs uses
> one-tree-one-subvoume, which makes race much hotter.

OK so this possibly means overlayfs might make things slower since all
I/O ends up getting dumped into one Btrfs fstree; whereas with Docker
using Btrfs rw snapshots, it puts each container's I/O into its own
subvolume.


>
> Extent tree used to have the same problem, but delayed-ref (no matter you
> like it or not) did reduce race and improved performance.
>
> IIRC, some postgresql benchmark shows that XFS/Ext4 with LVM-thin provide
> much better performance than Btrfs, even ZFS-on-Linux out-performs btrfs.

OK.


>> And that's why I'm kinda curious about the combination of Btrfs and
>> overlayfs. Overlayfs managed by Docker. And Btrfs for simpler and more
>> flexible storage management.
>
> Despite the performance problem, (working) btrfs does provide flex and
> unified management.
>
> So implementing shared page cache in btrfs will eliminate the necessary for
> overlayfs. :)
> Just kidding, such support need quite a lot of VFS and MM modification, and
> I don't know if we will be able to implement it at all.

Yeah I've read it's complicated for everyone, even overlayfs folks
have had growing pains.


-- 
Chris Murphy
