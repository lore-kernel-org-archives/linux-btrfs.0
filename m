Return-Path: <linux-btrfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 155E2C7EE23
	for <linux-btrfs@archiver.kernel.org>; Tue, 23 May 2023 11:38:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235914AbjEWLim (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 23 May 2023 07:38:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231846AbjEWLil (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 23 May 2023 07:38:41 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC14B119
        for <linux-btrfs@vger.kernel.org>; Tue, 23 May 2023 04:38:40 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 1B6B16732D; Tue, 23 May 2023 13:38:37 +0200 (CEST)
Date:   Tue, 23 May 2023 13:38:36 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc:     Christoph Hellwig <hch@lst.de>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 02/16] btrfs: factor out a btrfs_verify_page helper
Message-ID: <20230523113836.GA28908@lst.de>
References: <20230523081322.331337-1-hch@lst.de> <20230523081322.331337-3-hch@lst.de> <3906cde3-a64a-889f-e0d6-00a6bf8c0fd0@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3906cde3-a64a-889f-e0d6-00a6bf8c0fd0@gmx.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, May 23, 2023 at 05:23:19PM +0800, Qu Wenruo wrote:
> I know this patch is only doing refactoring, but this makes me wonder,
> should we make the btrfs_verify_page() to be subpage compatible?
>
> E.g. checking subpage page error and page uptodate?

Not without someone signing up to actually fully test and support
fsverity on sub-page file systems.
