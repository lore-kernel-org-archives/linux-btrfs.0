Return-Path: <SRS0=DOz6=SN=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C09FC10F13
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Apr 2019 21:45:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EB0FC20850
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Apr 2019 21:45:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1555019115;
	bh=5U2nGEc0qkSTIC9K7i5Cg5SZ03Mawkx8Fp0lItJm7qU=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:List-ID:From;
	b=hpgqRgfoaIokJUo8KhixJz1YwKJMCnw4+Lm+3nx0nkf8iFSkluJamV5qcfi7YMPsl
	 jDhq+4HblqeSxf3upfKiN46Q7vaP9ANa3oJmQXRfi0UUZGBxdpdMxBB3B6vvjvlALA
	 gzsznX5P9DuNmEdr9Gc5FcqpKsAtt3m981o3+Iyc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726994AbfDKVpJ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 11 Apr 2019 17:45:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:41326 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726800AbfDKVpH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Apr 2019 17:45:07 -0400
Subject: Re: [GIT PULL] Btrfs fixes for 5.1-rc5
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1555019107;
        bh=5U2nGEc0qkSTIC9K7i5Cg5SZ03Mawkx8Fp0lItJm7qU=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=WFxY4Ys4ykm0ZERCJFJgtKRhebHWLt+t0bZpwqbbbxWodLDRRN7p9v6BGILpOMp1o
         2FiOdcne5Jo7V5d29xVwumbk8zENjCvilr11q5EZK34LoErP3UI3xVS4cgmPdHGtIN
         rbznNFGcsxeiXh/GTso78QV+DNmlRXbbOyNW+5p4=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <cover.1555003647.git.dsterba@suse.com>
References: <cover.1555003647.git.dsterba@suse.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <cover.1555003647.git.dsterba@suse.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-5.1-rc4-tag
X-PR-Tracked-Commit-Id: 272e5326c7837697882ce3162029ba893059b616
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 2d06b235815e6bd20395f3db9ada786a6f7a876e
Message-Id: <155501910694.28368.16482944635811917957.pr-tracker-bot@kernel.org>
Date:   Thu, 11 Apr 2019 21:45:06 +0000
To:     David Sterba <dsterba@suse.com>
Cc:     torvalds@linux-foundation.org, David Sterba <dsterba@suse.com>,
        clm@fb.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

The pull request you sent on Thu, 11 Apr 2019 19:35:13 +0200:

> git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-5.1-rc4-tag

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/2d06b235815e6bd20395f3db9ada786a6f7a876e

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
