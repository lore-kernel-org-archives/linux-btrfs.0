Return-Path: <SRS0=/JOF=4C=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A121C2BA83
	for <linux-btrfs@archiver.kernel.org>; Fri, 14 Feb 2020 15:09:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E267824650
	for <linux-btrfs@archiver.kernel.org>; Fri, 14 Feb 2020 15:09:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729434AbgBNPJH (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 14 Feb 2020 10:09:07 -0500
Received: from mx2.suse.de ([195.135.220.15]:50486 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729320AbgBNPJG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 14 Feb 2020 10:09:06 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 1D36AAE2D;
        Fri, 14 Feb 2020 15:09:05 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 60176DA703; Fri, 14 Feb 2020 16:08:50 +0100 (CET)
Date:   Fri, 14 Feb 2020 16:08:50 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc:     David Sterba <dsterba@suse.cz>,
        Nikolay Borisov <nborisov@suse.com>,
        Josef Bacik <josef@toxicpanda.com>,
        "linux-btrfs @ vger . kernel . org" <linux-btrfs@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v8 5/8] btrfs: use BIOs instead of buffer_heads from
 superblock writeout
Message-ID: <20200214150850.GY2902@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Nikolay Borisov <nborisov@suse.com>,
        Josef Bacik <josef@toxicpanda.com>,
        "linux-btrfs @ vger . kernel . org" <linux-btrfs@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>
References: <20200213152436.13276-1-johannes.thumshirn@wdc.com>
 <20200213152436.13276-6-johannes.thumshirn@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200213152436.13276-6-johannes.thumshirn@wdc.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Feb 14, 2020 at 12:24:33AM +0900, Johannes Thumshirn wrote:
> +		/*
> +		 * Directly use BIOs here instead of relying on the page-cache
> +		 * to do I/O, so we don't loose the ability to do integrity
> +		 * checking.
> +		 */
> +		bio = bio_alloc(GFP_NOFS, 1);
> +		bio_set_dev(bio, device->bdev);
> +		bio->bi_iter.bi_sector = bytenr >> SECTOR_SHIFT;
> +		bio->bi_private = device;
> +		bio->bi_end_io = btrfs_end_super_write;

As a potential future cleanup and simplification, the per-device flush
bio can be used here and not a new one allocated. The flush bios are
sent synchronously and are free for later use by the async submit
writes.
