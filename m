Return-Path: <SRS0=ik6r=2A=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0251C2D0C6
	for <linux-btrfs@archiver.kernel.org>; Tue, 10 Dec 2019 10:10:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B0F522073D
	for <linux-btrfs@archiver.kernel.org>; Tue, 10 Dec 2019 10:10:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727163AbfLJKKU (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 10 Dec 2019 05:10:20 -0500
Received: from mx2.suse.de ([195.135.220.15]:44352 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727083AbfLJKKU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 10 Dec 2019 05:10:20 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 37277B13D;
        Tue, 10 Dec 2019 10:10:19 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 1931EDA793; Tue, 10 Dec 2019 11:10:12 +0100 (CET)
Date:   Tue, 10 Dec 2019 11:10:11 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Johannes Thumshirn <jth@kernel.org>
Cc:     David Sterba <dsterba@suse.com>,
        Nikolay Borisov <nborisov@suse.com>, Qu Wenruo <wqu@suse.com>,
        Linux BTRFS Mailinglist <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v5 0/2] remove BUG_ON()s in btrfs_close_one_device()
Message-ID: <20191210101011.GS2734@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Johannes Thumshirn <jth@kernel.org>,
        David Sterba <dsterba@suse.com>,
        Nikolay Borisov <nborisov@suse.com>, Qu Wenruo <wqu@suse.com>,
        Linux BTRFS Mailinglist <linux-btrfs@vger.kernel.org>
References: <20191204133639.2382-1-jth@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191204133639.2382-1-jth@kernel.org>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Dec 04, 2019 at 02:36:37PM +0100, Johannes Thumshirn wrote:
> This series attempts to remove the BUG_ON()s in btrfs_close_one_device().
> Therefore some reorganization of btrfs_close_one_device() was needed, to
> avoid the memory allocation.
> 
> This series has passed fstests without any deviation from the baseline.
> 
> Changes to v4:
> - Clear dev_stat_ccnt on removal (Dave)
> - Don't clear BTRFS_DEV_STATE_MISSING and BTRFS_DEV_STATE_FS_METADATA as
>   they'll be handled elsewhere
> - Release extent_io_tree (fstests)

Passed fstests, I don't see any other obvious problems so I'll add it to
misc-next.
