Return-Path: <SRS0=oOJ3=QZ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CC9BC43381
	for <linux-btrfs@archiver.kernel.org>; Mon, 18 Feb 2019 15:08:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 34FBA2173C
	for <linux-btrfs@archiver.kernel.org>; Mon, 18 Feb 2019 15:08:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730402AbfBRPIw (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 18 Feb 2019 10:08:52 -0500
Received: from mx2.suse.de ([195.135.220.15]:37620 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728249AbfBRPIv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 18 Feb 2019 10:08:51 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id B9639AF99;
        Mon, 18 Feb 2019 15:08:50 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id D2248DA870; Mon, 18 Feb 2019 16:10:14 +0100 (CET)
Date:   Mon, 18 Feb 2019 16:10:14 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Filipe Manana <fdmanana@kernel.org>
Cc:     linux-btrfs <linux-btrfs@vger.kernel.org>,
        David Sterba <dsterba@suse.com>
Subject: Re: [PATCH 4/4] Btrfs: remove no longer needed range length checks
 for deduplication
Message-ID: <20190218151014.GK9874@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Filipe Manana <fdmanana@kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        David Sterba <dsterba@suse.com>
References: <20181212180559.15249-1-fdmanana@kernel.org>
 <20181212180559.15249-5-fdmanana@kernel.org>
 <CAL3q7H55XWqvr2DA_BbqZtva_01iqVD19fkRZFLe14cVTyEY8Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL3q7H55XWqvr2DA_BbqZtva_01iqVD19fkRZFLe14cVTyEY8Q@mail.gmail.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Jan 31, 2019 at 04:31:49PM +0000, Filipe Manana wrote:
> On Wed, Dec 12, 2018 at 6:07 PM <fdmanana@kernel.org> wrote:
> >
> > From: Filipe Manana <fdmanana@suse.com>
> >
> > Comparing the content of the pages in the range to deduplicate is now done
> > by the generic helper generic_remap_file_range_prep(), which takes care of
> > ensuring we do not compare/deduplicate undefined data beyond a file's eof
> > (range from eof to the next block boundary). So remove these checks which
> > are now redundant.
> >
> > Signed-off-by: Filipe Manana <fdmanana@suse.com>
> 
> Any reason why this was not yet picked?

Added to misc-next now.
