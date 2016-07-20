Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:4846 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752284AbcGTNWm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 Jul 2016 09:22:42 -0400
Subject: Re: [PATCH 3/4] btrfs: introduce new EXTENT_CLEAR_DATA_RESV flag
To: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>, <linux-btrfs@vger.kernel.org>
References: <20160720055637.7275-1-wangxg.fnst@cn.fujitsu.com>
 <20160720055637.7275-4-wangxg.fnst@cn.fujitsu.com>
CC: <dsterba@suse.cz>, <holger@applied-asynchrony.com>
From: Josef Bacik <jbacik@fb.com>
Message-ID: <31d80e05-5e6d-7eba-3f7c-b436bc492c16@fb.com>
Date: Wed, 20 Jul 2016 09:22:23 -0400
MIME-Version: 1.0
In-Reply-To: <20160720055637.7275-4-wangxg.fnst@cn.fujitsu.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 07/20/2016 01:56 AM, Wang Xiaoguang wrote:
> In next patch, btrfs_clear_bit_hook() will not call
> btrfs_free_reserved_data_space_noquota() to update btrfs_space_info's
> bytes_may_use unless it has EXTENT_DO_ACCOUNTING or EXTENT_CLEAR_DATA_RESV,
> as for the reason, please see the next patch for detailed info.
>
> As we know, usually EXTENT_DO_ACCOUNTING is used for error path. In
> run_delalloc_nocow(), for inode marked as NODATACOW or extent marked as
> PREALLOC, we also need to update bytes_may_use, but can not pass
> EXTENT_DO_ACCOUNTING, because it also clears metadata reservation, so here
> we introduce EXTENT_CLEAR_DATA_RESV flag to indicate btrfs_clear_bit_hook()
> to update btrfs_space_info's bytes_may_use.
>
> Signed-off-by: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>

There's no point in introducing only a flag in one patch, collapse this into the 
patch that actually uses it.  Thanks,

Josef
