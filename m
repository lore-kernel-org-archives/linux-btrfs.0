Return-Path: <SRS0=L84K=B6=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 796DEC433E1
	for <linux-btrfs@archiver.kernel.org>; Thu, 20 Aug 2020 13:02:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 60E2A207DA
	for <linux-btrfs@archiver.kernel.org>; Thu, 20 Aug 2020 13:02:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729503AbgHTNCc (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 20 Aug 2020 09:02:32 -0400
Received: from mx2.suse.de ([195.135.220.15]:37980 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729008AbgHTJkG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 20 Aug 2020 05:40:06 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 5D898AEDA;
        Thu, 20 Aug 2020 09:40:32 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 869D7DA87C; Thu, 20 Aug 2020 11:38:59 +0200 (CEST)
Date:   Thu, 20 Aug 2020 11:38:59 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: add owner and fs_info for
 btrfs_device::alloc_state
Message-ID: <20200820093859.GV2026@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20200820074246.146503-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200820074246.146503-1-wqu@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Aug 20, 2020 at 03:42:46PM +0800, Qu Wenruo wrote:
> Commit 1c11b63eff2a ("btrfs: replace pending/pinned chunks lists with io
> tree") introduced btrfs_device::alloc_state extent io tree, but it
> doesn't initialize the fs_info and owner member.
> 
> This means the following features are not properly supported:
> - Fs owner report for insert_state() error
>   Without fs_info initialized, although btrfs_err() won't panic, it
>   won't output which fs is causing the error.
> 
> - Wrong owner for trace events
>   alloc_state will get the owner as pinned extents.
> 
> Fix this by assiging proper fs_info and owner for
> btrfs_device::alloc_state.
> 
> Fixes: 1c11b63eff2a ("btrfs: replace pending/pinned chunks lists with io tree")
> Signed-off-by: Qu Wenruo <wqu@suse.com>

Added to misc-next, thanks.
