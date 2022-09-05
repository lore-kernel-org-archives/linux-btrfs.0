Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 746D6C6FA89
	for <linux-btrfs@archiver.kernel.org>; Mon,  5 Sep 2022 06:50:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236097AbiIEGuh (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 5 Sep 2022 02:50:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230096AbiIEGuf (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 5 Sep 2022 02:50:35 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C83D1056A;
        Sun,  4 Sep 2022 23:50:34 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id D637768AFE; Mon,  5 Sep 2022 08:50:31 +0200 (CEST)
Date:   Mon, 5 Sep 2022 08:50:31 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
Cc:     Christoph Hellwig <hch@lst.de>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Naohiro Aota <Naohiro.Aota@wdc.com>, Qu Wenruo <wqu@suse.com>,
        Jens Axboe <axboe@kernel.dk>,
        "Darrick J. Wong" <djwong@kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH 15/17] btrfs: calculate file system wide queue limit
 for zoned mode
Message-ID: <20220905065031.GG2092@lst.de>
References: <20220901074216.1849941-1-hch@lst.de> <20220901074216.1849941-16-hch@lst.de> <PH0PR04MB7416325A65FAE8C9210F3F879B7B9@PH0PR04MB7416.namprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <PH0PR04MB7416325A65FAE8C9210F3F879B7B9@PH0PR04MB7416.namprd04.prod.outlook.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Sep 01, 2022 at 11:28:02AM +0000, Johannes Thumshirn wrote:
> On 01.09.22 09:43, Christoph Hellwig wrote:
> > To be able to split a write into properly sized zone append commands,
> > we need a queue_limits structure that contains the least common
> > denominator suitable for all devices.
> > 
> 
> This patch conflicts with Shinichiro's patch restoring functionality 
> of the zone emulation mode.

Looks like that got into misc-next in the meantime, so I'll rebase on
top of that.
