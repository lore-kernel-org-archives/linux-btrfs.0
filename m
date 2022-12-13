Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1941C4167B
	for <linux-btrfs@archiver.kernel.org>; Tue, 13 Dec 2022 05:54:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234303AbiLMFyF (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 13 Dec 2022 00:54:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234274AbiLMFyA (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 13 Dec 2022 00:54:00 -0500
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92F9D1A3A0;
        Mon, 12 Dec 2022 21:53:59 -0800 (PST)
Received: by verein.lst.de (Postfix, from userid 2407)
        id AB4DF6732D; Tue, 13 Dec 2022 06:53:55 +0100 (CET)
Date:   Tue, 13 Dec 2022 06:53:55 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     David Sterba <dsterba@suse.cz>
Cc:     Christoph Hellwig <hch@lst.de>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Naohiro Aota <naohiro.aota@wdc.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Qu Wenruo <wqu@suse.com>, Jens Axboe <axboe@kernel.dk>,
        "Darrick J. Wong" <djwong@kernel.org>, linux-block@vger.kernel.org,
        linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 02/19] btrfs: handle checksum validation and repair at
 the storage layer
Message-ID: <20221213055355.GA882@lst.de>
References: <20221120124734.18634-1-hch@lst.de> <20221120124734.18634-3-hch@lst.de> <20221212221347.GC5824@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221212221347.GC5824@twin.jikos.cz>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Dec 12, 2022 at 11:13:47PM +0100, David Sterba wrote:
> > There is one significant behavior change here:  If repair fails or
> > is impossible to start with, the whole bio will be failed to the
> > upper layer.  This is the behavior that all I/O submitters execept
> > for buffered I/O already emulated in their end_io handler.  For
> > buffered I/O this now means that a large readahead request can
> > fail due to a single bad sector, but as readahead errors are igored
> > the following readpage if the sector is actually accessed will
> > still be able to read.  This also matches the I/O failure handling
> > in other file systems.
> 
> This patch is apparently doing several things at once, please split it.
> Thanks.

We went through this last time:  yes, it apparently does multiple
things, but they are so deeply interconnected that they can't be
logically split.  Josef asked to maybe look into opting in, but
that would require a temporary flag in the btrfs_bio and not
significantly reduce the patch side, but just add a few more
patches for the switchover of direct, buffered and compressed I/O.
