Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED8C4C54EE9
	for <linux-btrfs@archiver.kernel.org>; Mon,  5 Sep 2022 14:25:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237551AbiIEOZw (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 5 Sep 2022 10:25:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237704AbiIEOZu (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 5 Sep 2022 10:25:50 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56BFA3FA17;
        Mon,  5 Sep 2022 07:25:48 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 9837468BEB; Mon,  5 Sep 2022 16:25:43 +0200 (CEST)
Date:   Mon, 5 Sep 2022 16:25:43 +0200
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
Subject: Re: [PATCH 16/17] btrfs: split zone append bios in btrfs_submit_bio
Message-ID: <20220905142543.GA5262@lst.de>
References: <20220901074216.1849941-1-hch@lst.de> <20220901074216.1849941-17-hch@lst.de> <PH0PR04MB74166908EB6DF6C586B5AC539B7F9@PH0PR04MB7416.namprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <PH0PR04MB74166908EB6DF6C586B5AC539B7F9@PH0PR04MB7416.namprd04.prod.outlook.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Sep 05, 2022 at 01:15:16PM +0000, Johannes Thumshirn wrote:
> On 01.09.22 09:43, Christoph Hellwig wrote:
> > +		ASSERT(btrfs_dev_is_sequential(dev, physical));
> > +		bio->bi_iter.bi_sector = zone_start >> SECTOR_SHIFT;
> 
> That ASSERT() will trigger on conventional zones, won't it?

The assert is inside a

	if (bio_op(bio) == REQ_OP_ZONE_APPEND) {

btrfs_submit_chunk only sets the op to REQ_OP_ZONE_APPEND when
btrfs_use_zone_append returns true, which excludes conventional zones.
