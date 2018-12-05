Return-Path: <SRS0=6XAY=OO=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,
	UNWANTED_LANGUAGE_BODY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C8B6C04EB9
	for <linux-btrfs@archiver.kernel.org>; Wed,  5 Dec 2018 18:20:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 255FD20879
	for <linux-btrfs@archiver.kernel.org>; Wed,  5 Dec 2018 18:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1544034016;
	bh=6CvRJN6Uso0KeyCBv319tDFww1hp8wn1jstF2b/gNeg=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:List-ID:From;
	b=suoVUzmugO0yQSRL1xdADRluGhDhrLobxDkFJokHtE5/MoP9bOmN2gsat7y2WRDEV
	 3Rgo6JOWailjhrLhszRAmiyD9/F/nzjPW0D71kDRKofDftpaQAoTIoTL0ZkR8+NVJv
	 FDXrrC1LmWd1YB6b1So9IhJqmKYKB2exOeAp4O6g=
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 255FD20879
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728338AbeLESUP (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 5 Dec 2018 13:20:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:48222 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728185AbeLESUE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 5 Dec 2018 13:20:04 -0500
Subject: Re: [GIT PULL] Btrfs fix for 4.20-rc5
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1544034003;
        bh=6CvRJN6Uso0KeyCBv319tDFww1hp8wn1jstF2b/gNeg=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=2vvxxI/ftLui9++mNNmCDnwAw+h/GoSSIEXVMF2Sg3jxwwH5tH5BSY30tLWHB9kvL
         hRaJfenpq/AuiUYACiDNzh7Em3tFhyNYToK3JWlr2OR0mCbOyNRx4JBkMlACug+xhd
         ybQegqvNlHXY3j/L5WJ6b5mQW+2uIdi8SI9RHW9g=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <cover.1544016523.git.dsterba@suse.com>
References: <cover.1544016523.git.dsterba@suse.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <cover.1544016523.git.dsterba@suse.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git
 for-4.20-rc5-tag
X-PR-Tracked-Commit-Id: 10950929e994c5ecee149ff0873388d3c98f12b5
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: d0897090458211f9c6b2d7f5af87f4d3b0403f69
Message-Id: <20181205182003.5826.70297.pr-tracker-bot@pdx-korg-gitolite-1.ci.codeaurora.org>
Date:   Wed, 05 Dec 2018 18:20:03 +0000
To:     David Sterba <dsterba@suse.com>
Cc:     torvalds@linux-foundation.org, David Sterba <dsterba@suse.com>,
        clm@fb.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

The pull request you sent on Wed,  5 Dec 2018 14:34:01 +0100:

> git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-4.20-rc5-tag

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/d0897090458211f9c6b2d7f5af87f4d3b0403f69

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
