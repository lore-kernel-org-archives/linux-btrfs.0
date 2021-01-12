Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE68FC433DB
	for <linux-btrfs@archiver.kernel.org>; Tue, 12 Jan 2021 14:32:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 760DE23132
	for <linux-btrfs@archiver.kernel.org>; Tue, 12 Jan 2021 14:32:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729847AbhALOcd (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 12 Jan 2021 09:32:33 -0500
Received: from mx2.suse.de ([195.135.220.15]:33952 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728386AbhALOcd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 12 Jan 2021 09:32:33 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 2D888ACAC;
        Tue, 12 Jan 2021 14:31:52 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id DA228DA87C; Tue, 12 Jan 2021 15:29:59 +0100 (CET)
Date:   Tue, 12 Jan 2021 15:29:59 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 0/2] btrfs: btrfs_dec_test_*_ordered_extent() refactor
Message-ID: <20210112142959.GP6430@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20201222055924.64724-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201222055924.64724-1-wqu@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Dec 22, 2020 at 01:59:22PM +0800, Qu Wenruo wrote:
> This small patchset is btrfs_dec_test_*_ordered_extent() refactor during
> subpage RW support development.
> 
> This is mostly to make btrfs_dev_test_* functions more human readable
> and prepare it for calling btrfs_dec_test_first_ordered_extent() in
> btrfs_writepage_endio_finish_ordered() where we can have one or more
> ordered extents for one bvec.
> 
> The first patch is a very safe width reduction, where there is only one
> assginment. Thus it should be very safe and won't be involved in other
> call sites.

I've added a comment to the 'bytes' and reworded some comments in the
2nd patch, now added to misc-next, thanks.
