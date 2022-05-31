Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A22F4C433EF
	for <linux-btrfs@archiver.kernel.org>; Tue, 31 May 2022 15:54:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345927AbiEaPyB (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 31 May 2022 11:54:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345920AbiEaPx5 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 31 May 2022 11:53:57 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 554F88FD45;
        Tue, 31 May 2022 08:53:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=nXLRHjCEg29aGCIYnHe/brKU54
        eW1vkE9hlrrbxNb/2iF2njSl8K2Jp5wFEirZkMJnYNyj00We9G9bklhF8EaIujMvK3+eQdswsLWNe
        VUTtXEWBHcO33dNHgcfqmJ6EF8NcQtTvu9g4+irdr7T0jNpOFQylX9e/YmcVuM9jIeDFV6/itYAc7
        auLe9cozHLZ4tCXaRDkgA8IGu7KTONNoHZzQUdWYa7yvBtzk7GO5QexXuIcRpWI87KAJHRhfWn1+4
        +hcWOUE/gQwN8e7UyJW7pIWDJrbuXl4WPfBKdS5n6usUUyYVAlMub9IycIMKImwtxDpVeINZkW8Mr
        l9gJ25/g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nw4Bs-00Beia-Gw; Tue, 31 May 2022 15:53:52 +0000
Date:   Tue, 31 May 2022 08:53:52 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Fabio M. De Francesco" <fmdefrancesco@gmail.com>
Cc:     Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Ira Weiny <ira.weiny@intel.com>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] btrfs: Replace kmap() with kmap_local_page() in
 zlib.c
Message-ID: <YpY6EEuwBnDYraKb@infradead.org>
References: <20220531145335.13954-1-fmdefrancesco@gmail.com>
 <20220531145335.13954-4-fmdefrancesco@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220531145335.13954-4-fmdefrancesco@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
