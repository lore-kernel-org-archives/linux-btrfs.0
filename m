Return-Path: <SRS0=nkCz=4L=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B607AC35666
	for <linux-btrfs@archiver.kernel.org>; Sun, 23 Feb 2020 17:50:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8FF8720836
	for <linux-btrfs@archiver.kernel.org>; Sun, 23 Feb 2020 17:50:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1582480221;
	bh=boRzcu6viWvl6eMBhO2UQMw5M2T7pkfbBM/6vzatuY0=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:List-ID:From;
	b=HtJubz/5MEI/pdX49e057tU0diUMqOtgx5LLii59ZqDqUOAIibgIcU2rvoDTBGMrk
	 3V52DO2kwhWZGMZR30qBJ+Dmen5EbXSrV33hcV/a5lPr6rovtwR08FMInG/c/5BzG3
	 GCPwgr7qQAn2V/C5MimmzTg1zyzwP+uWp80htA5A=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727181AbgBWRuP (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 23 Feb 2020 12:50:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:42862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726208AbgBWRuM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 23 Feb 2020 12:50:12 -0500
Subject: Re: [GIT PULL] Btrfs fixes for 5.6-rc3
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582480212;
        bh=boRzcu6viWvl6eMBhO2UQMw5M2T7pkfbBM/6vzatuY0=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=lI76QK4R97sp8gtztDZcabUI7+zfphcrx02tRcg6M7AgwIO+CloSHPJrBwHMgIwVX
         TYZcId5XcEZr+PcOdYBiwtf9clRLi4vSEFzyR+aDV/Lj9JBQa3CkzGPvf2RR3QvGAy
         Xqe75JBq+Rrm6kJn/PslMR7P6npgCHUpZEJB5OzE=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <cover.1582462302.git.dsterba@suse.com>
References: <cover.1582462302.git.dsterba@suse.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <cover.1582462302.git.dsterba@suse.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-5.6-rc2-tag
X-PR-Tracked-Commit-Id: a5ae50dea9111db63d30d700766dd5509602f7ad
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: d2eee25858f246051b49c42c411629c78513e2a8
Message-Id: <158248021206.10261.17046089960721140759.pr-tracker-bot@kernel.org>
Date:   Sun, 23 Feb 2020 17:50:12 +0000
To:     David Sterba <dsterba@suse.com>
Cc:     torvalds@linux-foundation.org, David Sterba <dsterba@suse.com>,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

The pull request you sent on Sun, 23 Feb 2020 14:36:29 +0100:

> git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-5.6-rc2-tag

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/d2eee25858f246051b49c42c411629c78513e2a8

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
