Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:48784 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965255AbbLOShF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 15 Dec 2015 13:37:05 -0500
Subject: Re: Btrfs: check for empty bitmap list in setup_cluster_bitmaps
To: Chris Mason <clm@fb.com>, Btrfs mailing list <linux-btrfs@vger.kernel.org>,
        Andrey Ryabinin <ryabinin.a.a@gmail.com>, Dave Jones <dsj@fb.com>
References: <20151215170827.GA6322@ret.masoncoding.com>
From: Josef Bacik <jbacik@fb.com>
Message-ID: <56705DCD.1060500@fb.com>
Date: Tue, 15 Dec 2015 13:37:01 -0500
MIME-Version: 1.0
In-Reply-To: <20151215170827.GA6322@ret.masoncoding.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 12/15/2015 12:08 PM, Chris Mason wrote:
> Dave Jones found a warning from kasan in setup_cluster_bitmaps()
>
> ==================================================================
> BUG: KASAN: stack-out-of-bounds in setup_cluster_bitmap+0xc4/0x5a0 at
> addr ffff88039bef6828
> Read of size 8 by task nfsd/1009
> page:ffffea000e6fbd80 count:0 mapcount:0 mapping:          (null)
> index:0x0
> flags: 0x8000000000000000()
> page dumped because: kasan: bad access detected
> CPU: 1 PID: 1009 Comm: nfsd Tainted: G        W
> 4.4.0-rc3-backup-debug+ #1
> ffff880065647b50 000000006bb712c2 ffff88039bef6640 ffffffffa680a43e
> 0000004559c00000 ffff88039bef66c8 ffffffffa62638d1 ffffffffa61121c0
> ffff8803a5769de8 0000000000000296 ffff8803a5769df0 0000000000046280
> Call Trace:
> [<ffffffffa680a43e>] dump_stack+0x4b/0x6d
> [<ffffffffa62638d1>] kasan_report_error+0x501/0x520
> [<ffffffffa61121c0>] ? debug_show_all_locks+0x1e0/0x1e0
> [<ffffffffa6263948>] kasan_report+0x58/0x60
> [<ffffffffa6814b00>] ? rb_last+0x10/0x40
> [<ffffffffa66f8af4>] ? setup_cluster_bitmap+0xc4/0x5a0
> [<ffffffffa6262ead>] __asan_load8+0x5d/0x70
> [<ffffffffa66f8af4>] setup_cluster_bitmap+0xc4/0x5a0
> [<ffffffffa66f675a>] ? setup_cluster_no_bitmap+0x6a/0x400
> [<ffffffffa66fcd16>] btrfs_find_space_cluster+0x4b6/0x640
> [<ffffffffa66fc860>] ? btrfs_alloc_from_cluster+0x4e0/0x4e0
> [<ffffffffa66fc36e>] ? btrfs_return_cluster_to_free_space+0x9e/0xb0
> [<ffffffffa702dc37>] ? _raw_spin_unlock+0x27/0x40
> [<ffffffffa666a1a1>] find_free_extent+0xba1/0x1520
>
> Andrey noticed this was because we were doing list_first_entry on a list
> that might be empty.  Rework the tests a bit so we don't do that.
>
> Signed-off-by: Chris Mason <clm@fb.com>
> Reprorted-by: Andrey Ryabinin <ryabinin.a.a@gmail.com>
> Reported-by:  Dave Jones <dsj@fb.com>
>
> diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
> index 0948d34..e6fc7d9 100644
> --- a/fs/btrfs/free-space-cache.c
> +++ b/fs/btrfs/free-space-cache.c
> @@ -2972,7 +2972,7 @@ setup_cluster_bitmap(struct btrfs_block_group_cache *block_group,
>   		     u64 cont1_bytes, u64 min_bytes)
>   {
>   	struct btrfs_free_space_ctl *ctl = block_group->free_space_ctl;
> -	struct btrfs_free_space *entry;
> +	struct btrfs_free_space *entry = NULL;
>   	int ret = -ENOSPC;
>   	u64 bitmap_offset = offset_to_bitmap(ctl, offset);
>
> @@ -2983,8 +2983,10 @@ setup_cluster_bitmap(struct btrfs_block_group_cache *block_group,
>   	 * The bitmap that covers offset won't be in the list unless offset
>   	 * is just its start offset.
>   	 */

Just above this we have a if (ctl->total_bitmaps == 0) return NULL; 
check that should make this useless, which means we're screwing up our 
ctl->total_bitmaps counter somehow.  We should probably figure out why 
that is happening.  Thanks,

Josef
