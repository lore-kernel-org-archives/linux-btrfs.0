Return-Path: <linux-btrfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1BE1C6FD19
	for <linux-btrfs@archiver.kernel.org>; Fri, 10 Mar 2023 08:43:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231345AbjCJInj (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 10 Mar 2023 03:43:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230400AbjCJInF (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 10 Mar 2023 03:43:05 -0500
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6A0FDB4BC
        for <linux-btrfs@vger.kernel.org>; Fri, 10 Mar 2023 00:41:09 -0800 (PST)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 5B6BC6732D; Fri, 10 Mar 2023 09:41:06 +0100 (CET)
Date:   Fri, 10 Mar 2023 09:41:06 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc:     Christoph Hellwig <hch@lst.de>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 12/20] btrfs: simplify extent buffer writing
Message-ID: <20230310084106.GA16264@lst.de>
References: <20230309090526.332550-1-hch@lst.de> <20230309090526.332550-13-hch@lst.de> <1ec86c37-b5d9-639e-fb9a-f78088164b9f@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1ec86c37-b5d9-639e-fb9a-f78088164b9f@gmx.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Mar 10, 2023 at 04:34:10PM +0800, Qu Wenruo wrote:
> Does this also mean, the only benefit of manually merging continuous pages 
> into a larger bio, compared to multiple smaller adjacent bios, is just 
> memory saving?

That is the only significant saving.  There also is a very minimal amount
of CPU cycles saved as well.
