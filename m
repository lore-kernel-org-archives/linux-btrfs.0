Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAF8AC433DB
	for <linux-btrfs@archiver.kernel.org>; Tue, 16 Mar 2021 10:18:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 507A264FAC
	for <linux-btrfs@archiver.kernel.org>; Tue, 16 Mar 2021 10:18:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236034AbhCPKRc (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 16 Mar 2021 06:17:32 -0400
Received: from mx2.suse.de ([195.135.220.15]:32988 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236626AbhCPKRS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 16 Mar 2021 06:17:18 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id A6FFAAC1D;
        Tue, 16 Mar 2021 10:17:17 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 2A693DA6E2; Tue, 16 Mar 2021 11:15:16 +0100 (CET)
Date:   Tue, 16 Mar 2021 11:15:16 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/2] btrfs: fixes for subpage which also affect read-only
 mount
Message-ID: <20210316101515.GE7604@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20210315053915.62420-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210315053915.62420-1-wqu@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Mar 15, 2021 at 01:39:13PM +0800, Qu Wenruo wrote:
> During the fstests run for btrfs subpage read-write support, generic/475
> crashes the system with a very high chance.
> 
> It turns out the cause is also affecting btrfs subpage read-only mount
> so it's worthy a quick fix.
> 
> Also the crash call site shows a new rabbit hole of hard coded
> PAGE_SHIFT in readahead.
> This reada problem does not only greatly slow down my test on my ARM
> board, but also affects read-only mount.
> 
> So this patchset is here to address the problems, and hope these fixes
> can fit into current merge window.

Now added to the -rc queue, thanks.
