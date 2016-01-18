Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:50509 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753977AbcARKZ7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 18 Jan 2016 05:25:59 -0500
From: Martin Steigerwald <martin@lichtvoll.de>
To: Chris Mason <clm@fb.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Btrfs mailing list <linux-btrfs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] Btrfs
Date: Mon, 18 Jan 2016 11:25:57 +0100
Message-ID: <3289863.t1Fo0U0Yqz@merkaba>
In-Reply-To: <20160117233033.aowuldoul2cfuaad@floor.thefacebook.com>
References: <20160117233033.aowuldoul2cfuaad@floor.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris,

Am Sonntag, 17. Januar 2016, 18:30:34 CET schrieb Chris Mason:
> For very large filesystems (30T+) our existing free space caching code
> can end up taking a huge amount of time during commits.  The new tree
> based code is faster and less work overall to update as the commit
> progresses.

Will be interesting to see whether this also helps with:

[Bug 90401] New: btrfs kworker thread uses up 100% of a Sandybridge core for 
minutes on random write into big file

https://bugzilla.kernel.org/show_bug.cgi?id=90401

Thanks,
-- 
Martin
