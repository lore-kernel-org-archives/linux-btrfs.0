Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:40013 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754019AbcCJA52 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 9 Mar 2016 19:57:28 -0500
Subject: Re: [PATCH v7 01/20] btrfs: dedup: Introduce dedup framework and its
 header
To: NeilBrown <neilb@suse.com>, <linux-btrfs@vger.kernel.org>, <clm@fb.com>
References: <1455774178-3595-1-git-send-email-quwenruo@cn.fujitsu.com>
 <1455774178-3595-2-git-send-email-quwenruo@cn.fujitsu.com>
 <87io0vjq9x.fsf@notabene.neil.brown.name>
CC: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <56E0C668.4020406@cn.fujitsu.com>
Date: Thu, 10 Mar 2016 08:57:12 +0800
MIME-Version: 1.0
In-Reply-To: <87io0vjq9x.fsf@notabene.neil.brown.name>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



NeilBrown wrote on 2016/03/10 08:27 +1100:
> On Thu, Feb 18 2016, Qu Wenruo wrote:
>
>> +
>> +/*
>> + * Dedup storage backend
>> + * On disk is persist storage but overhead is large
>> + * In memory is fast but will lose all its hash on umount
>> + */
>> +#define BTRFS_DEDUP_BACKEND_INMEMORY		0
>> +#define BTRFS_DEDUP_BACKEND_ONDISK		1
>> +#define BTRFS_DEDUP_BACKEND_LAST		2
>
> Hi,
>
> This may seem petty, but I'm here to complain about the names. :-)

Any complaint is better than no complaint. :)

>
> Firstly, "2" is *not* the LAST backend.  The LAST backed is clearly
> "ONDISK" with is "1:.
> "2" is the number of backends, or the count of them.
> So
>> +#define BTRFS_DEDUP_BACKEND_LAST		1
>
> would be OK, as would
>
>> +#define BTRFS_DEDUP_BACKEND_COUNT		2
>
> but what you have is wrong.
>
> The place where you use this define:
>
> +	if (backend >= BTRFS_DEDUP_BACKEND_LAST)
> +		return -EINVAL;
>
> is correct, but it looks wrong.  It looks like it is saying that it is
> invalid to use the LAST backend!

Makes sense, I'll use BACKEND_COUNT as the name.

>
> Secondly, you use "dup" as an abbreviation of "duplicate".
> The ioctl FIDEDUPERANGE and the tool duperemove both use "dupe".
> It would be nice if we could be consistent and all use the same
> abbreviation.

Yes, current kernel VFS level offline dedup uses the name "dedupe".
But on the other hand, ZFS uses the name "dedup" for their online dedup.

And personally speaking, I'd like some difference to distinguish inline 
dedup and offline dedup.
In that case, the extra "e" seems somewhat useful.
With "e", it's intended for offline use. Without "e", it's intended for 
online use.

Thanks,
Qu

>
> Thanks,
> NeilBrown
>


