Return-Path: <linux-btrfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BFD0C74A5B
	for <linux-btrfs@archiver.kernel.org>; Fri, 24 Mar 2023 01:05:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229868AbjCXBFe (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 23 Mar 2023 21:05:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbjCXBFe (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 23 Mar 2023 21:05:34 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF7AF5269
        for <linux-btrfs@vger.kernel.org>; Thu, 23 Mar 2023 18:05:30 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 7D00168B05; Fri, 24 Mar 2023 02:05:27 +0100 (CET)
Date:   Fri, 24 Mar 2023 02:05:27 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: simplify extent_buffer reading and writing v2
Message-ID: <20230324010527.GA12152@lst.de>
References: <20230314061655.245340-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230314061655.245340-1-hch@lst.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Mar 14, 2023 at 07:16:34AM +0100, Christoph Hellwig wrote:
> Hi all,
> 
> currently reading and writing of extent_buffers is very complicated as it
> tries to work in a page oriented way.  Switch as much as possible to work
> based on the extent_buffer object to simplify the code.
> 
> I suspect in the long run switching to dedicated object based writeback
> and reclaim similar to the XFS buffer cache would be a good idea, but as
> that involves pretty big behavior changes that's better left for a
> separate series.

Dave, and comment on where this stands?

With the series we don't need bbio->inode for metadata and could
actually do the fs_info pointer Qu needs in a nice way.
