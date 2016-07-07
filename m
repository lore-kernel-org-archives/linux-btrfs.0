Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:58495 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751504AbcGGCaD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 Jul 2016 22:30:03 -0400
Subject: Re: [PATCH 2/2] btrfs: fix false ENOSPC for btrfs_fallocate()
To: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>,
        <linux-btrfs@vger.kernel.org>
References: <20160706103753.4908-1-wangxg.fnst@cn.fujitsu.com>
 <20160706103753.4908-2-wangxg.fnst@cn.fujitsu.com>
 <577CF94E.1010506@applied-asynchrony.com>
CC: <dsterba@suse.cz>
From: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Message-ID: <577DBE26.7030601@cn.fujitsu.com>
Date: Thu, 7 Jul 2016 10:27:50 +0800
MIME-Version: 1.0
In-Reply-To: <577CF94E.1010506@applied-asynchrony.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

hello,

On 07/06/2016 08:27 PM, Holger Hoffstätte wrote:
> On 07/06/16 12:37, Wang Xiaoguang wrote:
>> Below test scripts can reproduce this false ENOSPC:
>> 	#!/bin/bash
>> 	dd if=/dev/zero of=fs.img bs=$((1024*1024)) count=128
>> 	dev=$(losetup --show -f fs.img)
>> 	mkfs.btrfs -f -M $dev
>> 	mkdir /tmp/mntpoint
>> 	mount /dev/loop0 /tmp/mntpoint
>> 	cd mntpoint
>> 	xfs_io -f -c "falloc 0 $((40*1024*1024))" testfile
>>
>> Above fallocate(2) operation will fail for ENOSPC reason, but indeed
>> fs still has free space to satisfy this request. The reason is
>> btrfs_fallocate() dose not decrease btrfs_space_info's bytes_may_use
>> just in time, and it calls btrfs_free_reserved_data_space_noquota() in
>> the end of btrfs_fallocate(), which is too late and have already added
>> false unnecessary pressure to enospc system. See call graph:
>> btrfs_fallocate()
>> |-> btrfs_alloc_data_chunk_ondemand()
>>      It will add btrfs_space_info's bytes_may_use accordingly.
>> |-> btrfs_prealloc_file_range()
>>      It will call btrfs_reserve_extent(), but note that alloc type is
>>      RESERVE_ALLOC_NO_ACCOUNT, so btrfs_update_reserved_bytes() will
>>      only increase btrfs_space_info's bytes_reserved accordingly, but
>>      will not decrease btrfs_space_info's bytes_may_use, then obviously
>>      we have overestimated real needed disk space, and it'll impact
>>      other processes who do write(2) or fallocate(2) operations, also
>>      can impact metadata reservation in mixed mode, and bytes_max_use
>>      will only be decreased in the end of btrfs_fallocate(). To fix
>>      this false ENOSPC, we need to decrease btrfs_space_info's
>>      bytes_may_use in btrfs_prealloc_file_range() in time, as what we
>>      do in cow_file_range(),
>>      See call graph in :
>>      cow_file_range()
>>      |-> extent_clear_unlock_delalloc()
>>          |-> clear_extent_bit()
>>              |-> btrfs_clear_bit_hook()
>>                  |-> btrfs_free_reserved_data_space_noquota()
>>                      This function will decrease bytes_may_use accordingly.
>>
>> So this patch choose to call btrfs_free_reserved_data_space() in
>> __btrfs_prealloc_file_range() for both successful and failed path.
>>
>> Also this patch removes some old and useless comments.
>>
>> Signed-off-by: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
> Verified that the reproducer script indeed fails (with btrfs ~4.7) and
> the patch (on top of 1/2) fixes it. Also ran a bunch of other fallocating
> things without problem. Free space also still seems sane, as far as I
> could tell.
>
> So for both patches:
>
> Tested-by: Holger Hoffstätte <holger@applied-asynchrony.com>
Thanks very much :)

Regards,
Xiaoguang Wang

>
> cheers,
> Holger
>
>
>



