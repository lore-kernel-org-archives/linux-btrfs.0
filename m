Return-Path: <SRS0=PiMA=56=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 690E6C2BA19
	for <linux-btrfs@archiver.kernel.org>; Tue, 14 Apr 2020 15:16:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 49C6D20768
	for <linux-btrfs@archiver.kernel.org>; Tue, 14 Apr 2020 15:16:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407285AbgDNPGl (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 14 Apr 2020 11:06:41 -0400
Received: from mx2.suse.de ([195.135.220.15]:36544 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2407280AbgDNPGa (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 14 Apr 2020 11:06:30 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id B2E90ACE3;
        Tue, 14 Apr 2020 15:06:28 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 1C452DA823; Tue, 14 Apr 2020 17:05:49 +0200 (CEST)
Date:   Tue, 14 Apr 2020 17:05:49 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: Remove extent_buffer::tree member
Message-ID: <20200414150549.GS5920@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20200414013404.41830-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200414013404.41830-1-wqu@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Apr 14, 2020 at 09:34:04AM +0800, Qu Wenruo wrote:
> This member can be fetched from eb::fs_info, and no caller really
> depends on that member to determine if an eb is dummy. We have eb::flags
> to determine that.
> 
> Kernel doesn't have such member either.
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>

Added to devel, thanks.

> NOTE: Another candidate to cleanup is eb::cache_node, in kernel we use
> radix tree, thus no need for any structure in eb.
> 
> But in btrfs-progs, we also rely on extent_io_tree to do cache size
> limitation, and for U-boot there is no radix tree implemented yet.
> 
> Thus eb::cache_node may live for a longer time.

Ok. There will be differences among the implementations, we might add
some thin API to hide the caching or underlying strcutres but for now I
don't have anything specific in mind.
