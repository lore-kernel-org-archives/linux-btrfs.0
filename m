Return-Path: <SRS0=mYd/=OF=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 418C3C43441
	for <linux-btrfs@archiver.kernel.org>; Mon, 26 Nov 2018 22:39:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EDA1220873
	for <linux-btrfs@archiver.kernel.org>; Mon, 26 Nov 2018 22:39:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=osandov-com.20150623.gappssmtp.com header.i=@osandov-com.20150623.gappssmtp.com header.b="kWu3M/Pg"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EDA1220873
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=osandov.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727412AbeK0JfV (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 27 Nov 2018 04:35:21 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:35163 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727066AbeK0JfU (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 27 Nov 2018 04:35:20 -0500
Received: by mail-pg1-f194.google.com with SMTP id s198so6851890pgs.2
        for <linux-btrfs@vger.kernel.org>; Mon, 26 Nov 2018 14:39:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=osandov-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=RUaiQARROohQiAOdny5us6dTb3HLIuGpGt6crRAlRs8=;
        b=kWu3M/Pg7YRitikkahpKiBl5cCUnoiBMDo/k7D4nxQKGNeUrhzsp3IHHN3doNwb/kD
         e+9EBrzpQwB1ZBTyEn44PpIKLid6y29HqBgkdjvAB+Bg1igpAKj3RVm/PKOxRyqGPY2T
         X1rggbUOJC5rYhwhHSW/Hh59KSJuPHtxnoOYRn7BqHzxEdVNZLywgqCv6o62Cd/XzV6n
         PeAdxxPpGLw9a7YBjD1adzo7n6tgd5+FvwuuKMouy46sgY8NzvhWen76DwmWnzzNYePH
         acjs1KTVl6/uL/knjosfu1aMoXstmrlISal/OL9bYMv4RMuinjL5cWOJWhT0eMGeDgNx
         vt+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=RUaiQARROohQiAOdny5us6dTb3HLIuGpGt6crRAlRs8=;
        b=s7zOo1cWaSzeGM3Isw4VPyWzu/vIEc2AU8HHDQAQP6JrAp8GNgfH1v97ot94CNevIh
         30xQacyElECQZ9LZQ7iyDPuPF8JU9h1f4lbQKyRgvOlEoZLx+CCALWhGtwoliDDeRaiE
         HAQXcrsgz4nXsNpr0URcNG2/3/QE33HIMyyzvQj65EkK7U5tGMHh08qBq3LoF310C7h/
         bqDtxZC2NE36bShkS6fFfD8f8SbrIKb0IBTbpwab/ttj66pHi/za5yCY6ZP3gVi2cG0g
         UPF0RAt/C++w/MP+R+coYx5ZJbebM8JWMew9N3GGhCP8T9hp5DMgnw+tvL71nmkqqaDy
         TvIQ==
X-Gm-Message-State: AA+aEWbCAKLVDuP/E2MsJiwNlIkelgaPKQ8rdZSyj9RWZzCQuHF+h6BS
        T6sd1RKOYONr7fT5mths7Pf5vg==
X-Google-Smtp-Source: AFSGD/WKF2YX6sjXdtrywlIZWIhARgrTQBAsfQcHBfGoFipMevteRNDHtxwiJzMkTPu20TTEPw3acw==
X-Received: by 2002:a62:4b4d:: with SMTP id y74mr28649197pfa.186.1543271980701;
        Mon, 26 Nov 2018 14:39:40 -0800 (PST)
Received: from vader ([2601:602:8b00:55d3:e6a7:a0ff:fe0b:c9a8])
        by smtp.gmail.com with ESMTPSA id y12sm2059602pfk.70.2018.11.26.14.39.39
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 26 Nov 2018 14:39:40 -0800 (PST)
Date:   Mon, 26 Nov 2018 14:39:38 -0800
From:   Omar Sandoval <osandov@osandov.com>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Theodore Ts'o <tytso@mit.edu>, Omar Sandoval <osandov@fb.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Dave Chinner <dchinner@redhat.com>,
        Kent Overstreet <kent.overstreet@gmail.com>,
        Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, Shaohua Li <shli@kernel.org>,
        linux-raid@vger.kernel.org, David Sterba <dsterba@suse.com>,
        linux-btrfs@vger.kernel.org,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org, Gao Xiang <gaoxiang25@huawei.com>,
        Christoph Hellwig <hch@lst.de>, linux-ext4@vger.kernel.org,
        Coly Li <colyli@suse.de>, linux-bcache@vger.kernel.org,
        Boaz Harrosh <ooo@electrozaur.com>,
        Bob Peterson <rpeterso@redhat.com>, cluster-devel@redhat.com
Subject: Re: [PATCH V12 13/20] block: loop: pass multi-page bvec to iov_iter
Message-ID: <20181126223938.GJ30411@vader>
References: <20181126021720.19471-1-ming.lei@redhat.com>
 <20181126021720.19471-14-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181126021720.19471-14-ming.lei@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Nov 26, 2018 at 10:17:13AM +0800, Ming Lei wrote:
> iov_iter is implemented on bvec itererator helpers, so it is safe to pass
> multi-page bvec to it, and this way is much more efficient than passing one
> page in each bvec.
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Omar Sandoval <osandov@fb.com>

> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> ---
>  drivers/block/loop.c | 20 ++++++++++----------
>  1 file changed, 10 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/block/loop.c b/drivers/block/loop.c
> index 176ab1f28eca..e3683211f12d 100644
> --- a/drivers/block/loop.c
> +++ b/drivers/block/loop.c
> @@ -510,21 +510,22 @@ static int lo_rw_aio(struct loop_device *lo, struct loop_cmd *cmd,
>  		     loff_t pos, bool rw)
>  {
>  	struct iov_iter iter;
> +	struct req_iterator rq_iter;
>  	struct bio_vec *bvec;
>  	struct request *rq = blk_mq_rq_from_pdu(cmd);
>  	struct bio *bio = rq->bio;
>  	struct file *file = lo->lo_backing_file;
> +	struct bio_vec tmp;
>  	unsigned int offset;
> -	int segments = 0;
> +	int nr_bvec = 0;
>  	int ret;
>  
> +	rq_for_each_bvec(tmp, rq, rq_iter)
> +		nr_bvec++;
> +
>  	if (rq->bio != rq->biotail) {
> -		struct req_iterator iter;
> -		struct bio_vec tmp;
>  
> -		__rq_for_each_bio(bio, rq)
> -			segments += bio_segments(bio);
> -		bvec = kmalloc_array(segments, sizeof(struct bio_vec),
> +		bvec = kmalloc_array(nr_bvec, sizeof(struct bio_vec),
>  				     GFP_NOIO);
>  		if (!bvec)
>  			return -EIO;
> @@ -533,10 +534,10 @@ static int lo_rw_aio(struct loop_device *lo, struct loop_cmd *cmd,
>  		/*
>  		 * The bios of the request may be started from the middle of
>  		 * the 'bvec' because of bio splitting, so we can't directly
> -		 * copy bio->bi_iov_vec to new bvec. The rq_for_each_segment
> +		 * copy bio->bi_iov_vec to new bvec. The rq_for_each_bvec
>  		 * API will take care of all details for us.
>  		 */
> -		rq_for_each_segment(tmp, rq, iter) {
> +		rq_for_each_bvec(tmp, rq, rq_iter) {
>  			*bvec = tmp;
>  			bvec++;
>  		}
> @@ -550,11 +551,10 @@ static int lo_rw_aio(struct loop_device *lo, struct loop_cmd *cmd,
>  		 */
>  		offset = bio->bi_iter.bi_bvec_done;
>  		bvec = __bvec_iter_bvec(bio->bi_io_vec, bio->bi_iter);
> -		segments = bio_segments(bio);
>  	}
>  	atomic_set(&cmd->ref, 2);
>  
> -	iov_iter_bvec(&iter, rw, bvec, segments, blk_rq_bytes(rq));
> +	iov_iter_bvec(&iter, rw, bvec, nr_bvec, blk_rq_bytes(rq));
>  	iter.iov_offset = offset;
>  
>  	cmd->iocb.ki_pos = pos;
> -- 
> 2.9.5
> 
