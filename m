Return-Path: <SRS0=sbT/=2Y=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E61CC3F68F
	for <linux-btrfs@archiver.kernel.org>; Fri,  3 Jan 2020 20:40:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 50D2E22314
	for <linux-btrfs@archiver.kernel.org>; Fri,  3 Jan 2020 20:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1578084012;
	bh=jKRYsk8UKiOHI8sLwzjoUdnnNVWzuyHVZHGQI8Pje6s=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:List-ID:From;
	b=dRK/boxAo4Yxj4iLQVn+HKnPohEXBAKwdhmkShOeLU2X0/+bInFHjOSQK0EUoPW22
	 GB/4pQ7iZrrUa2dvI86apFg5wredP6EjjcqplgO6oKYFhZlCUeBVUAF16JY62odPfN
	 8eLu+8jMTh+LWZyQPBz0R4dO6728LQrTs9LTXwsI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728456AbgACUkI (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 3 Jan 2020 15:40:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:37392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727400AbgACUkH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 3 Jan 2020 15:40:07 -0500
Subject: Re: [GIT PULL] Btrfs fixes for 5.5-rc5
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578084007;
        bh=jKRYsk8UKiOHI8sLwzjoUdnnNVWzuyHVZHGQI8Pje6s=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=G3S+rMtdnBBsCHdgt7GB/gxYfEhFjcrnVpzHlubIlKcZx1e2rDmAI9+Z/FLCGDikz
         70RdDSH7FLHmy0us/PSDMTer98U/xM+28W9lqMSqZDivoMdFPQ2VEBdGGIpPsDWO7S
         RcF0VPAzrQbmO/d+KBSbktDsIe4OkCdPEoDDYAAo=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <cover.1578072747.git.dsterba@suse.com>
References: <cover.1578072747.git.dsterba@suse.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <cover.1578072747.git.dsterba@suse.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-5.5-rc4-tag
X-PR-Tracked-Commit-Id: de7999afedff02c6631feab3ea726a0e8f8c3d40
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 3a562aee727a7bfbb3a37b1aa934118397dad701
Message-Id: <157808400737.14632.3810685075146341152.pr-tracker-bot@kernel.org>
Date:   Fri, 03 Jan 2020 20:40:07 +0000
To:     David Sterba <dsterba@suse.com>
Cc:     torvalds@linux-foundation.org, David Sterba <dsterba@suse.com>,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

The pull request you sent on Fri,  3 Jan 2020 18:43:16 +0100:

> git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-5.5-rc4-tag

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/3a562aee727a7bfbb3a37b1aa934118397dad701

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
