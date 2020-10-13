Return-Path: <SRS0=7yWS=DU=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B761DC433DF
	for <linux-btrfs@archiver.kernel.org>; Tue, 13 Oct 2020 16:24:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8261B252AF
	for <linux-btrfs@archiver.kernel.org>; Tue, 13 Oct 2020 16:24:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602606268;
	bh=KWAzpjmi9l7B0c4W5/JaRhuvdkK4DnAmvRgfkjSSJm8=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:List-ID:From;
	b=mQTinwwjdMym5zf7Y4MmTTEdcxb+yNZIdNIp6gPVA+apKQZhVJavrf2jHhi+KWqrh
	 +3FxtgNozqh4A4A37Ozmc/pVj/lUDiAx//gs5LRoEDocQY96XLiGhBIy4pBASSZnTx
	 4IEpmP66lycJMC6Kv/d/G5zhfOCKXEC/6h8HjQRA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389725AbgJMQYE (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 13 Oct 2020 12:24:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:49280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389679AbgJMQYE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 13 Oct 2020 12:24:04 -0400
Subject: Re: [GIT PULL] Btrfs updates for 5.10
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602606244;
        bh=KWAzpjmi9l7B0c4W5/JaRhuvdkK4DnAmvRgfkjSSJm8=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=hSOLxh093RVv+JyWQTgNOj31ryVZWyhutkTh2g/MgU/DU8PwrrlRFfi6OazXKU21R
         2MFCDxzOyYc0jy85HsmPzKR5rSBeJzBdGcKTSF1gqu6SAZGEoCdWQ2cwt631ulngj9
         YG0YwZbPOK0svrDwnB7DG/uYiP6dIB/WXBw0uBgs=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <cover.1602519695.git.dsterba@suse.com>
References: <cover.1602519695.git.dsterba@suse.com>
X-PR-Tracked-List-Id: <linux-btrfs.vger.kernel.org>
X-PR-Tracked-Message-Id: <cover.1602519695.git.dsterba@suse.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-5.10-tag
X-PR-Tracked-Commit-Id: 1fd4033dd011a3525bacddf37ab9eac425d25c4f
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 11e3235b4399f7e626caa791a68a0ea8337f6683
Message-Id: <160260624422.24492.10394506834366879321.pr-tracker-bot@kernel.org>
Date:   Tue, 13 Oct 2020 16:24:04 +0000
To:     David Sterba <dsterba@suse.com>
Cc:     torvalds@linux-foundation.org, David Sterba <dsterba@suse.com>,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

The pull request you sent on Mon, 12 Oct 2020 22:25:02 +0200:

> git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-5.10-tag

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/11e3235b4399f7e626caa791a68a0ea8337f6683

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
