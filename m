Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAC8AC433EF
	for <linux-btrfs@archiver.kernel.org>; Sun, 22 May 2022 12:31:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344940AbiEVMbP (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 22 May 2022 08:31:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245619AbiEVMbO (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 22 May 2022 08:31:14 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95C376339
        for <linux-btrfs@vger.kernel.org>; Sun, 22 May 2022 05:31:12 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 9F91B68AFE; Sun, 22 May 2022 14:31:08 +0200 (CEST)
Date:   Sun, 22 May 2022 14:31:08 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc:     Christoph Hellwig <hch@lst.de>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 8/8] btrfs: use btrfs_bio_for_each_sector in
 btrfs_check_read_dio_bio
Message-ID: <20220522123108.GA23355@lst.de>
References: <20220522114754.173685-1-hch@lst.de> <20220522114754.173685-9-hch@lst.de> <d3065bfe-c7ae-5182-84de-17101afbd39e@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d3065bfe-c7ae-5182-84de-17101afbd39e@gmx.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Sun, May 22, 2022 at 08:21:47PM +0800, Qu Wenruo wrote:
> In fact, in my version I also want to convert the buffered read endio to
> use the helper, and get rid of the error bitmap thing.

Yes, the buffered end I/O path could use some more love.  I also wonder
if splitting the data vs metadata case might be good idea as well.  But
maybe we can finish the read repair series first and do that next?
'cause now a lot of the bio works will depend on the read repair, and
I don't want to block it on yet another series..
