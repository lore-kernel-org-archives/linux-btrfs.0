Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A2B2C433FE
	for <linux-btrfs@archiver.kernel.org>; Sun,  6 Mar 2022 20:34:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234259AbiCFUfB (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 6 Mar 2022 15:35:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234251AbiCFUfA (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 6 Mar 2022 15:35:00 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 807DA5D5D9;
        Sun,  6 Mar 2022 12:34:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3D9F9B80EBA;
        Sun,  6 Mar 2022 20:34:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0C683C340F7;
        Sun,  6 Mar 2022 20:34:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646598846;
        bh=AHIwRHqsXm5SzHlDYsBD7WNzcpDdaKXXKvTXyzaCa/g=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=D7qzgM7PIByFiHz9FFmXXn+ZruMQF6paRBthCNnTNTRd1rp/ED7Y9lxHjO01rqq4+
         FArNQ2aVB9Y3HCcTvvpsv2uZVu4S31Ol5iQaKu84gzZU2SROdc1h8dysrXmsHrcCWH
         ijGcaYaXDcI4/DSAX43rzkhfSSF2uqsHkCsc+N8BJQbHf73rR2sBKzoLyKvzcVurch
         lmnEyvGdecv4QJGMDUytVmuydRAcyHPJp/7+RMradwQDlbIbqb8OjtzHNm+Yaubtzc
         De5pRv9iawO8ARbNPREzEc2OFc3ZRr3yb4V+8R4kQuOffuoMMIenrTKVH5ujyii9So
         KBsyceMs1rO/A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id EB500E7BB18;
        Sun,  6 Mar 2022 20:34:05 +0000 (UTC)
Subject: Re: [GIT PULL] Btrfs fixes for 5.17-rc7
From:   pr-tracker-bot@kernel.org
In-Reply-To: <cover.1646581845.git.dsterba@suse.com>
References: <cover.1646581845.git.dsterba@suse.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <cover.1646581845.git.dsterba@suse.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-5.17-rc6-tag
X-PR-Tracked-Commit-Id: ca93e44bfb5fd7996b76f0f544999171f647f93b
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 3ee65c0f0778b8fa95381cd7676cde2c03e0f889
Message-Id: <164659884595.14106.16096582682233393574.pr-tracker-bot@kernel.org>
Date:   Sun, 06 Mar 2022 20:34:05 +0000
To:     David Sterba <dsterba@suse.com>
Cc:     torvalds@linux-foundation.org, David Sterba <dsterba@suse.com>,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

The pull request you sent on Sun,  6 Mar 2022 17:32:30 +0100:

> git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-5.17-rc6-tag

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/3ee65c0f0778b8fa95381cd7676cde2c03e0f889

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
