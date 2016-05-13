Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:62409 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751201AbcEMXmr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 May 2016 19:42:47 -0400
Subject: Re: [PATCH 1/2] Btrfs: add more valid checks for superblock
To: bo.li.liu@oracle.com, Qu Wenruo <quwenruo@cn.fujitsu.com>
References: <1462212951-28113-1-git-send-email-bo.li.liu@oracle.com>
 <9fa04dd7-13c4-6c24-dddc-4521eccea65c@cn.fujitsu.com>
 <20160504132329.GT29353@twin.jikos.cz>
 <20160504174436.GB14909@localhost.localdomain>
 <a7811da3-06f5-2ff2-06e4-19be9fd31410@cn.fujitsu.com>
 <20160506143529.GD29353@twin.jikos.cz>
 <47023701-8dd4-6c38-b242-230a372890e7@cn.fujitsu.com>
 <20160513181412.GA27734@localhost.localdomain>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org, vegard.nossum@oracle.com
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <a1cc8a93-c4a8-61f3-e5b6-5feceb8c838d@gmx.com>
Date: Sat, 14 May 2016 07:42:26 +0800
MIME-Version: 1.0
In-Reply-To: <20160513181412.GA27734@localhost.localdomain>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 05/14/2016 02:14 AM, Liu Bo wrote:
> On Mon, May 09, 2016 at 09:31:37AM +0800, Qu Wenruo wrote:
>>
>>
>> David Sterba wrote on 2016/05/06 16:35 +0200:
>>> On Thu, May 05, 2016 at 09:08:54AM +0800, Qu Wenruo wrote:
>>>>>> An early check can compare against some reasonable value, but the
>>>>>> total_bytes value must be equal to the sum of all device sizes
>>>>>> (disk_total_bytes). I'm not sure if we have enough information to verify
>>>>>> that at this point though.
>>>>>
>>>>> That's what I had in mind, the problem is that only the first device information is recorded in superblock.
>>>>>
>>>>> At this moment We have device_num but we don't know the size of other devices.
>>>>>
>>>>> Thanks,
>>>>>
>>>>> -liubo
>>>>>
>>>>>
>>>> What about error out if we found sb->total_bytes <
>>>> sb->dev_item->total_bytes?
>>>>
>>>> As we are just doing early check, no need to be comprehensive, but spot
>>>> obvious problem.
>>>
>>> Ok.
>
> I'm gonna check for total_bytes and num_devices after loading chunk
> tree.
>
>>>
>>>> For exact device_num and sb->total_bytes, we may do post check when
>>>> device tree are loaded?
>>>> Splitting early_check() and post_check() seems valid for me.
>>>> (Also I prefer post_check() just warning, not forced exit)
>>>
>>> Why just warning? Superblock total_bytes and device sizes must be
>>> correct, otherwise all sorts of operations can fail randomly.
>>>
>>>
>> Because if we exit, we can't even do fsck.
>>
>> Maybe we need a new flag to control whether exit or warn at post_check().
>>
>
>> Thanks,
>> Qu
>>
>
> IMHO for kernel part, we have to exit in order to avoid any panic due to those invalid value.

I'm OK with this.

>
> For fsck code, we can go forth and back to fix them.  In fact I don't
> think fsck could work out anything, as superblock checksum has _matched_
> but the values inside superblock are invalid, in this case we cannot trust
>  other parts in this FS image, then how can we expect fsck to fix it by reading
> other parts?

For rw fsck, that may cause huge problem and I agree with you on error out.
But for ro fsck, it's a little overkilled for me.

Currently, if we found error in extent tree, we still continue checking 
fstree, to shows what is really wrong.

And for case like btrfs-image restored images, its dev extents doesn't 
even match with its chunk (may be it's already fixed?), but that's not a 
big problem for ro btrfsck, and we can go on without problem.

So the same case is here for ro btrfsck.
As long as that's ro btrfsck, we could just continue as we don't really 
need the total_bytes in superblock.

Thanks,
Qu

>
> Thanks,
>
> -liubo
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
