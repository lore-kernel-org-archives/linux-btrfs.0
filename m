Return-Path: <SRS0=Lw6u=5H=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7D2EC54FCF
	for <linux-btrfs@archiver.kernel.org>; Sun, 22 Mar 2020 18:40:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7D1E420724
	for <linux-btrfs@archiver.kernel.org>; Sun, 22 Mar 2020 18:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1584902410;
	bh=JQVVJ1Nx7F+YEJ+mzsN8JazYuZhxd4EDSs9Czs3OvIY=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:List-ID:From;
	b=tCNsgtHdGOd3lt+fMmnHm+ExzXWDED55Dv7rvVQJpojvdM3K5eyYEO+ch82g/99tu
	 xZEpH360ud5OeTRunj1CagOXGTtG8CZeR1qSIE0Ndp+0sRssBvmFw4a+ozpPkTSaGL
	 uB1Nt5YJkvE7E+U3hz1mVWB6OEqpjUQmXtoaGEBU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726082AbgCVSkH (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 22 Mar 2020 14:40:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:46460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725785AbgCVSkH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 22 Mar 2020 14:40:07 -0400
Subject: Re: [GIT PULL] Btrfs fixes for 5.6-rc7
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584902407;
        bh=JQVVJ1Nx7F+YEJ+mzsN8JazYuZhxd4EDSs9Czs3OvIY=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=AClqTZmkAOqkER3KxzCSZAUOy8pM9T/PfmLoepgBAMbx/XWVehqwgNjnKtS54yjJS
         jHebEd3LWbNZMH8MORFipPGvCkBNRAS6M4Jzzqk/rHchjczcBRYvZD4SN42+RhkJHE
         h72xbOfwgZYd1jXEjEaMDrBFcjsWPQA4xkcjKFLk=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <cover.1584893030.git.dsterba@suse.com>
References: <cover.1584893030.git.dsterba@suse.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <cover.1584893030.git.dsterba@suse.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-5.6-rc6-tag
X-PR-Tracked-Commit-Id: d8e6fd5c7991033037842b32c9774370a038e902
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 67d584e33e54c3f33c8541928aa7115388c97433
Message-Id: <158490240717.3351.13363017113089060704.pr-tracker-bot@kernel.org>
Date:   Sun, 22 Mar 2020 18:40:07 +0000
To:     David Sterba <dsterba@suse.com>
Cc:     torvalds@linux-foundation.org, David Sterba <dsterba@suse.com>,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

The pull request you sent on Sun, 22 Mar 2020 17:37:40 +0100:

> git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-5.6-rc6-tag

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/67d584e33e54c3f33c8541928aa7115388c97433

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
