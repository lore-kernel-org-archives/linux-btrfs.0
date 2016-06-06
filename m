Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:49440 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750884AbcFFInZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 6 Jun 2016 04:43:25 -0400
Subject: Re: [PATCH 0/4] btrfs: return all mirror whether need_raid_map set or
 not
To: <dsterba@suse.cz>, Zhao Lei <zhaolei@cn.fujitsu.com>,
        <linux-btrfs@vger.kernel.org>
References: <cover.1450177455.git.zhaolei@cn.fujitsu.com>
 <20160606082139.GS29147@twin.jikos.cz>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <c64562f1-4544-35fe-7f4b-821633472689@cn.fujitsu.com>
Date: Mon, 6 Jun 2016 16:43:08 +0800
MIME-Version: 1.0
In-Reply-To: <20160606082139.GS29147@twin.jikos.cz>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 06/06/2016 04:21 PM, David Sterba wrote:
> On Tue, Dec 15, 2015 at 07:09:48PM +0800, Zhao Lei wrote:
>> __btrfs_map_block() should return all mirror on WRITE,
>> REQ_GET_READ_MIRRORS, and RECOVERY case, whether need_raid_map set
>> or not.
>>
>> need_raid_map only used to control is to set bbio->raid_map.
>>
>> Current code works right becuase there is only one caller can
>> trigger above bug, which is readahead, and this function happened
>> to bypass on less mirror.
>>
>> But after we fixed __btrfs_map_block(), readahead will be really
>> works, and exit with warning at another bug.
>> This patchset fixed __btrfs_map_block(), and disable raid56
>> readahead temp temporary, (actually, it already disable by this bug),
>> and I'll fix raid56 readahead next.
>>
>> Zhao Lei (4):
>>   btrfs: Disable raid56 readahead
>>   btrfs: return all mirror whether need_raid_map set or not
>>   btrfs: Small cleanup for get index_srcdev loop
>>   btrfs: Use direct way to determine raid56 write/recover mode
>
> Are these patches still relevant? If yes, please update and resed,
> thanks.

Hi David,

Zhao doesn't work on btrfs any more.

So I'll re-check these patches and see if they are still needed.
If so, I'll rebase (some of) them and resend.

Thanks,
Qu
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>


