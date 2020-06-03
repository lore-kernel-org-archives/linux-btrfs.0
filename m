Return-Path: <SRS0=7Enz=7Q=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5841C433DF
	for <linux-btrfs@archiver.kernel.org>; Wed,  3 Jun 2020 03:50:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C3ED9206E6
	for <linux-btrfs@archiver.kernel.org>; Wed,  3 Jun 2020 03:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1591156212;
	bh=uxLBNfsO/YI2tyqQItJTfnnheIwxdADpEhCmBIFstxw=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:List-ID:From;
	b=rsn+4NKjDgyKpFM0ttxmz/yAPVhxq4ZfYOdo6gSdgy+35uOnRkHUYBTztJpWPtYCS
	 pr9uex5bVp+q+WlemqtfNN5zWMJo7N3ejMOhHO0HGL0d1jhdGJaGmGREU81Mc5p14o
	 hCQ9n4NK4t8x0LmPuOyDmLwGQ6Lk+QR/B+SVTqb8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726774AbgFCDuM (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 2 Jun 2020 23:50:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:50122 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725922AbgFCDuJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 2 Jun 2020 23:50:09 -0400
Subject: Re: [GIT PULL] Btrfs updates for 5.8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591156209;
        bh=uxLBNfsO/YI2tyqQItJTfnnheIwxdADpEhCmBIFstxw=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=Gt6pipdcoelkT5803FBU39++5b9k27KCsZR6u6Oz9Be31HU0GoA5Z+xYyfuOCby1u
         9S2YxL9oIvZmc4qj9CVc7blBlpkWld/6Z/hhrg8nQbQZDsjMwywpe9JzWbuK8fxGWg
         frtl39jOviqSMjArjiwJyjhD6Jf4f5jTi2Wxj8hA=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <cover.1591014060.git.dsterba@suse.com>
References: <cover.1591014060.git.dsterba@suse.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <cover.1591014060.git.dsterba@suse.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-5.8-tag
X-PR-Tracked-Commit-Id: 2166e5edce9ac1edf3b113d6091ef72fcac2d6c4
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: f3cdc8ae116e27d84e1f33c7a2995960cebb73ac
Message-Id: <159115620927.30123.8464936394919802236.pr-tracker-bot@kernel.org>
Date:   Wed, 03 Jun 2020 03:50:09 +0000
To:     David Sterba <dsterba@suse.com>
Cc:     torvalds@linux-foundation.org, David Sterba <dsterba@suse.com>,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

The pull request you sent on Mon,  1 Jun 2020 14:37:21 +0200:

> git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-5.8-tag

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/f3cdc8ae116e27d84e1f33c7a2995960cebb73ac

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
