Return-Path: <SRS0=qk6s=AE=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50CA2C433DF
	for <linux-btrfs@archiver.kernel.org>; Tue, 23 Jun 2020 16:50:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2F51E20716
	for <linux-btrfs@archiver.kernel.org>; Tue, 23 Jun 2020 16:50:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1592931025;
	bh=Sd6SjhyVGewNRWiidoTTRQ5tZ9NYamhA0C4eDTLjMkU=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:List-ID:From;
	b=aIktwkYR8WKF0tj/lutQssvqwPqebMTETCsps20CN2ULuGBJqnuH6bmBgOOuPnbyz
	 MuEvLlhPyhSnPMrHi/d2JDM/NrrJDlZPB9wz5NtvKkOTYVvFxkZvom1yALx3I9vYuk
	 6Q5oMU2dK+5rpxfvGZl2Sg+FZ/n7XszY0ovxeUCk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733012AbgFWQuV (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 23 Jun 2020 12:50:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:57820 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732953AbgFWQuV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 23 Jun 2020 12:50:21 -0400
Subject: Re: [GIT PULL] Btrfs fixes for 5.8-rc3
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592931021;
        bh=Sd6SjhyVGewNRWiidoTTRQ5tZ9NYamhA0C4eDTLjMkU=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=XmLc9zP1SStylE8J/3uCJj+ygUrpgOwdWTWlUWO+UbAyh1WFqsxgXQNCjPUTAg8sj
         ZOQRAZODkXmTmKmn1NcpCU9hBfQumte6RB16Noy2wuHR6whXOpnAyamMY+ZJ9DYgJZ
         yol7Ta/s04uUWLwHUlqnt6v39xLXd12dbjVM2qGo=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <cover.1592918083.git.dsterba@suse.com>
References: <cover.1592918083.git.dsterba@suse.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <cover.1592918083.git.dsterba@suse.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-5.8-rc2-tag
X-PR-Tracked-Commit-Id: b091f7fede97cc64f7aaad3eeb37965aebee3082
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 3e08a95294a4fb3702bb3d35ed08028433c37fe6
Message-Id: <159293102113.9844.16810566723336922683.pr-tracker-bot@kernel.org>
Date:   Tue, 23 Jun 2020 16:50:21 +0000
To:     David Sterba <dsterba@suse.com>
Cc:     torvalds@linux-foundation.org, David Sterba <dsterba@suse.com>,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

The pull request you sent on Tue, 23 Jun 2020 15:53:45 +0200:

> git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-5.8-rc2-tag

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/3e08a95294a4fb3702bb3d35ed08028433c37fe6

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
