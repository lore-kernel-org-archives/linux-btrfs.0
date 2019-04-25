Return-Path: <SRS0=mBNC=S3=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72CC2C43219
	for <linux-btrfs@archiver.kernel.org>; Thu, 25 Apr 2019 15:21:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A57782067D
	for <linux-btrfs@archiver.kernel.org>; Thu, 25 Apr 2019 15:21:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728233AbfDYPVH (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 25 Apr 2019 11:21:07 -0400
Received: from mx2.suse.de ([195.135.220.15]:40788 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728227AbfDYPVG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 25 Apr 2019 11:21:06 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id D41E7AEE2;
        Thu, 25 Apr 2019 15:21:05 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 111A1DA847; Thu, 25 Apr 2019 17:22:08 +0200 (CEST)
Date:   Thu, 25 Apr 2019 17:22:07 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Josef Bacik <josef@toxicpanda.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/2] ENOSPC refinements
Message-ID: <20190425152206.GK20156@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Josef Bacik <josef@toxicpanda.com>,
        linux-btrfs@vger.kernel.org
References: <20190410195610.84110-1-josef@toxicpanda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190410195610.84110-1-josef@toxicpanda.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Apr 10, 2019 at 03:56:08PM -0400, Josef Bacik wrote:
> I noticed our continuous testing for btrfs started timing out recently, and dug
> down to discover that generic/224 was taking upwards of an hour to run.  This
> test should take seconds to run, so this is a problem.
> 
> Fix this by reworking how we do delalloc metadata reservations, as described in
> patch 2/2.
> 
> I also noticed we don't quite do the right thing when we are mostly O_DIRECT,
> and addressed this in patch 1/2.  I've run these through xfstests and everything
> is back to normal.  Thanks,

The patches have been in for-next for some time, I'd like to merge them
to 5.2 queue. Please update the changelogs, either post just the text or
whole patches. Thanks.
