Return-Path: <SRS0=Obef=3R=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C56CC33CB2
	for <linux-btrfs@archiver.kernel.org>; Tue, 28 Jan 2020 23:40:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E2AE622522
	for <linux-btrfs@archiver.kernel.org>; Tue, 28 Jan 2020 23:40:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1580254814;
	bh=tUhXcy5ta6IIU8tmwDqL/iRBsLFREm3taAO1DytlLAg=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:List-ID:From;
	b=19CLC4rw+ek/1O1vVUSlTvmEq7ePT7HwxbJ3cSl4ZHUqBNyfeNURKyp8+6HnnhUho
	 z1FFnohW9MmHUXqgYMrobD0kMslTLWMLUM4POZZ05JK+XF8VGQw3Nh+lfgh7RtzrXd
	 c2jOkXSJD7yAj1bR50og1P6FCOpCpbhduzi1FN5A=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726808AbgA1XkH (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 28 Jan 2020 18:40:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:49328 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726303AbgA1XkF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 28 Jan 2020 18:40:05 -0500
Subject: Re: [GIT PULL] fs: Deduplication ioctl fix
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580254805;
        bh=tUhXcy5ta6IIU8tmwDqL/iRBsLFREm3taAO1DytlLAg=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=VTFIwDPQnC7wXIFqKXQ6vGoBwhZkGiQeXpxaeZNXgVq4l0p6phULPaVbL882PX82v
         /5HgDrJ0QQpo8DhBBijslnMwaN4BvVzUgk4qSGkrK7rcIC94Yg6xB7BP8UfiVBjple
         gXRq7S3x8BypMYYwv4GwCfqqKwBMaps3Gl7WQiIQ=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <cover.1580142827.git.dsterba@suse.com>
References: <cover.1580142827.git.dsterba@suse.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <cover.1580142827.git.dsterba@suse.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git
 fs-dedupe-last-block-tag
X-PR-Tracked-Commit-Id: 831d2fa25ab8e27592b1b0268dae6f2dfaf7cc43
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: b5f7ab6b1c4ed967fb76258f79251193cb1ad41d
Message-Id: <158025480536.16364.16698686040672279236.pr-tracker-bot@kernel.org>
Date:   Tue, 28 Jan 2020 23:40:05 +0000
To:     David Sterba <dsterba@suse.com>
Cc:     torvalds@linux-foundation.org, David Sterba <dsterba@suse.com>,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Darrick J . Wong" <darrick.wong@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

The pull request you sent on Mon, 27 Jan 2020 18:19:15 +0100:

> git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git fs-dedupe-last-block-tag

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/b5f7ab6b1c4ed967fb76258f79251193cb1ad41d

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
