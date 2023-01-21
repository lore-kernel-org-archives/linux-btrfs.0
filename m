Return-Path: <linux-btrfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F09B4C004D4
	for <linux-btrfs@archiver.kernel.org>; Sat, 21 Jan 2023 08:08:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229741AbjAUIIB (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 21 Jan 2023 03:08:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229656AbjAUIIB (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 21 Jan 2023 03:08:01 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC00754B0C
        for <linux-btrfs@vger.kernel.org>; Sat, 21 Jan 2023 00:07:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=j1V/iJBBlyTF/Njg1e4yX3l5oo
        NqqYvW6WhGovTvZJh9mMhqZ5r+J8V1rgM8z8QDe6jOf/JI+NLiltElxdgS+WHDfNvCisPqtd+MUbY
        IL4SzQwnap0YsGqJ4dTLqa6qirZbZsRE/mDeGl+wiy3Y81lqTiMcI7wO04B0TVYqPmBqKCRASDLMn
        WfOlZKnn2oqWWa+S9VMMypqUZfvrz7BHI9KjnidKtcPqF7sJdKpcKJxYzUw4WcbGXS4RFvDizMNnq
        U/tMv/gr1W85liKMeas03EMXjdCLr2nfNMp0O+eZOKqoRuEMOa3/pO3jzUYjXUXP6dyMNOZR38rek
        Zb0PGbWw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pJ8uq-00DZuN-Ps; Sat, 21 Jan 2023 08:07:56 +0000
Date:   Sat, 21 Jan 2023 00:07:56 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 1/2] btrfs: raid56: make error_bitmap update atomic
Message-ID: <Y8udXIdbvvgqce+E@infradead.org>
References: <cover.1674285037.git.wqu@suse.com>
 <5d3ab2fda0edb0b89ca829af1f59a7270ce6e238.1674285037.git.wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5d3ab2fda0edb0b89ca829af1f59a7270ce6e238.1674285037.git.wqu@suse.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
