Return-Path: <SRS0=L0dM=NW=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84334C43441
	for <linux-btrfs@archiver.kernel.org>; Sun, 11 Nov 2018 23:10:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 56D1D20817
	for <linux-btrfs@archiver.kernel.org>; Sun, 11 Nov 2018 23:10:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 56D1D20817
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390353AbeKLJAV (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 12 Nov 2018 04:00:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:50342 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728928AbeKLJAL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 12 Nov 2018 04:00:11 -0500
Subject: Re: [GIT PULL] Btrfs fixes for 4.20-rc1
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6AD6620862
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=fail smtp.mailfrom=pr-tracker-bot@kernel.org
From:   pr-tracker-bot@kernel.org
In-Reply-To: <cover.1541937408.git.dsterba@suse.com>
References: <cover.1541937408.git.dsterba@suse.com>
Message-Id: <20181111231003.12478.46983.pr-tracker-bot-63a42e1a5cb3d01eef2f370c11d8733a32f12f86@pdx-korg-gitolite-1.ci.codeaurora.org>
Date:   Sun, 11 Nov 2018 23:10:03 +0000
To:     David Sterba <dsterba@suse.com>
Cc:     torvalds@linux-foundation.org, David Sterba <dsterba@suse.com>,
        clm@fb.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

The pull request you sent on Sun, 11 Nov 2018 13:10:56 +0100:

> git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-4.20-rc1-tag

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/63a42e1a5cb3d01eef2f370c11d8733a32f12f86

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
