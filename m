Return-Path: <SRS0=qk6s=AE=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 845E9C433E0
	for <linux-btrfs@archiver.kernel.org>; Tue, 23 Jun 2020 15:32:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6642020656
	for <linux-btrfs@archiver.kernel.org>; Tue, 23 Jun 2020 15:32:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732933AbgFWPcT (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 23 Jun 2020 11:32:19 -0400
Received: from mx2.suse.de ([195.135.220.15]:36364 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732781AbgFWPcT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 23 Jun 2020 11:32:19 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 8BD62AE67;
        Tue, 23 Jun 2020 15:32:17 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id D8157DA79B; Tue, 23 Jun 2020 17:32:05 +0200 (CEST)
Date:   Tue, 23 Jun 2020 17:32:05 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc:     David Sterba <dsterba@suse.cz>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: use free_root_extent_buffer to free root
Message-ID: <20200623153205.GK27795@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        linux-btrfs@vger.kernel.org
References: <20200623084007.34215-1-johannes.thumshirn@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200623084007.34215-1-johannes.thumshirn@wdc.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Jun 23, 2020 at 05:40:07PM +0900, Johannes Thumshirn wrote:
> In btrfs_put_root() we're freeing a btrfs_root's 'node' and 'commit_root'
> extent buffers manually via kfree(), while we're using
> free_root_extent_buffers() in the free_root_pointers() function above.
> 
> free_root_extent_buffers() also NULLs the pointers after freeing, which
> mitigates potential double frees.
> 
> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>

Added to misc-next, thanks.
