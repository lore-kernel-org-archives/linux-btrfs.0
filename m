Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BC12C433F5
	for <linux-btrfs@archiver.kernel.org>; Tue, 31 May 2022 15:53:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345909AbiEaPxa (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 31 May 2022 11:53:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232910AbiEaPx3 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 31 May 2022 11:53:29 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A9408CCF7;
        Tue, 31 May 2022 08:53:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=SyCCA8xNAu5xvp9ZYw0ecT1Pa/ENMKYOzhnUMu60o+A=; b=urwMtMApR8qGDR3HQAJX+3rFJM
        YzK1edqcDS3NGRfxREhyrLMU1guayrd8sPVOxHp1WFwY3qOIR9ly3xk8SUn+pvfKYdTFVDGCZRZYL
        MI3N6klHOSXN6nKL0Kt+AG/KS1Cm6D36QH7bnvHGPDUhVO67mPOWJMxJg6ZYbFtzh5di0bZov+QaV
        bPqDGyfp+Dfk2WLCXCPBJGInfACfHyHjTEjtj/1565PUPTRBabaVHUbAiwMJ1O9jDBryQ6vF97OwR
        soo1lY6Pfnhwv4zgL3NGtckQy10SKYQmLvV5oEG0EQUWzDoPKm/jEkmxSrmAr1OljCEOQIe92REfX
        9VkQ6BsA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nw4BP-00BeeT-7K; Tue, 31 May 2022 15:53:23 +0000
Date:   Tue, 31 May 2022 08:53:23 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Fabio M. De Francesco" <fmdefrancesco@gmail.com>
Cc:     Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Ira Weiny <ira.weiny@intel.com>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] btrfs: Replace kmap() with kmap_local_page() in lzo.c
Message-ID: <YpY580+u9UU7XJX2@infradead.org>
References: <20220531145335.13954-1-fmdefrancesco@gmail.com>
 <20220531145335.13954-3-fmdefrancesco@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220531145335.13954-3-fmdefrancesco@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, May 31, 2022 at 04:53:34PM +0200, Fabio M. De Francesco wrote:
> The use of kmap() is being deprecated in favor of kmap_local_page() where
> it is feasible. With kmap_local_page(), the mapping is per thread, CPU
> local and not globally visible.
> 
> Therefore, use kmap_local_page() / kunmap_local() in lzo.c wherever the
> mappings are per thread and not globally visible.

This looks fine:

Reviewed-by: Christoph Hellwig <hch@lst.de>
