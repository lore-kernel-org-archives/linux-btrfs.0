Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF2D5C43334
	for <linux-btrfs@archiver.kernel.org>; Tue, 12 Jul 2022 09:32:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231938AbiGLJcC (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 12 Jul 2022 05:32:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231952AbiGLJcB (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 12 Jul 2022 05:32:01 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B29FC9CE2A
        for <linux-btrfs@vger.kernel.org>; Tue, 12 Jul 2022 02:32:00 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 09FFE68AA6; Tue, 12 Jul 2022 11:31:56 +0200 (CEST)
Date:   Tue, 12 Jul 2022 11:31:55 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     Christoph Hellwig <hch@lst.de>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 7/7] btrfs: stop allocation a btrfs_io_context for
 simple I/O
Message-ID: <20220712093155.GA16647@lst.de>
References: <20220704084406.106929-1-hch@lst.de> <20220704084406.106929-8-hch@lst.de> <d5bffdd9-1ed5-89db-18c1-2bcccb9f537c@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d5bffdd9-1ed5-89db-18c1-2bcccb9f537c@suse.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Jul 12, 2022 at 12:28:14PM +0300, Nikolay Borisov wrote:
> This patch IMO needs to be split:
>
> 1. Make a patch which introduces the various split endio functions.

Where "the various split endio functions" is btrfs_simple_end_io?

btrfs_simple_end_io relies on the fact that it doesn't need to deal
with and a free a btrfs_io_context, so without:

> 2. Then do the cleanups around __btrfs_map_block group and how submitted 
> bios are being initialized and processed in btrfs_submit_bio et al.

the only thing I could do is to first allocate an btrfs_io_context and
just free it directly after I/O submission.  Which sounds doable if
we really want to split it for splitting's sake, but it probably
hurts understanding the concept instead of helping that.
