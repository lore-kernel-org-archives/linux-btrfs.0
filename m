Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE5FBC433ED
	for <linux-btrfs@archiver.kernel.org>; Thu, 20 May 2021 15:08:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BC16961246
	for <linux-btrfs@archiver.kernel.org>; Thu, 20 May 2021 15:08:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239826AbhETPJW (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 20 May 2021 11:09:22 -0400
Received: from mx2.suse.de ([195.135.220.15]:45076 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243132AbhETPJV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 20 May 2021 11:09:21 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 571B2AC4B;
        Thu, 20 May 2021 15:07:59 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 1DA5CDA781; Thu, 20 May 2021 17:05:25 +0200 (CEST)
Date:   Thu, 20 May 2021 17:05:24 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc:     David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 0/3] btrfs: zoned: fix writes on a compressed zoned
 filesystem
Message-ID: <20210520150524.GE7604@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
References: <cover.1621351444.git.johannes.thumshirn@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1621351444.git.johannes.thumshirn@wdc.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, May 19, 2021 at 12:40:26AM +0900, Johannes Thumshirn wrote:
> David reported that I/O errors get thrown on a zoned filesystem with
> compression enabled.
> 
> This happens because we're using regular writes instead of zoned append, but
> with regular writes and increased parallelism, we cannot guarantee the data
> placement requirements can be met.
> 
> This series switches the compressed I/O submission path to zone append writing
> on a zoned filesystem.
> 
> Changes in v2:
> - Factor out zoned device lookup
> - limit scope of bdev variable
> 
> Johannes Thumshirn (3):
>   btrfs: zoned: pass start block to btrfs_use_zone_append
>   btrfs: zoned: fix compressed writes
>   btrfs: zoned: factor out zoned device lookup

The test now does not report any problems. Moved to misc-next, thanks.
