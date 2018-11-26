Return-Path: <SRS0=mYd/=OF=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA125C43441
	for <linux-btrfs@archiver.kernel.org>; Mon, 26 Nov 2018 22:42:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6DD9620659
	for <linux-btrfs@archiver.kernel.org>; Mon, 26 Nov 2018 22:42:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=osandov-com.20150623.gappssmtp.com header.i=@osandov-com.20150623.gappssmtp.com header.b="Bx1j+lqw"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6DD9620659
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=osandov.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727416AbeK0JiV (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 27 Nov 2018 04:38:21 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:39338 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727188AbeK0JiV (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 27 Nov 2018 04:38:21 -0500
Received: by mail-pf1-f195.google.com with SMTP id c72so7299038pfc.6
        for <linux-btrfs@vger.kernel.org>; Mon, 26 Nov 2018 14:42:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=osandov-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=YuH1w73FA6WYLZ5PA5S14thQJO6eyI0QOFLNT60OTJc=;
        b=Bx1j+lqwud+6YMhgE8fvAnnofXRSIVMmc4+dX0jlcXSpQCJIk4B+bUhHBljIazVRGJ
         Yk7s53K7vLYUdH1weyn8juWVj7JnXzi4lGAfPAqHbV7l99W7b0q0X6Xn3PZqUWOcrEkd
         mZuZVvlCcEBBZzZGHo/SlfB6fKZZiy8Kphak3sinkPySYb/ehv1xJQG2UrhQdwAVIpJw
         SqRls5qx0kDzq2oTQD6DeCRgGHBuLLy8Sf+pc5mZcJ7ip/ry2XBAAlCV/u0qQg7CnysJ
         Vjndg8quzQ7mwS0+GVH6zYEhFL676afI+yrinTaascDgESuKXzWQNI44jdwT8ZuzLxT3
         YTVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=YuH1w73FA6WYLZ5PA5S14thQJO6eyI0QOFLNT60OTJc=;
        b=t74+s08NrA214QqDfuWBcvAK3yABl2P7w3G4q/K7MJwYlQac8PasXQ0b33fmdsKD0D
         zm+eDAo7MYJ1dzKPIfCJsYUkMzzJqn8MwiV6P1ragG1UwsjKsbGZ+R0JRGYAEQy7Jut3
         Hl1RXxI9CRQ1CPkfjZyIVi9ericNb0dpPUrH3MyUWhJ+h8oiZhSVoK+ylGpi5xHCym0X
         U1CSLC62zarghFi9yV1JPv1On3GkcpnSZaImxSR63KWZ0WfelKmRguDzNKX5sQqCjTEJ
         bOULVN2CJufgVMuaBFJYpP5ZjULOkR/1QNc16kq0XW0W9Q8XRAx4eQaPaIYQ3xvsSzFU
         e2eA==
X-Gm-Message-State: AGRZ1gJlc45fy6Lbuonv5hmZx/WDvpHKaevm8mov/ITHCkzAplwEun6n
        PF1Ma4VvdFVALA7LPZ6VA9+qaQ==
X-Google-Smtp-Source: AJdET5e2BEpZc6Fotrea8olGNGHkemA82Jgu1cMl9/akUhhNFtk5Vm9tZfEYpy7G9FZMTaL59XcYxg==
X-Received: by 2002:a62:7687:: with SMTP id r129mr29880739pfc.17.1543272161181;
        Mon, 26 Nov 2018 14:42:41 -0800 (PST)
Received: from vader ([2601:602:8b00:55d3:e6a7:a0ff:fe0b:c9a8])
        by smtp.gmail.com with ESMTPSA id i4sm2029143pfj.82.2018.11.26.14.42.39
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 26 Nov 2018 14:42:40 -0800 (PST)
Date:   Mon, 26 Nov 2018 14:42:39 -0800
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
Subject: Re: [PATCH V12 15/20] block: allow bio_for_each_segment_all() to
 iterate over multi-page bvec
Message-ID: <20181126224239.GL30411@vader>
References: <20181126021720.19471-1-ming.lei@redhat.com>
 <20181126021720.19471-16-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181126021720.19471-16-ming.lei@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Nov 26, 2018 at 10:17:15AM +0800, Ming Lei wrote:
> This patch introduces one extra iterator variable to bio_for_each_segment_all(),
> then we can allow bio_for_each_segment_all() to iterate over multi-page bvec.
> 
> Given it is just one mechannical & simple change on all bio_for_each_segment_all()
> users, this patch does tree-wide change in one single patch, so that we can
> avoid to use a temporary helper for this conversion.
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Omar Sandoval <osandov@fb.com>

> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> ---
>  block/bio.c                       | 27 ++++++++++++++++++---------
>  block/bounce.c                    |  6 ++++--
>  drivers/md/bcache/btree.c         |  3 ++-
>  drivers/md/dm-crypt.c             |  3 ++-
>  drivers/md/raid1.c                |  3 ++-
>  drivers/staging/erofs/data.c      |  3 ++-
>  drivers/staging/erofs/unzip_vle.c |  3 ++-
>  fs/block_dev.c                    |  6 ++++--
>  fs/btrfs/compression.c            |  3 ++-
>  fs/btrfs/disk-io.c                |  3 ++-
>  fs/btrfs/extent_io.c              |  9 ++++++---
>  fs/btrfs/inode.c                  |  6 ++++--
>  fs/btrfs/raid56.c                 |  3 ++-
>  fs/crypto/bio.c                   |  3 ++-
>  fs/direct-io.c                    |  4 +++-
>  fs/exofs/ore.c                    |  3 ++-
>  fs/exofs/ore_raid.c               |  3 ++-
>  fs/ext4/page-io.c                 |  3 ++-
>  fs/ext4/readpage.c                |  3 ++-
>  fs/f2fs/data.c                    |  9 ++++++---
>  fs/gfs2/lops.c                    |  6 ++++--
>  fs/gfs2/meta_io.c                 |  3 ++-
>  fs/iomap.c                        |  6 ++++--
>  fs/mpage.c                        |  3 ++-
>  fs/xfs/xfs_aops.c                 |  5 +++--
>  include/linux/bio.h               | 11 +++++++++--
>  include/linux/bvec.h              | 30 ++++++++++++++++++++++++++++++
>  27 files changed, 125 insertions(+), 45 deletions(-)
