Return-Path: <SRS0=uAB+=EF=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91992C388F9
	for <linux-btrfs@archiver.kernel.org>; Fri, 30 Oct 2020 20:36:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3A26F20791
	for <linux-btrfs@archiver.kernel.org>; Fri, 30 Oct 2020 20:36:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1604090195;
	bh=VmrLGl6WE2EXNkLLlDxsm7f6JiKeRoK2ljfuW6VZbWU=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:List-ID:From;
	b=FoqxMcWsZI2wC5n71pbJQuYMBLgjQpfb7PYNniYbFtxhPfYyPpt91qQ7PPc0lzc9c
	 QSeoKBqH87g0sQ1nxPDv/+H6NMcq7ndSnIdEvGwZ+QXBUZRblmGA7IFmgfeks1KzOD
	 sxAWlqM32au9lRK/9p50dfFpJ72EV27ymOL37okY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727637AbgJ3Ugb (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 30 Oct 2020 16:36:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:50104 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726917AbgJ3Ufy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 30 Oct 2020 16:35:54 -0400
Subject: Re: [GIT PULL] Btrfs fixes for 5.10-rc2
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604090154;
        bh=VmrLGl6WE2EXNkLLlDxsm7f6JiKeRoK2ljfuW6VZbWU=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=0kEZDa0OimBkx3aUBlbbq1gEPwOnthf+pty83JucLhEb4+kLdLuVhEXlZcH0AomhK
         k6TubWuPTWrwjhROAcv2nDN923kpxbsCc9GEFZkDogPfs0UHGpXlTBtNcxuCixTu//
         3GyVyCwa3jnlgMbbbVrjiozptRhBLBUIOxcyhyig=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <cover.1604073247.git.dsterba@suse.com>
References: <cover.1604073247.git.dsterba@suse.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <cover.1604073247.git.dsterba@suse.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-5.10-rc1-tag
X-PR-Tracked-Commit-Id: d5c8238849e7bae6063dfc16c08ed62cee7ee688
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: f5d808567a51d97e171e0a8111813f973bf4ac12
Message-Id: <160409015420.30485.3407223768263792247.pr-tracker-bot@kernel.org>
Date:   Fri, 30 Oct 2020 20:35:54 +0000
To:     David Sterba <dsterba@suse.com>
Cc:     torvalds@linux-foundation.org, David Sterba <dsterba@suse.com>,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

The pull request you sent on Fri, 30 Oct 2020 17:12:27 +0100:

> git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-5.10-rc1-tag

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/f5d808567a51d97e171e0a8111813f973bf4ac12

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
