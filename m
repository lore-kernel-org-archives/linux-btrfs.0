Return-Path: <SRS0=1Z4l=OC=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCB12C43610
	for <linux-btrfs@archiver.kernel.org>; Fri, 23 Nov 2018 01:48:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A49CF206B2
	for <linux-btrfs@archiver.kernel.org>; Fri, 23 Nov 2018 01:48:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A49CF206B2
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439343AbeKWMaz (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 23 Nov 2018 07:30:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36152 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733028AbeKWMaz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 23 Nov 2018 07:30:55 -0500
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 0A18C83F4C;
        Fri, 23 Nov 2018 01:48:46 +0000 (UTC)
Received: from ming.t460p (ovpn-8-31.pek2.redhat.com [10.72.8.31])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7997D104C53B;
        Fri, 23 Nov 2018 01:48:25 +0000 (UTC)
Date:   Fri, 23 Nov 2018 09:48:21 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
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
        linux-ext4@vger.kernel.org, Coly Li <colyli@suse.de>,
        linux-bcache@vger.kernel.org, Boaz Harrosh <ooo@electrozaur.com>,
        Bob Peterson <rpeterso@redhat.com>, cluster-devel@redhat.com
Subject: Re: [PATCH V11 07/19] fs/buffer.c: use bvec iterator to truncate the
 bio
Message-ID: <20181123014820.GA20110@ming.t460p>
References: <20181121032327.8434-1-ming.lei@redhat.com>
 <20181121032327.8434-8-ming.lei@redhat.com>
 <20181122105849.GA30066@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181122105849.GA30066@lst.de>
User-Agent: Mutt/1.9.1 (2017-09-22)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.27]); Fri, 23 Nov 2018 01:48:47 +0000 (UTC)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Nov 22, 2018 at 11:58:49AM +0100, Christoph Hellwig wrote:
> Btw, given that this is the last user of bvec_last_segment after my
> other patches I think we should kill bvec_last_segment and do something
> like this here:
> 
> 
> diff --git a/fs/buffer.c b/fs/buffer.c
> index fa37ad52e962..af5e135d2b83 100644
> --- a/fs/buffer.c
> +++ b/fs/buffer.c
> @@ -2981,6 +2981,14 @@ static void end_bio_bh_io_sync(struct bio *bio)
>  	bio_put(bio);
>  }
>  
> +static void zero_trailing_sectors(struct bio_vec *bvec, unsigned bytes)
> +{
> +	unsigned last_page = (bvec->bv_offset + bvec->bv_len - 1) >> PAGE_SHIFT;
> +
> +	zero_user(nth_page(bvec->bv_page, last_page),
> +		  bvec->bv_offset % PAGE_SIZE + bvec->bv_len, bytes);
> +}

The above 'start' parameter is figured out as wrong, and the computation
isn't very obvious, so I'd suggest to keep bvec_last_segment().

Thanks,
Ming
