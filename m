Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98EDEC433ED
	for <linux-btrfs@archiver.kernel.org>; Tue, 11 May 2021 17:37:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6205361378
	for <linux-btrfs@archiver.kernel.org>; Tue, 11 May 2021 17:37:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231703AbhEKRi3 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 11 May 2021 13:38:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:55264 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231792AbhEKRi0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 11 May 2021 13:38:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 801BB61363;
        Tue, 11 May 2021 17:37:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620754639;
        bh=/1lTATtXyXK31jqvCZp0uuL9QQqjJfsdoD5qI7C6Dmg=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=VGs2ozhSzG/tCIqDQM7dFYsw3AVfBNByKPBcR58JMlfjtL05pjseGM1kluxxhZw//
         q8xuFTR4HqBCZrMMVLLIATXVHUSF9ooN4MV+2FcxhfHAH0x2s9ba4YJu+djgXZUVEY
         pEw15TZeLc1YD5gnA2qqZkG9/Mo6nwaXCye3HJ0PJBHDPHRlfm/xp9htkO6Prx6IJX
         29wXavfGVfK0pvPlnbgbkynSoMYV73w7ejMTJzq/9dYqXuNMTw0NxqZvGmo99LJDsF
         J5znEWACMA/rdFy6uUjMxiKM6OS0mJoDuzuEmX4iar3clRUEbQRYRvz4iKn6vHELMe
         jRn1g9rHuB5+g==
Subject: Re: [GIT PULL] Btrfs fix for 5.13-rc2, part 2
From:   pr-tracker-bot@kernel.org
In-Reply-To: <cover.1620740882.git.dsterba@suse.com>
References: <cover.1620740882.git.dsterba@suse.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <cover.1620740882.git.dsterba@suse.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-5.13-rc1-part2-tag
X-PR-Tracked-Commit-Id: 9b8a233bc294dd71d3c7d30692a78ab32f246a0f
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 88b06399c9c766c283e070b022b5ceafa4f63f19
Message-Id: <162075463936.31015.4668712531274943344.pr-tracker-bot@kernel.org>
Date:   Tue, 11 May 2021 17:37:19 +0000
To:     David Sterba <dsterba@suse.com>
Cc:     torvalds@linux-foundation.org, David Sterba <dsterba@suse.com>,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

The pull request you sent on Tue, 11 May 2021 15:57:55 +0200:

> git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-5.13-rc1-part2-tag

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/88b06399c9c766c283e070b022b5ceafa4f63f19

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
