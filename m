Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 196FDC47096
	for <linux-btrfs@archiver.kernel.org>; Thu,  3 Jun 2021 19:09:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EDA1E613E3
	for <linux-btrfs@archiver.kernel.org>; Thu,  3 Jun 2021 19:09:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229751AbhFCTL0 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 3 Jun 2021 15:11:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:58452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229697AbhFCTL0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 3 Jun 2021 15:11:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id A0E7E613F4;
        Thu,  3 Jun 2021 19:09:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622747381;
        bh=kgbhbjTvfZkle0B5mVEnLImUnlmRWDVSSQLybFCDIyo=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=hVHSD+El/7g78jejL4pGEk3jdAEDFSWrfxxSSmzLYsnTjt4p0KYFTsrlbjT4SItlr
         5ih6yzp9KgZZsAFuHWIzn4IMCrfhVwAw9IeTSdYg0vGW/R6md0KILf67mtbjlDxm4A
         KjBNhYcajXWi7LNDvq9T5k92aZYiijZKI8HWQ2o7oFQtIBjpBHpbxYtuorRLSsj6So
         KsR0bhIq6tMIMdwzRSpt3A4Vip2VRPbez0SE4W2fDfetIYvNFaxEmpl2pKNBj9VaiP
         MhGd0Iym7SH2r/yeT9yGLM4NQgeHydiJUV0Zf5M5ZFCnFJrZ+G4G6LymQ7BbpIuN2H
         DZdSvUdOkEO4A==
Subject: Re: [GIT PULL] Btrfs fixes for 5.13-rc5
From:   pr-tracker-bot@kernel.org
In-Reply-To: <cover.1622728563.git.dsterba@suse.com>
References: <cover.1622728563.git.dsterba@suse.com>
X-PR-Tracked-List-Id: <linux-btrfs.vger.kernel.org>
X-PR-Tracked-Message-Id: <cover.1622728563.git.dsterba@suse.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-5.13-rc4-tag
X-PR-Tracked-Commit-Id: 503d1acb01826b42e5afb496dfcc32751bec9478
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: fd2ff2774e90a0ba58f1158d7ea095af51f31644
Message-Id: <162274738152.14300.1619073635263173258.pr-tracker-bot@kernel.org>
Date:   Thu, 03 Jun 2021 19:09:41 +0000
To:     David Sterba <dsterba@suse.com>
Cc:     torvalds@linux-foundation.org, David Sterba <dsterba@suse.com>,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

The pull request you sent on Thu,  3 Jun 2021 16:50:15 +0200:

> git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-5.13-rc4-tag

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/fd2ff2774e90a0ba58f1158d7ea095af51f31644

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
