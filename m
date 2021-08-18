Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7D5BC4320A
	for <linux-btrfs@archiver.kernel.org>; Wed, 18 Aug 2021 19:12:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9B8E361101
	for <linux-btrfs@archiver.kernel.org>; Wed, 18 Aug 2021 19:12:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232918AbhHRTNb (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 18 Aug 2021 15:13:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:41582 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232375AbhHRTNa (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 18 Aug 2021 15:13:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id E432A60BD3;
        Wed, 18 Aug 2021 19:12:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629313975;
        bh=ygeycQhA1oMb4WMjwljcLOIOgbOvHqPCm+AHRe4S6Do=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=gjlCOfaNvpi7RBAs/iL45IqfrktWgDUQ2PzgGdfOxaY1RyyBipDhH/rrA+iq4fTy2
         ko0bjQVb8xgLoKPgr/bbVcxpqk4NGpGfpF+1Yo/iz5Exg0ve1D8NkUcW3GukeSA1P7
         bJOBHyftmjO1eWRjeid2c1o7iYtx4da6jaoorcfv5bBwLiIISAW+am7h4g21X0mXVx
         D7y5lc8WRNhGamqEZ8r6DMj7VMk2PxpyYHomgxMdwd3V0H+vE1tcAaA7pMqLDlpJdT
         SOiJLg/mPMkkiBSdktmSCmENKzvfNNPXm9XyotHaU3yZ4k/ah/1nH+3loEVOG46COh
         W90ISg+WQ4rJQ==
Subject: Re: [GIT PULL] Btrfs fix for v5.14-rc7
From:   pr-tracker-bot@kernel.org
In-Reply-To: <cover.1629303887.git.dsterba@suse.com>
References: <cover.1629303887.git.dsterba@suse.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <cover.1629303887.git.dsterba@suse.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-5.14-rc6-tag
X-PR-Tracked-Commit-Id: 3f79f6f6247c83f448c8026c3ee16d4636ef8d4f
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: d6d09a6942050f21b065a134169002b4d6b701ef
Message-Id: <162931397589.7328.15416555636440346321.pr-tracker-bot@kernel.org>
Date:   Wed, 18 Aug 2021 19:12:55 +0000
To:     David Sterba <dsterba@suse.com>
Cc:     torvalds@linux-foundation.org, David Sterba <dsterba@suse.com>,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

The pull request you sent on Wed, 18 Aug 2021 18:40:07 +0200:

> git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-5.14-rc6-tag

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/d6d09a6942050f21b065a134169002b4d6b701ef

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
