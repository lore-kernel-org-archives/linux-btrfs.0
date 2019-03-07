Return-Path: <SRS0=nVQC=RK=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66781C43381
	for <linux-btrfs@archiver.kernel.org>; Thu,  7 Mar 2019 17:41:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4160220851
	for <linux-btrfs@archiver.kernel.org>; Thu,  7 Mar 2019 17:41:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726274AbfCGRlZ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 7 Mar 2019 12:41:25 -0500
Received: from mx2.suse.de ([195.135.220.15]:46208 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726249AbfCGRlY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 7 Mar 2019 12:41:24 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 5A0E3ABD0
        for <linux-btrfs@vger.kernel.org>; Thu,  7 Mar 2019 17:41:23 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id A5B56DA83C; Thu,  7 Mar 2019 18:42:40 +0100 (CET)
Date:   Thu, 7 Mar 2019 18:42:40 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Johannes Thumshirn <jthumshirn@suse.de>
Cc:     David Sterba <dsterba@suse.com>,
        Linux BTRFS Mailinglist <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs: reduce kmap_atomic time for checksumming
Message-ID: <20190307174239.GN31119@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Johannes Thumshirn <jthumshirn@suse.de>,
        David Sterba <dsterba@suse.com>,
        Linux BTRFS Mailinglist <linux-btrfs@vger.kernel.org>
References: <20190307161400.25065-1-jthumshirn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190307161400.25065-1-jthumshirn@suse.de>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Mar 07, 2019 at 05:14:00PM +0100, Johannes Thumshirn wrote:
> Since commit c40a3d38aff4 ("Btrfs: Compute and look up csums based on
> sectorsized blocks") we do a kmap_atomic() on the contents of a bvec.
> 
> kmap_atomic() in turn does a preempt_disable() and pagefault_disable(),
> so we shouldn't map the data for too long. Reduce the time the bvec's
> page is mapped to when we actually need it.
> 
> Performance wise it doesn't seem to make a huge difference with a 2 vcpu VM
> on a /dev/zram device:
> 
>        vanilla      patched      delta
> write  17.4MiB/s    17.8MiB/s	+0.4MiB/s (+2%)
> read   40.6MiB/s    41.5MiB/s   +0.9MiB/s (+2%)
> 
> The following fio job profile was used in the comparision:
> 
> [global]
> ioengine=libaio
> direct=1
> sync=1
> norandommap
> time_based
> runtime=10m
> size=100m
> group_reporting
> numjobs=2
> 
> [test]
> filename=/mnt/test/fio
> rw=randrw
> rwmixread=70
> 
> Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
> ---
>  fs/btrfs/file-item.c | 8 ++------
>  1 file changed, 2 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
> index 920bf3b4b0ef..aa40e66df1e1 100644
> --- a/fs/btrfs/file-item.c
> +++ b/fs/btrfs/file-item.c
> @@ -453,8 +453,6 @@ blk_status_t btrfs_csum_one_bio(struct inode *inode, struct bio *bio,
>  			BUG_ON(!ordered); /* Logic error */
>  		}
>  
> -		data = kmap_atomic(bvec.bv_page);
> -
>  		nr_sectors = BTRFS_BYTES_TO_BLKS(fs_info,
>  						 bvec.bv_len + fs_info->sectorsize
>  						 - 1);
> @@ -464,7 +462,6 @@ blk_status_t btrfs_csum_one_bio(struct inode *inode, struct bio *bio,
>  				offset < ordered->file_offset) {
>  				unsigned long bytes_left;
>  
> -				kunmap_atomic(data);
>  				sums->len = this_sum_bytes;
>  				this_sum_bytes = 0;
>  				btrfs_add_ordered_sum(inode, ordered, sums);
> @@ -482,16 +479,16 @@ blk_status_t btrfs_csum_one_bio(struct inode *inode, struct bio *bio,
>  				sums->bytenr = ((u64)bio->bi_iter.bi_sector << 9)
>  					+ total_bytes;
>  				index = 0;
> -
> -				data = kmap_atomic(bvec.bv_page);
>  			}
>  
>  			sums->sums[index] = ~(u32)0;
> +			data = kmap_atomic(bvec.bv_page);
>  			sums->sums[index]
>  				= btrfs_csum_data(data + bvec.bv_offset
>  						+ (i * fs_info->sectorsize),
>  						sums->sums[index],
>  						fs_info->sectorsize);
> +			kunmap_atomic(data);

The code before c40a3d38aff4 did exactly this, ie. kmap only around the
checksumming. I don't actually see anywhere from the context why it
would need to be around the whole bvec as none of the operations uses
that.

So I think your patch is correct.

Reviewed-by: David Sterba <dsterba@suse.com>
