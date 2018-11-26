Return-Path: <SRS0=mYd/=OF=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6BD0C43441
	for <linux-btrfs@archiver.kernel.org>; Mon, 26 Nov 2018 22:44:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AB157208E4
	for <linux-btrfs@archiver.kernel.org>; Mon, 26 Nov 2018 22:44:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=osandov-com.20150623.gappssmtp.com header.i=@osandov-com.20150623.gappssmtp.com header.b="Z0bQFfql"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AB157208E4
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=osandov.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727569AbeK0Jk0 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 27 Nov 2018 04:40:26 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:36038 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727311AbeK0JkX (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 27 Nov 2018 04:40:23 -0500
Received: by mail-pg1-f196.google.com with SMTP id n2so6862423pgm.3
        for <linux-btrfs@vger.kernel.org>; Mon, 26 Nov 2018 14:44:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=osandov-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=cA9eOqjetgKdwTc0IyYrmBxIamtijscygN3GSsAT39o=;
        b=Z0bQFfqlNiGrkj90Vl6WWbS+aa0UGMgFkN5W5rWNB0z7ULOP4pQv4acxcfxe2Yu8qB
         4W3Sww2RJW17EOid7sccXAKeBNDhBUgM6gKCJHhAcTuUhkIm1q7U9zB5wGs/6e9+B1sB
         jO3SNgel20symJK9mP+LJ7Y3kpOfRghqXkkhCU9QL4oO3tB7ZQTRPZP5kfan5gMDGUqK
         ByXzD3ty1oNCWb336xuJZx0OHpUV+9jUUPIC92388B5wMuCva9C/hlBOKo7B4LDv/ZX0
         xuB6whVjbQKLUy9bAF/R6Nq8fEBlkfdluRV1yKs7Bl7Nw+VkHmjSzJ3j7ID3cQBCTnDZ
         VFeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=cA9eOqjetgKdwTc0IyYrmBxIamtijscygN3GSsAT39o=;
        b=LN3ugQ061bihQeTQGR0DJWEIBGQ7KfXcNa1xtVxWq9zGEDwNeR9H0Iwy5cx14XZLxY
         +9PeQgeHc2sjLAe1+Xrw88ciqy+7DasT3VSkymQFPD9XhT50Sw0rqZzN4npCZw5BDyrr
         XCusTshp8WacsBqtlbWD7ite0rEWqdLcOEuUov6S6plmRuw1AGGlSTKQKwtmJDryP9jC
         dT8cGToGeBEog7euaBV7gO6bE0TT1H8TXDDlFu/SLfyKgGxvLRMJpao19ILzUzIAQn4R
         wX3F8XQLdg80fF2YMFOitkHlRWN5meyHrQwO3FaD9VtH+s1dhvFQUsS+vfj3qJQb0zA9
         DPdw==
X-Gm-Message-State: AA+aEWaqbiz9VInwv77LxFD/jpKJOOlj/USIMW2dWth6tRxPPvEdaH6K
        azqkvn4kjAjCViVO5RS/rbz0jg==
X-Google-Smtp-Source: AFSGD/VY8xs+PEaRm5mqycYa0Hlc3dDL4yii3H+Z1byxLEHStBdMF628b3PHLUEXvo+3AFN58Vvpvw==
X-Received: by 2002:a63:2054:: with SMTP id r20mr26725129pgm.328.1543272282188;
        Mon, 26 Nov 2018 14:44:42 -0800 (PST)
Received: from vader ([2601:602:8b00:55d3:e6a7:a0ff:fe0b:c9a8])
        by smtp.gmail.com with ESMTPSA id l63-v6sm1769066pfb.75.2018.11.26.14.44.40
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 26 Nov 2018 14:44:41 -0800 (PST)
Date:   Mon, 26 Nov 2018 14:44:39 -0800
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
Subject: Re: [PATCH V12 17/20] block: always define BIO_MAX_PAGES as 256
Message-ID: <20181126224439.GN30411@vader>
References: <20181126021720.19471-1-ming.lei@redhat.com>
 <20181126021720.19471-18-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181126021720.19471-18-ming.lei@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Nov 26, 2018 at 10:17:17AM +0800, Ming Lei wrote:
> Now multi-page bvec can cover CONFIG_THP_SWAP, so we don't need to
> increase BIO_MAX_PAGES for it.
> 
> CONFIG_THP_SWAP needs to split one THP into normal pages and adds
> them all to one bio. With multipage-bvec, it just takes one bvec to
> hold them all.
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Omar Sandoval <osandov@fb.com>

> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> ---
>  include/linux/bio.h | 8 --------
>  1 file changed, 8 deletions(-)
> 
> diff --git a/include/linux/bio.h b/include/linux/bio.h
> index 5505f74aef8b..7be48c55b14a 100644
> --- a/include/linux/bio.h
> +++ b/include/linux/bio.h
> @@ -34,15 +34,7 @@
>  #define BIO_BUG_ON
>  #endif
>  
> -#ifdef CONFIG_THP_SWAP
> -#if HPAGE_PMD_NR > 256
> -#define BIO_MAX_PAGES		HPAGE_PMD_NR
> -#else
>  #define BIO_MAX_PAGES		256
> -#endif
> -#else
> -#define BIO_MAX_PAGES		256
> -#endif
>  
>  #define bio_prio(bio)			(bio)->bi_ioprio
>  #define bio_set_prio(bio, prio)		((bio)->bi_ioprio = prio)
> -- 
> 2.9.5
> 
