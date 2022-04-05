Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1ADCC433FE
	for <linux-btrfs@archiver.kernel.org>; Tue,  5 Apr 2022 21:15:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243956AbiDEVM4 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 5 Apr 2022 17:12:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1457874AbiDEQyG (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 5 Apr 2022 12:54:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 892E5326E9;
        Tue,  5 Apr 2022 09:52:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2276B6187A;
        Tue,  5 Apr 2022 16:52:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7EA34C385A1;
        Tue,  5 Apr 2022 16:52:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649177527;
        bh=Y7Mst8KQiuSlm/hirze6AqU381D0n5oCqAcv5T0uzsQ=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=Rik8keXLhHjTTb9+WfjTpHN7fhIp0W77s2Ye55P9Feqy3C0Z/vHSTWGYV5LHndpRP
         5lI8TxrKifRHSBKPdqGMBqcuHAAZTm67bo9AJ2mlvfoBUNW7VerfVSOmBDisKF1Xpz
         YfToC0IICv4VG2OlrAGOfwbyGXqXvvmD4xEUTDRY4xoe+aPb4CO1OsyOnmaN3aPRe5
         Kl53yE5dpvT2yM8hP+fMCCqY3ndLp8K6RNpahiWIcsqihtEc861vVT2FcUensY1zfL
         QVJZvpzEnq7LQ1iP5yAKDcS1pdWghaS3rYKOXON/afehyEsMA0xhn9fFVoyQPoas0d
         5+QGbGf1SetcA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 67F56E6D402;
        Tue,  5 Apr 2022 16:52:07 +0000 (UTC)
Subject: Re: [GIT PULL] Btrfs fixes for 5.18-rc2
From:   pr-tracker-bot@kernel.org
In-Reply-To: <cover.1649109877.git.dsterba@suse.com>
References: <cover.1649109877.git.dsterba@suse.com>
X-PR-Tracked-List-Id: <linux-btrfs.vger.kernel.org>
X-PR-Tracked-Message-Id: <cover.1649109877.git.dsterba@suse.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-5.18-rc1-tag
X-PR-Tracked-Commit-Id: 60021bd754c6ca0addc6817994f20290a321d8d6
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: ce4c854ee8681bc66c1c369518b6594e93b11ee5
Message-Id: <164917752741.856.4378700460752736894.pr-tracker-bot@kernel.org>
Date:   Tue, 05 Apr 2022 16:52:07 +0000
To:     David Sterba <dsterba@suse.com>
Cc:     torvalds@linux-foundation.org, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

The pull request you sent on Tue, 5 Apr 2022 13:28:27 +0200:

> git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-5.18-rc1-tag

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/ce4c854ee8681bc66c1c369518b6594e93b11ee5

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
