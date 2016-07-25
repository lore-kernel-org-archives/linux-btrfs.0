Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:35878 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753607AbcGYSLd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Jul 2016 14:11:33 -0400
Subject: Re: [PATCH v2 3/4] btrfs: update btrfs_space_info's bytes_may_use
 timely
To: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>, <linux-btrfs@vger.kernel.org>
References: <20160725075141.5712-1-wangxg.fnst@cn.fujitsu.com>
 <20160725075141.5712-4-wangxg.fnst@cn.fujitsu.com>
CC: <dsterba@suse.cz>, <holger@applied-asynchrony.com>
From: Josef Bacik <jbacik@fb.com>
Message-ID: <babf31f7-5ebb-70b5-b6f8-38a3206d0926@fb.com>
Date: Mon, 25 Jul 2016 14:10:27 -0400
MIME-Version: 1.0
In-Reply-To: <20160725075141.5712-4-wangxg.fnst@cn.fujitsu.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 07/25/2016 03:51 AM, Wang Xiaoguang wrote:
> This patch can fix some false ENOSPC errors, below test script can
> reproduce one false ENOSPC error:
> 	#!/bin/bash
> 	dd if=/dev/zero of=fs.img bs=$((1024*1024)) count=128
> 	dev=$(losetup --show -f fs.img)
> 	mkfs.btrfs -f -M $dev
> 	mkdir /tmp/mntpoint
> 	mount $dev /tmp/mntpoint
> 	cd /tmp/mntpoint
> 	xfs_io -f -c "falloc 0 $((64*1024*1024))" testfile
>
> Above script will fail for ENOSPC reason, but indeed fs still has free
> space to satisfy this request. Please see call graph:
> btrfs_fallocate()
> |-> btrfs_alloc_data_chunk_ondemand()
> |   bytes_may_use += 64M
> |-> btrfs_prealloc_file_range()
>     |-> btrfs_reserve_extent()
>         |-> btrfs_add_reserved_bytes()
>         |   alloc_type is RESERVE_ALLOC_NO_ACCOUNT, so it does not
>         |   change bytes_may_use, and bytes_reserved += 64M. Now
>         |   bytes_may_use + bytes_reserved == 128M, which is greater
>         |   than btrfs_space_info's total_bytes, false enospc occurs.
>         |   Note, the bytes_may_use decrease operation will be done in
>         |   end of btrfs_fallocate(), which is too late.
>
> Here is another simple case for buffered write:
>                     CPU 1              |              CPU 2
>                                        |
> |-> cow_file_range()                   |-> __btrfs_buffered_write()
>     |-> btrfs_reserve_extent()         |   |
>     |                                  |   |
>     |                                  |   |
>     |    .....                         |   |-> btrfs_check_data_free_space()
>     |                                  |
>     |                                  |
>     |-> extent_clear_unlock_delalloc() |
>
> In CPU 1, btrfs_reserve_extent()->find_free_extent()->
> btrfs_add_reserved_bytes() do not decrease bytes_may_use, the decrease
> operation will be delayed to be done in extent_clear_unlock_delalloc().
> Assume in this case, btrfs_reserve_extent() reserved 128MB data, CPU2's
> btrfs_check_data_free_space() tries to reserve 100MB data space.
> If
> 	100MB > data_sinfo->total_bytes - data_sinfo->bytes_used -
> 		data_sinfo->bytes_reserved - data_sinfo->bytes_pinned -
> 		data_sinfo->bytes_readonly - data_sinfo->bytes_may_use
> btrfs_check_data_free_space() will try to allcate new data chunk or call
> btrfs_start_delalloc_roots(), or commit current transaction in order to
> reserve some free space, obviously a lot of work. But indeed it's not
> necessary as long as decreasing bytes_may_use timely, we still have
> free space, decreasing 128M from bytes_may_use.
>
> To fix this issue, this patch chooses to update bytes_may_use for both
> data and metadata in btrfs_add_reserved_bytes(). For compress path, real
> extent length may not be equal to file content length, so introduce a
> ram_bytes argument for btrfs_reserve_extent(), find_free_extent() and
> btrfs_add_reserved_bytes(), it's becasue bytes_may_use is increased by
> file content length. Then compress path can update bytes_may_use
> correctly. Also now we can discard RESERVE_ALLOC_NO_ACCOUNT, RESERVE_ALLOC
> and RESERVE_FREE.
>
> As we know, usually EXTENT_DO_ACCOUNTING is used for error path. In
> run_delalloc_nocow(), for inode marked as NODATACOW or extent marked as
> PREALLOC, we also need to update bytes_may_use, but can not pass
> EXTENT_DO_ACCOUNTING, because it also clears metadata reservation, so
> here we introduce EXTENT_CLEAR_DATA_RESV flag to indicate btrfs_clear_bit_hook()
> to update btrfs_space_info's bytes_may_use.
>
> Meanwhile __btrfs_prealloc_file_range() will call
> btrfs_free_reserved_data_space() internally for both sucessful and failed
> path, btrfs_prealloc_file_range()'s callers does not need to call
> btrfs_free_reserved_data_space() any more.
>
> Signed-off-by: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
> ---

Sigh sorry, baby kept me up most of the night, that should be

Reviewed-by: Josef Bacik <jbacik@fb.com>

Thanks,

Josef

