Return-Path: <SRS0=zwl1=CC=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1121C433E1
	for <linux-btrfs@archiver.kernel.org>; Mon, 24 Aug 2020 15:30:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A3C6620738
	for <linux-btrfs@archiver.kernel.org>; Mon, 24 Aug 2020 15:30:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725946AbgHXPaI (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 24 Aug 2020 11:30:08 -0400
Received: from mx2.suse.de ([195.135.220.15]:56250 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726878AbgHXP3i (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 24 Aug 2020 11:29:38 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 95AD4AC92;
        Mon, 24 Aug 2020 15:30:07 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 9CB1BDA730; Mon, 24 Aug 2020 17:28:29 +0200 (CEST)
Date:   Mon, 24 Aug 2020 17:28:29 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Marcos Paulo de Souza <marcos@mpdesouza.com>
Cc:     linux-kernel@vger.kernel.org, dsterba@suse.com,
        linux-btrfs@vger.kernel.org,
        Marcos Paulo de Souza <mpdesouza@suse.com>,
        stable@vger.kernel.org, Qu Wenruo <wqu@suse.com>,
        Filipe Manana <fdmanana@suse.com>
Subject: Re: [PATCH v3] btrfs: block-group: Fix free-space bitmap threshould
Message-ID: <20200824152829.GK2026@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz,
        Marcos Paulo de Souza <marcos@mpdesouza.com>,
        linux-kernel@vger.kernel.org, dsterba@suse.com,
        linux-btrfs@vger.kernel.org,
        Marcos Paulo de Souza <mpdesouza@suse.com>, stable@vger.kernel.org,
        Qu Wenruo <wqu@suse.com>, Filipe Manana <fdmanana@suse.com>
References: <20200821145444.25791-1-marcos@mpdesouza.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200821145444.25791-1-marcos@mpdesouza.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Aug 21, 2020 at 11:54:44AM -0300, Marcos Paulo de Souza wrote:
> From: Marcos Paulo de Souza <mpdesouza@suse.com>
> 
> [BUG]
> After commit 9afc66498a0b ("btrfs: block-group: refactor how we read one
> block group item"), cache->length is being assigned after calling
> btrfs_create_block_group_cache. This causes a problem since
> set_free_space_tree_thresholds is calculate the free-space threshould to
> decide is the free-space tree should convert from extents to bitmaps.
> 
> The current code calls set_free_space_tree_thresholds with cache->length
> being 0, which then makes cache->bitmap_high_thresh being zero. This
> implies the system will always use bitmap instead of extents, which is
> not desired if the block group is not fragmented.
> 
> This behavior can be seen by a test that expects to repair systems
> with FREE_SPACE_EXTENT and FREE_SPACE_BITMAP, but the current code only
> created FREE_SPACE_BITMAP.
> 
> [FIX]
> Call set_free_space_tree_thresholds after setting cache->length. There
> is now a WARN_ON in set_free_space_tree_thresholds to help preventing
> the same mistake to happen again in the future.
> 
> Link: https://github.com/kdave/btrfs-progs/issues/251
> Fixes: 9afc66498a0b ("btrfs: block-group: refactor how we read one block group item")
> CC: stable@vger.kernel.org # 5.8+
> Reviewed-by: Qu Wenruo <wqu@suse.com>
> Reviewed-by: Filipe Manana <fdmanana@suse.com>
> Signed-off-by: Marcos Paulo de Souza <mpdesouza@suse.com>

Added to misc-next, thanks.
