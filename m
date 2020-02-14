Return-Path: <SRS0=/JOF=4C=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7F9AC2BA83
	for <linux-btrfs@archiver.kernel.org>; Fri, 14 Feb 2020 13:53:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7DD80222C4
	for <linux-btrfs@archiver.kernel.org>; Fri, 14 Feb 2020 13:53:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729294AbgBNNxl (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 14 Feb 2020 08:53:41 -0500
Received: from mx2.suse.de ([195.135.220.15]:36898 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728223AbgBNNxl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 14 Feb 2020 08:53:41 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id EF66AAE39;
        Fri, 14 Feb 2020 13:53:39 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 1858ADA703; Fri, 14 Feb 2020 14:53:25 +0100 (CET)
Date:   Fri, 14 Feb 2020 14:53:24 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc:     David Sterba <dsterba@suse.cz>,
        Nikolay Borisov <nborisov@suse.com>,
        Josef Bacik <josef@toxicpanda.com>,
        "linux-btrfs @ vger . kernel . org" <linux-btrfs@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v8 8/8] btrfs: remove buffer_heads form superblock mirror
 integrity checking
Message-ID: <20200214135324.GV2902@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Nikolay Borisov <nborisov@suse.com>,
        Josef Bacik <josef@toxicpanda.com>,
        "linux-btrfs @ vger . kernel . org" <linux-btrfs@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>
References: <20200213152436.13276-1-johannes.thumshirn@wdc.com>
 <20200213152436.13276-9-johannes.thumshirn@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200213152436.13276-9-johannes.thumshirn@wdc.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Feb 14, 2020 at 12:24:36AM +0900, Johannes Thumshirn wrote:
> The integrity checking code for the superblock mirrors is the last remaining
> user of buffer_heads in BTRFS, change it to using plain BIOs as well.
> 
> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> Reviewed-by: Josef Bacik <josef@toxicpanda.com>
> Reviewed-by: Nikolay Borisov <nborisov@suse.com>
> 
> ---
> Changes to v7:
> - Use read_Cache_page_gfp()
> - Don't kmap() block device mappings (David)
> 
> Changes to v4:
> - Remove mapping_gfp_constraint()
> 
> Changes to v2:
> - Open-code kunmap() + put_page() (David)
> - Remove __GFP_NOFAIL from allocation (Josef)
> - Merge error paths (David)

The per-patch changes are a nice bonus, let me use it to point out a
thing that the reviews from previous iterations should be kept only if
there are cosmetic changes (like renaming identifiers, formatting or
comments) and not functional changes like the kmap/kunmap or
read_cache_gfp.

If the rev-by lines are there I would expect that the respective
reviewers will skip reading the patch. Good if not, but without an
explicit reply 'still ok' we're losing some information.
