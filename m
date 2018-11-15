Return-Path: <SRS0=Mirb=N2=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21FF8C43441
	for <linux-btrfs@archiver.kernel.org>; Thu, 15 Nov 2018 18:26:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D77B921780
	for <linux-btrfs@archiver.kernel.org>; Thu, 15 Nov 2018 18:26:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=osandov-com.20150623.gappssmtp.com header.i=@osandov-com.20150623.gappssmtp.com header.b="hqxoBng/"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D77B921780
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=osandov.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388881AbeKPEe7 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 15 Nov 2018 23:34:59 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:36218 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387839AbeKPEe5 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 15 Nov 2018 23:34:57 -0500
Received: by mail-pf1-f194.google.com with SMTP id b85so3265156pfc.3
        for <linux-btrfs@vger.kernel.org>; Thu, 15 Nov 2018 10:26:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=osandov-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=LZBZD86Znd9LyHdczTLvGztQ2bKPH9Yi3lDzItF2KWw=;
        b=hqxoBng/CavFPILF3XTaCP0hdlrGVTFYcEVuZcRu1M2nQ/9ofUYBnVA6xdnpWWuy3d
         tLemHB+WZvRYGPE8HH+OLncnhKhFjbQc0l1MYLbbqxnLZoziaQZ6eQ7TOcl7OyVsBZWb
         CuLQ6BoHuCVbf7yWa7Qmcb1Jt0K44fRqsJYsnhUmjPZav58fEHLN5MMo60kHxUHefXnl
         K+t0Zu6g8DOdCvuNJHLcYJLRL/ktyo5YxUZMh2viTeAYDO4NRLCHsdZlcCWVUSnwJCLi
         pddtldwMDnlESbYlmjcwB0C2C+5aGF8SEQD30lRkhsiTdONGwuUR1Y3TWKmoT2O/sZYu
         cIhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=LZBZD86Znd9LyHdczTLvGztQ2bKPH9Yi3lDzItF2KWw=;
        b=JwIONVjNh9z+8L4hWc05IoY4D3Jk9L6XXYWtQp3YBfJyFmatNFgNLwvjDEpo0H7l+M
         rb6qJ3d7WHhKu0+lUefZD2FiO4TlB2gklfjA6JcdeNxVmBcwYt6H1olMlkU0v53TGE/8
         DhNyWdc2Yzjsg5C0orTMvD927fw9fWjkLgC2dofNMmW6IdyLC4DxNDDUYmEWRhuBEkSe
         G3EIVx6n6S7JFJd/9z2K+7OwIQdzkXdY343AXHAbc4axiRD2Skx/uCB8Vs20oAuZou3Z
         JPFAZuh0kE54Ed7WrWNT073UtE4I0i+SRncp1cQHswAqhHjbetTvnBtBUIw0eJBOnP6Y
         SupA==
X-Gm-Message-State: AGRZ1gKIJnPgcWDYFe5w5yEEKWOFeN6fJNfASMT26HqAekwggMscdVXu
        6eBDJo0thz8Wt/U6G1rDh4Y8Vw==
X-Google-Smtp-Source: AJdET5csVSw8rOnSLuu0/5ZHJYO4LwWh4n88DP3oYUT2NICBwFSDWdKjRu6fqlHwL2K1OaBXZhjWbg==
X-Received: by 2002:a62:5343:: with SMTP id h64-v6mr7523295pfb.226.1542306362402;
        Thu, 15 Nov 2018 10:26:02 -0800 (PST)
Received: from vader ([64.114.255.97])
        by smtp.gmail.com with ESMTPSA id x12sm26569212pgr.55.2018.11.15.10.26.00
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 15 Nov 2018 10:26:01 -0800 (PST)
Date:   Thu, 15 Nov 2018 10:25:59 -0800
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
Subject: Re: [PATCH V10 01/19] block: introduce multi-page page bvec helpers
Message-ID: <20181115182559.GA9348@vader>
References: <20181115085306.9910-1-ming.lei@redhat.com>
 <20181115085306.9910-2-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181115085306.9910-2-ming.lei@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Nov 15, 2018 at 04:52:48PM +0800, Ming Lei wrote:
> This patch introduces helpers of 'mp_bvec_iter_*' for multipage
> bvec support.
> 
> The introduced helpers treate one bvec as real multi-page segment,
> which may include more than one pages.
> 
> The existed helpers of bvec_iter_* are interfaces for supporting current
> bvec iterator which is thought as single-page by drivers, fs, dm and
> etc. These introduced helpers will build single-page bvec in flight, so
> this way won't break current bio/bvec users, which needn't any change.
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

But a couple of comments below.

> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> ---
>  include/linux/bvec.h | 63 +++++++++++++++++++++++++++++++++++++++++++++++++---
>  1 file changed, 60 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/bvec.h b/include/linux/bvec.h
> index 02c73c6aa805..8ef904a50577 100644
> --- a/include/linux/bvec.h
> +++ b/include/linux/bvec.h
> @@ -23,6 +23,44 @@
>  #include <linux/kernel.h>
>  #include <linux/bug.h>
>  #include <linux/errno.h>
> +#include <linux/mm.h>
> +
> +/*
> + * What is multi-page bvecs?
> + *
> + * - bvecs stored in bio->bi_io_vec is always multi-page(mp) style
> + *
> + * - bvec(struct bio_vec) represents one physically contiguous I/O
> + *   buffer, now the buffer may include more than one pages after
> + *   multi-page(mp) bvec is supported, and all these pages represented
> + *   by one bvec is physically contiguous. Before mp support, at most
> + *   one page is included in one bvec, we call it single-page(sp)
> + *   bvec.
> + *
> + * - .bv_page of the bvec represents the 1st page in the mp bvec
> + *
> + * - .bv_offset of the bvec represents offset of the buffer in the bvec
> + *
> + * The effect on the current drivers/filesystem/dm/bcache/...:
> + *
> + * - almost everyone supposes that one bvec only includes one single
> + *   page, so we keep the sp interface not changed, for example,
> + *   bio_for_each_segment() still returns bvec with single page
> + *
> + * - bio_for_each_segment*() will be changed to return single-page
> + *   bvec too
> + *
> + * - during iterating, iterator variable(struct bvec_iter) is always
> + *   updated in multipage bvec style and that means bvec_iter_advance()
> + *   is kept not changed
> + *
> + * - returned(copied) single-page bvec is built in flight by bvec
> + *   helpers from the stored multipage bvec
> + *
> + * - In case that some components(such as iov_iter) need to support
> + *   multi-page bvec, we introduce new helpers(mp_bvec_iter_*) for
> + *   them.
> + */

This comment sounds more like a commit message (i.e., how were things
before, and how are we changing them). In a couple of years when I read
this code, I probably won't care how it was changed, just how it works.
So I think a comment explaining the concepts of multi-page and
single-page bvecs is very useful, but please move all of the "foo was
changed" and "before mp support" type stuff to the commit message.

>  /*
>   * was unsigned short, but we might as well be ready for > 64kB I/O pages
> @@ -50,16 +88,35 @@ struct bvec_iter {
>   */
>  #define __bvec_iter_bvec(bvec, iter)	(&(bvec)[(iter).bi_idx])
>  
> -#define bvec_iter_page(bvec, iter)				\
> +#define mp_bvec_iter_page(bvec, iter)				\
>  	(__bvec_iter_bvec((bvec), (iter))->bv_page)
>  
> -#define bvec_iter_len(bvec, iter)				\
> +#define mp_bvec_iter_len(bvec, iter)				\
>  	min((iter).bi_size,					\
>  	    __bvec_iter_bvec((bvec), (iter))->bv_len - (iter).bi_bvec_done)
>  
> -#define bvec_iter_offset(bvec, iter)				\
> +#define mp_bvec_iter_offset(bvec, iter)				\
>  	(__bvec_iter_bvec((bvec), (iter))->bv_offset + (iter).bi_bvec_done)
>  
> +#define mp_bvec_iter_page_idx(bvec, iter)			\
> +	(mp_bvec_iter_offset((bvec), (iter)) / PAGE_SIZE)
> +
> +/*
> + * <page, offset,length> of single-page(sp) segment.
> + *
> + * This helpers are for building sp bvec in flight.
> + */
> +#define bvec_iter_offset(bvec, iter)					\
> +	(mp_bvec_iter_offset((bvec), (iter)) % PAGE_SIZE)
> +
> +#define bvec_iter_len(bvec, iter)					\
> +	min_t(unsigned, mp_bvec_iter_len((bvec), (iter)),		\
> +	    (PAGE_SIZE - (bvec_iter_offset((bvec), (iter)))))

The parentheses around (bvec_iter_offset((bvec), (iter))) and
(PAGE_SIZE - (bvec_iter_offset((bvec), (iter)))) are unnecessary
clutter. This looks easier to read to me:

#define bvec_iter_len(bvec, iter)					\
	min_t(unsigned, mp_bvec_iter_len((bvec), (iter)),		\
	      PAGE_SIZE - bvec_iter_offset((bvec), (iter)))

> +
> +#define bvec_iter_page(bvec, iter)					\
> +	nth_page(mp_bvec_iter_page((bvec), (iter)),		\
> +		 mp_bvec_iter_page_idx((bvec), (iter)))
> +
>  #define bvec_iter_bvec(bvec, iter)				\
>  ((struct bio_vec) {						\
>  	.bv_page	= bvec_iter_page((bvec), (iter)),	\
> -- 
> 2.9.5
> 
