Return-Path: <SRS0=UCOX=WY=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C184CC3A5A1
	for <linux-btrfs@archiver.kernel.org>; Wed, 28 Aug 2019 18:02:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A01E8206BB
	for <linux-btrfs@archiver.kernel.org>; Wed, 28 Aug 2019 18:02:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726749AbfH1SC4 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 28 Aug 2019 14:02:56 -0400
Received: from mx2.suse.de ([195.135.220.15]:52622 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726549AbfH1SC4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 28 Aug 2019 14:02:56 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 12F04AF55;
        Wed, 28 Aug 2019 18:02:55 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 051B8DA809; Wed, 28 Aug 2019 20:03:17 +0200 (CEST)
Date:   Wed, 28 Aug 2019 20:03:17 +0200
From:   David Sterba <dsterba@suse.cz>
To:     David Sterba <dsterba@suse.cz>
Cc:     Josef Bacik <josef@toxicpanda.com>, kernel-team@fb.com,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/5][v2] Fix global reserve size and can overcommit
Message-ID: <20190828180317.GH2752@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Josef Bacik <josef@toxicpanda.com>,
        kernel-team@fb.com, linux-btrfs@vger.kernel.org
References: <20190822191904.13939-1-josef@toxicpanda.com>
 <20190823131726.GQ2752@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190823131726.GQ2752@twin.jikos.cz>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Aug 23, 2019 at 03:17:26PM +0200, David Sterba wrote:
> On Thu, Aug 22, 2019 at 03:18:59PM -0400, Josef Bacik wrote:
> > This didn't series didn't change much, but I did move things around a little bit
> > in previous series so these needed to be updated.
> > 
> >  fs/btrfs/block-rsv.c  | 36 ++++++++++++++++++++++++++----------
> >  fs/btrfs/space-info.c | 51 ++++++++++++++++++++++++++-------------------------
> >  2 files changed, 52 insertions(+), 35 deletions(-)
> 
> Added as topic branch to for-next (based on the ticket rework patchset).

Moved to misc-next.
