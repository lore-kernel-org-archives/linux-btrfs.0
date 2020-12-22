Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A206DC433E6
	for <linux-btrfs@archiver.kernel.org>; Tue, 22 Dec 2020 13:39:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7B3E223103
	for <linux-btrfs@archiver.kernel.org>; Tue, 22 Dec 2020 13:39:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726885AbgLVNir (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 22 Dec 2020 08:38:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726557AbgLVNir (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 22 Dec 2020 08:38:47 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13A20C0613D3;
        Tue, 22 Dec 2020 05:38:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=WHrf6YIzjXVChJky7cwkEbpKWCOIRtddF2apRRbImRM=; b=Ka8WkTCfRgwJDV30XxpU4zv3Rw
        OcD9ZUR2gEeB07uocqNvER3TVtRzGeNKsiRk1/BaalIRaW5/+EgpiiL+6zdORp0+GVIIqAkS5QsSc
        r7SyO62mn7qAfvxAkHESJDwM0R3ILx04qCue43F3mYW2nT8ZkL8beTIMOj0O8LAf6Mv4ZRHNJjiZF
        SI9bOTympjHtkuA5mE29dYWFDp3RFYiRWzSdrrmcz9eSUH/vh8DdC6QNwyWfS/vAy8g3YhDPQtpUc
        KyQMQ/TdPKs0+YHoiIQEUFWtsy+oUvIQoaFYNsN/0YIvFIZDVdTqmDSHAwBujkrD0lB/mKSfngHRL
        oIkVleSw==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1krhrZ-0001rR-Oe; Tue, 22 Dec 2020 13:38:05 +0000
Date:   Tue, 22 Dec 2020 13:38:05 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     Naohiro Aota <naohiro.aota@wdc.com>
Cc:     linux-btrfs@vger.kernel.org, dsterba@suse.com, hare@suse.com,
        linux-fsdevel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v11 00/40] btrfs: zoned block device support
Message-ID: <20201222133805.GA6778@infradead.org>
References: <cover.1608515994.git.naohiro.aota@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1608515994.git.naohiro.aota@wdc.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

I just did a very quick look, but didn't see anything (based on the
subjects) that deals with ITER_BVEC direct I/O.  Is the support for that
hidden somewhere?
