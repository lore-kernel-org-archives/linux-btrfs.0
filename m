Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3457FC433EF
	for <linux-btrfs@archiver.kernel.org>; Wed, 13 Jul 2022 06:51:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230146AbiGMGvL (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 13 Jul 2022 02:51:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229854AbiGMGvK (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 13 Jul 2022 02:51:10 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28F04BD6A2
        for <linux-btrfs@vger.kernel.org>; Tue, 12 Jul 2022 23:51:10 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 8986A68AA6; Wed, 13 Jul 2022 08:51:07 +0200 (CEST)
Date:   Wed, 13 Jul 2022 08:51:07 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
Cc:     Christoph Hellwig <hch@lst.de>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Nikolay Borisov <nborisov@suse.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 07/11] btrfs: give struct btrfs_bio a real end_io
 handler
Message-ID: <20220713065107.GB14237@lst.de>
References: <20220713061359.1980118-1-hch@lst.de> <20220713061359.1980118-8-hch@lst.de> <PH0PR04MB741607BE824ED888120C58B19B899@PH0PR04MB7416.namprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <PH0PR04MB741607BE824ED888120C58B19B899@PH0PR04MB7416.namprd04.prod.outlook.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Jul 13, 2022 at 06:47:18AM +0000, Johannes Thumshirn wrote:
> JFYI this one doesn't apply cleanly on today's misc-next.

Yes, as stated in the cover letter this is against the for-next
branch that has the compressed repair fixes.
