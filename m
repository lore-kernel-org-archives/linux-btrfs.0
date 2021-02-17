Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31CD8C433DB
	for <linux-btrfs@archiver.kernel.org>; Wed, 17 Feb 2021 17:50:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 040E964E4A
	for <linux-btrfs@archiver.kernel.org>; Wed, 17 Feb 2021 17:50:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231773AbhBQRuT (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 17 Feb 2021 12:50:19 -0500
Received: from mx2.suse.de ([195.135.220.15]:44704 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230315AbhBQRuS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 17 Feb 2021 12:50:18 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id E3F03B077;
        Wed, 17 Feb 2021 17:49:36 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 60AC3DA7C5; Wed, 17 Feb 2021 18:47:40 +0100 (CET)
Date:   Wed, 17 Feb 2021 18:47:40 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/4] Couple of misc patches
Message-ID: <20210217174740.GX1993@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20210217131250.265859-1-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210217131250.265859-1-nborisov@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Feb 17, 2021 at 03:12:46PM +0200, Nikolay Borisov wrote:
> Here are 4 patches which are independent of one another. The first 2 just
> change two more function to take btrfs_inode. Patch 3 just extends the usage of
> in_range which renders offset_in_entry redundant thus removing the function.
> Final patch just restructures btrfs_inc_block_group_ro to use a do{} while() loo
> rather than a label-based. This doesn't introduce extra nesting so I don't know
> why the label approach was chosen in the first place.
> 
> Nikolay Borisov (4):
>   btrfs: Make btrfs_replace_file_extents take btrfs_inode
>   btrfs: Make find_desired_extent take btrfs_inode
>   btrfs: Replace offset_in_entry with in_range
>   btrfs: Replace opencoded while loop with proper construct

Added to topic branch, will be in for-next once merge window is over.
Thanks.
