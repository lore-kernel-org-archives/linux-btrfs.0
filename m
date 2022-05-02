Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F82DC433EF
	for <linux-btrfs@archiver.kernel.org>; Mon,  2 May 2022 19:03:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387027AbiEBTHL (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 2 May 2022 15:07:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387020AbiEBTHK (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 2 May 2022 15:07:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C72D656C;
        Mon,  2 May 2022 12:03:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 40485B819C5;
        Mon,  2 May 2022 19:03:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EB58FC385A4;
        Mon,  2 May 2022 19:03:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651518219;
        bh=4P55vRnvaLVdrO90M4o3p4gCoV215a27VoY7NirbUrk=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=Yv0L4UYdHdArVyTXqraV8WAx0Ed7eARatrWYi+C45/2wGcGXybbVuxFRDmrnuQxt+
         B/2+AymakGR/rIcceLh/5nbi8hJxoFL9ZG15dWMgV07WxS2lolmFZAB4cgeoUOVAv7
         mzxx8dS8LjrrW6WHtiWlrYXFxi8v98Dw6WMCchBkqF+pI+hTHPlh7OJrBfjPE8uvMd
         s9yTVv1csasnq7QD4cnIV3BHvqFKVzA8qabBTRkCzQFjv36kzMsWLC/4dVUgG4WIwR
         vrRuDHGeQvvDUfw9S/HNa5PLvWNqyMsGGT+hS/FiBPFz2TOr1yNzmMi/u+TbVqChv2
         H/bcqG9VuuBZA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D8A5CE8DBDA;
        Mon,  2 May 2022 19:03:38 +0000 (UTC)
Subject: Re: [GIT PULL] Btrfs fixes for 5.18-rc6
From:   pr-tracker-bot@kernel.org
In-Reply-To: <cover.1651509134.git.dsterba@suse.com>
References: <cover.1651509134.git.dsterba@suse.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <cover.1651509134.git.dsterba@suse.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-5.18-rc5-tag
X-PR-Tracked-Commit-Id: 4b73c55fdebd8939f0f6000921075f7f6fa41397
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 9050ba3a61a4b5bd84c2cde092a100404f814f31
Message-Id: <165151821888.9575.5319840983699473794.pr-tracker-bot@kernel.org>
Date:   Mon, 02 May 2022 19:03:38 +0000
To:     David Sterba <dsterba@suse.cz>
Cc:     torvalds@linux-foundation.org, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

The pull request you sent on Mon, 2 May 2022 18:47:39 +0200:

> git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-5.18-rc5-tag

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/9050ba3a61a4b5bd84c2cde092a100404f814f31

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
