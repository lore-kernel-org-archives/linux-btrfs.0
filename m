Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C3D8C63777
	for <linux-btrfs@archiver.kernel.org>; Thu, 19 Nov 2020 21:11:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2071522259
	for <linux-btrfs@archiver.kernel.org>; Thu, 19 Nov 2020 21:11:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726515AbgKSVKq (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 19 Nov 2020 16:10:46 -0500
Received: from mx2.suse.de ([195.135.220.15]:35066 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726599AbgKSVKp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 19 Nov 2020 16:10:45 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 628D3ABF4;
        Thu, 19 Nov 2020 21:10:43 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 30161DA701; Thu, 19 Nov 2020 22:08:57 +0100 (CET)
Date:   Thu, 19 Nov 2020 22:08:57 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 04/24] btrfs: extent_io: introduce helper to handle
 page status update in end_bio_extent_readpage()
Message-ID: <20201119210857.GM20563@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20201113125149.140836-1-wqu@suse.com>
 <20201113125149.140836-5-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201113125149.140836-5-wqu@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Nov 13, 2020 at 08:51:29PM +0800, Qu Wenruo wrote:
> Introduce a new helper, endio_readpage_release_extent(), to handle
> update status update in end_bio_extent_readpage().
> 
> The refactor itself is not really nothing interesting, the point here is
> to provide the basis for later subpage support, where the page status
> update can be more complex than current code.
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>

Added to misc-next.
