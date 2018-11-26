Return-Path: <SRS0=mYd/=OF=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 766F6C43441
	for <linux-btrfs@archiver.kernel.org>; Mon, 26 Nov 2018 22:40:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3D85620873
	for <linux-btrfs@archiver.kernel.org>; Mon, 26 Nov 2018 22:40:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=osandov-com.20150623.gappssmtp.com header.i=@osandov-com.20150623.gappssmtp.com header.b="i3qnjehB"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3D85620873
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=osandov.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727645AbeK0Jfs (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 27 Nov 2018 04:35:48 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:37154 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727633AbeK0Jfp (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 27 Nov 2018 04:35:45 -0500
Received: by mail-pl1-f193.google.com with SMTP id b5so14582638plr.4
        for <linux-btrfs@vger.kernel.org>; Mon, 26 Nov 2018 14:40:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=osandov-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=7SO7oOEdYQMovzlJck3mc2068mng5do2HhlfyldvWPU=;
        b=i3qnjehBiyOqrFRjAHBr9Jb6QUj670RxC/4MexyY1O/JiJiZzrjd8nTLEhgSW7RAfc
         +FVQbE8UyT+he+H1Q/aEJn7aHCBC5DFtZgeBL+uBBaKIAdDIfovyVnEu86oD25w4aMJ3
         bDQLit7fjyShtnmlwlIKSnMKWauICluAa5y02isaD/gK3jBbk0SVRWiSOASYM62FQd1D
         E0TxievofnMe9YDLX8FKtJ0j3ToCj7fKJfNyPMY1owCLnWL/ioXt1vjKxzo45yRN8OMG
         qi64+ePkHIswSk+nzc6tG7YZyrgg/qop0MKatM26GS0yrqjjnl2yv8qFAO7A1OlHW3pX
         JO3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=7SO7oOEdYQMovzlJck3mc2068mng5do2HhlfyldvWPU=;
        b=AR7yDKE/aGsOWK49+sZOaZohqq12vfiqMPXG1umW9Q5kq9NtUW9w0FOJN4+TjNCOSH
         X4VeWYhq2OjKIuvaT0plyiehe+LKp5XaF12fghn3aEI43zmEzFpgHypRBQohp/Oh4DSV
         cxTNcy85MO1Pa0cbhnB3MXT6l0kAoNSEnMEMwAG0RePo216K8qOjSRDju41C05SuZMIh
         f6JsdFqbyNdeEKylRbWXZjkdIj9xy8uTRkW8OyG0C62ZbqavJNYglommd2NxNV9eZibz
         A2KO83jyePvBb5SBvScABApsQp+PJVL98Rk+biPZiLOmhvJ9nJ9RK3oFW4c/wtt85f/C
         qQAw==
X-Gm-Message-State: AA+aEWYGJqukiq3MK6hAochItV3wPMFuIgHS+6QA87i4aJ1/I+AxrZGH
        wUzgdFirvuQrCMga1JMwQ+DXUw==
X-Google-Smtp-Source: AFSGD/XiSRQHKl6i4Ud9hpVkTqDz9dHlgDZMIs2FFvUUJM4ork3eboFR7OiJBXZO5SjLcJMPsHmCow==
X-Received: by 2002:a17:902:aa8c:: with SMTP id d12mr7815591plr.25.1543272005111;
        Mon, 26 Nov 2018 14:40:05 -0800 (PST)
Received: from vader ([2601:602:8b00:55d3:e6a7:a0ff:fe0b:c9a8])
        by smtp.gmail.com with ESMTPSA id t13sm3253245pgr.42.2018.11.26.14.40.03
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 26 Nov 2018 14:40:04 -0800 (PST)
Date:   Mon, 26 Nov 2018 14:40:03 -0800
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
Subject: Re: [PATCH V12 14/20] bcache: avoid to use
 bio_for_each_segment_all() in bch_bio_alloc_pages()
Message-ID: <20181126224003.GK30411@vader>
References: <20181126021720.19471-1-ming.lei@redhat.com>
 <20181126021720.19471-15-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181126021720.19471-15-ming.lei@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Nov 26, 2018 at 10:17:14AM +0800, Ming Lei wrote:
> bch_bio_alloc_pages() is always called on one new bio, so it is safe
> to access the bvec table directly. Given it is the only kind of this
> case, open code the bvec table access since bio_for_each_segment_all()
> will be changed to support for iterating over multipage bvec.
> 
> Acked-by: Coly Li <colyli@suse.de>
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Omar Sandoval <osandov@fb.com>

> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> ---
>  drivers/md/bcache/util.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/md/bcache/util.c b/drivers/md/bcache/util.c
> index 20eddeac1531..62fb917f7a4f 100644
> --- a/drivers/md/bcache/util.c
> +++ b/drivers/md/bcache/util.c
> @@ -270,7 +270,11 @@ int bch_bio_alloc_pages(struct bio *bio, gfp_t gfp_mask)
>  	int i;
>  	struct bio_vec *bv;
>  
> -	bio_for_each_segment_all(bv, bio, i) {
> +	/*
> +	 * This is called on freshly new bio, so it is safe to access the
> +	 * bvec table directly.
> +	 */
> +	for (i = 0, bv = bio->bi_io_vec; i < bio->bi_vcnt; bv++, i++) {
>  		bv->bv_page = alloc_page(gfp_mask);
>  		if (!bv->bv_page) {
>  			while (--bv >= bio->bi_io_vec)
> -- 
> 2.9.5
> 
