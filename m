Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46BDAC5519F
	for <linux-btrfs@archiver.kernel.org>; Wed, 18 Nov 2020 20:11:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D9CE52100A
	for <linux-btrfs@archiver.kernel.org>; Wed, 18 Nov 2020 20:11:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726466AbgKRULO (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 18 Nov 2020 15:11:14 -0500
Received: from mx2.suse.de ([195.135.220.15]:40936 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726136AbgKRULN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 18 Nov 2020 15:11:13 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 58BB8AC1F;
        Wed, 18 Nov 2020 20:11:12 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 9D1A3DA701; Wed, 18 Nov 2020 21:09:26 +0100 (CET)
Date:   Wed, 18 Nov 2020 21:09:26 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.com>
Subject: Re: [PATCH v2 05/24] btrfs: extent_io: extract the btree page
 submission code into its own helper function
Message-ID: <20201118200926.GF20563@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.com>
References: <20201113125149.140836-1-wqu@suse.com>
 <20201113125149.140836-6-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201113125149.140836-6-wqu@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Nov 13, 2020 at 08:51:30PM +0800, Qu Wenruo wrote:
> +/*
> + * Submit one page of one extent buffer.
> + *
> + * Will try to submit all pages of one extent buffer, thus will skip some pages
> + * if it's already submitted.

I think I have a deja vu, reading the above is contradictory (submit one
vs submit all) and that I replied that it should be clarified.
