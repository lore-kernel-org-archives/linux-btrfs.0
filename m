Return-Path: <SRS0=7zqG=AX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4BD3C433E1
	for <linux-btrfs@archiver.kernel.org>; Sun, 12 Jul 2020 19:30:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C4A8120720
	for <linux-btrfs@archiver.kernel.org>; Sun, 12 Jul 2020 19:30:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1594582215;
	bh=SF5iAQeq/11QhFwI1nHYlrFH2RvER9fHSR60c0I3TM0=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:List-ID:From;
	b=IvTgpW+U8HX92nr3E/2iRgnB6ska06nZCS+1blEiZOM6FgK03cRF309/8hG7tc5GS
	 31YjmTXuUAyk4Whetk1hKv6h4q/glS39ymMYhfbgEnuKc1X3oqGzm4pUxZ7ApZx0kp
	 Whc0nK58y18PX80QWh9Q9oddnaqzItxIiXphcLCM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729162AbgGLTaF (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 12 Jul 2020 15:30:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:51448 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729210AbgGLTaE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 12 Jul 2020 15:30:04 -0400
Subject: Re: [GIT PULL] Btrfs fixes for 5.8-rc5, part 2
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594582204;
        bh=SF5iAQeq/11QhFwI1nHYlrFH2RvER9fHSR60c0I3TM0=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=GJXGeUidSuIGFqE8Q2ehiS9utzXW3w8WDaL14yEOeXrcsfenZ8AHfc884nfTmD2PU
         eMPKsgeLeeuCDvZtc9XObNv3XM3DBmqlW9wdcIFtU4jBfXqzvNBF3IaVkdA5ryztpO
         2/bZVn3BejBTRaD/W08tf3C6uZMUKcKdaGvw8B7g=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <cover.1594548115.git.dsterba@suse.com>
References: <cover.1594548115.git.dsterba@suse.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <cover.1594548115.git.dsterba@suse.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-5.8-rc4-tag
X-PR-Tracked-Commit-Id: d77765911385b65fc82d74ab71b8983cddfe0b58
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 72c34e8d7099c329c2934c2ac9c886f638b6edaf
Message-Id: <159458220443.16981.9962622832431601410.pr-tracker-bot@kernel.org>
Date:   Sun, 12 Jul 2020 19:30:04 +0000
To:     David Sterba <dsterba@suse.com>
Cc:     torvalds@linux-foundation.org, David Sterba <dsterba@suse.com>,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

The pull request you sent on Sun, 12 Jul 2020 12:14:58 +0200:

> git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-5.8-rc4-tag

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/72c34e8d7099c329c2934c2ac9c886f638b6edaf

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
