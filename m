Return-Path: <linux-btrfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E85CAC64EC4
	for <linux-btrfs@archiver.kernel.org>; Fri, 10 Mar 2023 17:02:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231843AbjCJRCM (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 10 Mar 2023 12:02:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231859AbjCJRBw (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 10 Mar 2023 12:01:52 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EC1654CA6;
        Fri, 10 Mar 2023 08:59:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 635D461B4E;
        Fri, 10 Mar 2023 16:58:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C5923C433A1;
        Fri, 10 Mar 2023 16:58:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678467490;
        bh=wjm9Zwyt3IPMh+k/cYuQlk7EXtI90C7Hb/fZrsoCbXs=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=uXHZnqzrKGQVBu4+TsE44yGNZ4MS8P8uU1DSYG8RPYvfPmNmdp8Sv/Aj4215aoaAG
         kLdIdn08U2SSRvhOGDh/duqB/IKUKs6yXp0ByRlf0IJpTyIXKR32I9HgsrGv+CDJyw
         uDgF4LnmZz+E9W8ierXoqDpoXvo5+mZ4FU3QjPnM9LNc3tpWQpvEiLm9dw4D1jOwF4
         o1Ks9xVmDEfmr6LGk0QJIebVXFQPyEU9olTi+/pwY+g6XybWdENVMC9xsucCWv2+NN
         cuJrZamuLpq4YZMctkgPqTZDLS/57X+zeYY2wMbJom8A2FQ24WanIq/EsmAUTDrKjT
         uOLkRCc5rPIRA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id AF77AC59A4C;
        Fri, 10 Mar 2023 16:58:10 +0000 (UTC)
Subject: Re: [GIT PULL] Btrfs fixes for 6.3-rc2
From:   pr-tracker-bot@kernel.org
In-Reply-To: <cover.1678398321.git.dsterba@suse.com>
References: <cover.1678398321.git.dsterba@suse.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <cover.1678398321.git.dsterba@suse.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-6.3-rc1-tag
X-PR-Tracked-Commit-Id: 675dfe1223a69e270b3d52cb0211c8a501455cec
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: ae195ca1a8a4af75073e82c485148897c923f88f
Message-Id: <167846749071.19444.8725150548225147277.pr-tracker-bot@kernel.org>
Date:   Fri, 10 Mar 2023 16:58:10 +0000
To:     David Sterba <dsterba@suse.com>
Cc:     torvalds@linux-foundation.org, David Sterba <dsterba@suse.com>,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

The pull request you sent on Fri, 10 Mar 2023 00:04:07 +0100:

> git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-6.3-rc1-tag

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/ae195ca1a8a4af75073e82c485148897c923f88f

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
