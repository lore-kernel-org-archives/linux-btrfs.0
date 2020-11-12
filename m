Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96A97C2D0E4
	for <linux-btrfs@archiver.kernel.org>; Thu, 12 Nov 2020 19:22:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 49BAD20B80
	for <linux-btrfs@archiver.kernel.org>; Thu, 12 Nov 2020 19:22:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726685AbgKLTWw (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 12 Nov 2020 14:22:52 -0500
Received: from mx2.suse.de ([195.135.220.15]:37100 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726629AbgKLTWv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 12 Nov 2020 14:22:51 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 067F8B122;
        Thu, 12 Nov 2020 19:22:51 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 865E7DA6E1; Thu, 12 Nov 2020 20:21:08 +0100 (CET)
Date:   Thu, 12 Nov 2020 20:21:08 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: Rename __set_extent_bit to set_extent_bit
Message-ID: <20201112192108.GX6756@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20201105090800.19098-1-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201105090800.19098-1-nborisov@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Nov 05, 2020 at 11:08:00AM +0200, Nikolay Borisov wrote:
> There are only 2 direct calls to set_extent_bit outside of extent-io - in
> btrfs_find_new_delalloc_bytes and btrfs_truncate_block, the rest are thin wrappers
> around __set_extent_bit. This adds unnecessary indirection and just makes it
> more annoying when looking at the various extent bit manipulation functions.
> This patch renames __set_extent_bit to set_extent_bit effectively removing
> a level of indirection. No functional changes.

Makes sense, we can avoid the raw calls to set_extent_bit by adding the
static inline wrappers set_extent_bit_noreserve and
set_extent_bit_delalloc_new. Qu has some cleanups in the io tree helpers
so further cleanups can be done and I'll add this patch to misc-next as
it's a good first step.
