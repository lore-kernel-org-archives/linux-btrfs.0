Return-Path: <SRS0=kp3V=6R=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA46FC28CBC
	for <linux-btrfs@archiver.kernel.org>; Sun,  3 May 2020 18:35:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 83F72206F0
	for <linux-btrfs@archiver.kernel.org>; Sun,  3 May 2020 18:35:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1588530912;
	bh=BTwl0Y8+VKc741Os+C0DSxED2lISWaGLB8OF40Emuyk=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:List-ID:From;
	b=wpd0JZvCw6iQQjOTHbMXdWM4zSvGz8MOqpxA1EA0v0qtZH1n9LARLtV7jXa7OVsyV
	 IVlyauvoPvzlcP4QmWYKzN4H9Ow4n2EAQd6uy872PriDNlTHroQqihu1Cv9S1PVk56
	 g/FVF8xKd/vj3ucEquYIDj1qkLBsrO2W52vPWXsI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728998AbgECSfJ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 3 May 2020 14:35:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:52830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728863AbgECSfJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 3 May 2020 14:35:09 -0400
Subject: Re: [GIT PULL] Btrfs fixes for 5.7-rc4, part 2
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588530908;
        bh=BTwl0Y8+VKc741Os+C0DSxED2lISWaGLB8OF40Emuyk=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=bAz9YIgKwxqsv+DkbqKSh6NV6Z3Pqyd8H8LnLCSxnpaXPc3ZspkNjX/acsLIkdIzL
         /5IKxsK0GRng52R/aXTDAi4Yoc77CdyV70KR1JDeQo9rIMBbfxKk0QPBr55yRxWdxY
         ZbrK+fSL1OfV9CZc67FWUcRC1PXtEQDsnmnW26rk=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <cover.1588522631.git.dsterba@suse.com>
References: <cover.1588522631.git.dsterba@suse.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <cover.1588522631.git.dsterba@suse.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-5.7-rc3-tag
X-PR-Tracked-Commit-Id: eb91db63a90d8f8e8768b82fcb2cae5f7198cf6b
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 262f7a6b8317a06e7d51befb690f0bca06a473ea
Message-Id: <158853090878.15713.16382357327351730130.pr-tracker-bot@kernel.org>
Date:   Sun, 03 May 2020 18:35:08 +0000
To:     David Sterba <dsterba@suse.com>
Cc:     torvalds@linux-foundation.org, David Sterba <dsterba@suse.com>,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

The pull request you sent on Sun,  3 May 2020 18:25:37 +0200:

> git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-5.7-rc3-tag

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/262f7a6b8317a06e7d51befb690f0bca06a473ea

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
