Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:14705 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751513AbcERA6C (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 May 2016 20:58:02 -0400
Subject: Re: [PATCH v10 10/21] btrfs: try more times to alloc metadata reserve
 space
To: <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>,
        Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
References: <1459492512-31435-1-git-send-email-quwenruo@cn.fujitsu.com>
 <1459492512-31435-11-git-send-email-quwenruo@cn.fujitsu.com>
 <20160517132016.GQ511@twin.jikos.cz>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <1d41a47f-4b2c-e7a8-f0bb-86386eb7f0f8@cn.fujitsu.com>
Date: Wed, 18 May 2016 08:57:59 +0800
MIME-Version: 1.0
In-Reply-To: <20160517132016.GQ511@twin.jikos.cz>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



David Sterba wrote on 2016/05/17 15:20 +0200:
> On Fri, Apr 01, 2016 at 02:35:01PM +0800, Qu Wenruo wrote:
>> @@ -5815,6 +5817,23 @@ out_fail:
>>  	}
>>  	if (delalloc_lock)
>>  		mutex_unlock(&BTRFS_I(inode)->delalloc_mutex);
>> +	/*
>> +	 * The number of metadata bytes is calculated by the difference
>> +	 * between outstanding_extents and reserved_extents. Sometimes though
>> +	 * reserve_metadata_bytes() fails to reserve the wanted metadata bytes,
>> +	 * indeed it has already done some work to reclaim metadata space, hence
>> +	 * both outstanding_extents and reserved_extents would have changed and
>> +	 * the bytes we try to reserve would also has changed(may be smaller).
>> +	 * So here we try to reserve again. This is much useful for online
>> +	 * dedupe, which will easily eat almost all meta space.
>> +	 *
>> +	 * XXX: Indeed here 3 is arbitrarily choosed, it's a good workaround for
>> +	 * online dedupe, later we should find a better method to avoid dedupe
>> +	 * enospc issue.
>> +	 */
>> +	if (unlikely(ret == -ENOSPC && loops++ < 3))
>> +		goto again;
>> +
>
> This does not seem right and needs to be addressed properly before I
> consider adding the patchset to for-next. I don't have idea how to fix
> it.
>
>
Right, the code is bad, just as Josef pointed out.

In fact this behavior really hides a lot of ENOSPC problem and shows 
quite a lot original metadata reserve limitation of current code.
(Mostly hidden by the default 128M max extent size)

We are actively debugging and testing new root fix for the problem.

Thanks,
Qu


