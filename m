Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 953A8C433ED
	for <linux-btrfs@archiver.kernel.org>; Tue, 18 May 2021 21:12:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 65393611BF
	for <linux-btrfs@archiver.kernel.org>; Tue, 18 May 2021 21:12:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236141AbhERVNV (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 18 May 2021 17:13:21 -0400
Received: from mx2.suse.de ([195.135.220.15]:41990 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231681AbhERVNU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 18 May 2021 17:13:20 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 6EFB3AFD5;
        Tue, 18 May 2021 21:12:01 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 63B76DB228; Tue, 18 May 2021 23:09:28 +0200 (CEST)
Date:   Tue, 18 May 2021 23:09:28 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v3 0/2] btrfs: fixes for the 13 subpage preparation
 patches
Message-ID: <20210518210928.GV7604@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20210518070942.206846-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210518070942.206846-1-wqu@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, May 18, 2021 at 03:09:40PM +0800, Qu Wenruo wrote:
> v3:
> - Change the fix for the btrfs/215 hang
>   Now we choose to skip the locked page, leaving both its Ordered bit
>   and ordered extent accounting to be handled by run_delalloc_range()
>   error hanlding path.
> 
>   This fixes a possible ordered extent underflow, and removes a forward
>   declaration.

There are 2 finished fstests runs and it did hang or crash so it seems
to be fixed, thanks. I haven't verified individual tests that reported
some output mismatch, so can't say if they're known false positives or
possibly related to your patches. I'll try to take a look tomorrow.
