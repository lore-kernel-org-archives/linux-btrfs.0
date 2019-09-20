Return-Path: <SRS0=xOG6=XP=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B58D9C4CEC9
	for <linux-btrfs@archiver.kernel.org>; Fri, 20 Sep 2019 14:38:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8DC3620B7C
	for <linux-btrfs@archiver.kernel.org>; Fri, 20 Sep 2019 14:38:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392980AbfITOir (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 20 Sep 2019 10:38:47 -0400
Received: from mx2.suse.de ([195.135.220.15]:60170 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2392975AbfITOiq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 20 Sep 2019 10:38:46 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 37BE6AD12;
        Fri, 20 Sep 2019 14:38:44 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id 0191F1E3C02; Fri, 20 Sep 2019 16:38:55 +0200 (CEST)
Date:   Fri, 20 Sep 2019 16:38:55 +0200
From:   Jan Kara <jack@suse.cz>
To:     Omar Sandoval <osandov@osandov.com>
Cc:     linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
        Dave Chinner <david@fromorbit.com>, linux-api@vger.kernel.org,
        kernel-team@fb.com, Jan Kara <jack@suse.cz>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [RFC PATCH 1/3] fs: pass READ/WRITE to kiocb_set_rw_flags()
Message-ID: <20190920143855.GD25765@quack2.suse.cz>
References: <cover.1568875700.git.osandov@fb.com>
 <d23a40f0ad3fa0631fe6189b94811be473e7cc4a.1568875700.git.osandov@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d23a40f0ad3fa0631fe6189b94811be473e7cc4a.1568875700.git.osandov@fb.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed 18-09-19 23:53:44, Omar Sandoval wrote:
> From: Omar Sandoval <osandov@fb.com>
> 
> A following change will want to check whether an IO is a read or write
> in kiocb_set_rw_flags(). Additionally, aio and io_uring currently set
> the IOCB_WRITE flag on a kiocb right before calling call_write_iter(),
> but we can move that into the common code.
> 
> Cc: Jan Kara <jack@suse.cz>
> Cc: Jens Axboe <axboe@kernel.dk>
> Signed-off-by: Omar Sandoval <osandov@fb.com>
...
> index ffe35d97afcb..75c4b7680385 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -3351,8 +3351,11 @@ static inline int iocb_flags(struct file *file)
>  	return res;
>  }
>  
> -static inline int kiocb_set_rw_flags(struct kiocb *ki, rwf_t flags)
> +static inline int kiocb_set_rw_flags(int rw, struct kiocb *ki, rwf_t flags)
>  {
> +	if (rw == WRITE)
> +		ki->ki_flags |= IOCB_WRITE;
> +
>  	if (unlikely(flags & ~RWF_SUPPORTED))
>  		return -EOPNOTSUPP;

I'd find it more natural if the destination argument (i.e., kiocb) stayed
to be the first argument of the function. Otherwise the patch looks good to
me.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
