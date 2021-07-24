Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD600C4338F
	for <linux-btrfs@archiver.kernel.org>; Sat, 24 Jul 2021 16:54:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9D11860E0C
	for <linux-btrfs@archiver.kernel.org>; Sat, 24 Jul 2021 16:54:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229648AbhGXQNw (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 24 Jul 2021 12:13:52 -0400
Received: from verein.lst.de ([213.95.11.211]:40992 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229530AbhGXQNv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 24 Jul 2021 12:13:51 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 7E83467373; Sat, 24 Jul 2021 18:54:20 +0200 (CEST)
Date:   Sat, 24 Jul 2021 18:54:20 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Christoph Hellwig <hch@lst.de>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Naohiro Aota <naohiro.aota@wdc.com>,
        linux-block@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: fixes and cleanups for block_device refcounting v3
Message-ID: <20210724165420.GA22350@lst.de>
References: <20210724071249.1284585-1-hch@lst.de> <20210724072223.GA2930@lst.de> <718272a2-de67-c849-7c6e-2232f8762b23@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <718272a2-de67-c849-7c6e-2232f8762b23@kernel.dk>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Sat, Jul 24, 2021 at 10:06:31AM -0600, Jens Axboe wrote:
> Shall we get patch 1 queued up for next week, and then look at the rest
> for the 5.15 block tree once the btrfs fix lands in mainline?

Sounds good.  The btrfs patch is in fact in mainline already as of today.
