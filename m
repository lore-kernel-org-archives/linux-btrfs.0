Return-Path: <SRS0=S1wN=N3=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_MUTT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CFE3C43441
	for <linux-btrfs@archiver.kernel.org>; Fri, 16 Nov 2018 16:41:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 330E520684
	for <linux-btrfs@archiver.kernel.org>; Fri, 16 Nov 2018 16:41:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=osandov-com.20150623.gappssmtp.com header.i=@osandov-com.20150623.gappssmtp.com header.b="g8W/KOH8"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 330E520684
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=osandov.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390314AbeKQCyA (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 16 Nov 2018 21:54:00 -0500
Received: from mail-pl1-f175.google.com ([209.85.214.175]:34767 "EHLO
        mail-pl1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390313AbeKQCx7 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 16 Nov 2018 21:53:59 -0500
Received: by mail-pl1-f175.google.com with SMTP id f12-v6so11425960plo.1
        for <linux-btrfs@vger.kernel.org>; Fri, 16 Nov 2018 08:40:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=osandov-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=bny0TXB+9Px9Iy+gNMLb4H8gjcq4AOg+MD+AIz84fCw=;
        b=g8W/KOH8dZzK+WRcnsaWa6XKyDUuvqnBz24eOJ7BwIiQV1graz5dEOAWyuo8doRPW9
         XoULjFdbOCJ2An4IXJHWqnTagIYv32w3I4IGaeH83KIJLkoSos6HhiMYXf8jKUqFXzH5
         BHR/qlei4Tt1VmPYeBfE7bwYJuoR/nb3mbPVZoo7MJKLSwjE7nkvL2m3SjinoN6wffv8
         0Gr3ehjITIE0ExjDvd58NwA97iv/TGLtEhADx/mb9kr3VEi/+9yS3toa/TBLyM7q6A9h
         27O/bVFHjJc4rGPPJ+PK2iKHWFUeyYu67WrgBzznG+wxTeljKIU9iVAApH6/4nHYn9UW
         LTNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=bny0TXB+9Px9Iy+gNMLb4H8gjcq4AOg+MD+AIz84fCw=;
        b=siwFCzyvebxwIWcZxeOMlwrbj12M4yjCPTFVU49rPsRnfGOCpBXuQ+qcT/W9PwkjFa
         Q/+jCm6lidBU7TtdvP9btK9TrrIxp+Jn7CmTfMNx28He7qdaKeLc6yv19mfNLuT05PNa
         CAWle6RSYZ9K0e35WOiBRcBtcLGDASVSt6GmWJJqSWjM55eDCksPVW1MEoTED8TM4AVt
         +rEnVLlShKa7lkTaDhVkes6aZFX4nvTrSo0Ryo1OtLEkZGJS0ceoFFWDO4YokayaDnFV
         HQznev6z/68T4nH+MyzeyAUB9Q5ML6rTlhZJnXHJv/hTJ0+SQ8OTwx+Ai+MIQFahEs3I
         aliQ==
X-Gm-Message-State: AGRZ1gKPsmWKMDFMLK4T14loTLzFEv9LD2+xBwG7gh6YcolCH3Ge4de8
        MNbNOqMqqGuTVZVgSz5Nt0Mu8A==
X-Google-Smtp-Source: AJdET5eFG8fx0T3F+JVe59UfhXxaDDI9DZh3ex+iVka0uMMsTCebGTiK3K4TApqM1zyWPjmymOGiKA==
X-Received: by 2002:a17:902:8214:: with SMTP id x20-v6mr11166302pln.224.1542386453671;
        Fri, 16 Nov 2018 08:40:53 -0800 (PST)
Received: from vader ([64.114.255.114])
        by smtp.gmail.com with ESMTPSA id q35sm17109981pgk.12.2018.11.16.08.40.52
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 16 Nov 2018 08:40:53 -0800 (PST)
Date:   Fri, 16 Nov 2018 08:40:51 -0800
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
Subject: Re: [PATCH V10 19/19] block: kill BLK_MQ_F_SG_MERGE
Message-ID: <20181116164051.GX23828@vader>
References: <20181115085306.9910-1-ming.lei@redhat.com>
 <20181115085306.9910-20-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181115085306.9910-20-ming.lei@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Nov 15, 2018 at 04:53:06PM +0800, Ming Lei wrote:
> QUEUE_FLAG_NO_SG_MERGE has been killed, so kill BLK_MQ_F_SG_MERGE too.
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
>  block/blk-mq-debugfs.c       | 1 -
>  drivers/block/loop.c         | 2 +-
>  drivers/block/nbd.c          | 2 +-
>  drivers/block/rbd.c          | 2 +-
>  drivers/block/skd_main.c     | 1 -
>  drivers/block/xen-blkfront.c | 2 +-
>  drivers/md/dm-rq.c           | 2 +-
>  drivers/mmc/core/queue.c     | 3 +--
>  drivers/scsi/scsi_lib.c      | 2 +-
>  include/linux/blk-mq.h       | 1 -
>  10 files changed, 7 insertions(+), 11 deletions(-)

[snip]
