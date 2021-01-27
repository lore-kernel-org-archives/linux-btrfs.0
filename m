Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97CB8C433DB
	for <linux-btrfs@archiver.kernel.org>; Wed, 27 Jan 2021 19:53:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3704864DA1
	for <linux-btrfs@archiver.kernel.org>; Wed, 27 Jan 2021 19:53:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231564AbhA0Tx2 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 27 Jan 2021 14:53:28 -0500
Received: from mx2.suse.de ([195.135.220.15]:51374 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231704AbhA0TxW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 27 Jan 2021 14:53:22 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id A4841ACF4;
        Wed, 27 Jan 2021 19:52:40 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 3A047DA84C; Wed, 27 Jan 2021 20:50:53 +0100 (CET)
Date:   Wed, 27 Jan 2021 20:50:53 +0100
From:   David Sterba <dsterba@suse.cz>
To:     fdmanana@kernel.org
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: remove wrong comment for can_nocow_extent()
Message-ID: <20210127195053.GE1993@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, fdmanana@kernel.org,
        linux-btrfs@vger.kernel.org
References: <9017cffd318c09a5e6248ca904903938c691b450.1611759896.git.fdmanana@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9017cffd318c09a5e6248ca904903938c691b450.1611759896.git.fdmanana@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Jan 27, 2021 at 03:05:41PM +0000, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> The comment for can_nocow_extent() says that the function will flush
> ordered extents, however that never happens and was never true before the
> comment was added in commit e4ecaf90bc13 ("btrfs: add comments for
> btrfs_check_can_nocow() and can_nocow_extent()"). This is true only for
> the function btrfs_check_can_nocow(), which after that commit was renamed
> to check_can_nocow(). So just remove that part of the comment.
> 
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Added to misc-next, thanks.
