Return-Path: <SRS0=Bqu+=B3=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C6B3C433E1
	for <linux-btrfs@archiver.kernel.org>; Mon, 17 Aug 2020 12:19:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3E62B2063A
	for <linux-btrfs@archiver.kernel.org>; Mon, 17 Aug 2020 12:19:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726830AbgHQMTH (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 17 Aug 2020 08:19:07 -0400
Received: from mx2.suse.de ([195.135.220.15]:33722 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726151AbgHQMTG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 17 Aug 2020 08:19:06 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 5799BAC97;
        Mon, 17 Aug 2020 12:19:30 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 15734DA6EF; Mon, 17 Aug 2020 14:18:01 +0200 (CEST)
Date:   Mon, 17 Aug 2020 14:18:00 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: cleanup how we calculate lockend in
 lock_and_cleanup_extent_if_need()
Message-ID: <20200817121800.GC2026@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20200813063352.94447-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200813063352.94447-1-wqu@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Aug 13, 2020 at 02:33:52PM +0800, Qu Wenruo wrote:
> We're just doing rounding up to sectorsize to calculate the lockend.
> 
> There is no need to do the unnecessary length calculation, just direct
> round_up() is enough.
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>

Added to misc-next, thanks.
