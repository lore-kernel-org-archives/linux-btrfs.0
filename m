Return-Path: <SRS0=V6R8=6B=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69FFBC3815B
	for <linux-btrfs@archiver.kernel.org>; Fri, 17 Apr 2020 17:45:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 514A62220A
	for <linux-btrfs@archiver.kernel.org>; Fri, 17 Apr 2020 17:45:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1587145536;
	bh=h9VHIl3XzVPoitHMnTRbmFfTS9rskjanMz/YQ56koSw=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:List-ID:From;
	b=oOUr+XopueG2fcwH1WULTtkPY7XQ8AFh7OW0PfQHlPPEpnTleXqI5v1UeM33rlh53
	 Bd7WI8fB2e5V0qU4wwe7jUR0oBH/b9xYtVK+xL6wc3D+l9OfgoipAlx5bA2ucLMxBJ
	 Dz/1I71ud54ONiVfuiGH4DIh7kIcskTXwDgtzYDY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730018AbgDQRpZ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 17 Apr 2020 13:45:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:46022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728421AbgDQRpX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 17 Apr 2020 13:45:23 -0400
Subject: Re: [GIT PULL] Btrfs fix for 5.7-rc2
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587145523;
        bh=h9VHIl3XzVPoitHMnTRbmFfTS9rskjanMz/YQ56koSw=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=RPmrvLyxlhB0C4OWcxFv7d0JpN8Xo7b+AxwQhDkBKgSkiNZTOUowbIc3c06rDHLlR
         US4Cobm490rkuHP3vsPwiC+wnlJOXWT5oOeWXlNpojWfJtNi4o/rZx6en2Yu9c83vq
         xU6JvhPihndBvrhI/VaV5sy3h4PHHBWIF/lvQ5FQ=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <cover.1587129870.git.dsterba@suse.com>
References: <cover.1587129870.git.dsterba@suse.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <cover.1587129870.git.dsterba@suse.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-5.7-rc1-tag
X-PR-Tracked-Commit-Id: aec7db3b13a07d515c15ada752a7287a44a79ea0
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: c5304dd59b0c26cd9744121b77ca61f014929ba8
Message-Id: <158714552315.1625.6990943266152755880.pr-tracker-bot@kernel.org>
Date:   Fri, 17 Apr 2020 17:45:23 +0000
To:     David Sterba <dsterba@suse.com>
Cc:     torvalds@linux-foundation.org, David Sterba <dsterba@suse.com>,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

The pull request you sent on Fri, 17 Apr 2020 15:29:54 +0200:

> git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-5.7-rc1-tag

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/c5304dd59b0c26cd9744121b77ca61f014929ba8

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
