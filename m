Return-Path: <SRS0=pqVg=DS=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58001C433DF
	for <linux-btrfs@archiver.kernel.org>; Sun, 11 Oct 2020 00:42:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 23B002078B
	for <linux-btrfs@archiver.kernel.org>; Sun, 11 Oct 2020 00:41:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728491AbgJKAkR (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 10 Oct 2020 20:40:17 -0400
Received: from james.kirk.hungrycats.org ([174.142.39.145]:43046 "EHLO
        james.kirk.hungrycats.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726473AbgJKAkQ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 10 Oct 2020 20:40:16 -0400
Received: by james.kirk.hungrycats.org (Postfix, from userid 1002)
        id 6E7758493D6; Sat, 10 Oct 2020 20:40:15 -0400 (EDT)
Date:   Sat, 10 Oct 2020 20:40:15 -0400
From:   Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To:     linux-btrfs@vger.kernel.org
Subject: missing btrfs fixes in 5.4 and older LTS
Message-ID: <20201011004015.GP5890@hungrycats.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

I audited LTS kernels against bees's shiny new kernel bug tracking
table[1], and found some fixes are missing in LTS kernels:

	39dba8739c4e btrfs: do not resolve backrefs for roots that are
	being deleted (missing in 4.19 and 5.4, maybe not relevant for
	4.14 and earlier, patch confirmed to fix a deadlock in 5.4)

	4ea748e1d2c9 Btrfs: fix deadlock between clone/dedupe and rename
	(merge conflict with kernels before 5.0, bug goes back to 4.4)

	62d54f3a7fa2 Btrfs: fix race between send and deduplication that
	lead to failures and crashes (merge conflict with kernels before
	5.0, relevant on 4.4 and later)

I didn't look at patches that were missing on LTS further back than 4.14.

One didn't get flagged for -stable.  The other two will not cherry-pick
cleanly and need a backport.

[1] https://zygo.github.io/bees/btrfs-kernel.html
