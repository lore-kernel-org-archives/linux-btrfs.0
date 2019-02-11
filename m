Return-Path: <SRS0=aenA=QS=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8E75C169C4
	for <linux-btrfs@archiver.kernel.org>; Mon, 11 Feb 2019 07:46:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 99BE620811
	for <linux-btrfs@archiver.kernel.org>; Mon, 11 Feb 2019 07:46:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726366AbfBKHqN (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 11 Feb 2019 02:46:13 -0500
Received: from mx2.suse.de ([195.135.220.15]:35406 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725931AbfBKHqM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 11 Feb 2019 02:46:12 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 6BF52AF82
        for <linux-btrfs@vger.kernel.org>; Mon, 11 Feb 2019 07:46:11 +0000 (UTC)
Subject: Re: [RFC PATCH] btrfs: Remove __extent_readpages
To:     linux-btrfs@vger.kernel.org
References: <20181203102532.13945-1-nborisov@suse.com>
From:   Nikolay Borisov <nborisov@suse.com>
Openpgp: preference=signencrypt
Autocrypt: addr=nborisov@suse.com; prefer-encrypt=mutual; keydata=
 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
Message-ID: <50e531dd-1c4d-dc27-332d-58f7f748c5b0@suse.com>
Date:   Mon, 11 Feb 2019 09:46:10 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <20181203102532.13945-1-nborisov@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 3.12.18 г. 12:25 ч., Nikolay Borisov wrote:
> When extent_readpages is called from the generic readahead code it first
> builds a batch of 16 pages (which might or might not be consecutive,
> depending on whether add_to_page_cache_lru failed) and submits them to
> __extent_readpages. The latter ensures that the range of pages (in the
> batch of 16) that is passed to __do_contiguous_readpages is consecutive.
> 
> If add_to_page_cache_lru does't fail then __extent_readpages will call
> __do_contiguous_readpages only once with the whole batch of 16.
> Alternatively, if add_to_page_cache_lru fails once on the 8th page (as an example)
> then the contigous page read code will be called twice.
> 
> All of this can be simplified by exploiting the fact that all pages passed
> to extent_readpages are consecutive, thus when the batch is built in
> that function it is already consecutive (barring add_to_page_cache_lru
> failures) so are ready to be submitted directly to __do_contiguous_readpages.
> Also simplify the name of the function to contiguous_readpages. 
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> ---
> 
> So this patch looks like a very nice cleanup, however when doing performance 
> measurements with fio I was shocked to see that it actually is detrimental to 
> performance. Here are the results: 
> 
> The command line used for fio: 
> fio --name=/media/scratch/seqread --rw=read --direct=0 --ioengine=sync --bs=4k
>  --numjobs=1 --size=1G --runtime=600  --group_reporting --loop 10
> 
> This was tested on a vm with 4g of ram so the size of the test is smaller than 
> the memory, so pages should have been nicely readahead. 
> 
> PATCHED: 
> 
> Starting 1 process
> Jobs: 1 (f=1): [R(1)][100.0%][r=519MiB/s][r=133k IOPS][eta 00m:00s] 
> /media/scratch/seqread: (groupid=0, jobs=1): err= 0: pid=3722: Mon Dec  3 09:57:17 2018
>   read: IOPS=78.4k, BW=306MiB/s (321MB/s)(10.0GiB/33444msec)
>     clat (nsec): min=1703, max=9042.7k, avg=5463.97, stdev=121068.28
>      lat (usec): min=2, max=9043, avg= 6.00, stdev=121.07
>     clat percentiles (nsec):
>      |  1.00th=[   1848],  5.00th=[   1896], 10.00th=[   1912],
>      | 20.00th=[   1960], 30.00th=[   2024], 40.00th=[   2160],
>      | 50.00th=[   2384], 60.00th=[   2576], 70.00th=[   2800],
>      | 80.00th=[   3120], 90.00th=[   3824], 95.00th=[   4768],
>      | 99.00th=[   7968], 99.50th=[  14912], 99.90th=[  50944],
>      | 99.95th=[ 667648], 99.99th=[5931008]
>    bw (  KiB/s): min= 2768, max=544542, per=100.00%, avg=409912.68, stdev=162333.72, samples=50
>    iops        : min=  692, max=136135, avg=102478.08, stdev=40583.47, samples=50
>   lat (usec)   : 2=25.93%, 4=65.58%, 10=7.69%, 20=0.57%, 50=0.13%
>   lat (usec)   : 100=0.04%, 250=0.01%, 500=0.01%, 750=0.01%, 1000=0.01%
>   lat (msec)   : 2=0.01%, 4=0.01%, 10=0.05%
>   cpu          : usr=7.20%, sys=92.55%, ctx=396, majf=0, minf=9
>   IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
>      submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
>      complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
>      issued rwts: total=2621440,0,0,0 short=0,0,0,0 dropped=0,0,0,0
>      latency   : target=0, window=0, percentile=100.00%, depth=1
> 
> Run status group 0 (all jobs):
>    READ: bw=306MiB/s (321MB/s), 306MiB/s-306MiB/s (321MB/s-321MB/s), io=10.0GiB (10.7GB), run=33444-33444msec
> 
> 
> UNPATCHED:
> 
> Starting 1 process
> Jobs: 1 (f=1): [R(1)][100.0%][r=568MiB/s][r=145k IOPS][eta 00m:00s] 
> /media/scratch/seqread: (groupid=0, jobs=1): err= 0: pid=640: Mon Dec  3 10:07:38 2018
>   read: IOPS=90.4k, BW=353MiB/s (370MB/s)(10.0GiB/29008msec)
>     clat (nsec): min=1418, max=12374k, avg=4816.38, stdev=109448.00
>      lat (nsec): min=1836, max=12374k, avg=5284.46, stdev=109451.36
>     clat percentiles (nsec):
>      |  1.00th=[   1576],  5.00th=[   1608], 10.00th=[   1640],
>      | 20.00th=[   1672], 30.00th=[   1720], 40.00th=[   1832],
>      | 50.00th=[   2096], 60.00th=[   2288], 70.00th=[   2480],
>      | 80.00th=[   2736], 90.00th=[   3248], 95.00th=[   3952],
>      | 99.00th=[   6368], 99.50th=[  12736], 99.90th=[  43776],
>      | 99.95th=[ 798720], 99.99th=[5341184]
>    bw (  KiB/s): min=34144, max=606208, per=100.00%, avg=465737.56, stdev=177637.57, samples=45
>    iops        : min= 8536, max=151552, avg=116434.33, stdev=44409.46, samples=45
>   lat (usec)   : 2=45.74%, 4=49.50%, 10=4.13%, 20=0.45%, 50=0.08%
>   lat (usec)   : 100=0.03%, 250=0.01%, 500=0.01%, 750=0.01%, 1000=0.01%
>   lat (msec)   : 2=0.01%, 4=0.01%, 10=0.05%, 20=0.01%
>   cpu          : usr=7.14%, sys=92.39%, ctx=1059, majf=0, minf=9
>   IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
>      submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
>      complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
>      issued rwts: total=2621440,0,0,0 short=0,0,0,0 dropped=0,0,0,0
>      latency   : target=0, window=0, percentile=100.00%, depth=1
> 
> Run status group 0 (all jobs):
>    READ: bw=353MiB/s (370MB/s), 353MiB/s-353MiB/s (370MB/s-370MB/s), io=10.0GiB (10.7GB), run=29008-29008msec
> 
> Clearly both bandwidth and iops are worse. However I'm puzzled as to why this is 
> the case, given that I don't see how this patch affects the submission of 
> readahead io. 
> 
>  fs/btrfs/extent_io.c | 63 +++++++++++++-------------------------------
>  1 file changed, 19 insertions(+), 44 deletions(-)

Revisiting the patch and the results IMHO it shouldn't be RFC and is
ready for merging.

So gentle ping :)

> 
> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> index 233f835dd6f8..c097eec1b73d 100644
> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c
> @@ -3059,7 +3059,7 @@ static int __do_readpage(struct extent_io_tree *tree,
>  	return ret;
>  }
>  
> -static inline void __do_contiguous_readpages(struct extent_io_tree *tree,
> +static inline void contiguous_readpages(struct extent_io_tree *tree,
>  					     struct page *pages[], int nr_pages,
>  					     u64 start, u64 end,
>  					     struct extent_map **em_cached,
> @@ -3090,46 +3090,6 @@ static inline void __do_contiguous_readpages(struct extent_io_tree *tree,
>  	}
>  }
>  
> -static void __extent_readpages(struct extent_io_tree *tree,
> -			       struct page *pages[],
> -			       int nr_pages,
> -			       struct extent_map **em_cached,
> -			       struct bio **bio, unsigned long *bio_flags,
> -			       u64 *prev_em_start)
> -{
> -	u64 start = 0;
> -	u64 end = 0;
> -	u64 page_start;
> -	int index;
> -	int first_index = 0;
> -
> -	for (index = 0; index < nr_pages; index++) {
> -		page_start = page_offset(pages[index]);
> -		if (!end) {
> -			start = page_start;
> -			end = start + PAGE_SIZE - 1;
> -			first_index = index;
> -		} else if (end + 1 == page_start) {
> -			end += PAGE_SIZE;
> -		} else {
> -			__do_contiguous_readpages(tree, &pages[first_index],
> -						  index - first_index, start,
> -						  end, em_cached,
> -						  bio, bio_flags,
> -						  prev_em_start);
> -			start = page_start;
> -			end = start + PAGE_SIZE - 1;
> -			first_index = index;
> -		}
> -	}
> -
> -	if (end)
> -		__do_contiguous_readpages(tree, &pages[first_index],
> -					  index - first_index, start,
> -					  end, em_cached, bio,
> -					  bio_flags, prev_em_start);
> -}
> -
>  static int __extent_read_full_page(struct extent_io_tree *tree,
>  				   struct page *page,
>  				   get_extent_t *get_extent,
> @@ -4104,6 +4064,13 @@ int extent_readpages(struct address_space *mapping, struct list_head *pages,
>  	u64 prev_em_start = (u64)-1;
>  
>  	while (!list_empty(pages)) {
> +		u64 contig_end = 0;
> +
> +		/*
> +		 * Produces a batch of up to 16 contiguous pages, assumes
> +		 * that pages are consecutive in pages list (guaranteed by the
> +		 * generic code)
> +		 **/
>  		for (nr = 0; nr < BTRFS_PAGES_BATCH && !list_empty(pages);) {
>  			struct page *page = lru_to_page(pages);
>  
> @@ -4112,14 +4079,22 @@ int extent_readpages(struct address_space *mapping, struct list_head *pages,
>  			if (add_to_page_cache_lru(page, mapping, page->index,
>  						readahead_gfp_mask(mapping))) {
>  				put_page(page);
> -				continue;
> +				break;
>  			}
>  
>  			pagepool[nr++] = page;
> +			contig_end = page_offset(page) + PAGE_SIZE - 1;
>  		}
>  
> -		__extent_readpages(tree, pagepool, nr, &em_cached, &bio,
> -				   &bio_flags, &prev_em_start);
> +		if (nr) {
> +			u64 contig_start = page_offset(pagepool[0]);
> +
> +			ASSERT(contig_start + (nr*PAGE_SIZE) - 1 == contig_end);
> +
> +			contiguous_readpages(tree, pagepool, nr, contig_start,
> +				     contig_end, &em_cached, &bio, &bio_flags,
> +				     &prev_em_start);
> +		}
>  	}
>  
>  	if (em_cached)
> 
