Return-Path: <SRS0=0wlt=2B=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4EF1C43603
	for <linux-btrfs@archiver.kernel.org>; Wed, 11 Dec 2019 15:57:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 94E5F2073B
	for <linux-btrfs@archiver.kernel.org>; Wed, 11 Dec 2019 15:57:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731462AbfLKP5A (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 11 Dec 2019 10:57:00 -0500
Received: from mx2.suse.de ([195.135.220.15]:51172 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730461AbfLKPPU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 11 Dec 2019 10:15:20 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 433E3AB71;
        Wed, 11 Dec 2019 15:15:18 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id DE4C1DA883; Wed, 11 Dec 2019 16:15:18 +0100 (CET)
Date:   Wed, 11 Dec 2019 16:15:18 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Josef Bacik <josef@toxicpanda.com>
Cc:     Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org,
        Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
Subject: Re: [PATCH 2/3] btrfs: relocation: Fix KASAN report on
 create_reloc_tree due to extended reloc tree lifepsan
Message-ID: <20191211151518.GN3929@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Josef Bacik <josef@toxicpanda.com>,
        Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org,
        Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
References: <20191211050004.18414-1-wqu@suse.com>
 <20191211050004.18414-3-wqu@suse.com>
 <e429eb35-16d3-1231-b984-7210b1b6972b@toxicpanda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e429eb35-16d3-1231-b984-7210b1b6972b@toxicpanda.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Dec 11, 2019 at 09:55:04AM -0500, Josef Bacik wrote:
> > +	/*
> > +	 * We don't need to use reloc tree if:
> > +	 * - No reloc tree
> > +	 * - Relocation not running
> > +	 * - Reloc tree already merged
> > +	 */
> > +	if (!root->reloc_root || !rc || test_bit(BTRFS_ROOT_DEAD_RELOC_TREE,
> > +				&root->state))
> 
> This is awkward formatting, can we move the test_bit() to the first thing we 
> check so it's less weird?  Then you can add

I had the same thought, will move the test_bit on the next line.
