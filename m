From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH] btrfs: quasi-round-robin for chunk allocation
Date: Fri, 18 Mar 2011 10:40:20 -0400
Message-ID: <1300458780-sup-7019@think>
References: <1297188212-23212-1-git-send-email-sensille@gmx.net> <4D5203E5.7000902@cn.fujitsu.com> <4D822FB6.7020901@gmx.net>
Content-Type: text/plain; charset=UTF-8
Cc: miaox <miaox@cn.fujitsu.com>, josef <josef@redhat.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Arne Jansen <sensille@gmx.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <4D822FB6.7020901@gmx.net>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Arne Jansen's message of 2011-03-17 11:58:46 -0400:
> On 09.02.2011 04:03, Miao Xie wrote:
> 
> > On tue, 8 Feb 2011 19:03:32 +0100, Arne Jansen wrote:
> >> In a multi device setup, the chunk allocator currently always allocates
> >> chunks on the devices in the same order. This leads to a very uneven
> >> distribution, especially with RAID1 or RAID10 and an uneven number of
> >> devices.
> >> This patch always sorts the device before allocating, and allocates the
> >> stripes on the devices with the most available space, as long as there
> > 
> > Yes, the chunk allocator currently cannot allocates chunks on the devices
> > on the devices fairly. But your patch doesn't fix this problem, with your patch,
> > the chunk allocator will allocate chunks on the devices which have the most
> > available space, if we create btrfs filesystem on the devices with different size,
> > the chunk allocator will always allocate chunks on the devices with the most
> > available space, and can't spread the data across all the devices at the beginning.
> 
> Right, but this only holds for the beginning. As soon as the devices
> reach an even level, the data gets spread over all devices.
> On the other hand, if you first fill all devices evenly, the moment
> the first device is full, you will also not be able to stripe the data
> over all devices. So the situation is the same, except that in one case
> you don't distribute evenly in the beginning while in the other you
> don't do in the end. The main difference is that with this patch you
> waste less space in the end.
> Look at a situation where you have three devices, one twice as large as
> the other two. If you start distributing evenly, you'll end up with the
> two smaller devices filled completely and the larger one only half full.
> You can't allocate anymore, because you have only one device left. So
> you waste half of your larger device.
> With this patch, all chunks will get one stripe on one of the smaller
> devices, alternately, and one on the large device. While you'll have an
> uneven load distribution, all devices get filled completely.

I think that filling all the devices fully is more important than the
initial spread.  Miao is correct that the administrator will
probably complain if all the devices aren't used for the initial stripes.
But, over the long term the admin does expect that if he gives us 350GB
of drives in any config, we find try our best to use all 350GB.  I'd
rather meet that expectation than worry about initial performance in a
mixed drive setup.

The difficult part of this patch is that it mixes the cleanup with the
policy change.  Since Fujitsu had a number of tests for corner cases in
device allocation, it would help a lot if they could test and review the
cleanup at hand.

> 
> > 
> > Besides that, I think we needn't  sort the devices if we can allocate chunks by
> > the default size.
> > 
> > In fact, we just fix it by using list_splice_tail() instead of list_splice().
> > just like this(in __btrfs_alloc_chunk()):
> > -    list_splice(&private_devs, &fs_devices->alloc_list);
> > +    list_splice_tail(&private_devs, &fs_devices->alloc_list);
> > 
> 
> This would only be a very weak solution, for two reasons. First, we
> have chunks of different sizes (meta/data). This would disturb the
> distribution. Second, the order in the list is not persistent. So
> with each remount, the first allocation will always get to the same
> devices. A possible scenario would be a desktop machine where the
> disks only get filled slowly and which is shutdown every day. You'd
> end up with only 2 out of 3 devices used and one device completely
> wasted.

I do think the mixed chunk sizes is a better reason to keep the pure
sort.  It's unlikely that we'll have desktop users who frequently reboot
and also use lots of mixed devices in a btrfs raid ;)

Overall the vast majority of chunks are usually data, so the list splice
above will probably be within a few percent of the more complex sort.
But, that's really a side issue.

-chris
