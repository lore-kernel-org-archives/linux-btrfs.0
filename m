Return-Path: <SRS0=RqtL=C7=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F336EC4727D
	for <linux-btrfs@archiver.kernel.org>; Tue, 22 Sep 2020 13:26:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BAAFB20888
	for <linux-btrfs@archiver.kernel.org>; Tue, 22 Sep 2020 13:26:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726593AbgIVN0L (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 22 Sep 2020 09:26:11 -0400
Received: from verein.lst.de ([213.95.11.211]:44649 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726473AbgIVN0L (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 22 Sep 2020 09:26:11 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id B8F9A67373; Tue, 22 Sep 2020 15:26:08 +0200 (CEST)
Date:   Tue, 22 Sep 2020 15:26:08 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc:     linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
        david@fromorbit.com, hch@lst.de, johannes.thumshirn@wdc.com,
        dsterba@suse.com, darrick.wong@oracle.com, josef@toxicpanda.com,
        Goldwyn Rodrigues <rgoldwyn@suse.com>
Subject: Re: [PATCH 08/15] btrfs: Introduce btrfs_write_check()
Message-ID: <20200922132608.GF20432@lst.de>
References: <20200921144353.31319-1-rgoldwyn@suse.de> <20200921144353.31319-9-rgoldwyn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200921144353.31319-9-rgoldwyn@suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

> +	if (iocb->ki_flags & IOCB_NOWAIT) {
> +		size_t nocow_bytes = count;
> +
> +		/*
> +		 * We will allocate space in case nodatacow is not set,
> +		 * so bail
> +		 */
> +		if (check_nocow_nolock(BTRFS_I(inode), pos, &nocow_bytes)
> +		    <= 0)

This could easily be:

		if (check_nocow_nolock(BTRFS_I(inode), pos, &nocow_bytes) <= 0)

as it perfectly fits withing 80 characters.
