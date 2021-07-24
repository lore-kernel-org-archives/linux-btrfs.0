Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53D3DC4320A
	for <linux-btrfs@archiver.kernel.org>; Sat, 24 Jul 2021 07:22:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2EAA860ED7
	for <linux-btrfs@archiver.kernel.org>; Sat, 24 Jul 2021 07:22:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234307AbhGXGlx (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 24 Jul 2021 02:41:53 -0400
Received: from verein.lst.de ([213.95.11.211]:40361 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234269AbhGXGlx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 24 Jul 2021 02:41:53 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 7467B67373; Sat, 24 Jul 2021 09:22:23 +0200 (CEST)
Date:   Sat, 24 Jul 2021 09:22:23 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Naohiro Aota <naohiro.aota@wdc.com>,
        linux-block@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: fixes and cleanups for block_device refcounting v3
Message-ID: <20210724072223.GA2930@lst.de>
References: <20210724071249.1284585-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210724071249.1284585-1-hch@lst.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Sat, Jul 24, 2021 at 09:12:39AM +0200, Christoph Hellwig wrote:
> Hi Jens,
> 
> this series fixes up a possible race with the block_device lookup
> changes, and the finishes off the conversion to stop using the inode
> refcount for block devices.
> 
> Note that patch 1 is a 5.14 and -stable candidate.

Oh, and patch 7 is on its way to Linus via the btrfs tree.
