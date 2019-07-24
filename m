Return-Path: <SRS0=kS6Y=VV=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E435C7618B
	for <linux-btrfs@archiver.kernel.org>; Wed, 24 Jul 2019 10:59:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4CA8E22387
	for <linux-btrfs@archiver.kernel.org>; Wed, 24 Jul 2019 10:59:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727329AbfGXK7u (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 24 Jul 2019 06:59:50 -0400
Received: from mx2.suse.de ([195.135.220.15]:32954 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726622AbfGXK7u (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 24 Jul 2019 06:59:50 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 0878CB008
        for <linux-btrfs@vger.kernel.org>; Wed, 24 Jul 2019 10:59:49 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 8F554DA808; Wed, 24 Jul 2019 13:00:26 +0200 (CEST)
Date:   Wed, 24 Jul 2019 13:00:26 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: extent-tree: Unify the parameters of
 btrfs_inc_extent_ref()
Message-ID: <20190724110026.GI2868@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20190724083554.5545-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190724083554.5545-1-wqu@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Jul 24, 2019 at 04:35:54PM +0800, Qu Wenruo wrote:
> The old parameters, @ref_generation and @owner_objectid, are pretty
> confusing when using auto-completion.
> 
> Unify the parameters as a quick fix.
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>

Applied, thanks.
