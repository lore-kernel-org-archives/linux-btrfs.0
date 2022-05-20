Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 438EDC433F5
	for <linux-btrfs@archiver.kernel.org>; Fri, 20 May 2022 16:27:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351637AbiETQ1s (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 20 May 2022 12:27:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351659AbiETQ1q (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 20 May 2022 12:27:46 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09E2617EC2F
        for <linux-btrfs@vger.kernel.org>; Fri, 20 May 2022 09:27:42 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 98D2668BFE; Fri, 20 May 2022 18:27:37 +0200 (CEST)
Date:   Fri, 20 May 2022 18:27:36 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Johannes Thumshirn <Johannes.Thumshirn@wdc.com>,
        Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, Qu Wenruo <wqu@suse.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 05/15] btrfs: add a helper to iterate through a
 btrfs_bio with sector sized chunks
Message-ID: <20220520162736.GC25490@lst.de>
References: <20220517145039.3202184-1-hch@lst.de> <20220517145039.3202184-6-hch@lst.de> <PH0PR04MB7416A9EFBE86253DD0DB4DDE9BCE9@PH0PR04MB7416.namprd04.prod.outlook.com> <20220518084600.GD6933@lst.de> <bc356025-00b4-e5fd-2394-f00b3746a9d7@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bc356025-00b4-e5fd-2394-f00b3746a9d7@gmx.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, May 18, 2022 at 06:07:38PM +0800, Qu Wenruo wrote:
>> Because it is a logically separate change that doesn't really have
>> anything to do with the repair code, except that it happens to be the
>> first user?
>
> In fact, there are some other call sites can benefit from the helper,
> like btrfs_csum_one_bio().
>
> Thus if you can convert those call sites, there will be no question on
> introducing the helper in one patch.

Yes, there is a bunch of places where it would be pretty useful.  But
the series is already large enough as is, so for now I'd rather
keep that for another round.
