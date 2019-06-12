Return-Path: <SRS0=509H=UL=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	T_DKIMWL_WL_HIGH autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73594C31E44
	for <linux-btrfs@archiver.kernel.org>; Wed, 12 Jun 2019 01:55:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4DCDE20896
	for <linux-btrfs@archiver.kernel.org>; Wed, 12 Jun 2019 01:55:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1560304528;
	bh=IH2n/rNr1mNHaQl1eZb628HBD5FQEExCtCUPXnWNU0U=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:List-ID:From;
	b=ajKEQd8kSKNP6qnhUOILNctpo0MUhObU9ZjceB8bpgU/h0Da/TyIk/4K4zdpKSmK7
	 SU14yySKQE7j6MBLqwvpTZs5TK9JDaJ52UDH1gWbI+V9iw4MfKoTIcqbyyhe48hMMt
	 kszAQ6QuoPdp+lJ6aLUMeETmLa94pU+jpu0bEOlQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406637AbfFLBzL (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 11 Jun 2019 21:55:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:52020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404091AbfFLBzL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 11 Jun 2019 21:55:11 -0400
Subject: Re: [GIT PULL] Btrfs fix for 5.2-rc5
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560304510;
        bh=IH2n/rNr1mNHaQl1eZb628HBD5FQEExCtCUPXnWNU0U=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=Ad/LBcVo4xSD3yQM7qrV8GHflqQhcSG0wjZ2DYjfOI2QAeMCH5xZtoMiVib4ryAQo
         wNPKEwGPFC5fd/F6lU5tHojHjfpqMNWQXKNOb0YLmN4TvbVCn324b8XWBJZC4+URjk
         JcGQOti5lRMwq4yogYG7St9DJtnTkSB9WvNmeSx0=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <cover.1560268545.git.dsterba@suse.com>
References: <cover.1560268545.git.dsterba@suse.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <cover.1560268545.git.dsterba@suse.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-5.2-rc4-tag
X-PR-Tracked-Commit-Id: 8103d10b71610aa65a65d6611cd3ad3f3bd7beeb
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 6fa425a2651515f8d262f2c1d972c6632e7c941d
Message-Id: <156030451057.13515.14003261403956431603.pr-tracker-bot@kernel.org>
Date:   Wed, 12 Jun 2019 01:55:10 +0000
To:     David Sterba <dsterba@suse.com>
Cc:     torvalds@linux-foundation.org, David Sterba <dsterba@suse.com>,
        clm@fb.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

The pull request you sent on Tue, 11 Jun 2019 18:16:28 +0200:

> git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-5.2-rc4-tag

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/6fa425a2651515f8d262f2c1d972c6632e7c941d

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
