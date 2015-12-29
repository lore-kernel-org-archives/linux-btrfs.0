Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f177.google.com ([209.85.223.177]:35470 "EHLO
	mail-io0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753704AbbL2VdX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Dec 2015 16:33:23 -0500
Received: by mail-io0-f177.google.com with SMTP id 77so28016967ioc.2
        for <linux-btrfs@vger.kernel.org>; Tue, 29 Dec 2015 13:33:22 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <56796FCB.5080303@gmail.com>
References: <CAJCQCtSQUu8c-eG01tJwwUzC9jONuuaVRTpyLLDCK-gwEE6hUg@mail.gmail.com>
	<566E584B.5040104@cn.fujitsu.com>
	<CAJCQCtRzQ=9NbaaajPuoP2KOCvOd_rFT6P990aU=-EOo8dKS1A@mail.gmail.com>
	<566E77FA.3050405@cn.fujitsu.com>
	<CAJCQCtR7B7h0+CKdpRT2KuZP-Bdzv3j0zPWD6s5MMMs7apTCOg@mail.gmail.com>
	<CAJCQCtSEx_wYPkfazik0bcpQwXxJCA=O5f0o6RbxON4jjB4q7A@mail.gmail.com>
	<5677592F.5000202@cn.fujitsu.com>
	<CAJCQCtRyCxiAKDuyX-F_5Kmn8Xq+RruEo=H-S32FJPr_=b33TA@mail.gmail.com>
	<567762A3.9060007@cn.fujitsu.com>
	<20151222020529.1ac0c913@jupiter.sol.kaishome.de>
	<5678A5CC.7050900@cn.fujitsu.com>
	<20151222024804.5c4f7da2@jupiter.sol.kaishome.de>
	<pan$30f15$f6f8b13b$d72dd248$aaee075f@cox.net>
	<56796FCB.5080303@gmail.com>
Date: Tue, 29 Dec 2015 14:33:22 -0700
Message-ID: <CAJCQCtRpAJ_-qndq7T0V2CHmF5cwqhnMcf9K9Y+D0+H58OvLwg@mail.gmail.com>
Subject: Re: btrfs check inconsistency with raid1, part 1
From: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
To: unlisted-recipients:; (no To-header on input)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Latest update on this thread. btrfs check (4.3.1) reports no problems.
Volume mounts with kernel 4.2.8 with no errors. And I just did a scrub
and there were no errors, not even any fix up messages. And dev stats
are all zero.

So... it appears it was a minor enough problem, and still consistent
enough, that it fixed itself. Granted, there was no writing occurring
at the time, just heavy reading, or perhaps this would be a different
story.


Chris Murphy
