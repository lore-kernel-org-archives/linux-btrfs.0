Return-Path: <SRS0=sQVi=6Z=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F317C47255
	for <linux-btrfs@archiver.kernel.org>; Mon, 11 May 2020 18:51:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 82840206DB
	for <linux-btrfs@archiver.kernel.org>; Mon, 11 May 2020 18:51:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731112AbgEKSv3 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 11 May 2020 14:51:29 -0400
Received: from mx2.suse.de ([195.135.220.15]:57832 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729215AbgEKSv3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 11 May 2020 14:51:29 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id EE96AAC40;
        Mon, 11 May 2020 18:51:30 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id B49BFDA82A; Mon, 11 May 2020 20:50:37 +0200 (CEST)
Date:   Mon, 11 May 2020 20:50:37 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 0/4] btrfs-progs: Sync code for btrfs_block_group
Message-ID: <20200511185037.GW18421@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20200501065219.484868-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200501065219.484868-1-wqu@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, May 01, 2020 at 02:52:15PM +0800, Qu Wenruo wrote:
> This patchset mostly make btrfs_block_group structure to sync with
> kernel, providing the basis for later modification. (Hint: skinny bg
> tree)
> 
> Changelog:
> v2:
> - Add a patch to sync the block group item accessors
> 
> Qu Wenruo (4):
>   btrfs-progs: Sync block group item accessors from kernel
>   btrfs-progs: Kill block_group_cache::key
>   btrfs-progs: Remove the unused btrfs_block_group_cache::cache
>   btrfs-progs: Rename btrfs_block_group_cache to btrfs_block_group

All added to devel, thanks.
