Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:58060 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751236AbbEHI5P convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 8 May 2015 04:57:15 -0400
Message-ID: <554C7A6A.8040404@cn.fujitsu.com>
Date: Fri, 8 May 2015 16:57:14 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 0/8] Introduce offline fsid/chunk tree uuid change for
 btrfstune.
References: <1430806606-3226-1-git-send-email-quwenruo@cn.fujitsu.com> <20150505152055.GH5099@twin.jikos.cz> <5549651D.6020005@cn.fujitsu.com> <20150506154347.GC23255@twin.jikos.cz>
In-Reply-To: <20150506154347.GC23255@twin.jikos.cz>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



-------- Original Message  --------
Subject: Re: [PATCH 0/8] Introduce offline fsid/chunk tree uuid change 
for btrfstune.
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Date: 2015年05月06日 23:43

> On Wed, May 06, 2015 at 08:49:33AM +0800, Qu Wenruo wrote:
>>> Code looks good to me. I'm not sure whether it should land in btrfstune
>>> or in 'btrfs' proper.
>>>
>>> * btrfstune should go away at some point, so I'd rather not add new
>>>     features there
>>>
>>> * 'btrfs property set -t filesystem uuid' seems best to me at this moment
>> Good idea.
>>
>> I'll change it to property in next version.
>
> I've realized this later on.  The original purpose of the properties is
> to manipulate objects on a mounted filesystem, so this might need some
> adjustnments on the progs side. I'd really want to avoid another
> separate tool, so we should make sure that the interface is sane even if
> it could mix online/offline filesystem changes.
That's the original reason why I put these codes into btrfstune.

But that should not be a big problem. (See below)
>
> Respecting the current syntax, the way to set the uuid is:
>
>   btrfs prop set -t filesytem /dev/sdx uuid ...UUID...
>
> In this special case, the property handler should check if the device is
> unmounted (and is a btrfs filesystem) and then do the rest.
This is one good idea, but I'm afraid it may still be confusing.
And things may get even worse when we try to move everything into 
btrfs-prop,
E.g. if we auto move seeding flag to prop, we must give a quite detailed 
explain on which property is offline.

So I prefer to add a new type called offline, and put uuid change with 
other btrfstune function into this type.
IMHO this should provide a good explain on which is online and which is 
offline.

How do you think about this method?

Thanks,
Qu
>
>>> A minor suggestion: set BTRFS_SUPER_FLAG_ERROR on the filesystem during
>>> the conversion and drop it after it finishes successfully. It's merely a
>>> hint that there's something wrong with the filesytem, the mount will
>>> fail because filesystem uuid would not match the device id.
>>>
>> Nice idea too.
>> But I'd like to use more specific flags like
>> BTRFS_SUPER_FLAG_UUID_CHANGING to give better info if kernel can't mount it.
>
> Yeah that would be better and we'd use that for the on-line uuid change
> as well. I've outlined the idea here
> https://btrfs.wiki.kernel.org/index.php/Project_ideas#Filesystem_UUID_change_-_on-line
>
> The code should really support only 2 UUIDs, so we should check if the
> UUIDs specified by user matches one of them if the superblock flag is
> set. Ie. a partial uuid conversion must be finished before another
> UUID change (though it's a rare case, we have to be ready for that).
>
