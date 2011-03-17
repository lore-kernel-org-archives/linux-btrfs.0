From: Arne Jansen <sensille@gmx.net>
Subject: Re: [PATCH] btrfs: quasi-round-robin for chunk allocation
Date: Thu, 17 Mar 2011 16:58:46 +0100
Message-ID: <4D822FB6.7020901@gmx.net>
References: <1297188212-23212-1-git-send-email-sensille@gmx.net> <4D5203E5.7000902@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Cc: chris.mason@oracle.com, josef@redhat.com,
	linux-btrfs@vger.kernel.org
To: miaox@cn.fujitsu.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4D5203E5.7000902@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 09.02.2011 04:03, Miao Xie wrote:

> On tue, 8 Feb 2011 19:03:32 +0100, Arne Jansen wrote:
>> In a multi device setup, the chunk allocator currently always allocates
>> chunks on the devices in the same order. This leads to a very uneven
>> distribution, especially with RAID1 or RAID10 and an uneven number of
>> devices.
>> This patch always sorts the device before allocating, and allocates the
>> stripes on the devices with the most available space, as long as there
> 
> Yes, the chunk allocator currently cannot allocates chunks on the devices
> on the devices fairly. But your patch doesn't fix this problem, with your patch,
> the chunk allocator will allocate chunks on the devices which have the most
> available space, if we create btrfs filesystem on the devices with different size,
> the chunk allocator will always allocate chunks on the devices with the most
> available space, and can't spread the data across all the devices at the beginning.

Right, but this only holds for the beginning. As soon as the devices
reach an even level, the data gets spread over all devices.
On the other hand, if you first fill all devices evenly, the moment
the first device is full, you will also not be able to stripe the data
over all devices. So the situation is the same, except that in one case
you don't distribute evenly in the beginning while in the other you
don't do in the end. The main difference is that with this patch you
waste less space in the end.
Look at a situation where you have three devices, one twice as large as
the other two. If you start distributing evenly, you'll end up with the
two smaller devices filled completely and the larger one only half full.
You can't allocate anymore, because you have only one device left. So
you waste half of your larger device.
With this patch, all chunks will get one stripe on one of the smaller
devices, alternately, and one on the large device. While you'll have an
uneven load distribution, all devices get filled completely.

> 
> Besides that, I think we needn't  sort the devices if we can allocate chunks by
> the default size.
> 
> In fact, we just fix it by using list_splice_tail() instead of list_splice().
> just like this(in __btrfs_alloc_chunk()):
> -	list_splice(&private_devs, &fs_devices->alloc_list);
> +	list_splice_tail(&private_devs, &fs_devices->alloc_list);
> 

This would only be a very weak solution, for two reasons. First, we
have chunks of different sizes (meta/data). This would disturb the
distribution. Second, the order in the list is not persistent. So
with each remount, the first allocation will always get to the same
devices. A possible scenario would be a desktop machine where the
disks only get filled slowly and which is shutdown every day. You'd
end up with only 2 out of 3 devices used and one device completely
wasted.

-Arne

>> is enough space available. In a low space situation, it first tries to
>> maximize striping.
> 
> This feature has been implemented.
> 
>> The patch also simplifies the allocator and reduces the checks for
>> corner cases. Additionally, alloc_start is now always heeded.
> 
> Yes, the code of the allocator is complex and ugly, it is necessary to simplify it.
> 
> Thanks
> Miao
> 
