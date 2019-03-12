Return-Path: <SRS0=uY43=RP=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1E01C43381
	for <linux-btrfs@archiver.kernel.org>; Tue, 12 Mar 2019 22:20:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B8F202175B
	for <linux-btrfs@archiver.kernel.org>; Tue, 12 Mar 2019 22:20:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1552429245;
	bh=XNHyyzs3LyS+Q2fxVRhlUjgK5o/vg2Tk/GgHS2uvt4w=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:List-ID:From;
	b=1oGAGqpkyh9riXb5O500G91o+rxnOO0fHegrnveEk2gX/fnRiavRqqU35K2WWczFH
	 /wLS+lujfGQO0bAKIJBmdkuQYUrcJlza+yGLqpsmwsbfnk8DsjfBlhtXoQUk0W+8BO
	 yGDtmIe/vXxg1dRr0LOZXfuqOXcSYO1bYwPKHzy4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727404AbfCLWUX (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 12 Mar 2019 18:20:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:43308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727392AbfCLWUW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 12 Mar 2019 18:20:22 -0400
Subject: Re: [GIT PULL] Btrfs updates for 5.1, part 2
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1552429221;
        bh=XNHyyzs3LyS+Q2fxVRhlUjgK5o/vg2Tk/GgHS2uvt4w=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=11rZA4u1yG7FWpPiNzQj+kbOyIjWylGia9RJRPv7mj2XaLwpKO1ZnJqLGpjZnZjre
         Hx5MWXXAkTLA9T/joXXGaHLkJL8l5/SmCkRaLS9FYVxrE6s17QEZywGVAMpYFuUxGJ
         UxOadi3a9V5GYdBcIZFl5uUWDD8mx7bPQMIonke8=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <cover.1552401006.git.dsterba@suse.com>
References: <cover.1552401006.git.dsterba@suse.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <cover.1552401006.git.dsterba@suse.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git
 for-5.1-part2-tag
X-PR-Tracked-Commit-Id: d3865159ac7823f645d313fdbac0b256ac01eeb9
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 92825b0298ca6822085ef483f914b6e0dea9bf66
Message-Id: <155242922173.11942.3180833678040247357.pr-tracker-bot@kernel.org>
Date:   Tue, 12 Mar 2019 22:20:21 +0000
To:     David Sterba <dsterba@suse.com>
Cc:     torvalds@linux-foundation.org, David Sterba <dsterba@suse.com>,
        clm@fb.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

The pull request you sent on Tue, 12 Mar 2019 16:08:52 +0100:

> git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-5.1-part2-tag

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/92825b0298ca6822085ef483f914b6e0dea9bf66

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
