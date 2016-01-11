Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:21856 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757233AbcAKB3d (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 10 Jan 2016 20:29:33 -0500
Subject: Re: [PATCH] BTRFS: Adds an option to select RAID Stripe size
To: Sanidhya Solanki <jpage.lkml@gmail.com>,
        Qu Wenruo <quwenruo.btrfs@gmx.com>
References: <1451305451-31222-1-git-send-email-jpage.lkml@gmail.com>
 <1451341195.7094.0.camel@scientia.net> <20151228153801.6561feff@gmail.com>
 <1451352069.7094.3.camel@scientia.net> <20151228164333.2b8d8336@gmail.com>
 <1451360528.7094.7.camel@scientia.net> <20151228190336.59a3f440@gmail.com>
 <1451363188.7094.23.camel@scientia.net> <20151229180643.GD4227@twin.jikos.cz>
 <20160102065207.4eec760a@gmail.com> <56887B40.10105@gmx.com>
 <20160109221105.6b18fb8e@gmail.com>
CC: David Sterba <dsterba@suse.cz>, <jbacik@fb.com>,
        <linux-btrfs@vger.kernel.org>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <5693055E.5010207@cn.fujitsu.com>
Date: Mon, 11 Jan 2016 09:29:02 +0800
MIME-Version: 1.0
In-Reply-To: <20160109221105.6b18fb8e@gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Sanidhya Solanki wrote on 2016/01/09 22:11 -0500:
> On Sun, 3 Jan 2016 09:37:04 +0800
> Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
>> Btrfs checksum are calculated in 3 different method:
>> 1) Metadata: Per nodesize, stored in tree blocker header. (struct
>> btrfs_header->csum)
>> 2) Data: Per sectorsize, stored in csum tree.
>> 3) Superblock: Per 4K (fixed), stored in its header (struct
>> btrfs_super->csum)
>>
>> I didn't the need to change any of them, as you are not changing any
>> of the csum behavior.
>
> Good, that means I do not need to compare csums, just the data at the
> end of the re-sizing operation.
>
> I have finished most of the actual implementation details and
> documentation for the re-size. However, before I undertake the last
> part of the development, the integration of kernel-space and user-space,
> as well as the integration between my code and the kernel code.
>
>> Stripe size only affect how btrfs does IO, not the csum size.
>
> I have a question regarding this statement. I wanted to confirm that
> the re-size will result in all the data blocks being re-written. Is
> that correct?

AFAIK, Yes for stripe based RAID profile.

And I must admit that, the above statement is not completely right.
It also affect the on-disk data layout. But csum is still not affected.

> Because the single statement above may also mean that all that needs to
> be done is change one option and the kernel code takes care of the rest.
>
> Just clarify that for me.
>
>> And since you are making the stripe size configurable, then user is
>> responsible for any too large or too small stripe size setting.
>
> I have also left the option to use an un-conventional stripe size to the
> user, for e.g., 768, 3072, 6144, etc.

Although personally I prefer to restrict to power of 2, but that's a 
personal choice anyway.

Thanks,
Qu

>
> Thanks.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>


