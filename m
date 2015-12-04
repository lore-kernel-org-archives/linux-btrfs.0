Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:52412 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754633AbbLDCIx (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 3 Dec 2015 21:08:53 -0500
Subject: Re: [PATCH v2 0/5] Make btrfs-progs really compatible with any kernel
 version
To: <bo.li.liu@oracle.com>, <dsterba@suse.cz>
References: <1448283378-10579-1-git-send-email-anand.jain@oracle.com>
 <20151123175608.GI31035@twin.jikos.cz>
 <20151204014402.GF19589@localhost.localdomain>
CC: Anand Jain <anand.jain@oracle.com>, <linux-btrfs@vger.kernel.org>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <5660F5A3.3080409@cn.fujitsu.com>
Date: Fri, 4 Dec 2015 10:08:35 +0800
MIME-Version: 1.0
In-Reply-To: <20151204014402.GF19589@localhost.localdomain>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Liu Bo wrote on 2015/12/03 17:44 -0800:
> On Mon, Nov 23, 2015 at 06:56:09PM +0100, David Sterba wrote:
>> On Mon, Nov 23, 2015 at 08:56:13PM +0800, Anand Jain wrote:
>>> Btrfs-progs is a tool for the btrfs kernel and we hope latest btrfs-progs
>>> be compatible w any set of older/newer kernels.
>>>
>>> So far mkfs.btrfs and btrfs-convert sets the default features, for eg,
>>> skinny-metadata even if the running kernel does not supports it, and
>>> so the mount fails on the running.
>>
>> So the default behaviour of mkfs will try to best guess the feature set
>> of currently running kernel. I think this is is the most common scenario
>> and justifies the change in default behaviours.
>>
>> For the other cases I'd like to introduce some human-readable shortcuts
>> to the --features option. Eg. 'mkfs.btrfs -O compat-3.2' will pick all
>> options supported by the unpatched mainline kernel of version 3.2. This
>> would be present for all version, regardless if there was a change in the
>> options or not.
>>
>> Similarly for convenience, add 'running' that would pick the options
>> from running kernel but will be explicit.
>>
>> A remaining option should override the 'running' behaviour and pick the
>> latest mkfs options. Naming it 'defaults' sounds a bit ambiguous so the
>> name is yet to be determined.
>>
>>> Here in this set of patches will make sure the progs understands the
>>> kernel supported features.
>>>
>>> So in this patch, checks if sysfs tells whether the feature is
>>> supported if not, then it will relay on static kernel version which
>>> provided that feature (skinny-metadata here in this example), next
>>> if for some reason the running kernel does not provide the kernel
>>> version, then it will fall back to the original method to enable
>>> the feature with a hope that kernel will support it.
>>>
>>> Also the last patch adds a warning when we fail to read either
>>> sysfs features or the running kernel version.
>>
>> Your patchset is a good start, the additional options I've described can
>> be added on top of that. We might need to switch the version
>> representation from string to KERNEL_VERSION but that's an
>> implementation detail.
>
> Depending on sysfs is stable but depending on kernel version may be not,
> we may have a distro kernel which backports some incompat features from
> upstream, then we have to decide based on sysfs interface.

+1.

Although sysfs does not always show up even for supported kernel, e.g 
btrfs modules is not loaded after boot.
So we need to consider twice before choosing a fallback method.

>
> However, this brings another problems, for very old kernels, they don't
> have sysfs, do you have any suggestions for that?

Other fs, like xfs/ext* doesn't even have sysfs feature interface, only 
release announcement mentioning default behavior change.
And I don't see many users complaining about it.

Here is the example of xfsprogs changed its default feature recently:
In 10th, June, 2015, xfsprogs v3.2.3 is released, with new default 
feature of enabling CRC for fs.
The first supported kernel is 3.15, which is release in 8th Jun, 2014.
Almost one year ago.

On the other hand, the sysfs feature is introduced at the end of year 2013.
It's already over 2 years.

So just forgot the extra minor case of super old kernel would be good 
enough.

Thanks,
Qu

>
> Thanks,
>
> -liubo
>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>


