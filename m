Return-Path: <SRS0=1Lxm=CT=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13186C433E2
	for <linux-btrfs@archiver.kernel.org>; Thu, 10 Sep 2020 17:20:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CBA60214F1
	for <linux-btrfs@archiver.kernel.org>; Thu, 10 Sep 2020 17:20:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726657AbgIJRUA (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 10 Sep 2020 13:20:00 -0400
Received: from mx2.suse.de ([195.135.220.15]:56266 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726800AbgIJQSA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 10 Sep 2020 12:18:00 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 48F79B224;
        Thu, 10 Sep 2020 16:18:11 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id CC15DDA730; Thu, 10 Sep 2020 18:16:39 +0200 (CEST)
Date:   Thu, 10 Sep 2020 18:16:39 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/5] Improve setup_items_for_insert
Message-ID: <20200910161639.GM18399@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20200901144001.4265-1-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200901144001.4265-1-nborisov@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Sep 01, 2020 at 05:39:56PM +0300, Nikolay Borisov wrote:
> here is a series to improve setup_items_for_insert. First patch is a simple
> re-arranegement of statements to eliminate a duplication of calculation.
> Patches 2 and 3 improve leaky interface of setup_items_for_insert as they
> convey information about the function's implementation. Patch 4 adds a proper
> kernel doc. Finally, patch 5 improves the error message in an exceptional
> condition. As an added bonus after applying the whole series bloat-o-meter
> output looks like:
> 
> add/remove: 0/0 grow/shrink: 1/7 up/down: 33/-99 (-66)
> Function                                     old     new   delta
> setup_items_for_insert                      1200    1233     +33
> insert_extent                                448     445      -3
> btrfs_duplicate_item                         260     254      -6
> test_btrfs_split_item                       1784    1776      -8
> insert_inode_item_key                        156     148      -8
> __btrfs_drop_extents                        3637    3621     -16
> btrfs_insert_delayed_items                  1153    1125     -28
> btrfs_insert_empty_items                     177     147     -30
> Total: Before=1113157, After=1113091, chg -0.01%
> 
> This has survived -g quick of xfstests
> 
> Nikolay Borisov (5):
>   btrfs: Re-arrange statements in setup_items_for_insert
>   btrfs: Eliminate total_size parameter from setup_items_for_insert
>   btrfs: Sink total_data parameter in setup_items_for_insert
>   btrfs: Add kerneldoc for setup_items_for_insert
>   btrfs: improve error message in setup_items_for_insert

Thanks, all seem straightforward, I'll add it to for-next and move to
misc-next once the tests finish.
