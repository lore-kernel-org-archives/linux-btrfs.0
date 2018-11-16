Return-Path: <SRS0=S1wN=N3=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D6DFC43610
	for <linux-btrfs@archiver.kernel.org>; Fri, 16 Nov 2018 00:20:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C93EF208A3
	for <linux-btrfs@archiver.kernel.org>; Fri, 16 Nov 2018 00:20:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=osandov-com.20150623.gappssmtp.com header.i=@osandov-com.20150623.gappssmtp.com header.b="wiTESMyL"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C93EF208A3
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=osandov.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389114AbeKPKab (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 16 Nov 2018 05:30:31 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:37885 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389066AbeKPKaa (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 16 Nov 2018 05:30:30 -0500
Received: by mail-pl1-f193.google.com with SMTP id b5so3835839plr.4
        for <linux-btrfs@vger.kernel.org>; Thu, 15 Nov 2018 16:20:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=osandov-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=k6RVFd+Vc0pfdcIaqX824O1heqiP0xSaSAehffCttMk=;
        b=wiTESMyL5dqVRjbKaF3lqQafRzn4fD2CmMEEuGXYoy9BucJn1wjfdUQGcgIGszIxzw
         aSGoiV4BuM2mWpRoVdyMsKio4h1LfrHxwpAwDjfWqTiiooDZy4SiypGgXNwNHTSNEtNT
         AwhAoTqgxU+lWBiroMHUOFlupCBe6hrqs2rPDAIutpb+1jtSJG/4qNW1Vt2JMbj+34Hk
         fa3W8d3iXCJU7mXvImDoeUiGQY17fIuEU/rNtweFVtkjIKPeJ/0+bxRVWvDzSmngffLs
         MUQZm98vGL/G5DhQ1Xdg2XlfQRHxpEwftnHlu65FKAr0Ou5hT/0Hg4vfaJj9tG9USJR9
         YmYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=k6RVFd+Vc0pfdcIaqX824O1heqiP0xSaSAehffCttMk=;
        b=Fmjj9lctImr2G9tf6r0KcQrTLO4+b5G5guYwJd5BaTXTe9QEz+cJ3TJBJy9MxLr3MR
         B1tjawsBYqq8GuvUgijvqcz7741CJDHTU1W1HoAHYcpLTbFMs0FuQ8UCiWBxDiaX4dpJ
         ELaY5wwhqy2iCFK/ICLlPwUEGCiPrgwqcUk2YqvZZz2nHtKjKmRL76+AVJ8sk9qf5bIU
         x74jfWv8QE+9E2AICSgPev7gBQ5V5Fh2G3JOvLjIvo+BMgDWYzrmaX3YabOsV+5cRhbj
         zWD9m6IO+xuEWR73kFw8Qc4uJNoMK3d+l+WwTf31aAPw8nepNo/A2sxnTLV/DKeJ8kH7
         HqgQ==
X-Gm-Message-State: AGRZ1gIuNrqbKKCE4SUdwsgTLu5t8NeDAhzoLIoAjHtqKWDo4xb079TF
        X0hjynqVDfmA0LTb2wUDNaXNlQ==
X-Google-Smtp-Source: AJdET5fKVPn+iIW61iLWhEosSg5589LR6m3lIxuiM05g3Y/tYl5Es6VZhvHdcmSItsJ1rZb8Jg+C6A==
X-Received: by 2002:a17:902:e01:: with SMTP id 1-v6mr8205945plw.251.1542327623756;
        Thu, 15 Nov 2018 16:20:23 -0800 (PST)
Received: from vader ([64.114.255.97])
        by smtp.gmail.com with ESMTPSA id m20sm4874872pgv.93.2018.11.15.16.20.22
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 15 Nov 2018 16:20:23 -0800 (PST)
Date:   Thu, 15 Nov 2018 16:20:20 -0800
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
Subject: Re: [PATCH V10 06/19] fs/buffer.c: use bvec iterator to truncate the
 bio
Message-ID: <20181116002020.GA23828@vader>
References: <20181115085306.9910-1-ming.lei@redhat.com>
 <20181115085306.9910-7-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181115085306.9910-7-ming.lei@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Nov 15, 2018 at 04:52:53PM +0800, Ming Lei wrote:
> Once multi-page bvec is enabled, the last bvec may include more than one
> page, this patch use bvec_last_segment() to truncate the bio.
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

> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> ---
>  fs/buffer.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/buffer.c b/fs/buffer.c
> index 1286c2b95498..fa37ad52e962 100644
> --- a/fs/buffer.c
> +++ b/fs/buffer.c
> @@ -3032,7 +3032,10 @@ void guard_bio_eod(int op, struct bio *bio)
>  
>  	/* ..and clear the end of the buffer for reads */
>  	if (op == REQ_OP_READ) {
> -		zero_user(bvec->bv_page, bvec->bv_offset + bvec->bv_len,
> +		struct bio_vec bv;
> +
> +		bvec_last_segment(bvec, &bv);
> +		zero_user(bv.bv_page, bv.bv_offset + bv.bv_len,
>  				truncated_bytes);
>  	}
>  }
> -- 
> 2.9.5
> 
