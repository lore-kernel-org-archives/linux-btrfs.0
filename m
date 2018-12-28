Return-Path: <SRS0=VlvV=PF=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5ED9EC43444
	for <linux-btrfs@archiver.kernel.org>; Fri, 28 Dec 2018 01:45:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3038B218FE
	for <linux-btrfs@archiver.kernel.org>; Fri, 28 Dec 2018 01:45:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1545961552;
	bh=OXJyQ6XUvORzS8kLuK1G+ATjbBzfoFXky+P40ZRNE5U=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:List-ID:From;
	b=IZqagBqLzAXnPtLv+abNYvVLY+YcEcevrRS3ONMSg+x6v4y90bSjcBQydChJuOMrD
	 SGAmz+0DXFp7v4SDVmQ1+CL0vmQoVO4jcxv4LkF4TzXqpgSXap3lU744kE/URtCeyc
	 nf+ZHTIX6tnU3iI8NVp1LbibRRJlGZE9zpdDl0xs=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731351AbeL1BpD (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 27 Dec 2018 20:45:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:57884 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731349AbeL1BpC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 27 Dec 2018 20:45:02 -0500
Subject: Re: [GIT PULL] Btrfs updates for 4.21
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1545961502;
        bh=OXJyQ6XUvORzS8kLuK1G+ATjbBzfoFXky+P40ZRNE5U=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=QIU+Bv24h/NIG8mVc3INGH4gSNA0Z4uxg/gQlVfy6c7W5zOoYfXuMRLAilyxUQVKW
         PHVY5cXZ7iB3p6r6KvwZ+8K7YZUSyDAHIWZ1jV4WGhxb0xLolGjM3zNiIYdw4SBDWZ
         X/VOMBDi8NfYWyB8v2BQsaQTtc9c3FGc/MSdmvwI=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <cover.1545231616.git.dsterba@suse.com>
References: <cover.1545231616.git.dsterba@suse.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <cover.1545231616.git.dsterba@suse.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-4.21-tag
X-PR-Tracked-Commit-Id: 52042d8e82ff50d40e76a275ac0b97aa663328b0
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 32ee34eddad13cd44ad0cb3e659fe6fd49143b62
Message-Id: <20181228014501.3597.20824.pr-tracker-bot@pdx-korg-gitolite-1.ci.codeaurora.org>
Date:   Fri, 28 Dec 2018 01:45:01 +0000
To:     David Sterba <dsterba@suse.com>
Cc:     torvalds@linux-foundation.org, David Sterba <dsterba@suse.com>,
        clm@fb.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

The pull request you sent on Wed, 19 Dec 2018 16:11:04 +0100:

> git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-4.21-tag

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/32ee34eddad13cd44ad0cb3e659fe6fd49143b62

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
