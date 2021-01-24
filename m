Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCE45C433E0
	for <linux-btrfs@archiver.kernel.org>; Sun, 24 Jan 2021 13:00:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ACFFC22D3E
	for <linux-btrfs@archiver.kernel.org>; Sun, 24 Jan 2021 13:00:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726959AbhAXNAg (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 24 Jan 2021 08:00:36 -0500
Received: from mx2.suse.de ([195.135.220.15]:60398 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726929AbhAXNAd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 24 Jan 2021 08:00:33 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 5A26EACC6;
        Sun, 24 Jan 2021 12:59:51 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 73C82DA7D7; Sun, 24 Jan 2021 13:58:05 +0100 (CET)
Date:   Sun, 24 Jan 2021 13:58:05 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Josef Bacik <josef@toxicpanda.com>
Cc:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH v3 0/2] ->total_bytes_pinned fixes for early ENOSPC issues
Message-ID: <20210124125805.GG1993@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Josef Bacik <josef@toxicpanda.com>,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
References: <cover.1610747242.git.josef@toxicpanda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1610747242.git.josef@toxicpanda.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Jan 15, 2021 at 04:48:54PM -0500, Josef Bacik wrote:
> v2->v3:
> - Updated the changelog in patch 2 to refer to the patchset that inspired the
>   change.
> - Added Nik's reviewed-by for patch 2.

Thanks, the patches have been in for-next, adding v3 to misc-next.

I've tagged it for stable 5.10, though it looks like it would apply to
at least 5.4. There's a minor conflict with the way how the pinned
extents get tracked, changed in 5.7. The patchset switching to
per-transaction is not easily backportable to stable though it does not
seem to be a functionality conflict.
