Return-Path: <SRS0=8/Zd=P4=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 952DFC26641
	for <linux-btrfs@archiver.kernel.org>; Sun, 20 Jan 2019 18:40:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6232C2084F
	for <linux-btrfs@archiver.kernel.org>; Sun, 20 Jan 2019 18:40:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1548009630;
	bh=h0HVpnmOMn3YnQY8dWg2vJ6cf80ypMKGu3f9fU5ANVg=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:List-ID:From;
	b=falQpawzEo7cBm8YU+fP22vX3EmN56ubS30RrxnM7s8P6JDsOldgOfnaJHcRTiesF
	 zfqHn7oJ+7Wd36XZx7fMU5YfjvdRO/ZqISxw67bRk2iLaLm3YReg7bEeK+o1VFyBnM
	 8DlUADun5/HjNtqTKioUHl8tZOXOZNFEBA/UthJ0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727794AbfATSkY (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 20 Jan 2019 13:40:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:39628 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727630AbfATSkC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 20 Jan 2019 13:40:02 -0500
Subject: Re: [GIT PULL] Btrfs fixes for 5.0-rc3
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1548009602;
        bh=h0HVpnmOMn3YnQY8dWg2vJ6cf80ypMKGu3f9fU5ANVg=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=gyp58XMFbroZ3ChXBUKr6fVNOjD4Bn1OtF9EBu4gMwaH3V3ctIQg2/74o2xlqQWrZ
         YQ0uX7Bg6vaZ++U+yZJwTaPVQCxvXXxTXe8zrcv3W4Y4+Vzg1ZHsk7ahHdheHl+NCx
         Hct/sGuOOPEb6XkpX6m32Y1TO/kqsYJQZhAc5Duw=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <cover.1547998923.git.dsterba@suse.com>
References: <cover.1547998923.git.dsterba@suse.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <cover.1547998923.git.dsterba@suse.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-5.0-rc2-tag
X-PR-Tracked-Commit-Id: fd340d0f68cc87badfc9efcb226f23a5428826a0
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 1be969f4682b0aa1995e46fba51502de55f15ce8
Message-Id: <154800960227.15983.1928682040558514514.pr-tracker-bot@kernel.org>
Date:   Sun, 20 Jan 2019 18:40:02 +0000
To:     David Sterba <dsterba@suse.com>
Cc:     torvalds@linux-foundation.org, David Sterba <dsterba@suse.com>,
        clm@fb.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

The pull request you sent on Sun, 20 Jan 2019 16:51:29 +0100:

> git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-5.0-rc2-tag

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/1be969f4682b0aa1995e46fba51502de55f15ce8

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
