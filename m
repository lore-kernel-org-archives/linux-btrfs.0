Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7C5CC433EF
	for <linux-btrfs@archiver.kernel.org>; Tue, 15 Mar 2022 07:43:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345532AbiCOHoZ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 15 Mar 2022 03:44:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244096AbiCOHoY (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 15 Mar 2022 03:44:24 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9E63DF3
        for <linux-btrfs@vger.kernel.org>; Tue, 15 Mar 2022 00:43:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=QWhfsxcGZT5ReGsGDAra6pud/2/5yUcxfMCuHD7Ze60=; b=F/hlJTpa7gZt22ZiYWsHqdpAOq
        ZX7Ss6abVnfQCxjqP51/FPQrcIf0uhSE5Day8JZCZHYWljxErPHzeH1r2LqLCU2mRMXJGvC/VlvTq
        9EoP42YAeLze+NyTYTw+xKXbFGoLIyWo4rEgDj7ePZrkF/3wmLE5MtdqnCaXMcF4IwidBowwta6lG
        bbpuesw1rfXmoOzdAleaK83YKVmkgSJG8RbvKNAqE15Lyz6MoarsrjCq7HB9DMM2yIIf3l817ZrG6
        clrq9vxDdeeag5cs3EVN09ThTiDeycGncd4tyCoKMvfue3VFhR5P1dDevr5jiKELtrGNOgynwPnxl
        3icFABlA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nU1pp-0089kD-IR; Tue, 15 Mar 2022 07:43:13 +0000
Date:   Tue, 15 Mar 2022 00:43:13 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v3 01/18] btrfs: update an stale comment on
 btrfs_submit_bio_hook()
Message-ID: <YjBDkVcGH2cN1hni@infradead.org>
References: <cover.1647248613.git.wqu@suse.com>
 <b361293b6a5724d3351fb2e476014fb461eec336.1647248613.git.wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b361293b6a5724d3351fb2e476014fb461eec336.1647248613.git.wqu@suse.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Mar 14, 2022 at 05:07:14PM +0800, Qu Wenruo wrote:
> This function is renamed to btrfs_submit_data_bio(), update the comment
> and add extra reason why it doesn't completely follow the same rule in
> btrfs_submit_data_bio().

Looks good, I actually have something similar in a local tree:

Reviewed-by: Christoph Hellwig <hch@lst.de>
