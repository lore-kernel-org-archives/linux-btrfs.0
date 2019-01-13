Return-Path: <SRS0=FrL0=PV=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E848AC43444
	for <linux-btrfs@archiver.kernel.org>; Sun, 13 Jan 2019 18:05:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BE60A2064C
	for <linux-btrfs@archiver.kernel.org>; Sun, 13 Jan 2019 18:05:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1547402708;
	bh=7M/NuIdZQRu0d6BMk4bbJhV4x0KWouHhCRBcf51m/GA=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:List-ID:From;
	b=DMDfUqXq12kdTuhCA6mBvRKQkyVSIFFivjGBYEQG2K+/vguw6bAyqg1t1DjdqfLBr
	 IXIE5c+VijRsdzThP3bbiiYNhlfarfjgd8Z+easuhneASWqU8GDMylMUVInOFnlvb8
	 H53E4FlIdxakxk3q4v7GQuLM5QhoFLSQv6YlcEuU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726618AbfAMSFE (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 13 Jan 2019 13:05:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:34418 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726564AbfAMSFD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 13 Jan 2019 13:05:03 -0500
Subject: Re: [GIT PULL] Btrfs fixes for 5.0-rc2
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1547402703;
        bh=7M/NuIdZQRu0d6BMk4bbJhV4x0KWouHhCRBcf51m/GA=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=xV+6Y1MgsOb4hB8MG1o9Ty18NDfF82n7+Jo4IFPfOs+upDhIlQHHWAThQTRuV5K1D
         yqhmm+n6CGgesQvAwdoQptiFZRSy1eFfXJIeDkEqwM18TzvkV3VcJgVuH2csFDTspX
         uKA/fkNwhgAMNLQilVnwbAx+3/Lsus9Te6Shxi1s=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <cover.1547396230.git.dsterba@suse.com>
References: <cover.1547396230.git.dsterba@suse.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <cover.1547396230.git.dsterba@suse.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-5.0-rc1-tag
X-PR-Tracked-Commit-Id: 1b3922a8bc74231f9a767d1be6d9a061a4d4eeab
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 6b529fb0a3eabf9c4cc3e94c11477250379ce6d8
Message-Id: <154740270304.11831.13395155439302946150.pr-tracker-bot@kernel.org>
Date:   Sun, 13 Jan 2019 18:05:03 +0000
To:     David Sterba <dsterba@suse.com>
Cc:     torvalds@linux-foundation.org, clm@fb.com,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

The pull request you sent on Sun, 13 Jan 2019 17:39:38 +0100:

> git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-5.0-rc1-tag

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/6b529fb0a3eabf9c4cc3e94c11477250379ce6d8

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
