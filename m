Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:61741 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750948AbcEIBbo (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 8 May 2016 21:31:44 -0400
Subject: Re: [PATCH 1/2] Btrfs: add more valid checks for superblock
To: <dsterba@suse.cz>, <bo.li.liu@oracle.com>, <linux-btrfs@vger.kernel.org>,
        <vegard.nossum@oracle.com>, <dsterba@suse.com>
References: <1462212951-28113-1-git-send-email-bo.li.liu@oracle.com>
 <9fa04dd7-13c4-6c24-dddc-4521eccea65c@cn.fujitsu.com>
 <20160504132329.GT29353@twin.jikos.cz>
 <20160504174436.GB14909@localhost.localdomain>
 <a7811da3-06f5-2ff2-06e4-19be9fd31410@cn.fujitsu.com>
 <20160506143529.GD29353@twin.jikos.cz>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <47023701-8dd4-6c38-b242-230a372890e7@cn.fujitsu.com>
Date: Mon, 9 May 2016 09:31:37 +0800
MIME-Version: 1.0
In-Reply-To: <20160506143529.GD29353@twin.jikos.cz>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



David Sterba wrote on 2016/05/06 16:35 +0200:
> On Thu, May 05, 2016 at 09:08:54AM +0800, Qu Wenruo wrote:
>>>> An early check can compare against some reasonable value, but the
>>>> total_bytes value must be equal to the sum of all device sizes
>>>> (disk_total_bytes). I'm not sure if we have enough information to verify
>>>> that at this point though.
>>>
>>> That's what I had in mind, the problem is that only the first device information is recorded in superblock.
>>>
>>> At this moment We have device_num but we don't know the size of other devices.
>>>
>>> Thanks,
>>>
>>> -liubo
>>>
>>>
>> What about error out if we found sb->total_bytes <
>> sb->dev_item->total_bytes?
>>
>> As we are just doing early check, no need to be comprehensive, but spot
>> obvious problem.
>
> Ok.
>
>> For exact device_num and sb->total_bytes, we may do post check when
>> device tree are loaded?
>> Splitting early_check() and post_check() seems valid for me.
>> (Also I prefer post_check() just warning, not forced exit)
>
> Why just warning? Superblock total_bytes and device sizes must be
> correct, otherwise all sorts of operations can fail randomly.
>
>
Because if we exit, we can't even do fsck.

Maybe we need a new flag to control whether exit or warn at post_check().

Thanks,
Qu


