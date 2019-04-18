Return-Path: <SRS0=uOHe=SU=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB69CC10F0B
	for <linux-btrfs@archiver.kernel.org>; Thu, 18 Apr 2019 06:34:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A282C214DA
	for <linux-btrfs@archiver.kernel.org>; Thu, 18 Apr 2019 06:34:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388028AbfDRGe0 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 18 Apr 2019 02:34:26 -0400
Received: from mx2.suse.de ([195.135.220.15]:48166 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725886AbfDRGe0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 18 Apr 2019 02:34:26 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 4B57CAD05
        for <linux-btrfs@vger.kernel.org>; Thu, 18 Apr 2019 06:34:24 +0000 (UTC)
Subject: Re: [PATCH] btrfs: volumes: Check memory allocation failure for
 alloc_btrfs_bio()
To:     Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20190418062807.32340-1-wqu@suse.com>
From:   Nikolay Borisov <nborisov@suse.com>
Openpgp: preference=signencrypt
Autocrypt: addr=nborisov@suse.com; prefer-encrypt=mutual; keydata=
 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
Message-ID: <32da9d6c-0870-c5a6-4b7e-11404a2663ef@suse.com>
Date:   Thu, 18 Apr 2019 09:34:23 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190418062807.32340-1-wqu@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 18.04.19 г. 9:28 ч., Qu Wenruo wrote:
> [BUG]
> With kmalloc failure injection for submit_one_bio(), btrfs can crash like:
> 
>   BUG: unable to handle kernel NULL pointer dereference at 0000000000000038
>   #PF error: [WRITE]
>   PGD 0 P4D 0
>   Oops: 0002 [#1] PREEMPT SMP PTI
>   CPU: 1 PID: 247 Comm: kworker/u8:4 Not tainted 5.1.0-rc5-custom+ #19
>   Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/2015
>   Workqueue: writeback wb_workfn (flush-btrfs-6)
>   RIP: 0010:alloc_btrfs_bio+0x1e/0x30 [btrfs]
>   Code: 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 0f 1f 44 00 00 48 63 f6 48 63 ff 48 8d 7c fe 18 be 40 8d 00 00 48 c1 e7 02 e8 a2 86 94 e0 <c7> 40 38 00 00 00 00 c7 00 01 00 00 00 c3 0f 1f 40 00 0f 1f 44 00
>   Call Trace:
>    __btrfs_map_block+0x5ce/0x1210 [btrfs]
>    ? btrfs_bio_counter_inc_blocked+0x3a/0xc0 [btrfs]
>    btrfs_map_bio+0x9a/0x430 [btrfs]
>    btree_submit_bio_hook+0x82/0xb0 [btrfs]
>    submit_one_bio+0x95/0xc0 [btrfs]
>    copy_oldmem_page_encrypted+0x20/0x20
>    ? write_one_eb+0x18f/0x2a0 [btrfs]
>    ? end_extent_buffer_writeback+0x20/0x20 [btrfs]
>    ? btree_write_cache_pages+0x12c/0x350 [btrfs]
>    ? do_writepages+0x41/0xd0
>    ? __writeback_single_inode+0x54/0x650
>    ? writeback_sb_inodes+0x1f9/0x540
>    ? __writeback_inodes_wb+0x5d/0xb0
>    ? wb_writeback+0x340/0x4b0
>    ? wb_workfn+0x410/0x5d0
>    ? process_one_work+0x294/0x650
>    ? worker_thread+0x2d/0x3d0
>    ? process_one_work+0x650/0x650
>    ? kthread+0x112/0x130
>    ? kthread_park+0x80/0x80
>    ? ret_from_fork+0x3a/0x50
>   ---[ end trace b637169fb8b17c9c ]---
> 
> [CAUSE]
> We just forgot to check the return value of kmalloc.
> Surprisingly, all alloc_btrfs_bio() callers have handled memory
> allocation pretty well.
> 

The allocation uses the GFP_NOFAIL modified, which, according to the docs:

 * The VM implementation _must_ retry infinitely: the caller
 * cannot handle allocation failures. The allocation could block

 * indefinitely but will never return with failure. Testing for

 * failure is pointless.

The allocation requested is at least 128 bytes (assuming real_stripes is
0).

96 + 24 * total_stripes + 4 * real_stripes + 8 * total_stripes

Considering this I think it might be prudent to also remove the NOFAIL
flag altogether


> [FIX]
> Check and return if we failed memory allocation.
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>

Though the change is fine:

Reviewed-by: Nikolay Borisov <nborisov@suse.com>


> ---
>  fs/btrfs/volumes.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 78bab7803bda..875d0eee1785 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -5582,6 +5582,8 @@ static struct btrfs_bio *alloc_btrfs_bio(int total_stripes, int real_stripes)
>  		sizeof(u64) * (total_stripes),
>  		GFP_NOFS|__GFP_NOFAIL);
>  
> +	if (!bbio)
> +		return NULL;
>  	atomic_set(&bbio->error, 0);
>  	refcount_set(&bbio->refs, 1);
>  
> 
