Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDCD1C43334
	for <linux-btrfs@archiver.kernel.org>; Tue, 14 Jun 2022 09:56:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239917AbiFNJ4K (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 14 Jun 2022 05:56:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239637AbiFNJ4J (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 14 Jun 2022 05:56:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 926193AA7B
        for <linux-btrfs@vger.kernel.org>; Tue, 14 Jun 2022 02:56:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 36E8561715
        for <linux-btrfs@vger.kernel.org>; Tue, 14 Jun 2022 09:56:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B14CC3411B;
        Tue, 14 Jun 2022 09:56:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655200566;
        bh=WgE2VOPqmSv5mlbYfnwjxxEWREQ4Nj4sVWHJGy1PbyQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fVn5KlWDR9iWiW9W6FBbvKtkzcfBKsTekLq3Sclj8jSbL1VmJSUwNM8Ol+Vp6ACqZ
         f5Ur0qeVB7oMF4qSseTuoPTTxo6UDBZPNW8EJDmiJ3Rr8cEQvoJiCW5luZPXRinUjU
         +PonfCohYpBEzPBdRegPN+9tn9l0XeQpKB2op+HlnWbYUzjxSuQZe3duDb7DuUIvXw
         6J4bkKtPx3OoYC3YifmXoL4n3foKRsqVfBZQ/DUcR0tj/huo6i1QcAn8RsaHs4a0wu
         UT4ErFG5FCuCEE/i7RHTHsUtiogw+Mos4/qyIjg6aRgjjbobme29rpYP/5UjKD3Kma
         CGwQp6sAQfyrA==
Date:   Tue, 14 Jun 2022 10:56:03 +0100
From:   Filipe Manana <fdmanana@kernel.org>
To:     Josef Bacik <josef@toxicpanda.com>
Cc:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH v2 0/2] btrfs: fix deadlock with fsync and full sync
Message-ID: <20220614095603.GB3886393@falcondesktop>
References: <cover.1655147296.git.josef@toxicpanda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1655147296.git.josef@toxicpanda.com>
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Jun 13, 2022 at 03:09:47PM -0400, Josef Bacik wrote:
> v1->v2:
> - Make btrfs_sync_file also use the new BTRFS_LOG_FORCE_COMMIT define.
> - Adjust the title of the second patch
> 
> --- Original email ---
> Hello,
> 
> We've hit a pretty convoluted deadlock in production that Omar tracked down with
> drgn.  I've described the deadlock in the second patch, but generally it's a
> lock inversion where we have an existing dependency of extent lock ->
> transaction, but in fsync in a few cases we can end up with transaction ->
> extent lock, and the expected hilarity ensues.  Thanks,
> 
> Josef
> 
> Josef Bacik (2):
>   btrfs: make the return value for log syncing consistent
>   btrfs: fix deadlock with fsync+fiemap+transaction commit
> 
>  fs/btrfs/file.c     | 69 ++++++++++++++++++++++++++++++++++-----------
>  fs/btrfs/tree-log.c | 18 ++++++------
>  fs/btrfs/tree-log.h |  3 ++
>  3 files changed, 65 insertions(+), 25 deletions(-)

Reviewed-by: Filipe Manana <fdmanana@suse.com>

Looks good, thanks.

> 
> -- 
> 2.26.3
> 
