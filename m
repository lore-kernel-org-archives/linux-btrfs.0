Return-Path: <linux-btrfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF059C636D7
	for <linux-btrfs@archiver.kernel.org>; Tue, 21 Feb 2023 14:34:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234038AbjBUOeX (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 21 Feb 2023 09:34:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233049AbjBUOeW (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 21 Feb 2023 09:34:22 -0500
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A3572D6C
        for <linux-btrfs@vger.kernel.org>; Tue, 21 Feb 2023 06:34:22 -0800 (PST)
Received: by verein.lst.de (Postfix, from userid 2407)
        id A37E068AFE; Tue, 21 Feb 2023 15:34:18 +0100 (CET)
Date:   Tue, 21 Feb 2023 15:34:17 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Qu Wenruo <wqu@suse.com>
Cc:     Christoph Hellwig <hch@lst.de>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 08/12] btrfs: remove the compress_type argument to
 submit_extent_page
Message-ID: <20230221143417.GD29949@lst.de>
References: <20230216163437.2370948-1-hch@lst.de> <20230216163437.2370948-9-hch@lst.de> <8a536593-943f-46f2-f3df-23c78cd9874a@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8a536593-943f-46f2-f3df-23c78cd9874a@suse.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Feb 21, 2023 at 07:32:18PM +0800, Qu Wenruo wrote:
> I'm never a fan of the bio_ctrl thing, as it always rely on the next page 
> to submit the bio (of previous pages).
>
> Thus I'm wondering, can we detects if we're at extent end, and just submit 
> the bio if we're at the extent end.
> So we don't always need to pass bio_ctrl so deep?

We need some kind of context to delay the submission until actually
needed, compare this also to other code like iomap.

That being said the bio_ctrl as-is is a bit of a mess as it combines
reads and writes and data and metadata.  I plan to untangle this
going forward, especially the metadata is easy and doesn't need any
context except for the bio itself.
