Return-Path: <SRS0=A/rP=OI=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD330C43441
	for <linux-btrfs@archiver.kernel.org>; Thu, 29 Nov 2018 14:51:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7F42220673
	for <linux-btrfs@archiver.kernel.org>; Thu, 29 Nov 2018 14:51:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7F42220673
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732823AbeK3B4j (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 29 Nov 2018 20:56:39 -0500
Received: from mx2.suse.de ([195.135.220.15]:55690 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728695AbeK3B4i (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 29 Nov 2018 20:56:38 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id E79B0AFF5;
        Thu, 29 Nov 2018 14:51:00 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 228F2DAC25; Thu, 29 Nov 2018 15:50:44 +0100 (CET)
Date:   Thu, 29 Nov 2018 15:50:43 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Filipe Manana <fdmanana@kernel.org>
Cc:     linux-btrfs <linux-btrfs@vger.kernel.org>,
        David Sterba <dsterba@suse.com>
Subject: Re: [PATCH] Btrfs: bring back key search optimization to
 btrfs_search_old_slot()
Message-ID: <20181129145043.GB2842@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Filipe Manana <fdmanana@kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        David Sterba <dsterba@suse.com>
References: <20181116110845.28561-1-fdmanana@kernel.org>
 <CAL3q7H6kM3kG-tm3omMYzx_Ma31vK2OaxqJ0YGKiq8agu9QB0g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL3q7H6kM3kG-tm3omMYzx_Ma31vK2OaxqJ0YGKiq8agu9QB0g@mail.gmail.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Nov 26, 2018 at 04:53:11PM +0000, Filipe Manana wrote:
> On Fri, Nov 16, 2018 at 11:09 AM <fdmanana@kernel.org> wrote:
> >
> > From: Filipe Manana <fdmanana@suse.com>
> >
> > Commit d7396f07358a ("Btrfs: optimize key searches in btrfs_search_slot"),
> > dated from August 2013, introduced an optimization to search for keys in a
> > node/leaf to both btrfs_search_slot() and btrfs_search_old_slot(). For the
> > later, it ended up being reverted in commit d4b4087c43cc ("Btrfs: do a
> > full search everytime in btrfs_search_old_slot"), from September 2013,
> > because the content of extent buffers were often inconsistent during
> > replay. It turned out that the reason why they were often inconsistent was
> > because the extent buffer replay stopped being done atomically, and got
> > broken after commit c8cc63416537 ("Btrfs: stop using GFP_ATOMIC for the
> > tree mod log allocations"), introduced in July 2013. The extent buffer
> > replay issue was then found and fixed by commit 5de865eebb83 ("Btrfs: fix
> > tree mod logging"), dated from December 2013.
> >
> > So bring back the optimization to btrfs_search_old_slot() as skipping it
> > and its comment about disabling it confusing. After all, if unwinding
> > extent buffers resulted in some inconsistency, the normal searches (binary
> > searches) would also not always work.
> >
> > Signed-off-by: Filipe Manana <fdmanana@suse.com>
> 
> David, please remove this change from the integration branch.
> 
> It turns out after 3 weeks of stress tests it finally triggered an
> assertion failure (hard to hit) and
> it's indeed not reliable to use the search optimization because of how
> the mod log tree currently works.
> The idea was just to not make it different from btrfs_search_slot().
> Use of the mod log tree is limited
> to some cases where occasional faster search wouldn't bring much benefits.

Understood, thanks. Patch removed from misc-next.
