Return-Path: <SRS0=6qVc=3G=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A07BC33C9E
	for <linux-btrfs@archiver.kernel.org>; Fri, 17 Jan 2020 20:00:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 545632072E
	for <linux-btrfs@archiver.kernel.org>; Fri, 17 Jan 2020 20:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1579291207;
	bh=fmXTxDUIlYYp54eVmWS+lFuTAi8VG6mPeyJJEcKn9J0=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:List-ID:From;
	b=CdROXIjsynCBazy/bPVQskWpFjYNbMVStP7M64TczdhSlQfeUOCx7YKqPcsTjVIoA
	 q2/FlP8/c6aa2sS2S2Uqay8AvzxPrJVsva58hZRITLeid4CfqZZ4HkgewBQNDR6YKX
	 6NDEwN/QDO7RzhwoGEQ7zQKCG/0xi8AgsJ1mLK1Q=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729610AbgAQUAG (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 17 Jan 2020 15:00:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:38156 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726897AbgAQUAF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 17 Jan 2020 15:00:05 -0500
Subject: Re: [GIT PULL] Btrfs fixes for 5.5-rc7
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579291204;
        bh=fmXTxDUIlYYp54eVmWS+lFuTAi8VG6mPeyJJEcKn9J0=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=SirTZByzUcM3JPjPw8s3fITeN+8bVh/RxMHHZoHAVV15+wU7laRK2GXl+4Jf7sJwB
         qtbjmWP/xfldii1AlGXfxAgqQ3q62R/tQAydcmENDUEiv9iNX3ED+bfaadiLAOXRt7
         me4yF6G3f0o/rKoCmhk7qHTuOH9RRI5fA4XwAqZA=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <cover.1579282274.git.dsterba@suse.com>
References: <cover.1579282274.git.dsterba@suse.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <cover.1579282274.git.dsterba@suse.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-5.5-rc6-tag
X-PR-Tracked-Commit-Id: b35cf1f0bf1f2b0b193093338414b9bd63b29015
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: effaf90137e3a9bb9702746f993f369a53c4185f
Message-Id: <157929120492.30919.2900017973775631241.pr-tracker-bot@kernel.org>
Date:   Fri, 17 Jan 2020 20:00:04 +0000
To:     David Sterba <dsterba@suse.com>
Cc:     torvalds@linux-foundation.org, David Sterba <dsterba@suse.com>,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

The pull request you sent on Fri, 17 Jan 2020 19:39:20 +0100:

> git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-5.5-rc6-tag

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/effaf90137e3a9bb9702746f993f369a53c4185f

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
