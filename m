Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABE7DC4332F
	for <linux-btrfs@archiver.kernel.org>; Thu,  3 Nov 2022 18:32:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232109AbiKCSco (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 3 Nov 2022 14:32:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232045AbiKCSc2 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 3 Nov 2022 14:32:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FFC113D50;
        Thu,  3 Nov 2022 11:31:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 12315B8299E;
        Thu,  3 Nov 2022 18:31:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B4A37C433D6;
        Thu,  3 Nov 2022 18:31:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667500296;
        bh=FpHm1MYR7+Xrf4rlufJ+Z/ua/U9TLOxrL6WolU1n3go=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=AqbnYAfBEqn9cK8jQYusMa6HYvn5qiQtkq9JLozNnzQ00EwQWc10kslcRhHMk2Anz
         cGxcnp828SP1dIiHM+hnE/7UHqv17jmIGPdambszpkTo2UZ6iABeaoLcIu0plmkH/d
         ajqIFBBtC5X45beQi2yH0Qbdg1TndUgCUJB5Ve8yn9RcDhs655QQvii4xlzoWZsQDW
         Jy+g9U53p2PFNxiHnegTCXDtFjjQeVhivRhBHDUfHo4wAVSf8/xorLaig+U2HhFF4Q
         ovvfMesxwEoYOD8jTk8gwmATQE/Nhz1qJG/8/yUUt/J0NIQm4qJEeEO0I31+Bf2MpD
         Tm42PW12Qog2A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A4726E270E2;
        Thu,  3 Nov 2022 18:31:36 +0000 (UTC)
Subject: Re: [GIT PULL] Btrfs fixes for 6.1-rc4, part 2
From:   pr-tracker-bot@kernel.org
In-Reply-To: <cover.1667488810.git.dsterba@suse.com>
References: <cover.1667488810.git.dsterba@suse.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <cover.1667488810.git.dsterba@suse.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-6.1-rc3-tag
X-PR-Tracked-Commit-Id: eb81b682b131642405a05c627ab08cf0967b3dd8
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: f2f32f8af2b0ca9d619e5183eae3eed431793baf
Message-Id: <166750029666.3912.16897399912605147725.pr-tracker-bot@kernel.org>
Date:   Thu, 03 Nov 2022 18:31:36 +0000
To:     David Sterba <dsterba@suse.com>
Cc:     torvalds@linux-foundation.org, David Sterba <dsterba@suse.com>,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

The pull request you sent on Thu,  3 Nov 2022 16:41:00 +0100:

> git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-6.1-rc3-tag

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/f2f32f8af2b0ca9d619e5183eae3eed431793baf

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
