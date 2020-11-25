Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 494F3C56202
	for <linux-btrfs@archiver.kernel.org>; Wed, 25 Nov 2020 11:56:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EEFCA206E0
	for <linux-btrfs@archiver.kernel.org>; Wed, 25 Nov 2020 11:56:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728306AbgKYL4P (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 25 Nov 2020 06:56:15 -0500
Received: from mx2.suse.de ([195.135.220.15]:60810 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727661AbgKYL4O (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 25 Nov 2020 06:56:14 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id B05EAACBD;
        Wed, 25 Nov 2020 11:56:13 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id C65FCDA7FF; Wed, 25 Nov 2020 12:54:44 +0100 (CET)
Date:   Wed, 25 Nov 2020 12:54:44 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 4/4] btrfs: Return bool from btrfs_should_end_transaction
Message-ID: <20201125115444.GE6430@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20201124144925.3172221-1-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201124144925.3172221-1-nborisov@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Nov 24, 2020 at 04:49:25PM +0200, Nikolay Borisov wrote:
> Results in slightly smaller code.
> 
> add/remove: 0/0 grow/shrink: 0/1 up/down: 0/-11 (-11)
> Function                                     old     new   delta
> btrfs_should_end_transaction                  96      85     -11
> Total: Before=20070, After=20059, chg -0.05%
> 
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>

Added to misc-next, thanks.
