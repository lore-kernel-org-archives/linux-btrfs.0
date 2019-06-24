Return-Path: <SRS0=AU7F=UX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EFFCC43613
	for <linux-btrfs@archiver.kernel.org>; Mon, 24 Jun 2019 07:08:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4BEED205F4
	for <linux-btrfs@archiver.kernel.org>; Mon, 24 Jun 2019 07:08:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727625AbfFXHIG (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 24 Jun 2019 03:08:06 -0400
Received: from verein.lst.de ([213.95.11.211]:52929 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726340AbfFXHIG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 24 Jun 2019 03:08:06 -0400
Received: by newverein.lst.de (Postfix, from userid 2407)
        id 0254F68B02; Mon, 24 Jun 2019 09:07:35 +0200 (CEST)
Date:   Mon, 24 Jun 2019 09:07:34 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc:     linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        hch@lst.de, darrick.wong@oracle.com, david@fromorbit.com,
        Goldwyn Rodrigues <rgoldwyn@suse.com>
Subject: Re: [PATCH 1/6] iomap: Use a IOMAP_COW/srcmap for a
 read-modify-write I/O
Message-ID: <20190624070734.GB3675@lst.de>
References: <20190621192828.28900-1-rgoldwyn@suse.de> <20190621192828.28900-2-rgoldwyn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190621192828.28900-2-rgoldwyn@suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

xfs will need to be updated to fill in the additional iomap for the
COW case.  Has this series been tested on xfs?

I can't say I'm a huge fan of this two iomaps in one method call
approach.  I always though two separate iomap iterations would be nicer,
but compared to that even the older hack with just the additional
src_addr seems a little better.
