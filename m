Return-Path: <SRS0=CHLg=VO=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12DC8C76186
	for <linux-btrfs@archiver.kernel.org>; Wed, 17 Jul 2019 14:02:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E4F59208C0
	for <linux-btrfs@archiver.kernel.org>; Wed, 17 Jul 2019 14:01:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726898AbfGQOB7 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 17 Jul 2019 10:01:59 -0400
Received: from mx2.suse.de ([195.135.220.15]:43108 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725936AbfGQOB7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 17 Jul 2019 10:01:59 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id E4DDBB07D;
        Wed, 17 Jul 2019 14:01:57 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 174DADA8E1; Wed, 17 Jul 2019 16:02:35 +0200 (CEST)
Date:   Wed, 17 Jul 2019 16:02:34 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Johannes Thumshirn <jthumshirn@suse.de>
Cc:     Qu Wenruo <quwenruo.btrfs@gmx.com>,
        David Sterba <dsterba@suse.com>,
        Linux BTRFS Mailinglist <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs: free checksum hash on in close_ctree
Message-ID: <20190717140234.GD20977@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Johannes Thumshirn <jthumshirn@suse.de>,
        Qu Wenruo <quwenruo.btrfs@gmx.com>, David Sterba <dsterba@suse.com>,
        Linux BTRFS Mailinglist <linux-btrfs@vger.kernel.org>
References: <20190711152304.11438-1-jthumshirn@suse.de>
 <565cf2c9-6b97-349f-9540-655daa3c85f4@gmx.com>
 <20190712092138.GC16276@x250.microfocus.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190712092138.GC16276@x250.microfocus.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Jul 12, 2019 at 11:21:38AM +0200, Johannes Thumshirn wrote:
> On Fri, Jul 12, 2019 at 03:34:45PM +0800, Qu Wenruo wrote:
> > Not yet in upstream, thus I believe David could just fold this fix into
> > the original commit.
>  
> Right, I just didn't know if David's gonna rebase his branch before the pull
> request. AFAIK Linus doesn't really like recently rebased branches.

The branch for pull request is frozen at least a week before the merge
window starts and in exceptional and justified cases some changes are
possible, but certainly not rebaasing half of the branch.

As we found out, there are several problems with leaks, some of them
known before the merge window, but we have the rc milestones to fix
that.
