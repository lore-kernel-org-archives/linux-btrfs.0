Return-Path: <SRS0=8sAC=CD=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 229EAC433DF
	for <linux-btrfs@archiver.kernel.org>; Tue, 25 Aug 2020 11:44:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F270C20782
	for <linux-btrfs@archiver.kernel.org>; Tue, 25 Aug 2020 11:44:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="bOhCuQ+4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729967AbgHYLoo (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 25 Aug 2020 07:44:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725893AbgHYLoh (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 25 Aug 2020 07:44:37 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 820A6C061574
        for <linux-btrfs@vger.kernel.org>; Tue, 25 Aug 2020 04:44:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:References;
        bh=FV3pOl98ZCgLit9kpm+MXw8c6pxquFJXBK2KoAKCtho=; b=bOhCuQ+47QyEwMFfNw4jjN2EFu
        JYNFJxcdJmwagVliz7m08e/IqwRdbbYh6hk1rFHbhIYvSvov19nKFAOvHtvlH6Fy94isZEgItEor3
        3dOh+/dVD/G+oX3ChKebH3OfAhNcvXhjUhS8twnpxzaAitS8QUOI4hqBOMt7iVnlmFk/ZWoLYwGUZ
        W/gJeLgi63ERDgp1WnLQvkYEn/9EiefrNeWJEYACSc1uWHo4UyW2TM6Xyyi6OVngIKC8M2/UNBafQ
        Q0AZlGOmdX9sgDCvwzAb2628t28FCO8zWcwRWn3nhHq9F5y581/UCvoRoPfaO4SQPFT2noqhutmXP
        WCkjnE8g==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kAXNQ-0000qE-Mj; Tue, 25 Aug 2020 11:44:32 +0000
Date:   Tue, 25 Aug 2020 12:44:32 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org, Goldwyn Rodrigues <rgoldwyn@suse.com>
Subject: Re: [PATCH v3 0/4] btrfs: basic refactor of btrfs_buffered_write()
Message-ID: <20200825114432.GA2873@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200825054808.16241-1-wqu@suse.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Does much refactoring of this code make sense?  Goldwyn has initial
patches to convert the buffered I/O path to iomap, and I hope that would
pick up speed now that the direct I/O conversion landed.
