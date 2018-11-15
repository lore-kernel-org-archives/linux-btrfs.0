Return-Path: <SRS0=Mirb=N2=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CE77C4161B
	for <linux-btrfs@archiver.kernel.org>; Thu, 15 Nov 2018 23:24:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 314BE20869
	for <linux-btrfs@archiver.kernel.org>; Thu, 15 Nov 2018 23:24:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=osandov-com.20150623.gappssmtp.com header.i=@osandov-com.20150623.gappssmtp.com header.b="xNHPvfwn"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 314BE20869
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=osandov.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729090AbeKPJeB (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 16 Nov 2018 04:34:01 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:41598 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726233AbeKPJdz (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 16 Nov 2018 04:33:55 -0500
Received: by mail-pf1-f193.google.com with SMTP id e22-v6so10421528pfn.8
        for <linux-btrfs@vger.kernel.org>; Thu, 15 Nov 2018 15:24:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=osandov-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=jwnypmXRKe0aQmFwiDDHQvx5bHMn94jQ/OjQzX3YuJ0=;
        b=xNHPvfwni0CT/Ud+WG0Z+eArtj5FLHdX5ny0CAJBgZw/w5k8sAxb3sDWxubpfB1ZS/
         7WVq1n1Fp4vLIVMGHxTYOo5cgiGZQgwqJ7uYQNM33OACNJrd6jMSaYIYIelZKKlgosfK
         nkEnkYrUnadWqJ43cAXSq2fMz5RDwApNaX7RGATH2cbmys5FkjmJdNzQ2hvgOQoVv/Gp
         c5H+d8rWap2eHHnCaFtK4alcHdtD8uBvY3LcbPJXqocRZhw2iSpIq1ao3UU6L1cjlLAN
         3qaL6ExIwzLXqtDfHjK/EfEagOR/RXXe0pXUMJLjb8iAEqGmsTTgFST/ahlPUZeRcNVf
         m83Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=jwnypmXRKe0aQmFwiDDHQvx5bHMn94jQ/OjQzX3YuJ0=;
        b=FlCm6PaqtuJwu4EyxNWDve1EbKqEhpUhTXX13otG6w8yS9VuXsyE0m5Dpipc4ahYD3
         A9q8byOySzAhR9D0NpAKogsKdYRPT7a4hpgxNWINucJouLGr6jgKBIc55aK2EJGDn9hk
         vsc6omCVowtEy9hm/U99nc1cCgUUKfVdJNG+ibcMhkVrRy5XQrJ+PGrJQF+NBQUHb9FV
         NPBdFE68/yIn0zzuR5LajmsKWuoDJXXl8tuJsDseH3u4znhpv87Zu7Gf/EhB/QIZnQsU
         UatzdgMoBG3x5t7Bk3my/tfyP/H1Jhzo97Yf0LpfiptDE8/9JgmuHwyFdBFZDl6jJ0aX
         FWkQ==
X-Gm-Message-State: AGRZ1gKDUt5sF7BpT+Xg9sjQ5wWBgdjtcJ2aSO5aQMHErTIjYao2Q3sI
        oZ/0DZy2vP7W3eNpQc4TUPNO9g==
X-Google-Smtp-Source: AJdET5f1hxetB9UqDibiUkx95kTB/X389pkp9WONJq7RyIqm5kAs3ITocaP1OtKLLpS24I28CEXFdQ==
X-Received: by 2002:a63:344e:: with SMTP id b75mr7449203pga.184.1542324240224;
        Thu, 15 Nov 2018 15:24:00 -0800 (PST)
Received: from vader ([64.114.255.97])
        by smtp.gmail.com with ESMTPSA id x63-v6sm38337415pfk.14.2018.11.15.15.23.58
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 15 Nov 2018 15:23:59 -0800 (PST)
Date:   Thu, 15 Nov 2018 15:23:56 -0800
From:   Omar Sandoval <osandov@osandov.com>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Dave Chinner <dchinner@redhat.com>,
        Kent Overstreet <kent.overstreet@gmail.com>,
        Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, Shaohua Li <shli@kernel.org>,
        linux-raid@vger.kernel.org, linux-erofs@lists.ozlabs.org,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org, Gao Xiang <gaoxiang25@huawei.com>,
        Christoph Hellwig <hch@lst.de>, Theodore Ts'o <tytso@mit.edu>,
        linux-ext4@vger.kernel.org, Coly Li <colyli@suse.de>,
        linux-bcache@vger.kernel.org, Boaz Harrosh <ooo@electrozaur.com>,
        Bob Peterson <rpeterso@redhat.com>, cluster-devel@redhat.com
Subject: Re: [PATCH V10 05/19] block: introduce bvec_last_segment()
Message-ID: <20181115232356.GA23238@vader>
References: <20181115085306.9910-1-ming.lei@redhat.com>
 <20181115085306.9910-6-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181115085306.9910-6-ming.lei@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Nov 15, 2018 at 04:52:52PM +0800, Ming Lei wrote:
> BTRFS and guard_bio_eod() need to get the last singlepage segment
> from one multipage bvec, so introduce this helper to make them happy.
> 
> Cc: Dave Chinner <dchinner@redhat.com>
> Cc: Kent Overstreet <kent.overstreet@gmail.com>
> Cc: Mike Snitzer <snitzer@redhat.com>
> Cc: dm-devel@redhat.com
> Cc: Alexander Viro <viro@zeniv.linux.org.uk>
> Cc: linux-fsdevel@vger.kernel.org
> Cc: Shaohua Li <shli@kernel.org>
> Cc: linux-raid@vger.kernel.org
> Cc: linux-erofs@lists.ozlabs.org
> Cc: David Sterba <dsterba@suse.com>
> Cc: linux-btrfs@vger.kernel.org
> Cc: Darrick J. Wong <darrick.wong@oracle.com>
> Cc: linux-xfs@vger.kernel.org
> Cc: Gao Xiang <gaoxiang25@huawei.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Theodore Ts'o <tytso@mit.edu>
> Cc: linux-ext4@vger.kernel.org
> Cc: Coly Li <colyli@suse.de>
> Cc: linux-bcache@vger.kernel.org
> Cc: Boaz Harrosh <ooo@electrozaur.com>
> Cc: Bob Peterson <rpeterso@redhat.com>
> Cc: cluster-devel@redhat.com

Reviewed-by: Omar Sandoval <osandov@fb.com>

Minor comments below.

> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> ---
>  include/linux/bvec.h | 25 +++++++++++++++++++++++++
>  1 file changed, 25 insertions(+)
> 
> diff --git a/include/linux/bvec.h b/include/linux/bvec.h
> index 3d61352cd8cf..01616a0b6220 100644
> --- a/include/linux/bvec.h
> +++ b/include/linux/bvec.h
> @@ -216,4 +216,29 @@ static inline bool mp_bvec_iter_advance(const struct bio_vec *bv,
>  	.bi_bvec_done	= 0,						\
>  }
>  
> +/*
> + * Get the last singlepage segment from the multipage bvec and store it
> + * in @seg
> + */
> +static inline void bvec_last_segment(const struct bio_vec *bvec,
> +		struct bio_vec *seg)

Indentation is all messed up here.

> +{
> +	unsigned total = bvec->bv_offset + bvec->bv_len;
> +	unsigned last_page = total / PAGE_SIZE;
> +
> +	if (last_page * PAGE_SIZE == total)
> +		last_page--;

I think this could just be

	unsigned int last_page = (total - 1) / PAGE_SIZE;

> +	seg->bv_page = nth_page(bvec->bv_page, last_page);
> +
> +	/* the whole segment is inside the last page */
> +	if (bvec->bv_offset >= last_page * PAGE_SIZE) {
> +		seg->bv_offset = bvec->bv_offset % PAGE_SIZE;
> +		seg->bv_len = bvec->bv_len;
> +	} else {
> +		seg->bv_offset = 0;
> +		seg->bv_len = total - last_page * PAGE_SIZE;
> +	}
> +}
> +
>  #endif /* __LINUX_BVEC_ITER_H */
> -- 
> 2.9.5
> 
