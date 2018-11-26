Return-Path: <SRS0=mYd/=OF=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15B20C43441
	for <linux-btrfs@archiver.kernel.org>; Mon, 26 Nov 2018 22:16:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CF7292082F
	for <linux-btrfs@archiver.kernel.org>; Mon, 26 Nov 2018 22:16:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=osandov-com.20150623.gappssmtp.com header.i=@osandov-com.20150623.gappssmtp.com header.b="NB5gi8Jc"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CF7292082F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=osandov.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727311AbeK0JLo (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 27 Nov 2018 04:11:44 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:39728 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726296AbeK0JLn (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 27 Nov 2018 04:11:43 -0500
Received: by mail-pf1-f195.google.com with SMTP id c72so7269084pfc.6
        for <linux-btrfs@vger.kernel.org>; Mon, 26 Nov 2018 14:16:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=osandov-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=/6jOHBgej+zantiyYcOwKY1cQOjjygQGOg2a3ZRqxqU=;
        b=NB5gi8JcdVSjwscW8/Rt4u8b2kMuTzleBvZzAlQZ+T9HKueOpU3AaB85jQTJD4jk3t
         nHTYYAFFsNSwKzPdlToeAzO0xPvMmuFKi0bYFePZTkTtEzayyQVv/DUusQAIGgNyd0n7
         vNA30QEY5zc2kZaq31CE2DT2LBjFGbEUJsrbP1okkm3x3hoAzu+oO+9/Wwhqe4srGTzc
         UV2lq9zpmC7DtrOQXl33VpEk0HtUWmS39A5DnUDRItubhM29fNZdPQk0idKeqtXbfQ8J
         NS/awNANctdAuCwkiDmLfqZZbRzXoL4a2V2cdsoi6XvOCJC5jJUSx+D/kaPEMe3EIlQn
         EmeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=/6jOHBgej+zantiyYcOwKY1cQOjjygQGOg2a3ZRqxqU=;
        b=CSyFbZ/NtyBbX2Y9R99pE2kHDQVeNgezB6XufC330X7Gn19pzAuwtVHe36P/dkdJLJ
         bhDk4YNX4pniA00TAytvu8F2+QBZMsnEjQciTKs9SDmx9AUjQShcrM1SrHf6S2eM9EHC
         fv+dW0+2xhpCEpp3W33YRHQlQtahtiqZkKqVogzAkVzGo6C6GEXqz9cHvFwSsaOL++5+
         P0qsjfAuVeKb83yqZq55aNuAq1K+f7fNbqmbfw5JYnzbPqQYLBC2wgeillbB6NbWUNzZ
         2ldOTPaVp7RTV1EtWlGc1ITDDXL6ZGzAZBnan+yRy6Hy/BUXML6VOZUdFEuLUKA5qy26
         y2Nw==
X-Gm-Message-State: AA+aEWbmCdksYXUUgXXvP8DOfFbA950EimQ3hsKrOD/UyHXWRFVLnnqF
        ibWUTy2eIraPYBXIB/yjO1cM4w==
X-Google-Smtp-Source: AFSGD/WkD2Jd+TYnAi5lcg29tMSVS++t5Jswlm8qvWgciBvd6QwP4uBQrZNdVEz5RrrM5+19nucgSA==
X-Received: by 2002:a63:f658:: with SMTP id u24mr26947651pgj.267.1543270568603;
        Mon, 26 Nov 2018 14:16:08 -0800 (PST)
Received: from vader ([2601:602:8b00:55d3:e6a7:a0ff:fe0b:c9a8])
        by smtp.gmail.com with ESMTPSA id o7sm1831055pfb.34.2018.11.26.14.16.06
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 26 Nov 2018 14:16:07 -0800 (PST)
Date:   Mon, 26 Nov 2018 14:16:06 -0800
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
Subject: Re: [PATCH V12 05/20] block: remove bvec_iter_rewind()
Message-ID: <20181126221606.GF30411@vader>
References: <20181126021720.19471-1-ming.lei@redhat.com>
 <20181126021720.19471-6-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181126021720.19471-6-ming.lei@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Nov 26, 2018 at 10:17:05AM +0800, Ming Lei wrote:
> Commit 7759eb23fd980 ("block: remove bio_rewind_iter()") removes
> bio_rewind_iter(), then no one uses bvec_iter_rewind() any more,
> so remove it.

Reviewed-by: Omar Sandoval <osandov@fb.com>

> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> ---
>  include/linux/bvec.h | 24 ------------------------
>  1 file changed, 24 deletions(-)
> 
> diff --git a/include/linux/bvec.h b/include/linux/bvec.h
> index 02c73c6aa805..ba0ae40e77c9 100644
> --- a/include/linux/bvec.h
> +++ b/include/linux/bvec.h
> @@ -92,30 +92,6 @@ static inline bool bvec_iter_advance(const struct bio_vec *bv,
>  	return true;
>  }
>  
> -static inline bool bvec_iter_rewind(const struct bio_vec *bv,
> -				     struct bvec_iter *iter,
> -				     unsigned int bytes)
> -{
> -	while (bytes) {
> -		unsigned len = min(bytes, iter->bi_bvec_done);
> -
> -		if (iter->bi_bvec_done == 0) {
> -			if (WARN_ONCE(iter->bi_idx == 0,
> -				      "Attempted to rewind iter beyond "
> -				      "bvec's boundaries\n")) {
> -				return false;
> -			}
> -			iter->bi_idx--;
> -			iter->bi_bvec_done = __bvec_iter_bvec(bv, *iter)->bv_len;
> -			continue;
> -		}
> -		bytes -= len;
> -		iter->bi_size += len;
> -		iter->bi_bvec_done -= len;
> -	}
> -	return true;
> -}
> -
>  #define for_each_bvec(bvl, bio_vec, iter, start)			\
>  	for (iter = (start);						\
>  	     (iter).bi_size &&						\
> -- 
> 2.9.5
> 
