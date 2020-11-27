Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0ABFC63777
	for <linux-btrfs@archiver.kernel.org>; Fri, 27 Nov 2020 21:33:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7F62321534
	for <linux-btrfs@archiver.kernel.org>; Fri, 27 Nov 2020 21:33:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="QrjeH652"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731306AbgK0VdO (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 27 Nov 2020 16:33:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:47382 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729845AbgK0VWC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 27 Nov 2020 16:22:02 -0500
Subject: Re: [GIT PULL] Btrfs fixes for 5.10-rc6
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606512116;
        bh=l1SgnkQkRwVSpMPnhckNx1OrFIfFrWP/ltto5ya/nto=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=QrjeH652bSu94WM9iq18/8blPXPsXTIsmem9nQaezhvGqfzBxFtsWRrmv886ymaZu
         DF/AHjWvgP2NeQP+RGDezsQoOb7kxigpSS+SaSoOv2ZmAw45CY9NzBeD74aHvwj06c
         y/fXEAXg+N2V6LgECTt9G7uncB1t1dF8cWPZnkr0=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <cover.1606490199.git.dsterba@suse.com>
References: <cover.1606490199.git.dsterba@suse.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <cover.1606490199.git.dsterba@suse.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-5.10-rc5-tag
X-PR-Tracked-Commit-Id: a855fbe69229078cd8aecd8974fb996a5ca651e6
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: a17a3ca55e96d20e25e8b1a7cd08192ce2bac3cc
Message-Id: <160651211652.4351.8527817392867058929.pr-tracker-bot@kernel.org>
Date:   Fri, 27 Nov 2020 21:21:56 +0000
To:     David Sterba <dsterba@suse.com>
Cc:     torvalds@linux-foundation.org, David Sterba <dsterba@suse.com>,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

The pull request you sent on Fri, 27 Nov 2020 16:36:15 +0100:

> git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-5.10-rc5-tag

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/a17a3ca55e96d20e25e8b1a7cd08192ce2bac3cc

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
