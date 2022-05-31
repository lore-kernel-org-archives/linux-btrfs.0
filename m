Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57C67C433F5
	for <linux-btrfs@archiver.kernel.org>; Tue, 31 May 2022 15:46:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345857AbiEaPqL (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 31 May 2022 11:46:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237200AbiEaPqJ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 31 May 2022 11:46:09 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD0158CB1F;
        Tue, 31 May 2022 08:46:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=Z6AfR5126P6QhMpn8x958li86B
        310G8VPECCA/vc8M+1BCnAEXV+ELz+meUeNIbaFN2lWixqfYWgvq5GSS2sCooDo5xtwie/y5M4zxH
        Pk3C73mprPVFdb9xC7HZDkhVbDLCqL9rn86xmNVTR/WzbgWyyViRvx01f3ObLtgvzIFRt7o5b0ZRI
        AnGUWUyHEDDY8Hx/p6oex0RpmokCpSevDTcoPigLy/iN7yDS7ZYAQ/HvE/w21HPdBT+QzPPMxZDjQ
        4y7rwmqwjCs/0HSLQ/mJP9LOJHi57O4CwSynnfrJqA8Yg2QokH8QhIcFOVn4sS6vFRgnv+z4JOhPZ
        G4iuCNcg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nw44H-00Bcp4-2P; Tue, 31 May 2022 15:46:01 +0000
Date:   Tue, 31 May 2022 08:46:01 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Fabio M. De Francesco" <fmdefrancesco@gmail.com>
Cc:     Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Ira Weiny <ira.weiny@intel.com>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] btrfs: Replace kmap() with kmap_local_page() in
 inode.c
Message-ID: <YpY4OfM50zRgeZPG@infradead.org>
References: <20220531145335.13954-1-fmdefrancesco@gmail.com>
 <20220531145335.13954-2-fmdefrancesco@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220531145335.13954-2-fmdefrancesco@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
