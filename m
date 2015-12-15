Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:21201 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932999AbbLOAfH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 14 Dec 2015 19:35:07 -0500
Subject: Re: [PATCH v2 1/2] btrfs: Enhance super validation check
To: <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>
References: <1449560158-32577-1-git-send-email-quwenruo@cn.fujitsu.com>
 <20151214162441.GL4227@twin.jikos.cz>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <566F601C.1070907@cn.fujitsu.com>
Date: Tue, 15 Dec 2015 08:34:36 +0800
MIME-Version: 1.0
In-Reply-To: <20151214162441.GL4227@twin.jikos.cz>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



David Sterba wrote on 2015/12/14 17:24 +0100:
> On Tue, Dec 08, 2015 at 03:35:57PM +0800, Qu Wenruo wrote:
>> @@ -4005,31 +3989,47 @@ static int btrfs_check_super_valid(struct btrfs_fs_info *fs_info,
>>   	}
>>
>>   	/*
>> -	 * The common minimum, we don't know if we can trust the nodesize/sectorsize
>> -	 * items yet, they'll be verified later. Issue just a warning.
>> +	 * Check sectorsize and nodesize first, some other check will need it.
>> +	 * XXX: Just do a favor for later subpage size check. Check all
>
> Same as in v1: Please do not add new XXX or TODO markers to the sources.
> The comment would be fine with just:
>
> 	 "Check all possible sectorsizes (4K, 8K, 16K, 32K, 64K) here."
>
> With that fixed,
>
> Reviewed-by: David Sterba <dsterba@suse.com>
>
>
Oh, sorry, forgot to modify this, I'll update it soon.

Thanks,
Qu


