Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47129C433F5
	for <linux-btrfs@archiver.kernel.org>; Thu,  9 Sep 2021 23:23:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1CF6C610E8
	for <linux-btrfs@archiver.kernel.org>; Thu,  9 Sep 2021 23:23:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235102AbhIIXZD (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 9 Sep 2021 19:25:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:52352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231819AbhIIXZD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 9 Sep 2021 19:25:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 52570610C9;
        Thu,  9 Sep 2021 23:23:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631229833;
        bh=AWuIGHmdFV/ghsXtW80w3iRJEmPnzl4cG5Wb63fYW4M=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=SA+Lc3MSyojIMIzIfLsT8Pk0jfMxSpf7fhNYiRkiW7bZIyjC9CKUbbParxeWa+bXo
         k+/PB4ORQKTaAcfXbUNc7BQx7/RuBsSejEMKDbkChP9IFfn7h3AFTfyGxIdfs20dje
         e7s2Hx4gX1Lu7yoycNoiPBevPBw0FW01bJkCnsTcnzRVHKPxd2aKFO5rKyfOAIfS2E
         XvrvJy3Y/FqfwbbihECLfveGMOVwNsU/nWifu5uNWmuZPl/qaOmCkfDhyuUuJ7NfKN
         VMf7q7gBvosfn5vrV2u94lOnTSqpTYarQq6iwxm7vYErIYp5wDmca9R/nR5zrjunAE
         4gflV7tnaAF/Q==
Subject: Re: [GIT PULL] Btrfs fixes for 5.15-rc1
From:   pr-tracker-bot@kernel.org
In-Reply-To: <cover.1631193109.git.dsterba@suse.com>
References: <cover.1631193109.git.dsterba@suse.com>
X-PR-Tracked-List-Id: <linux-btrfs.vger.kernel.org>
X-PR-Tracked-Message-Id: <cover.1631193109.git.dsterba@suse.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-5.15-tag
X-PR-Tracked-Commit-Id: f79645df806565a03abb2847a1d20e6930b25e7e
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 8dde20867c443aedf6d64d8a494e8703d7ba53cb
Message-Id: <163122983321.18294.14216775009076169354.pr-tracker-bot@kernel.org>
Date:   Thu, 09 Sep 2021 23:23:53 +0000
To:     David Sterba <dsterba@suse.com>
Cc:     torvalds@linux-foundation.org, David Sterba <dsterba@suse.com>,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

The pull request you sent on Thu,  9 Sep 2021 15:42:37 +0200:

> git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-5.15-tag

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/8dde20867c443aedf6d64d8a494e8703d7ba53cb

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
