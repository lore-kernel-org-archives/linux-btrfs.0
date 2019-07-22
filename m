Return-Path: <SRS0=nkuV=VT=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC3C3C76194
	for <linux-btrfs@archiver.kernel.org>; Mon, 22 Jul 2019 16:40:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7F59421911
	for <linux-btrfs@archiver.kernel.org>; Mon, 22 Jul 2019 16:40:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1563813641;
	bh=zs5i9OM5loAP7/IoeXJmSgLs5f0QPzFOUn4oKcdnsPg=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:List-ID:From;
	b=SjfWS/wpqZH4inZeGWE07EvsxqyqOmboMJJPP9hbFE6FChVfiFQnqNJfsKsoQlGQP
	 6uKp94P9k8sO3Qib3Fuiqa19C/uxBsXOSPe8recAJ+5P/ulf/JlRGsYkVwUvXcNITi
	 f1Qt3j5q2LCfONLflNNFDExt0Wgf34piwmOKz5GA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731068AbfGVQk1 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 22 Jul 2019 12:40:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:47870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731057AbfGVQk0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 22 Jul 2019 12:40:26 -0400
Subject: Re: [GIT PULL] Btrfs fixes for 5.3-rc2
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563813625;
        bh=zs5i9OM5loAP7/IoeXJmSgLs5f0QPzFOUn4oKcdnsPg=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=L5jwqnET514zCB1mGRbXPGvfmkmlht46qQ2Fb+S5aDW5gszlzVKn4i57Zh1QgxN03
         joRyJ10rqPoXAwnrX9ZAdzKvSW7hDp+WI/dXcVkC3N+bc/AycFbe8DYrTMCPhkMS78
         qHbxacP9hK+0nIryF7JDGW9zXEbn22mzRcepQu9I=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <cover.1563797135.git.dsterba@suse.com>
References: <cover.1563797135.git.dsterba@suse.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <cover.1563797135.git.dsterba@suse.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-5.3-rc1-tag
X-PR-Tracked-Commit-Id: 373c3b80e459cb57c34381b928588a3794eb5bbd
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 21c730d7347126886c40453feb973161f4ae3fb3
Message-Id: <156381362502.340.7908822855033800675.pr-tracker-bot@kernel.org>
Date:   Mon, 22 Jul 2019 16:40:25 +0000
To:     David Sterba <dsterba@suse.com>
Cc:     torvalds@linux-foundation.org, David Sterba <dsterba@suse.com>,
        clm@fb.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

The pull request you sent on Mon, 22 Jul 2019 14:18:08 +0200:

> git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-5.3-rc1-tag

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/21c730d7347126886c40453feb973161f4ae3fb3

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
