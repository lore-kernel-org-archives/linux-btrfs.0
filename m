Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E0A2C11F68
	for <linux-btrfs@archiver.kernel.org>; Fri,  2 Jul 2021 07:11:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7018E613EE
	for <linux-btrfs@archiver.kernel.org>; Fri,  2 Jul 2021 07:11:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230026AbhGBHNm (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 2 Jul 2021 03:13:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229956AbhGBHNk (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 2 Jul 2021 03:13:40 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF886C061762
        for <linux-btrfs@vger.kernel.org>; Fri,  2 Jul 2021 00:11:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=jRLR1B9nE2eSXl8cb2dQ6cUhLgqjllFZBjON5RoT8sc=; b=s7Ug+QbLt3hmvAfu6junsJjzgq
        wj3HXR1eJD8fa3K0VxrQ8ccSr1OgsQEXClMA+exfciBoQiO3XBOXtfoHgjS+9ZNwG/9PU/A+o5JcF
        /mVuhu5K1b/OBAOGAZQbN3wpuaquE7FNIYLjpeYgDqh4dIumgfHe44j0eqHnVaHGuXWwpMFaidiL7
        qUjrXiwPAlIjf4UwbSUb6vYEVbRRSvkB42ekC34569Z4/8tWuoRXtTMDuTFojQ390iD7OJ5kHbhpl
        pVUcLNdukm3OpmnerKKhEGjLye3HQSOC6tbpFv24ZXzwpiHB45W1q8v8Mrgw98AF7/qOzBnAn88dK
        dRS69ZkA==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1lzDK6-007RAH-6R; Fri, 02 Jul 2021 07:10:53 +0000
Date:   Fri, 2 Jul 2021 08:10:50 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     David Sterba <dsterba@suse.com>
Cc:     linux-btrfs@vger.kernel.org,
        "Gustavo A . R . Silva" <gustavoars@kernel.org>
Subject: Re: [PATCH] btrfs: add special case to setget helpers for 64k pages
Message-ID: <YN67+nvpQBfiLXzh@infradead.org>
References: <20210701160039.12518-1-dsterba@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210701160039.12518-1-dsterba@suse.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

> +	if (INLINE_EXTENT_BUFFER_PAGES == 1) {				\
>  		return get_unaligned_le##bits(token->kaddr + oip);	\
> +	} else {							\

No need for an else after the return and thus no need for all the
reformatting.
