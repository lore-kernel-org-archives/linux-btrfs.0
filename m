Return-Path: <SRS0=Mirb=N2=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 632E7C43441
	for <linux-btrfs@archiver.kernel.org>; Thu, 15 Nov 2018 10:17:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2F07A20854
	for <linux-btrfs@archiver.kernel.org>; Thu, 15 Nov 2018 10:17:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2F07A20854
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729117AbeKOUYh (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 15 Nov 2018 15:24:37 -0500
Received: from mx2.suse.de ([195.135.220.15]:32980 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728699AbeKOUYh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 15 Nov 2018 15:24:37 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 5C0DAACC2;
        Thu, 15 Nov 2018 10:17:24 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 4E693DAC1D; Thu, 15 Nov 2018 11:17:08 +0100 (CET)
Date:   Thu, 15 Nov 2018 11:17:08 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc:     Johannes Thumshirn <jthumshirn@suse.de>,
        David Sterba <dsterba@suse.com>,
        Linux BTRFS Mailinglist <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 0/6] btrfs: fix compiler warning with make W=1
Message-ID: <20181115101708.GN24115@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <quwenruo.btrfs@gmx.com>,
        Johannes Thumshirn <jthumshirn@suse.de>,
        David Sterba <dsterba@suse.com>,
        Linux BTRFS Mailinglist <linux-btrfs@vger.kernel.org>
References: <20181114133520.16069-1-jthumshirn@suse.de>
 <2b491534-6071-131f-1d87-4239ee9c42ec@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2b491534-6071-131f-1d87-4239ee9c42ec@gmx.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Nov 15, 2018 at 09:30:42AM +0800, Qu Wenruo wrote:
> BTW, could we just make "-Wunused-but-set-variable" default for btrfs
> module instead of following the global setting?

We'd need to fix all the warnings first, there are more left. We could
make it on by default for the debugging build though. I've checked that
the the macro from scripts/Makefile.extrawarn to detect the options is
available when building the module so, something like

ifeq(CONFIG_BTRFS_DEBUG,y)

warnings+=$(call cc-option,-Wunused-but-set-variable)
...

ccflags-y+=$(warnings)

endif

may be a good start.
