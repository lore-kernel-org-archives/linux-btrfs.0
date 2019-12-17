Return-Path: <SRS0=yR0V=2H=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1781FC43603
	for <linux-btrfs@archiver.kernel.org>; Tue, 17 Dec 2019 21:40:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DFD7921582
	for <linux-btrfs@archiver.kernel.org>; Tue, 17 Dec 2019 21:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1576618817;
	bh=Wc14UeokW5LvLYjVQcbtcF+Eacw8mOVXMJiT1hUDrzA=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:List-ID:From;
	b=QCUWNguEgxXn/jKwDxexVS7S4QHyO4boyFEym9V57TFweYs6m8ubmlurXNAecoSPI
	 tVBeNVhRyMH+Nkc8W4QY4CbDzAMRDaR9UfyULtDP/DLSALVFUU9fuNxVz66M57ZY0s
	 Qfj86OMY2S/wAyB0OgHkui3a5AKc5Zg1XS+1WKVc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728152AbfLQVkO (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 17 Dec 2019 16:40:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:40678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727988AbfLQVkN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 17 Dec 2019 16:40:13 -0500
Subject: Re: [GIT PULL] Btrfs fixes for 5.5-rc3
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576618813;
        bh=Wc14UeokW5LvLYjVQcbtcF+Eacw8mOVXMJiT1hUDrzA=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=BnCVo0vvUOyrOS9YgeYat1dwueR3FS68EiBbAhTwLvAtCeLHwkWCYrAy1gU8wOzhY
         CZMD8tqXPwWKZe/b+XlYKhB1a+iMVmtiUmAZhNPCyM61XPkdFnlrVNWUvrrA/AmXxx
         pW6WGiJdMPFVgWECfqNFm875oWGKbyYS6HjU3F/M=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <cover.1576601647.git.dsterba@suse.com>
References: <cover.1576601647.git.dsterba@suse.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <cover.1576601647.git.dsterba@suse.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-5.5-rc2-tag
X-PR-Tracked-Commit-Id: fbd542971aa1e9ec33212afe1d9b4f1106cd85a1
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 2187f215ebaac73ddbd814696d7c7fa34f0c3de0
Message-Id: <157661881317.22679.5708312827036168575.pr-tracker-bot@kernel.org>
Date:   Tue, 17 Dec 2019 21:40:13 +0000
To:     David Sterba <dsterba@suse.com>
Cc:     torvalds@linux-foundation.org, David Sterba <dsterba@suse.com>,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

The pull request you sent on Tue, 17 Dec 2019 18:08:16 +0100:

> git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-5.5-rc2-tag

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/2187f215ebaac73ddbd814696d7c7fa34f0c3de0

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
