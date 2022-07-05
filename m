Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7637EC43334
	for <linux-btrfs@archiver.kernel.org>; Tue,  5 Jul 2022 17:16:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230271AbiGERQM (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 5 Jul 2022 13:16:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229617AbiGERQM (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 5 Jul 2022 13:16:12 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E216B1CFC4
        for <linux-btrfs@vger.kernel.org>; Tue,  5 Jul 2022 10:16:10 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 91D8767373; Tue,  5 Jul 2022 19:16:07 +0200 (CEST)
Date:   Tue, 5 Jul 2022 19:16:07 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     Christoph Hellwig <hch@lst.de>, clm@fb.com, josef@toxicpanda.com,
        dsterba@suse.com, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: don't take a bio_counter reference for cloned
 bios
Message-ID: <20220705171607.GA15148@lst.de>
References: <20220625091547.102882-1-hch@lst.de> <e31a4468-6589-58fe-4717-6b605b7f42ff@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e31a4468-6589-58fe-4717-6b605b7f42ff@suse.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Jul 05, 2022 at 03:38:32PM +0300, Nikolay Borisov wrote:
> Though this doesn't apply cleanly on current misc-next so had to manually 
> clean it up.

This applies against the for-next branch fine, which still has a
big chunk of bio related patches in it that didn't make it to misc-next.

> Also the changelog is somewhat terse essentially the block 
> count is now being "carried" by the top-level bio or rather the 
> bio_io_context  since btrfs_bio_counter_dec() call shall be moved into 
> btrfs_end_bioc.

btrfs_end_bioc is gone in for-next.
