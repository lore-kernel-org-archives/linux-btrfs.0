Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DE07C432BE
	for <linux-btrfs@archiver.kernel.org>; Mon, 26 Jul 2021 10:16:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 319A860F22
	for <linux-btrfs@archiver.kernel.org>; Mon, 26 Jul 2021 10:16:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233081AbhGZJfm (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 26 Jul 2021 05:35:42 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:24856 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232955AbhGZJfl (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 26 Jul 2021 05:35:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627294570;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7iZduvyTXATyk5FvcsQduGt6p3a0FG7RvWO3vuB7s0U=;
        b=MOs7Ev7MUKD1l+WydFwh8qM9O3qgOqPOfGmkIStdnjk+kYRjNsyo0tr2oA1/GPg4z3Uugb
        sqfd+KFcUYkZwq4kEzFDHkpia4M00UUBY/alxAG6wCzasz9qzaHFgZx2ae7kJtLoQKXXyq
        boAU6exFzC/6Bl+2iZb0QatDnhY1bKs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-274-zqkMbXsNPuiKc67TFd8yuA-1; Mon, 26 Jul 2021 06:16:08 -0400
X-MC-Unique: zqkMbXsNPuiKc67TFd8yuA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8F3D2760C0;
        Mon, 26 Jul 2021 10:16:07 +0000 (UTC)
Received: from T590 (ovpn-13-107.pek2.redhat.com [10.72.13.107])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9DA1E19D9F;
        Mon, 26 Jul 2021 10:15:57 +0000 (UTC)
Date:   Mon, 26 Jul 2021 18:15:55 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Naohiro Aota <naohiro.aota@wdc.com>,
        linux-block@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 03/10] block: unhash the block device inodes earlier
Message-ID: <YP6LW7YqRGVDSCmK@T590>
References: <20210724071249.1284585-1-hch@lst.de>
 <20210724071249.1284585-4-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210724071249.1284585-4-hch@lst.de>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Sat, Jul 24, 2021 at 09:12:42AM +0200, Christoph Hellwig wrote:
> Unhash the block device inodes as early as possible.  This ensures that
> the inode and thus block_device an't be found in the inode hash as soon
> as we start deleting the disk, instead of finding it and rejecting it
> later because GENHD_FL_UP is cleared.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Ming Lei <ming.lei@redhat.com>

-- 
Ming

