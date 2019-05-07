Return-Path: <SRS0=hL4i=TH=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,
	T_DKIMWL_WL_HIGH autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66F7FC004C9
	for <linux-btrfs@archiver.kernel.org>; Tue,  7 May 2019 19:55:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3D2782087F
	for <linux-btrfs@archiver.kernel.org>; Tue,  7 May 2019 19:55:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1557258939;
	bh=rLgIlP/8Mj6sFqDDwTyarVMcGbDfOIwOHgfHb84yOn0=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:List-ID:From;
	b=sRBmEZbkzFgf4KA7YgwApuHR2XKoN79PzXZ4WnTqmR2cYlVKpCFcSfx636ANNWMb5
	 PQfsU388yhs2InOyGupKO6cmN4ixFEJk8FQ60ifSSbTlLvu1IObXGWLDlJSGuN3MPt
	 nW9SJDQk4r2TPuBpPaFeyn7gvU8y8nMYBsfgh6Do=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726688AbfEGTzL (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 7 May 2019 15:55:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:52948 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726091AbfEGTzK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 7 May 2019 15:55:10 -0400
Subject: Re: [GIT PULL] Btrfs updates for 5.2
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557258910;
        bh=rLgIlP/8Mj6sFqDDwTyarVMcGbDfOIwOHgfHb84yOn0=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=KGqxgDXNnMsmbwIjuOBqGlkX0gsKnkkYMDYEPIoFKDHvSwBNWRMv4S09bUrjLBFtn
         FP84gdEe4T91X2tay1pUUAtGij9/A8LMD8tllLrmQ2eDXYxDIcyKjNla3BymHxgcTP
         hvPr4EnXXpe/ioem45OcFfzE2t3sQgZ/sy/rAVyE=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <cover.1557148716.git.dsterba@suse.com>
References: <cover.1557148716.git.dsterba@suse.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <cover.1557148716.git.dsterba@suse.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-5.2-tag
X-PR-Tracked-Commit-Id: b1c16ac978fd40ae636e629bb69a652df7eebdc2
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 9f2e3a53f7ec9ef55e9d01bc29a6285d291c151e
Message-Id: <155725891011.4809.15619592822017659104.pr-tracker-bot@kernel.org>
Date:   Tue, 07 May 2019 19:55:10 +0000
To:     David Sterba <dsterba@suse.com>
Cc:     torvalds@linux-foundation.org, David Sterba <dsterba@suse.com>,
        clm@fb.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

The pull request you sent on Mon,  6 May 2019 15:31:12 +0200:

> git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-5.2-tag

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/9f2e3a53f7ec9ef55e9d01bc29a6285d291c151e

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
