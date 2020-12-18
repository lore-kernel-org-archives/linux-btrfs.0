Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D519C4361B
	for <linux-btrfs@archiver.kernel.org>; Fri, 18 Dec 2020 16:00:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5104C23B6C
	for <linux-btrfs@archiver.kernel.org>; Fri, 18 Dec 2020 16:00:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727758AbgLRQAS (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 18 Dec 2020 11:00:18 -0500
Received: from mx2.suse.de ([195.135.220.15]:53916 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725949AbgLRQAR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 18 Dec 2020 11:00:17 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id B3A08AD09;
        Fri, 18 Dec 2020 15:59:36 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 0D2E0DA806; Fri, 18 Dec 2020 16:57:55 +0100 (CET)
Date:   Fri, 18 Dec 2020 16:57:55 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/2] btrfs: btrfs_dec_test_*_ordered_extent() refactor
Message-ID: <20201218155755.GB6430@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20201218051701.62262-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201218051701.62262-1-wqu@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Dec 18, 2020 at 01:16:59PM +0800, Qu Wenruo wrote:
> This small patchset is btrfs_dec_test_*_ordered_extent() refactor during
> subpage RW support development.
> 
> This is mostly to make btrfs_dev_test_* functions more human readable
> and prepare it for calling btrfs_dec_test_first_ordered_extent() in
> btrfs_writepage_endio_finish_ordered() where we can have one or more
> ordered extents for one bvec.
> 
> Qu Wenruo (2):
>   btrfs: make btrfs_dio_private::bytes to be u32
>   btrfs: refactor btrfs_dec_test_* functions for ordered extents

The idea makes sense but the patches are IMO in wrong order and still
leave some u64/u32, eg. in btrfs_dec_test_first_ordered_pending the
io_size is still u64 while for btrfs_dec_test_ordered_pending it
switches type to u32 (as expected).

The type cleanup should be done bottom-up, from the leaf functions
upwards. After that, the structure type can be safely switched.

I'm not sure what to do with __endio_write_update_ordered, it can take
u32 for bytes but internally uses u64 for ordered_bytes, that should be
u32 as well. But

 7711                 if (ordered_offset < offset + bytes) {
 7712                         ordered_bytes = offset + bytes - ordered_offset;
 7713                         ordered = NULL;
 7714                 }

expression on line 7712 would need a temporary variable for the u64
calculation and then reassign. Maybe such conversions are inevitable so
we have clean function API and not pass u64 just because.

I like that the hole btrfs_dio_private gets removed so the cleanups are
worthwhile, but maybe not trivial.
