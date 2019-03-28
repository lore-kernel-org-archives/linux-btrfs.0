Return-Path: <SRS0=ig1K=R7=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5117EC43381
	for <linux-btrfs@archiver.kernel.org>; Thu, 28 Mar 2019 12:52:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 18BA1204EC
	for <linux-btrfs@archiver.kernel.org>; Thu, 28 Mar 2019 12:52:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726173AbfC1Mwk (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 28 Mar 2019 08:52:40 -0400
Received: from mx2.suse.de ([195.135.220.15]:57768 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725779AbfC1Mwj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 28 Mar 2019 08:52:39 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id CE7A0ACAE
        for <linux-btrfs@vger.kernel.org>; Thu, 28 Mar 2019 12:52:37 +0000 (UTC)
Subject: Re: [PATCH 1/7] btrfs: Preallocate chunks in cow_file_range_async
From:   Nikolay Borisov <nborisov@suse.com>
To:     dsterba@suse.cz, linux-btrfs@vger.kernel.org
References: <20190312152030.31987-1-nborisov@suse.com>
 <20190312152030.31987-2-nborisov@suse.com>
 <20190327172308.GA29086@twin.jikos.cz>
 <04687d49-6642-54bf-1a8f-18f6b54465a0@suse.com>
Openpgp: preference=signencrypt
Autocrypt: addr=nborisov@suse.com; prefer-encrypt=mutual; keydata=
 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
Message-ID: <7dedd732-b3dd-8b2c-c6f5-9cb63fc899d3@suse.com>
Date:   Thu, 28 Mar 2019 14:52:37 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
MIME-Version: 1.0
In-Reply-To: <04687d49-6642-54bf-1a8f-18f6b54465a0@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 28.03.19 г. 14:49 ч., Nikolay Borisov wrote:
> 
> 
> On 27.03.19 г. 19:23 ч., David Sterba wrote:
>> On Tue, Mar 12, 2019 at 05:20:24PM +0200, Nikolay Borisov wrote:
>>> @@ -1190,45 +1201,71 @@ static int cow_file_range_async(struct inode *inode, struct page *locked_page,
>>>  				unsigned int write_flags)
>>>  {
>>>  	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
>>> -	struct async_cow *async_cow;
>>> +	struct async_cow *ctx;
>>> +	struct async_chunk *async_chunk;
>>>  	unsigned long nr_pages;
>>>  	u64 cur_end;
>>> +	u64 num_chunks = DIV_ROUND_UP(end - start, SZ_512K);
>>> +	int i;
>>> +	bool should_compress;
>>>  
>>>  	clear_extent_bit(&BTRFS_I(inode)->io_tree, start, end, EXTENT_LOCKED,
>>>  			 1, 0, NULL);
>>> -	while (start < end) {
>>> -		async_cow = kmalloc(sizeof(*async_cow), GFP_NOFS);
>>> -		BUG_ON(!async_cow); /* -ENOMEM */
>>> +
>>> +	if (BTRFS_I(inode)->flags & BTRFS_INODE_NOCOMPRESS &&
>>> +	    !btrfs_test_opt(fs_info, FORCE_COMPRESS)) {
>>> +		num_chunks = 1;
>>> +		should_compress = false;
>>> +	} else {
>>> +		should_compress = true;
>>> +	}
>>> +
>>> +	ctx = kmalloc(struct_size(ctx, chunks, num_chunks), GFP_NOFS);
>>
>> This leads to OOM due to high order allocation. And this is worse than
>> the previous state, where there are many small allocation that could
>> potentially fail (but most likely will not due to GFP_NOSF and size <
>> PAGE_SIZE).
>>
>> So this needs to be reworked to avoid the costly allocations or reverted
>> to the previous state.
> 
> Right, makes sense. In order to have a simplified submission logic I
> think to rework the allocation to have a loop that allocates a single
> item for every chunk or alternatively switch to using kvmalloc? I think
> the fact that vmalloced memory might not be contiguous is not critical
> for the metadata structures in this case?

Just had a quick read through gfp_mask-from-fs-io.rst:

vmalloc doesn't support GFP_NOFS semantic because there are hardcoded

GFP_KERNEL allocations deep inside the allocator which are quite
non-trivial
to fix up. That means that calling ``vmalloc`` with GFP_NOFS/GFP_NOIO is

almost always a bug. The good news is that the NOFS/NOIO semantic can be

achieved by the scope API.


> 
>>
>> btrfs/138               [19:44:05][ 4034.368157] run fstests btrfs/138 at 2019-03-25 19:44:05
>> [ 4034.559716] BTRFS: device fsid 9300f07a-78f4-4ac6-8376-1a902ef26830 devid 1 transid 5 /dev/vdb
>> [ 4034.573670] BTRFS info (device vdb): disk space caching is enabled
>> [ 4034.575068] BTRFS info (device vdb): has skinny extents
>> [ 4034.576258] BTRFS info (device vdb): flagging fs with big metadata feature
>> [ 4034.580226] BTRFS info (device vdb): checking UUID tree
>> [ 4066.104734] BTRFS info (device vdb): disk space caching is enabled
>> [ 4066.108558] BTRFS info (device vdb): has skinny extents
>> [ 4066.186856] BTRFS info (device vdb): setting 8 feature flag
>> [ 4074.017307] BTRFS info (device vdb): disk space caching is enabled
>> [ 4074.019646] BTRFS info (device vdb): has skinny extents
>> [ 4074.065117] BTRFS info (device vdb): setting 16 feature flag
>> [ 4075.787401] kworker/u8:12: page allocation failure: order:4, mode:0x604040(GFP_NOFS|__GFP_COMP), nodemask=(null)
>> [ 4075.789581] CPU: 0 PID: 31258 Comm: kworker/u8:12 Not tainted 5.0.0-rc8-default+ #524
>> [ 4075.791235] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.12.0-0-ga698c89-prebuilt.qemu.org 04/01/2014
>> [ 4075.793334] Workqueue: writeback wb_workfn (flush-btrfs-718)
>> [ 4075.794455] Call Trace:
>> [ 4075.795029]  dump_stack+0x67/0x90
>> [ 4075.795756]  warn_alloc.cold.131+0x73/0xf3
>> [ 4075.796601]  __alloc_pages_slowpath+0xa0e/0xb50
>> [ 4075.797595]  ? __wake_up_common_lock+0x89/0xc0
>> [ 4075.798558]  __alloc_pages_nodemask+0x2bd/0x310
>> [ 4075.799537]  kmalloc_order+0x14/0x60
>> [ 4075.800382]  kmalloc_order_trace+0x1d/0x120
>> [ 4075.801341]  btrfs_run_delalloc_range+0x3e6/0x4b0 [btrfs]
>> [ 4075.802344]  writepage_delalloc+0xf8/0x150 [btrfs]
>> [ 4075.802991]  __extent_writepage+0x113/0x420 [btrfs]
>> [ 4075.803640]  extent_write_cache_pages+0x2a6/0x400 [btrfs]
>> [ 4075.804340]  extent_writepages+0x52/0xa0 [btrfs]
>> [ 4075.804951]  do_writepages+0x3e/0xe0
>> [ 4075.805480]  ? writeback_sb_inodes+0x133/0x550
>> [ 4075.806406]  __writeback_single_inode+0x54/0x640
>> [ 4075.807315]  writeback_sb_inodes+0x204/0x550
>> [ 4075.808112]  __writeback_inodes_wb+0x5d/0xb0
>> [ 4075.808692]  wb_writeback+0x337/0x4a0
>> [ 4075.809207]  wb_workfn+0x3a7/0x590
>> [ 4075.809849]  process_one_work+0x246/0x610
>> [ 4075.810665]  worker_thread+0x3c/0x390
>> [ 4075.811415]  ? rescuer_thread+0x360/0x360
>> [ 4075.812293]  kthread+0x116/0x130
>> [ 4075.812965]  ? kthread_create_on_node+0x60/0x60
>> [ 4075.813870]  ret_from_fork+0x24/0x30
>> [ 4075.814664] Mem-Info:
>> [ 4075.815167] active_anon:2942 inactive_anon:15105 isolated_anon:0
>> [ 4075.815167]  active_file:2749 inactive_file:454876 isolated_file:0
>> [ 4075.815167]  unevictable:0 dirty:68316 writeback:0 unstable:0
>> [ 4075.815167]  slab_reclaimable:5500 slab_unreclaimable:6458
>> [ 4075.815167]  mapped:940 shmem:15483 pagetables:51 bounce:0
>> [ 4075.815167]  free:7068 free_pcp:297 free_cma:0
>> [ 4075.823236] Node 0 active_anon:11768kB inactive_anon:60420kB active_file:10996kB inactive_file:1827676kB unevictable:0kB isolated(anon):0kB isolated(file):0kB mapped:3760kB dirty:277360kB writeback:0kB shmem:61932kB writeback_tmp:0kB unstable:0kB all_unreclaimable? no
>> [ 4075.828200] Node 0 DMA free:7860kB min:44kB low:56kB high:68kB active_anon:0kB inactive_anon:4kB active_file:0kB inactive_file:8012kB unevictable:0kB writepending:0kB present:15992kB managed:15908kB mlocked:0kB kernel_stack:0kB pagetables:0kB bounce:0kB free_pcp:0kB local_pcp:0kB free_cma:0kB
>> [ 4075.834484] lowmem_reserve[]: 0 1955 1955 1955
>> [ 4075.835419] Node 0 DMA32 free:11292kB min:5632kB low:7632kB high:9632kB active_anon:11768kB inactive_anon:60416kB active_file:10996kB inactive_file:1820532kB unevictable:0kB writepending:281184kB present:2080568kB managed:2009324kB mlocked:0kB kernel_stack:1984kB pagetables:204kB bounce:0kB free_pcp:132kB local_pcp:0kB free_cma:0k 
>> [ 4075.841848] lowmem_reserve[]: 0 0 0 0
>> [ 4075.842677] Node 0 DMA: 1*4kB (U) 2*8kB (U) 4*16kB (UME) 5*32kB (UME) 1*64kB (E) 3*128kB (UME) 2*256kB (UE) 1*512kB (E) 2*1024kB (UE) 2*2048kB (ME) 0*4096kB = 7860kB
>> [ 4075.844961] Node 0 DMA32: 234*4kB (UME) 238*8kB (UME) 426*16kB (UM) 43*32kB (UM) 28*64kB (UM) 11*128kB (UM) 0*256kB 0*512kB 0*1024kB 1*2048kB (H) 0*4096kB = 16280kB
>> [ 4075.847915] Node 0 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=2048kB
>> [ 4075.849266] 474599 total pagecache pages
>> [ 4075.850058] 0 pages in swap cache
>> [ 4075.850808] Swap cache stats: add 0, delete 0, find 0/0
>> [ 4075.851990] Free swap  = 0kB
>> [ 4075.852811] Total swap = 0kB
>> [ 4075.853635] 524140 pages RAM
>> [ 4075.854351] 0 pages HighMem/MovableOnly
>> [ 4075.855048] 17832 pages reserved
>>
