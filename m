Return-Path: <SRS0=sQVi=6Z=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 134AEC47255
	for <linux-btrfs@archiver.kernel.org>; Mon, 11 May 2020 18:47:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EB89C20736
	for <linux-btrfs@archiver.kernel.org>; Mon, 11 May 2020 18:47:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728613AbgEKSr6 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 11 May 2020 14:47:58 -0400
Received: from mx2.suse.de ([195.135.220.15]:57112 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727051AbgEKSr5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 11 May 2020 14:47:57 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id F4114ACC5;
        Mon, 11 May 2020 18:47:58 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 69C11DA82A; Mon, 11 May 2020 20:47:02 +0200 (CEST)
Date:   Mon, 11 May 2020 20:46:59 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: check: Don't do early exit if
 maybe_repair_root_item() can't find needed root extent
Message-ID: <20200511184658.GU18421@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20200429101015.78658-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200429101015.78658-1-wqu@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Apr 29, 2020 at 06:10:15PM +0800, Qu Wenruo wrote:
> The whole maybe_repair_root_item() and repair_root_items() functions are
> introduced to handle an ancient bug in v3.17.
> 
> However in certain extent tree corruption case, such early exit would
> only exit the whole check process early on, preventing user to know
> what's really wrong about the fs.
> 
> So this patch will allow the check to continue, since the ancient bug is
> no long that common.
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>

Added to devel, thanks.
