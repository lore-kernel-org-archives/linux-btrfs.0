Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:58361 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754570AbbIWOA3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Sep 2015 10:00:29 -0400
Subject: Re: [PATCH] btrfs: Fix no space bug caused by removing bg
To: Austin S Hemmelgarn <ahferroin7@gmail.com>, dsterba@suse.cz,
        Hugo Mills <hugo@carfax.org.uk>,
        =?UTF-8?Q?Holger_Hoffst=c3=a4tte?=
	<holger.hoffstaette@googlemail.com>,
        linux-btrfs@vger.kernel.org
References: <15fc8f8d002e4ffcdb46e769736f240ae7ace20b.1442839332.git.zhaolei@cn.fujitsu.com>
 <560150CD.6070301@suse.com> <5601596B.1020607@googlemail.com>
 <20150922134131.GH5918@carfax.org.uk> <20150922142333.GH12815@twin.jikos.cz>
 <20150922143602.GI5918@carfax.org.uk> <20150923131226.GA12815@twin.jikos.cz>
 <5602A6EA.8050107@gmx.com> <5602A9F8.80802@gmail.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <5602B06C.8020600@gmx.com>
Date: Wed, 23 Sep 2015 22:00:12 +0800
MIME-Version: 1.0
In-Reply-To: <5602A9F8.80802@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



在 2015年09月23日 21:32, Austin S Hemmelgarn 写道:
> On 2015-09-23 09:19, Qu Wenruo wrote:
>>
>>
>> 在 2015年09月23日 21:12, David Sterba 写道:
>>> On Tue, Sep 22, 2015 at 02:36:02PM +0000, Hugo Mills wrote:
>>>>> Yeah, right now there's no persistent default for the allocator. I'm
>>>>> still hoping that the object properties will magically solve that.
>>>>
>>>>     There's no obvious place that filesystem-wide properties can be
>>>> stored, though. There's a userspace tool to manipulate the few current
>>>> FS-wide properties, but that's all special-cased to use the
>>>> "historical" ioctls for those properties, with no generalisation of a
>>>> property store, or even (IIRC) any external API for them.
>>>
>>>  From the UI point, we proposed to add a specifier that would route the
>>> property to either subvolume or the filesystem:
>>>
>>> $ btrfs prop set -t filesystem bgtype raid0
>>> $ btrfs prop set -t subvolume bgtype raid1
>>>
>>
>> BTW, is btrfs going to support different chunk/bg type for subvolume?!
>> I thought data/meta/system chunk types are all per filesystem level,
>> and was planning to use superblock to record it...
>>
>> If really to support that, does it mean we will have different meta/data
>> type for each subvolume?
>> That's a little too flex for me....
>>
> This has actually been a planned feature for a while, and really is
> needed to compete with the flexibility that ZFS gives for this kind of
> thing.  System chunk types should still be set separately (although,
> once we have n-way replication, they really should be set separately
> from metadata to at least one copy per device in multi-device filesystems).
>
>

Thanks, David and Austin.

As it's already planned, and I think it will need new incompact flag 
anyway, or old kernel can easily remove/convert desired profile.
So what about adding new ROOT_ITEM members to record data/meta profile?

I'm not a big fan to use xattr and it's quite easy to modify from user 
space, and not completely confident with the possible concurrency about 
xattr modification with chunk allocation.

And from the logical level, xattr is at the same level as inode, but 
subvolume is definitely at a higher level, even it's normally treated as 
directory.
So for me, I'd like to record it into root_item, not as sub xattr, even 
it may need an extra ioctl to handle it.

Anyway, I'm just a new comer for this feature, it's completely OK to 
ignore my stupid ideas.

BTW, what about the original patch? I hope it can be merged in next RC 
as the affected test case is quite a lot...

Thanks,
Qu
