Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:34644 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750707AbcEPEI1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 16 May 2016 00:08:27 -0400
Subject: Re: problems with free space cache
To: Nicholas D Steeves <nsteeves@gmail.com>
References: <CAD=QJKjop2j+K16nPcAU-bXiCVqm_aGK0g7WxjvTpBvXar+fQQ@mail.gmail.com>
 <85030f6b-b149-ccd2-ea87-42135b9ccd46@cn.fujitsu.com>
 <CAD=QJKiT-PGSApL+GSwN3eJxLRQVFD3RyPfNi=oQ-=TdmMBPZQ@mail.gmail.com>
CC: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <471954f8-e44d-2866-fb1d-50702ffada92@cn.fujitsu.com>
Date: Mon, 16 May 2016 12:08:18 +0800
MIME-Version: 1.0
In-Reply-To: <CAD=QJKiT-PGSApL+GSwN3eJxLRQVFD3RyPfNi=oQ-=TdmMBPZQ@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Nicholas D Steeves wrote on 2016/05/15 23:02 -0400:
> On 15 May 2016 at 22:24, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
>>
>>
>> Nicholas D Steeves wrote on 2016/05/15 22:11 -0400:
>>> What is the standard procedure for fixing the cache?  Rootfs is a
>>> subvolume and the first entry in fstab.  Second entry is /btrfs-admin,
>>> which is where I mount the whole volume.  Is it sufficient to add the
>>> clear_cache option to the rootfs entry, or does the /btrfs-admin entry
>>> also need it?
>>
>>
>> IIRC clear_cache option is fs level option.
>> So the first mount with clear_cache, then all subvolume will have
>> clear_cache.
>>
>
> So that means that in this case mounting subvol=rootfs with
> clear_cache will clear the cache for all subsequently mounted
> subvolumes, and for the whole volume, correct?
>

Yes, although I'm not sure whether clear_cache will fix all the problems.
I see other guy reporting such problem but clear_cache only fixed some 
of them.

Thanks,
Qu


> Thanks,
> Nicholas
>
>


