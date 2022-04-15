Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2E74C433F5
	for <linux-btrfs@archiver.kernel.org>; Fri, 15 Apr 2022 05:31:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343756AbiDOFeC (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 15 Apr 2022 01:34:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235877AbiDOFeC (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 15 Apr 2022 01:34:02 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D564A146C
        for <linux-btrfs@vger.kernel.org>; Thu, 14 Apr 2022 22:31:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=ctkBLb8Cg/Bz4aKBXQvERyw4x8D2xPQaIeFapNVACJk=; b=v6X40AL86DFplriWipTC52v3yo
        2LIde3p3Fa9PEyvZAwaJfScq/xPM8tB2WRyj3YXAf2iX5G8EiQOCxoEzSYMGAy+6kmfIW7s9Xp/Vq
        aPQ8dy+y1XMjtKjwk3Ju0FadhoBqhswQr1gwo6Nb0G5hpoSjT1LCHAaauOM65SJlr7+kUgRaFNFVx
        CBOIarJnEt6B5Zhw+u2zPU3g+Lz+QaIZUWCu0p6MZtpFwuAN6Emk/tGN6eS3rIbSea1FuOi9BUupP
        8uVFQsHr34PHfgXHB4eKj68497WapsUSPfm+BsSNNSvDFORfqNFVwG1MftNCzGTNzWWcoi9Udpmx4
        ZWDBFuTQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nfEYR-008gOu-6O; Fri, 15 Apr 2022 05:31:35 +0000
Date:   Thu, 14 Apr 2022 22:31:35 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 04/17] btrfs: introduce new cached members for
 btrfs_raid_bio
Message-ID: <YlkDN0OaSUTKGeRr@infradead.org>
References: <cover.1649753690.git.wqu@suse.com>
 <38fdde8665c4765551fea3c5818bfa79b1214fa6.1649753690.git.wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <38fdde8665c4765551fea3c5818bfa79b1214fa6.1649753690.git.wqu@suse.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

What is cached about these members?
