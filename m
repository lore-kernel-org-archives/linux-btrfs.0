Return-Path: <SRS0=mYd/=OF=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9770DC43610
	for <linux-btrfs@archiver.kernel.org>; Mon, 26 Nov 2018 22:43:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5B975208E4
	for <linux-btrfs@archiver.kernel.org>; Mon, 26 Nov 2018 22:43:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=osandov-com.20150623.gappssmtp.com header.i=@osandov-com.20150623.gappssmtp.com header.b="mtghKcHJ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5B975208E4
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=osandov.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727525AbeK0Jje (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 27 Nov 2018 04:39:34 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:42162 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727419AbeK0Jje (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 27 Nov 2018 04:39:34 -0500
Received: by mail-pl1-f195.google.com with SMTP id x21-v6so14564292pln.9
        for <linux-btrfs@vger.kernel.org>; Mon, 26 Nov 2018 14:43:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=osandov-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=i20Dt/Y4hePBhYO3MIpKYO6Bv6MubkueUCS1k0iokTY=;
        b=mtghKcHJWI8BJbNfFcoZPi2+shQHddKBvQPRffjh+/NC/Lp09PsWFdP5PVeyMKk4mc
         U3/2jqhVRapoVI7iN/MT36STFnCrKtR7W2FdC6+KOr1XS8VCGa5DPXqvI/8g9uoaFjrS
         lgsj1uu7qEfr+0e3O5Rbc/kltSRNSWMspBjXLhG1k9bnsh50BIXlkg7LrM5ugbRVFlax
         f7y1+rnrO4ZfH3esCZ4dgzuYfzr/CYnX4Bydws7ucItZgJJ1XHPdmd02MezSgrkLtl52
         GPkZtyJbbrYPfpXwf6G/nFCHWpvu/yN7559hsbwCHceF+ch9ypQVQxvE4ogzW4In0Tev
         16Ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=i20Dt/Y4hePBhYO3MIpKYO6Bv6MubkueUCS1k0iokTY=;
        b=jwEluCDbVjoTvEaj7V8jRIEm44pHsdMEIQifmqqe6N0sW0XQMXnKFnaOhwiL8YJaMO
         2uBF+PU/Qiam1doQUtncSvyNiMYEusVugoO7DTN7cc4N6Ur1JxOLpYYLoSJ9G4NJkV4n
         7nGEM6XZdDrNNIn9wENAfNf0qEGpmk+21eTFw4GZSdXc7Wgg2PlGj8TjKyQ3voN4aMNw
         SskcRYLXWDi1Z2vTyjw/km41VkQ1Gzy43SA2HlBiBrqkJPsb/OD7bsUqzA8jBJGZJfcb
         UMJYW2YiG1wgw88G98WCSIIDIdx3wMoBsO/7fmR51DxnY4fYSfhaz1J4S+i7LbiUKI6o
         s+uA==
X-Gm-Message-State: AA+aEWaqiTL+UX4Dul76uANEjXB8jYmoP9DnGaLXOBX7+jUWP5g09cyL
        HQuZnjTVb1fvJ2VL4g6jTwDxMQ==
X-Google-Smtp-Source: AFSGD/VoHhpKQXVCPJi5+g88XYO0xq2Iuexx3M+Z20/5Ic3K+rYrr8FKoEG7eTM2ndX25qcuXgUWuw==
X-Received: by 2002:a17:902:50e3:: with SMTP id c32mr29996012plj.318.1543272233950;
        Mon, 26 Nov 2018 14:43:53 -0800 (PST)
Received: from vader ([2601:602:8b00:55d3:e6a7:a0ff:fe0b:c9a8])
        by smtp.gmail.com with ESMTPSA id e128sm1718321pfe.67.2018.11.26.14.43.52
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 26 Nov 2018 14:43:53 -0800 (PST)
Date:   Mon, 26 Nov 2018 14:43:51 -0800
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
Subject: Re: [PATCH V12 18/20] block: document usage of bio iterator helpers
Message-ID: <20181126224351.GM30411@vader>
References: <20181126021720.19471-1-ming.lei@redhat.com>
 <20181126021720.19471-19-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181126021720.19471-19-ming.lei@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Nov 26, 2018 at 10:17:18AM +0800, Ming Lei wrote:
> Now multi-page bvec is supported, some helpers may return page by
> page, meantime some may return segment by segment, this patch
> documents the usage.

Reviewed-by: Omar Sandoval <osandov@fb.com>

> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> ---
>  Documentation/block/biovecs.txt | 25 +++++++++++++++++++++++++
>  1 file changed, 25 insertions(+)
> 
> diff --git a/Documentation/block/biovecs.txt b/Documentation/block/biovecs.txt
> index 25689584e6e0..ce6eccaf5df7 100644
> --- a/Documentation/block/biovecs.txt
> +++ b/Documentation/block/biovecs.txt
> @@ -117,3 +117,28 @@ Other implications:
>     size limitations and the limitations of the underlying devices. Thus
>     there's no need to define ->merge_bvec_fn() callbacks for individual block
>     drivers.
> +
> +Usage of helpers:
> +=================
> +
> +* The following helpers whose names have the suffix of "_all" can only be used
> +on non-BIO_CLONED bio. They are usually used by filesystem code. Drivers
> +shouldn't use them because the bio may have been split before it reached the
> +driver.
> +
> +	bio_for_each_segment_all()
> +	bio_first_bvec_all()
> +	bio_first_page_all()
> +	bio_last_bvec_all()
> +
> +* The following helpers iterate over single-page segment. The passed 'struct
> +bio_vec' will contain a single-page IO vector during the iteration
> +
> +	bio_for_each_segment()
> +	bio_for_each_segment_all()
> +
> +* The following helpers iterate over multi-page bvec. The passed 'struct
> +bio_vec' will contain a multi-page IO vector during the iteration
> +
> +	bio_for_each_bvec()
> +	rq_for_each_bvec()
> -- 
> 2.9.5
> 
