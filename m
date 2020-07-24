Return-Path: <SRS0=zwEw=BD=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 024D6C43600
	for <linux-btrfs@archiver.kernel.org>; Fri, 24 Jul 2020 21:40:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CF9CE2070E
	for <linux-btrfs@archiver.kernel.org>; Fri, 24 Jul 2020 21:40:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1595626826;
	bh=7UhMPzCgaKEnu4Gttos1vxeUZwOsAlOfhIW63IvJKas=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:List-ID:From;
	b=Bl7xdGHqLm+7qEBosZw9eVMjfx39LUCslcveGDoLfJB5DKbYbsQZadeECwDmbFVzX
	 +CKeYVwsnJZikNIrKf2MyYSk9hl0rpRtIwPz7aN/AaVHblRE8zrtxwCLR1yEIhOrsz
	 x2UdYHFkRqMt8r317abyjl0eff5hTw/YDiOS4/m0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727038AbgGXVkG (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 24 Jul 2020 17:40:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:48842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726576AbgGXVkF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 24 Jul 2020 17:40:05 -0400
Subject: Re: [GIT PULL] Btrfs fixes for 5.8-rc7
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595626805;
        bh=7UhMPzCgaKEnu4Gttos1vxeUZwOsAlOfhIW63IvJKas=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=DQpS+PAjP+wCy9EW+4NucgBcSvQR/5QjNUm99m/4umImBZdmPGbRBMMpEsdtUUBvE
         sRtBCQeREng9hg/Mbt/FUD5H5Wyuh5nPOiMFPDP+xA6Venth8RFSMh19xiN3Qjp9ch
         NwhOUrbknZpePDiH5hoRoiN91feaDi1kxsmbSbX8=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <cover.1595587350.git.dsterba@suse.com>
References: <cover.1595587350.git.dsterba@suse.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <cover.1595587350.git.dsterba@suse.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-5.8-rc6-tag
X-PR-Tracked-Commit-Id: 48cfa61b58a1fee0bc49eef04f8ccf31493b7cdd
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 0669704270e142483d80cfda5c526426c1a89711
Message-Id: <159562680517.3064.12869955746910943201.pr-tracker-bot@kernel.org>
Date:   Fri, 24 Jul 2020 21:40:05 +0000
To:     David Sterba <dsterba@suse.com>
Cc:     torvalds@linux-foundation.org, David Sterba <dsterba@suse.com>,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

The pull request you sent on Fri, 24 Jul 2020 13:21:32 +0200:

> git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-5.8-rc6-tag

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/0669704270e142483d80cfda5c526426c1a89711

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
