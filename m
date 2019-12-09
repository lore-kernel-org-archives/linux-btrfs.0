Return-Path: <SRS0=15Oe=Z7=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B543C43603
	for <linux-btrfs@archiver.kernel.org>; Mon,  9 Dec 2019 20:20:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2D75620663
	for <linux-btrfs@archiver.kernel.org>; Mon,  9 Dec 2019 20:20:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1575922834;
	bh=XB+N3nb/WUZ9uLXxdwbQjIQ9OZ0/S9O6TVQIH5ySn1A=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:List-ID:From;
	b=KKDGf+UU8ML7/qk3STKaXC7oSAbGzKjSRE887vewkQLs8Jyciynh7H5hrI5DUzLGj
	 cwtUdfH33CMdghe5l4kbF+8vH8H98L9GBktbJhyioHQSKjMHrhkfDnvpPt7oXQUwsm
	 GUr2k0i4Om6dfHs8/+RzBw4VBuhtABhz3upPd8Zc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726818AbfLIUU1 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 9 Dec 2019 15:20:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:36062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726502AbfLIUU1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 9 Dec 2019 15:20:27 -0500
Subject: Re: [GIT PULL] Btrfs kconfig update for 5.5-rc2
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575922826;
        bh=XB+N3nb/WUZ9uLXxdwbQjIQ9OZ0/S9O6TVQIH5ySn1A=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=UpjWPJlr7kwJfVE5TWyMGABjkn05jsdveaSlXtu8M6lfW1kA3U4ryj6MzePrN5zde
         HNBwOsYRBk8ZswvqEkghogQp0WW691e9glETMwdT7yLbtXZhqKhJ9t3eUonZD5ig+j
         BsI185ajfcrjdVJzH0ja84jGgnlO2oqS9J2eWUks=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <cover.1575911345.git.dsterba@suse.com>
References: <cover.1575911345.git.dsterba@suse.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <cover.1575911345.git.dsterba@suse.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git
 for-5.5-rc1-kconfig
X-PR-Tracked-Commit-Id: 78f926f72e43e4b974f69688593a9b682089e82a
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 6794862a16ef41f753abd75c03a152836e4c8028
Message-Id: <157592282661.794.2839761668961385321.pr-tracker-bot@kernel.org>
Date:   Mon, 09 Dec 2019 20:20:26 +0000
To:     David Sterba <dsterba@suse.com>
Cc:     torvalds@linux-foundation.org, David Sterba <dsterba@suse.com>,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

The pull request you sent on Mon,  9 Dec 2019 18:31:12 +0100:

> git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-5.5-rc1-kconfig

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/6794862a16ef41f753abd75c03a152836e4c8028

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
