Return-Path: <SRS0=mYd/=OF=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60777C43441
	for <linux-btrfs@archiver.kernel.org>; Mon, 26 Nov 2018 22:18:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 26FDC20664
	for <linux-btrfs@archiver.kernel.org>; Mon, 26 Nov 2018 22:18:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=osandov-com.20150623.gappssmtp.com header.i=@osandov-com.20150623.gappssmtp.com header.b="vkeurhET"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 26FDC20664
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=osandov.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727278AbeK0JOR (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 27 Nov 2018 04:14:17 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:38805 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727244AbeK0JOQ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 27 Nov 2018 04:14:16 -0500
Received: by mail-pl1-f193.google.com with SMTP id e5so14543741plb.5
        for <linux-btrfs@vger.kernel.org>; Mon, 26 Nov 2018 14:18:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=osandov-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=nnRkIidyTMCkCU8s4XbXhP39Wm67YCXxFtSWO/jSdU8=;
        b=vkeurhETkMrogwJmGI3eGa62QwDe4P+LcCcTlzyvWMH3ofHRs0MY6V2ZMtGLgSIJu8
         5TKpaf4v3xugYKohlsROKlKr07KQ+fgqw8xPMYAd536f4Bcp9YPfRYXrheq/uNZ/k/Hb
         wJwj0EW2vCOTGMz6LZxSHYJYkjrZeU+oOJuwmjTOrb2V2IsCRhZ682+Sz0kpWUHauGPg
         MLttGBLspbnFV4OAasq9Um7tqAJHWSITMjVpHsB7yZ2axltVtfxE7yy5GyNpYGRJpHTd
         MRHF3qI73pJ/mlDJxZyYTiTvRj8vsLSXGxzswrshkk4UkJIMQ7P+yk2ARm3KaeDpD2oQ
         elNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=nnRkIidyTMCkCU8s4XbXhP39Wm67YCXxFtSWO/jSdU8=;
        b=fBXiWarFEeB8VnusD0XQBi6xfBJF8VJ1ihJCv9PA3qsWN0Q4ArVy5vt229SzOHjiih
         P5DAiPaGTg0ygsoN2FOC6d2A63U2wkHihQZPdrYzUYmo7tUIg9UcWfNUjqPorOicc9fH
         +6jz2KiyOrVbh1wd0NQoHGqn/YZukZCmuaNpNwly7krJIGSRYCbfqRyb4DRGiV2bqUuH
         1CA8gogmIEsmqwmPD8z/bv4Woco0lvrh+mRzvRXTFKci6SdZYsUyZbVg2cKZrvkha9dI
         GeUeTSIsfYj7H93/Cnk3zbq8Kwf0FIS0dGc6FuSmz0o1bn1OirMy5Et+kw0N1FdHVJeX
         mOWQ==
X-Gm-Message-State: AA+aEWZQr7oamyq65bPtP9JOpYww1svRuHP37ZOlPMZsBTQ47Mda6KJw
        fESmBUiYDh0psHNX8yaovQkvIA==
X-Google-Smtp-Source: AFSGD/UZvPnmXOxr18I1aqWNh2aCKHb4dIcemmTBolztFwKCRREIPoguVnvpQPIq5Z5KW+MHH3uPZA==
X-Received: by 2002:a17:902:8214:: with SMTP id x20-v6mr28569658pln.224.1543270720790;
        Mon, 26 Nov 2018 14:18:40 -0800 (PST)
Received: from vader ([2601:602:8b00:55d3:e6a7:a0ff:fe0b:c9a8])
        by smtp.gmail.com with ESMTPSA id u69sm1721000pfj.116.2018.11.26.14.18.36
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 26 Nov 2018 14:18:38 -0800 (PST)
Date:   Mon, 26 Nov 2018 14:18:35 -0800
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
Subject: Re: [PATCH V12 06/20] block: rename bvec helpers
Message-ID: <20181126221835.GG30411@vader>
References: <20181126021720.19471-1-ming.lei@redhat.com>
 <20181126021720.19471-7-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181126021720.19471-7-ming.lei@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Nov 26, 2018 at 10:17:06AM +0800, Ming Lei wrote:
> We will support multi-page bvec soon, and have to deal with
> single-page vs multi-page bvec. This patch follows Christoph's
> suggestion to rename all the following helpers:
> 
> 	for_each_bvec
> 	bvec_iter_bvec
> 	bvec_iter_len
> 	bvec_iter_page
> 	bvec_iter_offset
> 
> into:
> 	for_each_segment
> 	segment_iter_bvec
> 	segment_iter_len
> 	segment_iter_page
> 	segment_iter_offset
> 
> so that these helpers named with 'segment' only deal with single-page
> bvec, or called segment. We will introduce helpers named with 'bvec'
> for multi-page bvec.
> 
> bvec_iter_advance() isn't renamed becasue this helper is always operated
> on real bvec even though multi-page bvec is supported.
> 
> Suggested-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Omar Sandoval <osandov@fb.com>

> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> ---
>  .clang-format                  |  2 +-
>  drivers/md/dm-integrity.c      |  2 +-
>  drivers/md/dm-io.c             |  4 ++--
>  drivers/nvdimm/blk.c           |  4 ++--
>  drivers/nvdimm/btt.c           |  4 ++--
>  include/linux/bio.h            | 10 +++++-----
>  include/linux/bvec.h           | 20 +++++++++++---------
>  include/linux/ceph/messenger.h |  2 +-
>  lib/iov_iter.c                 |  2 +-
>  net/ceph/messenger.c           | 14 +++++++-------
>  10 files changed, 33 insertions(+), 31 deletions(-)
