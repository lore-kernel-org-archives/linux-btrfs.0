Return-Path: <SRS0=C73g=6L=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68660C55199
	for <linux-btrfs@archiver.kernel.org>; Mon, 27 Apr 2020 15:18:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4CBE3206CD
	for <linux-btrfs@archiver.kernel.org>; Mon, 27 Apr 2020 15:18:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728161AbgD0PSw (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 27 Apr 2020 11:18:52 -0400
Received: from mx2.suse.de ([195.135.220.15]:48016 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726539AbgD0PSw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 27 Apr 2020 11:18:52 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 573B3AEBF;
        Mon, 27 Apr 2020 15:18:50 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id CB77EDA781; Mon, 27 Apr 2020 17:18:05 +0200 (CEST)
Date:   Mon, 27 Apr 2020 17:18:05 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Colin King <colin.king@canonical.com>
Cc:     Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][next] btrfs: fix check for memory allocation failure of
 ret->path
Message-ID: <20200427151805.GC18421@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Colin King <colin.king@canonical.com>,
        Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200421124703.149466-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200421124703.149466-1-colin.king@canonical.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Apr 21, 2020 at 01:47:03PM +0100, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> Currently the memory allocation failure check for ret->path is checking
> that ret is null rather than ret->path.  Fix this by checking ret->path
> instead.
> 
> Addresses-Coverity: ("Dereference null return")
> Fixes: bd8bdc532152 ("btrfs: backref: introduce the skeleton of btrfs_backref_iter")

As this is still in development branch, fixup folded in. Thanks.
