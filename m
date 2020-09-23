Return-Path: <SRS0=lTFz=DA=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A1B6C4727E
	for <linux-btrfs@archiver.kernel.org>; Wed, 23 Sep 2020 21:54:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E4B322388A
	for <linux-btrfs@archiver.kernel.org>; Wed, 23 Sep 2020 21:54:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600898076;
	bh=0n5rCr6NBQW1FMFTu8qhU7RAjFG/1o7e/G6KCDmZx64=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:List-ID:From;
	b=H5ori0/CMQdfrtI68OmTWU+d19qKlPRLWPvz7xbJD54ZQhBYkMAzSjRC+jSzgdq51
	 JmrPIGM6XZWIeFyYmKE0m0nxkoUJhHnAmYuoLRdorb1iOX8W7nJP4ggRZA8Us40zdQ
	 v6aHrZNaEWAJZ2JGdJIf3FHKZcYKckLtHzijNKfY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726681AbgIWVya (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 23 Sep 2020 17:54:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:59856 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726381AbgIWVya (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 23 Sep 2020 17:54:30 -0400
Subject: Re: [GIT PULL] Btrfs fixes for 5.9-rc7
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600898069;
        bh=0n5rCr6NBQW1FMFTu8qhU7RAjFG/1o7e/G6KCDmZx64=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=fyOm69A12bSvMKJIreLYIZ9cdFhJaFpCKdh/cl2GtcMBHY1SzXAu51jPt9pS2r1rP
         jDrjmUmGesgGN7pupuzURkUvHB4cr/UQ4dsh8qmo7/d5Iwzi5WHoCEreReadXuJthE
         wiToevtJRNRZfLTw2k+OlIbB0v4bvUJpAJUEQ10I=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <cover.1600846065.git.dsterba@suse.com>
References: <cover.1600846065.git.dsterba@suse.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <cover.1600846065.git.dsterba@suse.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-5.9-rc6-tag
X-PR-Tracked-Commit-Id: b5ddcffa37778244d5e786fe32f778edf2bfc93e
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: bffac4b5435a07bf26604385ae533adff3cccf23
Message-Id: <160089806971.12557.17129671305869253435.pr-tracker-bot@kernel.org>
Date:   Wed, 23 Sep 2020 21:54:29 +0000
To:     David Sterba <dsterba@suse.com>
Cc:     torvalds@linux-foundation.org, David Sterba <dsterba@suse.com>,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

The pull request you sent on Wed, 23 Sep 2020 11:07:20 +0200:

> git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-5.9-rc6-tag

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/bffac4b5435a07bf26604385ae533adff3cccf23

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
