Return-Path: <SRS0=lVOs=ZR=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2839C432C3
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Nov 2019 13:07:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 930AA20862
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Nov 2019 13:07:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727387AbfKYNHm (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 25 Nov 2019 08:07:42 -0500
Received: from mx2.suse.de ([195.135.220.15]:48752 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725823AbfKYNHm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 25 Nov 2019 08:07:42 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 26B86AE2E;
        Mon, 25 Nov 2019 13:07:41 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id A9DDBDA898; Mon, 25 Nov 2019 14:07:39 +0100 (CET)
Date:   Mon, 25 Nov 2019 14:07:39 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Josef Bacik <josef@toxicpanda.com>
Cc:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH] btrfs: handle error in btrfs_cache_block_group
Message-ID: <20191125130739.GA2734@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Josef Bacik <josef@toxicpanda.com>,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
References: <20191119185900.2985-1-josef@toxicpanda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191119185900.2985-1-josef@toxicpanda.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Nov 19, 2019 at 01:59:00PM -0500, Josef Bacik wrote:
> We have a BUG_ON(ret < 0) in find_free_extent from
> btrfs_cache_block_group.  If we fail to allocate our ctl we'll just
> panic, which is not good.  Instead just go on to another block group.
> If we fail to find a block group we don't want to return ENOSPC, because
> really we got a ENOMEM and that's the root of the problem.  Save our
> return from btrfs_cache_block_group(), and then if we still fail to make
> our allocation return that ret so we get the right error back.
> 
> Tested with inject-error.py from bcc.
> 
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>

Added to misc-next, thanks.
