Return-Path: <SRS0=Lsqx=DM=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 688B4C4363D
	for <linux-btrfs@archiver.kernel.org>; Mon,  5 Oct 2020 13:43:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 208DF20756
	for <linux-btrfs@archiver.kernel.org>; Mon,  5 Oct 2020 13:43:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="bkv55xe1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726335AbgJENn3 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 5 Oct 2020 09:43:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725932AbgJENn2 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 5 Oct 2020 09:43:28 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A164C0613CE;
        Mon,  5 Oct 2020 06:43:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=jb5thMIWpCkZBAm0OYkNTxcNM8PY6DURu7qCjd3L9nk=; b=bkv55xe1/G1SaZg+Ki7iWQKwNR
        q8pgQvSNPgTwrzZxa/2xHHL4iU/JMWqKDRv9YuDcofZCD/4sWqrHThuvXBIf7sQCuDueV/8S44IRX
        cxYlin4+qU9S89E46tk/MJi8AbJ4UfpX4kmKp7wqxlCKTL3zZPVgZeMXsG6iYTcZg8elDF5PxhZ3R
        1r5zkb7G90HwjOn8IgV1W0RjFGGyj9UJEDQL2ElR5OvwiYtdB/rJM1FYNZyQlx7FMhao5LjUlTEUt
        3J4xUsRlz/Ve3ANIK35psd/rrvf5nkqNcjucSAmcJFOThsz0t7dZtOng+nHYjhQT2gP/XmZmmRz3q
        8WvWI+Kw==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kPQls-00031f-0l; Mon, 05 Oct 2020 13:43:20 +0000
Date:   Mon, 5 Oct 2020 14:43:19 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Naohiro Aota <naohiro.aota@wdc.com>, linux-btrfs@vger.kernel.org,
        dsterba@suse.com, hare@suse.com, linux-fsdevel@vger.kernel.org,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: Re: [PATCH v8 01/41] block: add bio_add_zone_append_page
Message-ID: <20201005134319.GA11537@infradead.org>
References: <cover.1601572459.git.naohiro.aota@wdc.com>
 <dece91bca322ce44bed19f2b0f460fa5ded2e512.1601574234.git.naohiro.aota@wdc.com>
 <yq1k0w8g3rw.fsf@ca-mkp.ca.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yq1k0w8g3rw.fsf@ca-mkp.ca.oracle.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Oct 02, 2020 at 09:39:04AM -0400, Martin K. Petersen wrote:
> 
> Naohiro/Johannes,
> 
> > Add bio_add_zone_append_page(), a wrapper around bio_add_hw_page() which
> > is intended to be used by file systems that directly add pages to a bio
> > instead of using bio_iov_iter_get_pages().
> 
> Why use the hardware limit? For filesystem I/O we generally use the
> queue soft limit to prevent I/Os getting too big which can lead to very
> unpredictable latency in mixed workloads.
> 
> max_zone_append_sectors also appears to be gated exclusively by hardware
> constraints. Is there user-controllable limit in place for append
> operations?

Zone Append operations can't be split, as they return the first written
LBA to the caller.  If you'd split it you'd now need to return multiple
start LBA values.
