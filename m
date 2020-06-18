Return-Path: <SRS0=w3EC=77=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B444C433E2
	for <linux-btrfs@archiver.kernel.org>; Thu, 18 Jun 2020 15:29:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 167A720888
	for <linux-btrfs@archiver.kernel.org>; Thu, 18 Jun 2020 15:29:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731563AbgFRP3P (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 18 Jun 2020 11:29:15 -0400
Received: from mx2.suse.de ([195.135.220.15]:46416 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731548AbgFRP3M (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 18 Jun 2020 11:29:12 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 5772AAF21;
        Thu, 18 Jun 2020 15:29:10 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 13307DA703; Thu, 18 Jun 2020 17:29:00 +0200 (CEST)
Date:   Thu, 18 Jun 2020 17:29:00 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v3 0/3] btrfs: allow btrfs_truncate_block() to fallback
 to nocow for data space reservation
Message-ID: <20200618152900.GA27795@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20200618074950.136553-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200618074950.136553-1-wqu@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Jun 18, 2020 at 03:49:47PM +0800, Qu Wenruo wrote:
> v3:
> - Added two new patches
> - Refactor check_can_nocow()
>   Since the introduction of nowait, check_can_nocow() are in fact split
>   into two usage patterns: check_can_nocow(nowait = false) with
>   btrfs_drew_write_unlock(), and single check_can_nocow(nowait = true).
>   Refactor them into two functions: start_nocow_check() paired with
>   end_nocow_check(), and single try_nocow_check(). With comment added.
> 
> - Rebased to latest misc-next
> 
> - Added btrfs_assert_drew_write_locked() for btrfs_end_nocow_check()
>   This is a little concerning one, as it's in the hot path of buffered
>   write.
>   It has percpu_counter_sum() called in that hot path, causing
>   obvious performance drop for CONFIG_BTRFS_DEBUG build.
>   Not sure if the assert is worthy since there aren't any other users.
> 
> Qu Wenruo (3):
>   btrfs: add comments for check_can_nocow() and can_nocow_extent()
>   btrfs: refactor check_can_nocow() into two variants
>   btrfs: allow btrfs_truncate_block() to fallback to nocow for data
>     space reservation

As the patch is a stable backport candidate, please reorder the series
so the fix comes first and then the cleanups. The fixing patch does not
need to be perfect regarding naming. Thanks.
