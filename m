Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail02.iobjects.de ([188.40.134.68]:52387 "EHLO
	mail02.iobjects.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754273AbcARKwb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 18 Jan 2016 05:52:31 -0500
Subject: Re: [GIT PULL] Btrfs
To: Martin Steigerwald <martin@lichtvoll.de>
References: <20160117233033.aowuldoul2cfuaad@floor.thefacebook.com>
 <3289863.t1Fo0U0Yqz@merkaba>
Cc: Btrfs mailing list <linux-btrfs@vger.kernel.org>
From: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?=
	<holger.hoffstaette@googlemail.com>
Message-ID: <569CC3ED.50108@googlemail.com>
Date: Mon, 18 Jan 2016 11:52:29 +0100
MIME-Version: 1.0
In-Reply-To: <3289863.t1Fo0U0Yqz@merkaba>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

(trimmed cc:)

On 01/18/16 11:25, Martin Steigerwald wrote:
> Chris,
> 
> Am Sonntag, 17. Januar 2016, 18:30:34 CET schrieb Chris Mason:
>> For very large filesystems (30T+) our existing free space caching code
>> can end up taking a huge amount of time during commits.  The new tree
>> based code is faster and less work overall to update as the commit
>> progresses.
> 
> Will be interesting to see whether this also helps with:
> 
> [Bug 90401] New: btrfs kworker thread uses up 100% of a Sandybridge core for 
> minutes on random write into big file

Unlikely, because the fst addresses something entirely different. It's much
more likely that whatever CPU spinning was going on there was addressed by
Josef's allocator fixes in 4.4 [1], which removed a lot of looping and
unnecessary/repeated work.

-h

[1] https://git.kernel.org/cgit/linux/kernel/git/mason/linux-btrfs.git/log/?h=for-linus-4.4&ofs=50

