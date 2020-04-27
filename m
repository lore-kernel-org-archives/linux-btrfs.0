Return-Path: <SRS0=C73g=6L=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96662C4CECD
	for <linux-btrfs@archiver.kernel.org>; Mon, 27 Apr 2020 20:40:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7C6382072D
	for <linux-btrfs@archiver.kernel.org>; Mon, 27 Apr 2020 20:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1588020016;
	bh=UoFNoceYZZH5pyapz8+tDtt45JQ4gGxzCkqT0ld/LeQ=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:List-ID:From;
	b=LtNkpYaf41cSDv7wn7SawDbSnrxOyMNuxIUHpx44D5Cws2A3GpAsNTjL/2TzZ/RDi
	 Ku8nfBXTO0oo4+4Xc17ocFcWzL4avTdOKMTC6Ax+RBnXmo2vmIo1pCq82XsEUWsjTn
	 QunCqLNKn2bfQe4kFFWDF+niAOIS4Ep+SfuI6be0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726699AbgD0UkQ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 27 Apr 2020 16:40:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:48404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726205AbgD0UkP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 27 Apr 2020 16:40:15 -0400
Subject: Re: [GIT PULL] Btrfs fixes for 5.7-rc4
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588020014;
        bh=UoFNoceYZZH5pyapz8+tDtt45JQ4gGxzCkqT0ld/LeQ=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=WdYQQTkyxeK95T8CuHjz8bTH+zFimCl4GD6Z+WidKsgXUWQuUhxmGWIoYhTkfxRsc
         WU9DRhYs/o3mb7CHXk72wj710Uk1LzdjmY3VPTJLQwYrvijiq4cP69Opj6nhKhH2hz
         nQSFSeNmB+XfoO2o+ArhUknYksQMF/8aLB8Mc+vU=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <cover.1587992189.git.dsterba@suse.com>
References: <cover.1587992189.git.dsterba@suse.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <cover.1587992189.git.dsterba@suse.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-5.7-rc3-tag
X-PR-Tracked-Commit-Id: 1402d17dfd9657be0da8458b2079d03c2d61c86a
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 51184ae37e0518fd90cb437a2fbc953ae558cd0d
Message-Id: <158802001470.5189.1036883224851379926.pr-tracker-bot@kernel.org>
Date:   Mon, 27 Apr 2020 20:40:14 +0000
To:     David Sterba <dsterba@suse.com>
Cc:     torvalds@linux-foundation.org, David Sterba <dsterba@suse.com>,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

The pull request you sent on Mon, 27 Apr 2020 15:45:28 +0200:

> git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-5.7-rc3-tag

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/51184ae37e0518fd90cb437a2fbc953ae558cd0d

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
