Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D451C433E6
	for <linux-btrfs@archiver.kernel.org>; Tue, 22 Dec 2020 13:36:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 05EA523103
	for <linux-btrfs@archiver.kernel.org>; Tue, 22 Dec 2020 13:36:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726860AbgLVNgb (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 22 Dec 2020 08:36:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726756AbgLVNga (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 22 Dec 2020 08:36:30 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36B43C0613D3;
        Tue, 22 Dec 2020 05:35:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=IxaNHpnOj9YwPK8LjTC5qlGupfpYqIUDDfOBgg1n2xY=; b=Fj3VAl3hC1R4ecCdp0PNCgLYW9
        ZMSmwmyTCDZi9f9m/tZEfmOyaBx4FH3W4zcOkkq5aUHF62X2xXyNc2LRTUCN4sfiuFr843m0DBwAc
        ckxuteDDKlulow3e4WNrRzYzL2USNCxHQ+X+u3yKcP7CiEksceZuMvE99I4QWqn5Ovboux6DOwwIL
        1zGKW+kelFTCLv04UZTGF4UEnR3UKXRRcHIt4xJ5x5PG17n0o7i0jrjWweUswVewgKsjygSEizIaz
        sYlqhJmUCSEkIPDKiNNO0TYNt8qN9CAboFN9gZpz2pZmRIZE9PUi0IU7U22+1YAOMsSpqLlBh19gi
        3xOBLsIQ==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1krhpL-0001jY-GN; Tue, 22 Dec 2020 13:35:47 +0000
Date:   Tue, 22 Dec 2020 13:35:47 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     Naohiro Aota <naohiro.aota@wdc.com>
Cc:     linux-btrfs@vger.kernel.org, dsterba@suse.com, hare@suse.com,
        linux-fsdevel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Christoph Hellwig <hch@infradead.org>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v11 01/40] block: add bio_add_zone_append_page
Message-ID: <20201222133547.GC5099@infradead.org>
References: <cover.1608515994.git.naohiro.aota@wdc.com>
 <06add214bc16ef08214de1594ecdfcc4cdcdbd78.1608608848.git.naohiro.aota@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <06add214bc16ef08214de1594ecdfcc4cdcdbd78.1608608848.git.naohiro.aota@wdc.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

> +int bio_add_zone_append_page(struct bio *bio, struct page *page,
> +			     unsigned int len, unsigned int offset)
> +{
> +	struct request_queue *q;
> +	bool same_page = false;
> +
> +	if (WARN_ON_ONCE(bio_op(bio) != REQ_OP_ZONE_APPEND))
> +		return 0;
> +
> +	q = bio->bi_disk->queue;

I'd still prefer to initialize q at declaration time.

But except for this cosmetic nitpick the patch looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
