Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:44276 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751513AbcERAyg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 May 2016 20:54:36 -0400
Subject: Re: [PATCH v10 11/21] btrfs: dedupe: Add ioctl for inband
 dedupelication
To: <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>,
        Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>,
        David Sterba <dsterba@suse.com>
References: <1459492512-31435-1-git-send-email-quwenruo@cn.fujitsu.com>
 <1459492512-31435-12-git-send-email-quwenruo@cn.fujitsu.com>
 <8321f238-764e-d833-969f-e3d09723371a@cn.fujitsu.com>
 <20160517131420.GO511@twin.jikos.cz>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <bcdb32dc-37b5-4c11-86d6-d78aa5f5e6c1@cn.fujitsu.com>
Date: Wed, 18 May 2016 08:54:31 +0800
MIME-Version: 1.0
In-Reply-To: <20160517131420.GO511@twin.jikos.cz>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



David Sterba wrote on 2016/05/17 15:14 +0200:
> On Wed, Apr 27, 2016 at 09:29:29AM +0800, Qu Wenruo wrote:
>>> @@ -5542,6 +5606,10 @@ long btrfs_ioctl(struct file *file, unsigned int
>>>  		return btrfs_ioctl_get_fslabel(file, argp);
>>>  	case BTRFS_IOC_SET_FSLABEL:
>>>  		return btrfs_ioctl_set_fslabel(file, argp);
>>
>> Would you mind me to add a new kernel config "Btrfs experimental
>> features-> dedupe ioctl" for case like dedupe and further experimental
>> btrfs features?
>>
>> The BTRFS_DEBUG seems quite odd for me.
>> Although in-band dedupe is quite good at exposing bugs of
>> backref/qgroup/delayed_refs, but I still think it's not a debug tool.
>>
>> So I hope to use "BTRFS_EXPERIMENTAL_DEDUPE_IOCTL" and add corresponding
>> Kconfig interfaces.
>
> The point was not to add new config options, but if you find _DEBUG odd
> we can rethink the "hide it under config option" approach. The alternate
> way is to get the code into a good shape and add it to for-next. I don't
> want to track yet another set of branches with the too experimental
> stuff.

OK, I'll try the alternative method, make the code into good shape for 
in-memory backend.

As for the ioctl interface, I'll post some ideas on this to wiki and 
hopes we can get a good solution for it.

Like adding new 'force' flag, to make 'enable --force' to be stateless, 
and without that flag, go to normal enable/config stateful method.

Just going completely stateful method is still another alternative though.

Thanks,
Qu


