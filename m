Return-Path: <SRS0=jnhB=EL=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C20AC4741F
	for <linux-btrfs@archiver.kernel.org>; Thu,  5 Nov 2020 14:29:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D445120786
	for <linux-btrfs@archiver.kernel.org>; Thu,  5 Nov 2020 14:29:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731046AbgKEO32 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 5 Nov 2020 09:29:28 -0500
Received: from mx2.suse.de ([195.135.220.15]:33586 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727275AbgKEO31 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 5 Nov 2020 09:29:27 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id CC248AAF1;
        Thu,  5 Nov 2020 14:29:26 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 088B7DA6E3; Thu,  5 Nov 2020 15:27:47 +0100 (CET)
Date:   Thu, 5 Nov 2020 15:27:47 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Josef Bacik <josef@toxicpanda.com>
Cc:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH 0/8] Block group caching fixes
Message-ID: <20201105142747.GJ6756@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Josef Bacik <josef@toxicpanda.com>,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
References: <cover.1603460665.git.josef@toxicpanda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1603460665.git.josef@toxicpanda.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Oct 23, 2020 at 09:58:03AM -0400, Josef Bacik wrote:
> The main fixes are
>   
>   btrfs: do not shorten unpin len for caching block groups
>   btrfs: update last_byte_to_unpin in switch_commit_roots
>   btrfs: protect the fs_info->caching_block_groups differently
> 
> And the work to make space cache async is in the following patches
> 
>   btrfs: cleanup btrfs_discard_update_discardable usage
>   btrfs: load free space cache into a temporary ctl
>   btrfs: load the free space cache inode extents from commit root
>   btrfs: async load free space cache
> 
> Thanks,
> 
> Josef
> 
> Josef Bacik (8):
>   btrfs: do not shorten unpin len for caching block groups
>   btrfs: update last_byte_to_unpin in switch_commit_roots
>   btrfs: explicitly protect ->last_byte_to_unpin in unpin_extent_range
>   btrfs: cleanup btrfs_discard_update_discardable usage
>   btrfs: load free space cache into a temporary ctl
>   btrfs: load the free space cache inode extents from commit root
>   btrfs: async load free space cache
>   btrfs: protect the fs_info->caching_block_groups differently

Added to misc-next, thanks. Some of the fixes look like stable candidate
but eg. "btrfs: protect the fs_info->caching_block_groups differently"
depends on the other patches and in whole is not a simple fix.

Patches 1 and apply to 5.4 and 5.8 respectively but for lower versions
there are conflicts and not trivial so that's all.
