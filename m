Return-Path: <SRS0=nWHZ=AF=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 464B6C433DF
	for <linux-btrfs@archiver.kernel.org>; Wed, 24 Jun 2020 15:47:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2C61120706
	for <linux-btrfs@archiver.kernel.org>; Wed, 24 Jun 2020 15:47:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404293AbgFXPrM (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 24 Jun 2020 11:47:12 -0400
Received: from mx2.suse.de ([195.135.220.15]:36018 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390702AbgFXPrM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 24 Jun 2020 11:47:12 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id CCC1CAE2D;
        Wed, 24 Jun 2020 15:47:10 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id C2393DA79B; Wed, 24 Jun 2020 17:46:58 +0200 (CEST)
Date:   Wed, 24 Jun 2020 17:46:58 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/2] btrfs-progs: build warning hunting routine
Message-ID: <20200624154658.GT27795@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20200623054804.67175-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200623054804.67175-1-wqu@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Jun 23, 2020 at 01:48:02PM +0800, Qu Wenruo wrote:
> Two small cosmetic warning hunting with latest GCC/e2fsprogs.
> 
> Qu Wenruo (2):
>   btrfs-progs: convert/ext2: fix the pointer sign warning
>   btrfs-progs: Fix seemly wrong format overflow warning

Added to devel, thanks.
