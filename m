Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8E0CC433F5
	for <linux-btrfs@archiver.kernel.org>; Wed, 23 Mar 2022 06:26:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241984AbiCWG14 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 23 Mar 2022 02:27:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241959AbiCWG1t (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 23 Mar 2022 02:27:49 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85FD9710E4
        for <linux-btrfs@vger.kernel.org>; Tue, 22 Mar 2022 23:26:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=epodJS0CQbWB7npwU1RViMNFxKWmXnzqJFjVafanEn8=; b=LpwMNVJa4ZpA17Y3xUWkhSd3l1
        yiWYhNYLZE+Z6N9GFMnuLCBHxUuT4vH3Lqf15arXewqfafOK4HQqMA77oixwyCKaimVhxa8cDeQ2M
        rw6+Ma7cxcPa6hL4PJWo1Z/kMPts1Yo1bT5x149MdT+LuuZZ2IoCb5XiGTAxajpIE38f4THTY+xdw
        h5zjCocuQ93VAv8+h/5+EYC7XbCuIc2xwccuZdprmYGNB57IyKF1WJ+BeasKVeFcGOqpdg7Ex+wTd
        RlpEeQecfIDlPUIOWYNiT24Puctbe+RaQxOOz7AxHAuhU2Rc9wxNkxipv7ACU5CSP7awgz0Svkp/8
        xoEyLKVw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nWuRo-00CqM6-03; Wed, 23 Mar 2022 06:26:20 +0000
Date:   Tue, 22 Mar 2022 23:26:19 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v4 1/9] btrfs: calculate @physical_end using
 @dev_extent_len directly in scrub_stripe()
Message-ID: <Yjq9i/o7BEAxjGdH@infradead.org>
References: <cover.1646984153.git.wqu@suse.com>
 <62725efd10680c9c92364021f985865294d3b009.1646984153.git.wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <62725efd10680c9c92364021f985865294d3b009.1646984153.git.wqu@suse.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Mar 11, 2022 at 03:38:41PM +0800, Qu Wenruo wrote:
> @@ -3183,10 +3183,10 @@ static noinline_for_stack int scrub_stripe(struct scrub_ctx *sctx,
>  	int slot;
>  	u64 nstripes;
>  	struct extent_buffer *l;
> -	u64 physical;
> +	u64 physical = map->stripes[stripe_index].physical;
>  	u64 logical;
>  	u64 logic_end;
> -	u64 physical_end;
> +	const u64 physical_end = physical + dev_extent_len;

There isn't really much of a point in marking local variables const.
A a nitpick I'd also move the physical and physical_end declarations
next to other as that helps readability a bit.

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
