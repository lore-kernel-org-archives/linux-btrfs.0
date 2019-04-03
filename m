Return-Path: <SRS0=QfkU=SF=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C47CCC4360F
	for <linux-btrfs@archiver.kernel.org>; Wed,  3 Apr 2019 14:20:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9D66820830
	for <linux-btrfs@archiver.kernel.org>; Wed,  3 Apr 2019 14:20:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726607AbfDCOUe (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 3 Apr 2019 10:20:34 -0400
Received: from mx2.suse.de ([195.135.220.15]:48904 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726144AbfDCOUe (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 3 Apr 2019 10:20:34 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 175CBB00C
        for <linux-btrfs@vger.kernel.org>; Wed,  3 Apr 2019 14:20:33 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 859ADDA8D8; Wed,  3 Apr 2019 16:21:42 +0200 (CEST)
Date:   Wed, 3 Apr 2019 16:21:42 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/2] btrfs: tree-checker: Remove comprehensive root owner
 check
Message-ID: <20190403142142.GO29086@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20190403115919.17049-1-wqu@suse.com>
 <20190403115919.17049-2-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190403115919.17049-2-wqu@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Apr 03, 2019 at 07:59:19PM +0800, Qu Wenruo wrote:
> Commit 1ba98d086fe3 ("Btrfs: detect corruption when non-root leaf has
> zero item") introduced comprehensive root owner checker.

That's 4.7, so we might want to do stable backport to 4.9+.
> 
> However it's pretty expensive tree search to locate the owner root,
> especially when it get reused by mandatory read and write time
> tree-checker.
> 
> This patch will remove that check, and completely rely on owner based
> empty leaf check, which is much faster and still works fine for most
> case.
> 
> And since we skip the old root owner check, now write time tree check
> can be merged with btrfs_check_leaf_full().

And for that reason the change should be minimal, this patch depends on
current development queue so it's not suitable for the backport.

I'm thinking what to do here, I want to avoid patches that effectively
revert changes that are still in the development branch and haven't been
released.

This means to rework "btrfs: Do mandatory tree block check before
submitting bio", though it's deep in the branch, the scope of changes is
only 2 files so this should not cause any conflicts.
