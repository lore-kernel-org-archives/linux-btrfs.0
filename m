Return-Path: <SRS0=UWtY=4X=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8C44C10F25
	for <linux-btrfs@archiver.kernel.org>; Fri,  6 Mar 2020 21:00:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AC74C2070E
	for <linux-btrfs@archiver.kernel.org>; Fri,  6 Mar 2020 21:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1583528409;
	bh=0bQBUC30ukVWBt3o8n3o6kg3sYFkiEpbVf1bt28fNeM=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:List-ID:From;
	b=M8zfm2tAoNf5Dii4HQQ6nRiaQKFYHFka5fgx0+YT9qkdOH7v7YMvtSCk70sEiJWW+
	 6uKmoViVU25CQmtPY7THcL84GnHFVjDQyi0qdFIxt7Lz4UQCKmmQcSAt3G9Yx+g9r9
	 5oLnlRuM+WgZKRZNjZUNJQ3swJJ+xTDNZnDOkYAE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726635AbgCFVAH (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 6 Mar 2020 16:00:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:48680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726185AbgCFVAG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 6 Mar 2020 16:00:06 -0500
Subject: Re: [GIT PULL] Btrfs fix for 5.6-rc5
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583528406;
        bh=0bQBUC30ukVWBt3o8n3o6kg3sYFkiEpbVf1bt28fNeM=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=gqCk8Wj3UEqkvRNV4EuNKjCGsdrunzQcaw3A9QRwH2jVESYWUkRhtUj0aaKYM1c7s
         2OJa+kD21NZq6kkbRj81kX4CIl+MCF8jjoxnIjAMC0GCNJoIdr1pmDfCKBEkBAOiuh
         ELWnVyRTyqbxOZdmjpzn8Chq83SXaRZN+oSdNtYY=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <cover.1583514264.git.dsterba@suse.com>
References: <cover.1583514264.git.dsterba@suse.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <cover.1583514264.git.dsterba@suse.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-5.6-rc4-tag
X-PR-Tracked-Commit-Id: e7a04894c766daa4248cb736efee93550f2d5872
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 30fe0d07fd7b27d41d9b31a224052cc4e910947a
Message-Id: <158352840641.8472.10740926899785889939.pr-tracker-bot@kernel.org>
Date:   Fri, 06 Mar 2020 21:00:06 +0000
To:     David Sterba <dsterba@suse.com>
Cc:     torvalds@linux-foundation.org, David Sterba <dsterba@suse.com>,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

The pull request you sent on Fri,  6 Mar 2020 18:29:47 +0100:

> git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-5.6-rc4-tag

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/30fe0d07fd7b27d41d9b31a224052cc4e910947a

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
