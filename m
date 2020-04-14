Return-Path: <SRS0=PiMA=56=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C49D5C2BB1D
	for <linux-btrfs@archiver.kernel.org>; Tue, 14 Apr 2020 19:24:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A37E620575
	for <linux-btrfs@archiver.kernel.org>; Tue, 14 Apr 2020 19:24:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1586892288;
	bh=Mi6b47e7sZxf4lucQ8ES01EeyQZOSRxAHXiLRU0VwDg=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:List-ID:From;
	b=oqryTuMMEtYGsUQzHcHfyfBreqGlaD6dvIgDFVwRx5Qe/O8JZz/KFUfWIKUSiNOhM
	 C8rZ4B4tvJzsagSzf4ju0nKWJmi2IBoeTCLl++OCZGzTNq/fmx5jcq0jZgVlWHySIO
	 hhlT9Je/7sSy/1QzmNTdDwbMlo4QrfOZ+vLTnfXE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2504648AbgDNTYe (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 14 Apr 2020 15:24:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:33970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2504638AbgDNTYU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 14 Apr 2020 15:24:20 -0400
Subject: Re: [GIT PULL] Btrfs fixes for 5.7-rc2
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586891123;
        bh=Mi6b47e7sZxf4lucQ8ES01EeyQZOSRxAHXiLRU0VwDg=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=IN4H6DoD4MgQSG7CApDYBhwspxleLmWgsm6N3H3bGJEZX5lr+v9/ifDqmDzxlwy5y
         lUbFRG0wmIQwQjjwXeDUW8qdTB5nsFzqfMpL5u9NE48gWNgLZ1LOiMckYudtLLvVqu
         hmOoJeVbqtnqx2BiYEfA2gefveLIfd1m2TyoV840=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <cover.1586868872.git.dsterba@suse.com>
References: <cover.1586868872.git.dsterba@suse.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <cover.1586868872.git.dsterba@suse.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-5.7-rc1-tag
X-PR-Tracked-Commit-Id: 34c51814b2b87cb2e5a98c92fe957db2ee8e27f4
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 6cc9306b8fc03019e81e4f10c93ff0528cba5217
Message-Id: <158689112373.29674.16323985983606188540.pr-tracker-bot@kernel.org>
Date:   Tue, 14 Apr 2020 19:05:23 +0000
To:     David Sterba <dsterba@suse.com>
Cc:     torvalds@linux-foundation.org, David Sterba <dsterba@suse.com>,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

The pull request you sent on Tue, 14 Apr 2020 15:59:45 +0200:

> git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-5.7-rc1-tag

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/6cc9306b8fc03019e81e4f10c93ff0528cba5217

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
