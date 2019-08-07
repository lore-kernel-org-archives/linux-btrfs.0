Return-Path: <SRS0=+IVA=WD=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A49F1C32751
	for <linux-btrfs@archiver.kernel.org>; Wed,  7 Aug 2019 12:29:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 86E3A21E6B
	for <linux-btrfs@archiver.kernel.org>; Wed,  7 Aug 2019 12:29:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729978AbfHGM3l (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 7 Aug 2019 08:29:41 -0400
Received: from mx2.suse.de ([195.135.220.15]:43304 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729722AbfHGM3g (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 7 Aug 2019 08:29:36 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id EF77FAC51;
        Wed,  7 Aug 2019 12:29:34 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id AFAA2DA7D7; Wed,  7 Aug 2019 14:30:06 +0200 (CEST)
Date:   Wed, 7 Aug 2019 14:30:06 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc:     Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: trim: Check the range passed into to prevent
 overflow
Message-ID: <20190807123006.GR28208@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <quwenruo.btrfs@gmx.com>,
        Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20190528082154.6450-1-wqu@suse.com>
 <8c3ba53e-7718-514a-2d1a-765e84e0a75d@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8c3ba53e-7718-514a-2d1a-765e84e0a75d@gmx.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Aug 07, 2019 at 08:03:41PM +0800, Qu Wenruo wrote:
> Gentle ping?
> 
> Thanks to the discussion with Anand, I find this patch is not merged yet.

I had the patch marked as dropped as it was during the trim range
changes. Reading the discussion again it's ok to merge and I'll add it
to the queue.
