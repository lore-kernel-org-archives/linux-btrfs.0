Return-Path: <SRS0=ld6D=XO=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D49DDC4CEC9
	for <linux-btrfs@archiver.kernel.org>; Thu, 19 Sep 2019 01:55:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AB14621927
	for <linux-btrfs@archiver.kernel.org>; Thu, 19 Sep 2019 01:55:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1568858133;
	bh=QJrX8XXLkog0ID2O3CpD1VX61kiER/lSY4sEvp/C8Rg=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:List-ID:From;
	b=G9vBGgGB1Bo3zquRQOMPybUjfN3Nj9uNYpf+3N2bolTPkksD2ySDlwSfXqVZrBEe2
	 Mb9jNYkBqqbI+zfqkSzoF9Lv83FDKS1i58NqfQc9z6LtqqI6WDOh0O/9CnMNThyES0
	 K7+CSqb22Ld9dua8lUyCixguYVK/uRpX4HSLiUg8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388321AbfISBza (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 18 Sep 2019 21:55:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:56426 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387630AbfISBza (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 18 Sep 2019 21:55:30 -0400
Subject: Re: [GIT PULL] Btrfs updates for 5.4
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568858129;
        bh=QJrX8XXLkog0ID2O3CpD1VX61kiER/lSY4sEvp/C8Rg=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=HOWehXWDbUgaTDwziPHUHFIBGLtnKGY9K+y+nNcxr5SMwJgmsiElw2eY2JqDkAZZe
         pPN8p8RO01gcK6jAXNDFD66Q8/UYJyuSmeKN3InC8XrhdW8AodTZaKOjMa5YS++n4u
         WeMFCVBbS2/GLwXuIeWIoqhqL70APUijx3KGOKSM=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <cover.1568631647.git.dsterba@suse.com>
References: <cover.1568631647.git.dsterba@suse.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <cover.1568631647.git.dsterba@suse.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-5.4
X-PR-Tracked-Commit-Id: 6af112b11a4bc1b560f60a618ac9c1dcefe9836e
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 7d14df2d280fb7411eba2eb96682da0683ad97f6
Message-Id: <156885812946.31089.18026209226835825429.pr-tracker-bot@kernel.org>
Date:   Thu, 19 Sep 2019 01:55:29 +0000
To:     David Sterba <dsterba@suse.com>
Cc:     torvalds@linux-foundation.org, David Sterba <dsterba@suse.com>,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

The pull request you sent on Mon, 16 Sep 2019 13:55:05 +0200:

> git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-5.4

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/7d14df2d280fb7411eba2eb96682da0683ad97f6

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
