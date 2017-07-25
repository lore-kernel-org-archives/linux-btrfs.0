Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:54869 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755981AbdGYBEu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 24 Jul 2017 21:04:50 -0400
Subject: Re: [PATCH v14.4 01/15] btrfs: improve inode's outstanding_extents
 computation
To: Josef Bacik <josef@toxicpanda.com>, Lu Fengqi <lufq.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
References: <20170712085002.23241-1-lufq.fnst@cn.fujitsu.com>
 <20170712085002.23241-2-lufq.fnst@cn.fujitsu.com>
 <20170724200037.GA15181@destiny>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <7d64fa9f-a070-dbbf-4969-21a02bf0d549@gmx.com>
Date: Tue, 25 Jul 2017 09:04:36 +0800
MIME-Version: 1.0
In-Reply-To: <20170724200037.GA15181@destiny>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2017年07月25日 04:00, Josef Bacik wrote:
> On Wed, Jul 12, 2017 at 04:49:48PM +0800, Lu Fengqi wrote:
>> From: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
>>
>> This issue was revealed by modifying BTRFS_MAX_EXTENT_SIZE(128MB) to 64KB,
>> When modifying BTRFS_MAX_EXTENT_SIZE(128MB) to 64KB, fsstress test often
>> gets these warnings from btrfs_destroy_inode():
>> 	WARN_ON(BTRFS_I(inode)->outstanding_extents);
>> 	WARN_ON(BTRFS_I(inode)->reserved_extents);
>>
>> Simple test program below can reproduce this issue steadily.
>> Note: you need to modify BTRFS_MAX_EXTENT_SIZE to 64KB to have test,
>> otherwise there won't be such WARNING.
>> 	#include <string.h>
>> 	#include <unistd.h>
>> 	#include <sys/types.h>
>> 	#include <sys/stat.h>
>> 	#include <fcntl.h>
>>
>> 	int main(void)
>> 	{
>> 		int fd;
>> 		char buf[68 *1024];
>>
>> 		memset(buf, 0, 68 * 1024);
>> 		fd = open("testfile", O_CREAT | O_EXCL | O_RDWR);
>> 		pwrite(fd, buf, 68 * 1024, 64 * 1024);
>> 		return;
>> 	}
>>
>> When BTRFS_MAX_EXTENT_SIZE is 64KB, and buffered data range is:
>> 64KB						128K		132KB
>> |-----------------------------------------------|---------------|
>>                           64 + 4KB
>>
>> 1) for above data range, btrfs_delalloc_reserve_metadata() will reserve
>> metadata and set BTRFS_I(inode)->outstanding_extents to 2.
>> (68KB + 64KB - 1) / 64KB == 2
>>
>> Outstanding_extents: 2
>>
>> 2) then btrfs_dirty_page() will be called to dirty pages and set
>> EXTENT_DELALLOC flag. In this case, btrfs_set_bit_hook() will be called
>> twice.
>> The 1st set_bit_hook() call will set DEALLOC flag for the first 64K.
>> 64KB						128KB
>> |-----------------------------------------------|
>> 	64KB DELALLOC
>> Outstanding_extents: 2
>>
>> Set_bit_hooks() uses FIRST_DELALLOC flag to avoid re-increase
>> outstanding_extents counter.
>> So for 1st set_bit_hooks() call, it won't modify outstanding_extents,
>> it's still 2.
>>
>> Then FIRST_DELALLOC flag is *CLEARED*.
>>
>> 3) 2nd btrfs_set_bit_hook() call.
>> Because FIRST_DELALLOC have been cleared by previous set_bit_hook(),
>> btrfs_set_bit_hook() will increase BTRFS_I(inode)->outstanding_extents by
>> one, so now BTRFS_I(inode)->outstanding_extents is 3.
>> 64KB                                            128KB            132KB
>> |-----------------------------------------------|----------------|
>> 	64K DELALLOC				   4K DELALLOC
>> Outstanding_extents: 3
>>
>> But the correct outstanding_extents number should be 2, not 3.
>> The 2nd btrfs_set_bit_hook() call just screwed up this, and leads to the
>> WARN_ON().
>>
>> Normally, we can solve it by only increasing outstanding_extents in
>> set_bit_hook().
>> But the problem is for delalloc_reserve/release_metadata(), we only have
>> a 'length' parameter, and calculate in-accurate outstanding_extents.
>> If we only rely on set_bit_hook() release_metadata() will crew things up
>> as it will decrease inaccurate number.
>>
>> So the fix we use is:
>> 1) Increase *INACCURATE* outstanding_extents at delalloc_reserve_meta
>>     Just as a place holder.
>> 2) Increase *accurate* outstanding_extents at set_bit_hooks()
>>     This is the real increaser.
>> 3) Decrease *INACCURATE* outstanding_extents before returning
>>     This makes outstanding_extents to correct value.
>>
>> For 128M BTRFS_MAX_EXTENT_SIZE, due to limitation of
>> __btrfs_buffered_write(), each iteration will only handle about 2MB
>> data.
>> So btrfs_dirty_pages() won't need to handle cases cross 2 extents.
>>
> 
> NACK on this, it just makes a crappy problem harder to understand.  We need to
> stop using outstanding_extents as both a reservation thing _and_ an accurate
> count. 

Indeed, outstanding_extent is hard to understand and causing tons of 
problems.

> I'll rework this and fix the other issues related to over-reservation
> with compression.  Thanks,

Looking forward to it.

Thanks,
Qu

> 
> Josef
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
