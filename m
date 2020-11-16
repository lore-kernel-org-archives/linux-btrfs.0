Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2EB7C4742C
	for <linux-btrfs@archiver.kernel.org>; Mon, 16 Nov 2020 15:31:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5BE262068D
	for <linux-btrfs@archiver.kernel.org>; Mon, 16 Nov 2020 15:31:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730726AbgKPPbI (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 16 Nov 2020 10:31:08 -0500
Received: from mx2.suse.de ([195.135.220.15]:59424 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730182AbgKPPbI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 16 Nov 2020 10:31:08 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 11E91ABF4;
        Mon, 16 Nov 2020 15:31:07 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 9DA3ADA6E3; Mon, 16 Nov 2020 16:29:22 +0100 (CET)
Date:   Mon, 16 Nov 2020 16:29:22 +0100
From:   David Sterba <dsterba@suse.cz>
To:     fdmanana@kernel.org
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: remove unnecessary attempt do drop extent maps
 after adding inline extent
Message-ID: <20201116152922.GM6756@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, fdmanana@kernel.org,
        linux-btrfs@vger.kernel.org
References: <1b80a3ffc965dbf663ab746dc11ea5e9fa1e10bf.1605266387.git.fdmanana@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1b80a3ffc965dbf663ab746dc11ea5e9fa1e10bf.1605266387.git.fdmanana@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Nov 13, 2020 at 11:24:17AM +0000, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> At inode.c:cow_file_range_inline(), after we insert the inline extent
> in the fs/subvolume btree, we call btrfs_drop_extent_cache() to drop
> all extent maps in the file range, however that is not necessary because
> we have already done it in the call to btrfs_drop_extents(), which calls
> btrfs_drop_extent_cache() for us, and since at this point we have the file
> range locked in the inode's iotree (we are in the writeback path), we know
> no other task can come in and read stale file extent items or find none
> and therefore create either stale extent maps or an extent map that
> represens a hole.
> 
> So just remove that unnecessary call to btrfs_drop_extent_cache(), as it's
> doing nothing and only wasting time. This call has been around since 2008,
> introduced in commit c8b978188c9a ("Btrfs: Add zlib compression support"),
> but even back then it seems it was not necessary, since we had the range
> locked in the inode's iotree and the call to btrfs_drop_extents() already
> used to always call btrfs_drop_extent_cache().
> 
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Added to misc-next, thanks.
