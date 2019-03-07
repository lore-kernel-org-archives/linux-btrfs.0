Return-Path: <SRS0=nVQC=RK=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4746AC43381
	for <linux-btrfs@archiver.kernel.org>; Thu,  7 Mar 2019 17:50:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 17D1020661
	for <linux-btrfs@archiver.kernel.org>; Thu,  7 Mar 2019 17:50:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1551981024;
	bh=9WBs2yys3VCn0eHmlnSk7hVl9LjYIIA68eEdDzhrrn0=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:List-ID:From;
	b=2H9TGyg+v+wiJvqphUxQt93mCBsofZax88zIIDE87D+uELcX55cFrR3qi1IUvc6fi
	 /lh0CiYZGslA+ONspsrLVHKvxi7ruh+w+lzcy1G7sLxQk+9qx1x0EiFQvpAMPzolwc
	 wBVuOnsI2ZZjSossNytdvDaq7Zdi7rRKWs/q7CzY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726968AbfCGRuS (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 7 Mar 2019 12:50:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:43758 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726964AbfCGRuR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 7 Mar 2019 12:50:17 -0500
Subject: Re: [GIT PULL] Btrfs updates for 5.1, part 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1551981017;
        bh=9WBs2yys3VCn0eHmlnSk7hVl9LjYIIA68eEdDzhrrn0=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=HkQjU/ax0jxP4ZyQTtkOmEniyHRc0/wc6xsGAkS5EOe4t7NAdhiyqsT+FMzKvspoE
         zU7q2epWxIvgWy4apggWbbwzn4/vG6hiwCv7GUOIBkFfKfb+V+DrfzcNa/9KUQ5Z2s
         EV3kA/30Wd1E1l0b16TIATIbRbjQj4RUl71BR6k4=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <cover.1551726327.git.dsterba@suse.com>
References: <cover.1551726327.git.dsterba@suse.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <cover.1551726327.git.dsterba@suse.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git
 for-5.1-part1-tag
X-PR-Tracked-Commit-Id: f65e25e343cfc0e6f4db9a687c4085fad268325d
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: b1e243957e9b3ba8e820fb8583bdf18e7c737aa2
Message-Id: <155198101734.21542.14503309661735797521.pr-tracker-bot@kernel.org>
Date:   Thu, 07 Mar 2019 17:50:17 +0000
To:     David Sterba <dsterba@suse.com>
Cc:     torvalds@linux-foundation.org, David Sterba <dsterba@suse.com>,
        clm@fb.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

The pull request you sent on Mon,  4 Mar 2019 20:20:53 +0100:

> git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-5.1-part1-tag

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/b1e243957e9b3ba8e820fb8583bdf18e7c737aa2

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
