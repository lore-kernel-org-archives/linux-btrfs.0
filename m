Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:64648 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750808AbcCMFQp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 13 Mar 2016 00:16:45 -0500
Subject: Re: [PATCH v7 01/20] btrfs: dedup: Introduce dedup framework and its
 header
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, <dsterba@suse.cz>,
        NeilBrown <neilb@suse.com>, <linux-btrfs@vger.kernel.org>,
        <clm@fb.com>, Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
References: <1455774178-3595-1-git-send-email-quwenruo@cn.fujitsu.com>
 <1455774178-3595-2-git-send-email-quwenruo@cn.fujitsu.com>
 <87io0vjq9x.fsf@notabene.neil.brown.name> <56E0C668.4020406@cn.fujitsu.com>
 <20160311114305.GQ18908@twin.jikos.cz> <56E3D070.3020005@gmx.com>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <56E4F7AB.4010608@cn.fujitsu.com>
Date: Sun, 13 Mar 2016 13:16:27 +0800
MIME-Version: 1.0
In-Reply-To: <56E3D070.3020005@gmx.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Qu Wenruo wrote on 2016/03/12 16:16 +0800:
>
>
> On 03/11/2016 07:43 PM, David Sterba wrote:
>> On Thu, Mar 10, 2016 at 08:57:12AM +0800, Qu Wenruo wrote:
>>>> The ioctl FIDEDUPERANGE and the tool duperemove both use "dupe".
>>>> It would be nice if we could be consistent and all use the same
>>>> abbreviation.
>>>
>>> Yes, current kernel VFS level offline dedup uses the name "dedupe".
>>> But on the other hand, ZFS uses the name "dedup" for their online dedup.
>>>
>>> And personally speaking, I'd like some difference to distinguish inline
>>> dedup and offline dedup.
>>> In that case, the extra "e" seems somewhat useful.
>>> With "e", it's intended for offline use. Without "e", it's intended for
>>> online use.
>>
>> Such difference is very subtle and I think we should stick to just one
>> spelling, which shall be 'dedupe'.
>
> OK, I'll change them to 'dedupe' in next bug fix version.
>
> Thanks,
> Qu
>
>
BTW, I am always interested in, why de-duplication can be shorted as 
'dedupe'.

I didn't see any 'e' in the whole word "DUPlication".
Or it's an abbreviation of "DUPlicatE" instead of "DUPlication"?

Thanks,
Qu



