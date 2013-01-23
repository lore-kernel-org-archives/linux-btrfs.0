Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from eithel.gem.pl ([85.232.225.132]:65221 "EHLO eithel.gem.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755159Ab3AWL35 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Jan 2013 06:29:57 -0500
Message-ID: <50FFC9B8.1020605@adocean-global.com>
Date: Wed, 23 Jan 2013 12:30:00 +0100
From: Piotr Nowojski <piotr.nowojski@adocean-global.com>
MIME-Version: 1.0
To: Zach Brown <zab@zabbo.net>
CC: linux-btrfs@vger.kernel.org
Subject: Re: BTRFS deadlock (btrfs_join_transaction?)
References: <50FEC3B5.1040100@adocean-global.com> <20130122195154.GB14246@lenny.home.zabbo.net>
In-Reply-To: <20130122195154.GB14246@lenny.home.zabbo.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

W dniu 22.01.2013 20:51, Zach Brown pisze:
> It doesn't look like there's any easy answers in the code: no unbalanced
> lock and unlocks and nothing scary done while holding the lock.  (Some
> list traversal, but the traces don't show another cpu stuck spinning on
> a corrupt list).
>
> If I had to guess, I'd guess that the lock got corrupted somehow.  Maybe
> a race that has delayed work run on a freed structure.
>
> Would it be possible to enable some debugging options in the kernel
> you're building?   DEBUG_LIST, DEBUG_SPINLOCK, and the various lockdep
> options (DEBUG_LOCKDEP, PROVE_LOCKING) might raise an alarm that would
> shed some light.  Hopefully they wouldn't be unusably slow.
>
> - z
We will try to give it a shot. But it might be hard to reproduce. This 
problem occurred only once, after one week of very heavy (over)stress 
tests. Is it at least possible to confirm, that this is definitely the 
BTRFS problem?

Piotr
