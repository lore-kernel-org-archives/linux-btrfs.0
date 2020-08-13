Return-Path: <SRS0=PX3t=BX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96A17C433DF
	for <linux-btrfs@archiver.kernel.org>; Thu, 13 Aug 2020 15:15:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6C3532078D
	for <linux-btrfs@archiver.kernel.org>; Thu, 13 Aug 2020 15:15:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726612AbgHMPPr (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 13 Aug 2020 11:15:47 -0400
Received: from mx2.suse.de ([195.135.220.15]:60148 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726249AbgHMPPr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 13 Aug 2020 11:15:47 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 4D724AE25;
        Thu, 13 Aug 2020 15:16:08 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id B6736DA6EF; Thu, 13 Aug 2020 17:14:43 +0200 (CEST)
Date:   Thu, 13 Aug 2020 17:14:43 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Josef Bacik <josef@toxicpanda.com>
Cc:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH 00/23][v4] Change data reservations to use the ticketing
 infra
Message-ID: <20200813151443.GM2026@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Josef Bacik <josef@toxicpanda.com>,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
References: <20200721142234.2680-1-josef@toxicpanda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200721142234.2680-1-josef@toxicpanda.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Jul 21, 2020 at 10:22:11AM -0400, Josef Bacik wrote:
> v3->v4:
> - Rebased onto a recent misc-next, slight fixup because of commenting around the
>   flush states.
> 
> v2->v3:
> - Rebased onto a recent misc-next
> 
> v1->v2:
> - Adjusted a comment in may_commit_transaction.
> - Fixed one of the intermediate patches to properly update ->reclaim_size.
> 
> We've had two different things in place to reserve data and metadata space,
> because generally speaking data is much simpler.  However the data reservations
> still suffered from the same issues that plagued metadata reservations, you
> could get multiple tasks racing in to get reservations.  This causes problems
> with cases like write/delete loops where we should be able to fill up the fs,
> delete everything, and go again.  You would sometimes race with a flusher that's
> trying to unpin the free space, take it's reservations, and then it would fail.
> 
> Fix this by moving the data reservations under the metadata ticketing
> infrastructure.  This gets rid of that problem, and simplifies our enospc code
> more by consolidating it into a single path.  Thanks,

V4 was in for-next so it got some testing coverage, though I haven't
done enospc targeted tests. I'm going to go through this series and put
it to misc-next once rc1 is out.
