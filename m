Return-Path: <SRS0=QfkU=SF=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29E0CC4360F
	for <linux-btrfs@archiver.kernel.org>; Wed,  3 Apr 2019 14:24:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 010482075E
	for <linux-btrfs@archiver.kernel.org>; Wed,  3 Apr 2019 14:24:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726384AbfDCOYg (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 3 Apr 2019 10:24:36 -0400
Received: from mx2.suse.de ([195.135.220.15]:50494 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726168AbfDCOYg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 3 Apr 2019 10:24:36 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id A73F1ABE1
        for <linux-btrfs@vger.kernel.org>; Wed,  3 Apr 2019 14:24:35 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 70762DA8D8; Wed,  3 Apr 2019 16:25:45 +0200 (CEST)
Date:   Wed, 3 Apr 2019 16:25:45 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.de>
Cc:     dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2] btrfs: tree-checker: Make write time tree checker
 verify the content of leaves
Message-ID: <20190403142545.GP29086@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <wqu@suse.de>,
        Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20190403115919.17049-1-wqu@suse.com>
 <20190403141321.GN29086@twin.jikos.cz>
 <6a5021cd-573c-8a8f-3867-964c51bd3823@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6a5021cd-573c-8a8f-3867-964c51bd3823@suse.de>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Apr 03, 2019 at 10:15:27PM +0800, Qu Wenruo wrote:
> 
> 
> On 2019/4/3 下午10:13, David Sterba wrote:
> > On Wed, Apr 03, 2019 at 07:59:18PM +0800, Qu Wenruo wrote:
> >> Commit "btrfs: Do mandatory tree block check before submitting bio" is
> >> designed to check leaves contents, just as read time check.
> >>
> >> However due to the confusing parameter list, "false" is passed to where
> >> it is supposed to be "true".
> > 
> > And this seems to invalidate all testing since false->true will do
> > additional expensive checks.
> 
> That's the case.
> 
> However with the next patch, btrfs_check_leaf_full() is less expensive.
> Just 3~5 times expensive as csum_tree_block(), reduced from 20 times.
> 
> My full fstests run is coming to the end and so far no regression.
> 
> > I thought I'd fold the fix to the original
> > patch but in this case it'd be the wrong thing to do due to the visible
> > effects of the change.
> 
> If that's the case, I'd add new Fixes: tag, but that can only happen
> after write time patch get merged upstream.

Fixes: to development patches should raise an alert that something's
wrong.
