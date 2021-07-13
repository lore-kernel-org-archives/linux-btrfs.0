Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8193FC07E95
	for <linux-btrfs@archiver.kernel.org>; Tue, 13 Jul 2021 19:17:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5107861248
	for <linux-btrfs@archiver.kernel.org>; Tue, 13 Jul 2021 19:17:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234548AbhGMTUJ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 13 Jul 2021 15:20:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:39772 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230145AbhGMTUI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 13 Jul 2021 15:20:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 45FAB60698;
        Tue, 13 Jul 2021 19:17:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626203838;
        bh=7vddfjlGonuPFMn0IkFfj8i0W+b3DAFYixis0GMBeYs=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=Avvuz8jpRx8vdEalxVFYJ+8s+KOHNIJdScTcn4Bw22NvloVNEvrai9iR6Q8jeRLY7
         VTXvxnAOF5IGcjhL9p7JD+0QIDEI16qjukjhPmwfny1ypkkW/cXgpxeaP+69OCcvct
         l/A2Jc+cGuIhDKbxLpKmNxhcCEnhm5Eszr1LoCfuVIgsbPkM8NgE4Xr8S8mLVwlRPE
         TyRTjOLGtyTCzzsYPGEheY1WHqr+MccBQJj//DARFE8QoPkM6fGYK/flxk781xQdaP
         xsepR0yLpd0YuoMJHFjpDjjInbb3pkADlgXFgLbC6mume/zNnBsZzVUyWFwZmMczhM
         zO7lxBdI8GyGg==
Subject: Re: [GIT PULL] Btrfs fixes for 5.14-rc2
From:   pr-tracker-bot@kernel.org
In-Reply-To: <cover.1626115408.git.dsterba@suse.com>
References: <cover.1626115408.git.dsterba@suse.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <cover.1626115408.git.dsterba@suse.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-5.14-rc1-tag
X-PR-Tracked-Commit-Id: ea32af47f00a046a1f953370514d6d946efe0152
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: f02bf8578bd8dd400903291ccebc69665adc911c
Message-Id: <162620383814.18788.2485017643354037727.pr-tracker-bot@kernel.org>
Date:   Tue, 13 Jul 2021 19:17:18 +0000
To:     David Sterba <dsterba@suse.com>
Cc:     torvalds@linux-foundation.org, David Sterba <dsterba@suse.com>,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

The pull request you sent on Mon, 12 Jul 2021 21:28:00 +0200:

> git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-5.14-rc1-tag

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/f02bf8578bd8dd400903291ccebc69665adc911c

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
