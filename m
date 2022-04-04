Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB15DC433EF
	for <linux-btrfs@archiver.kernel.org>; Mon,  4 Apr 2022 07:07:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377602AbiDDHJ2 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 4 Apr 2022 03:09:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377596AbiDDHJ2 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Apr 2022 03:09:28 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 901D939148;
        Mon,  4 Apr 2022 00:07:31 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 2192768AFE; Mon,  4 Apr 2022 09:07:28 +0200 (CEST)
Date:   Mon, 4 Apr 2022 09:07:27 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
Cc:     Christoph Hellwig <hch@lst.de>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, Qu Wenruo <wqu@suse.com>,
        Naohiro Aota <Naohiro.Aota@wdc.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH 08/12] btrfs: pass a block_device to btrfs_bio_clone
Message-ID: <20220404070727.GA427@lst.de>
References: <20220404044528.71167-1-hch@lst.de> <20220404044528.71167-9-hch@lst.de> <PH0PR04MB74169A7FEDD5C747CC7B1ACF9BE59@PH0PR04MB7416.namprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <PH0PR04MB74169A7FEDD5C747CC7B1ACF9BE59@PH0PR04MB7416.namprd04.prod.outlook.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Apr 04, 2022 at 07:05:38AM +0000, Johannes Thumshirn wrote:
> On 04/04/2022 06:46, Christoph Hellwig wrote:
> > Pass the block_device to bio_alloc_clone instead of setting it later.
> 
> s/bio_alloc_clone/btrfs_bio_clone

Well, both if we want to be pedantic.
