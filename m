Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:54730 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932621AbcKVS7W (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 22 Nov 2016 13:59:22 -0500
Subject: Re: [PATCH] btrfs: raid56: Use correct stolen pages to calculate P/Q
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, <linux-btrfs@vger.kernel.org>
References: <20161121085016.7148-1-quwenruo@cn.fujitsu.com>
CC: <kreijack@inwind.it>, <ce3g8jdj@umail.furryterror.org>
From: Chris Mason <clm@fb.com>
Message-ID: <fd6f5be1-9f18-2311-403b-06bfd7abd28d@fb.com>
Date: Tue, 22 Nov 2016 13:58:35 -0500
MIME-Version: 1.0
In-Reply-To: <20161121085016.7148-1-quwenruo@cn.fujitsu.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 11/21/2016 03:50 AM, Qu Wenruo wrote:
> In the following situation, scrub will calculate wrong parity to
> overwrite correct one:
>
> RAID5 full stripe:
>
> Before
> |     Dev 1      |     Dev  2     |     Dev 3     |
> | Data stripe 1  | Data stripe 2  | Parity Stripe |
> --------------------------------------------------- 0
> | 0x0000 (Bad)   |     0xcdcd     |     0x0000    |
> --------------------------------------------------- 4K
> |     0xcdcd     |     0xcdcd     |     0x0000    |
> ...
> |     0xcdcd     |     0xcdcd     |     0x0000    |
> --------------------------------------------------- 64K
>
> After scrubbing dev3 only:
>
> |     Dev 1      |     Dev  2     |     Dev 3     |
> | Data stripe 1  | Data stripe 2  | Parity Stripe |
> --------------------------------------------------- 0
> | 0xcdcd (Good)  |     0xcdcd     | 0xcdcd (Bad)  |
> --------------------------------------------------- 4K
> |     0xcdcd     |     0xcdcd     |     0x0000    |
> ...
> |     0xcdcd     |     0xcdcd     |     0x0000    |
> --------------------------------------------------- 64K
>
> The calltrace of such corruption is as following:
>
> scrub_bio_end_io_worker() get called for each extent read out
> |- scriub_block_complete()
>    |- Data extent csum mismatch
>    |- scrub_handle_errored_block
>       |- scrub_recheck_block()
>          |- scrub_submit_raid56_bio_wait()
>             |- raid56_parity_recover()
>
> Now we have a rbio with correct data stripe 1 recovered.
> Let's call it "good_rbio".
>
> scrub_parity_check_and_repair()
> |- raid56_parity_submit_scrub_rbio()
>    |- lock_stripe_add()
>    |  |- steal_rbio()
>    |     |- Recovered data are steal from "good_rbio", stored into
>    |        rbio->stripe_pages[]
>    |        Now rbio->bio_pages[] are bad data read from disk.
>    |- async_scrub_parity()
>       |- scrub_parity_work() (delayed_call to scrub_parity_work)
>
> scrub_parity_work()
> |- raid56_parity_scrub_stripe()
>    |- validate_rbio_for_parity_scrub()
>       |- finish_parity_scrub()
>          |- Recalculate parity using *BAD* pages in rbio->bio_pages[]
>             So good parity is overwritten with *BAD* one
>
> The fix is to introduce 2 new members, bad_ondisk_a/b, to struct
> btrfs_raid_bio, to info scrub code to use correct data pages to
> re-calculate parity.
>
> Reported-by: Goffredo Baroncelli <kreijack@inwind.it>
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
> ---
> Thanks to the above hell of delayed function all and damn stupid code
> logical, such bug is quite hard to trace.
>
> The damn kernel scrub is already multi-thread, why do such meaningless
> delayed function call again and again?
>
> What's wrong with single thread scrub?
> We can do thing like in each stripe for raid56 which is easy and
> straightforward, only delayed thing is to wake up waiter:
>
> 	lock_full_stripe()
> 	if (!is_parity_stripe()) {
> 		prepare_data_stripe_bios()
> 		submit_and_wait_bios()
> 		if (check_csum() == 0)
> 			goto out;
> 	}
> 	prepare_full_stripe_bios()
> 	submit_and_wait_bios()
>
> 	recover_raid56_stipres();
> 	prepare_full_stripe_write_bios()
> 	submit_and_wait_bios()
>
> out:
>   	unlock_full_stripe()
>
> We really need to re-work the whole damn scrub code.
>
> Also, we need to enhance btrfs-progs to detect scrub problem(my
> submitted offline scrub is good enough for such usage), and tools to
> corrupt extents reliably to put it into xfstests test cases.
>
> RAID56 scrub code is neither tested nor well-designed.

Great description, thanks for tracking this down.

> @@ -2352,7 +2370,16 @@ static noinline void finish_parity_scrub(struct btrfs_raid_bio *rbio,
>  		void *parity;
>  		/* first collect one page from each data stripe */
>  		for (stripe = 0; stripe < nr_data; stripe++) {
> -			p = page_in_rbio(rbio, stripe, pagenr, 0);
> +
> +			/*
> +			 * Use stolen recovered page other than bad
> +			 * on disk pages
> +			 */
> +			if (stripe == rbio->bad_ondisk_a ||
> +			    stripe == rbio->bad_ondisk_b)
> +				p = rbio_stripe_page(rbio, stripe, pagenr);
> +			else
> +				p = page_in_rbio(rbio, stripe, pagenr, 0);
>  			pointers[stripe] = kmap(p);
>  		}
>
>

We're changing which pages we kmap() but not which ones we kunmap(). 
Can you please update the kunmap loop to use this pointers array?  Also 
it looks like this kmap is never unmapped.

pointers[stripe++] = kmap(q_page);

-chris
