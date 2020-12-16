Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47C19C2D0E4
	for <linux-btrfs@archiver.kernel.org>; Wed, 16 Dec 2020 03:44:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 155D223384
	for <linux-btrfs@archiver.kernel.org>; Wed, 16 Dec 2020 03:44:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725804AbgLPDou (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 15 Dec 2020 22:44:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:37636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725771AbgLPDou (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 15 Dec 2020 22:44:50 -0500
Subject: Re: [GIT PULL] Btrfs updates for 5.11
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608090249;
        bh=GbQJTx0fsDEkflKqlsH/IsqhacatyuIsuy+1Mf1lJco=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=qTr0N0nO9CEz2pwsdMyKJvx2lnuYtf4RQTGPmeGlTqxSGnL80H/6LX1o6nA5L4yFf
         /MPeaLkianpQkYdJSHYsVGUa/hUo2RAtVC5Zuep+pnnqt20hdlaTVkyzjpRzDO9JwO
         AOXpJkDrXV7WycsMrYP5Mm/iBuTVRTwNdqiHkqxX4O1oqN/rUz5T5c1z3CYTRuj6AD
         Qbz8eCoYaDFLCDDhxP9w/pY63xhK50odhNCSn7/rdgFDKM60u9+2zBJ/qsUkkeWmHw
         0JSgyPy4VnP6+r5qnY43sknnQLcyjZ9rGtq7TsvVPTDDbDrYadSvqB2znnAveWaJQJ
         J4dTql2UYYZBg==
From:   pr-tracker-bot@kernel.org
In-Reply-To: <cover.1607955523.git.dsterba@suse.com>
References: <cover.1607955523.git.dsterba@suse.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <cover.1607955523.git.dsterba@suse.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-5.11-tag
X-PR-Tracked-Commit-Id: b42fe98c92698d2a10094997e5f4d2dd968fd44f
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: f1ee3b8829006b3fda999f00f0059aa327e3f3d0
Message-Id: <160809024984.9893.8535729534204843936.pr-tracker-bot@kernel.org>
Date:   Wed, 16 Dec 2020 03:44:09 +0000
To:     David Sterba <dsterba@suse.com>
Cc:     torvalds@linux-foundation.org, David Sterba <dsterba@suse.com>,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

The pull request you sent on Mon, 14 Dec 2020 16:15:53 +0100:

> git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-5.11-tag

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/f1ee3b8829006b3fda999f00f0059aa327e3f3d0

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
