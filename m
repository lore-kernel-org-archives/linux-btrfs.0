Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tetsuo.zabbo.net ([50.193.208.193]:37649 "EHLO tetsuo.zabbo.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750852Ab3AWSed (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Jan 2013 13:34:33 -0500
Date: Wed, 23 Jan 2013 10:34:32 -0800
From: Zach Brown <zab@zabbo.net>
To: Piotr Nowojski <piotr.nowojski@adocean-global.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: BTRFS deadlock (btrfs_join_transaction?)
Message-ID: <20130123183432.GC14246@lenny.home.zabbo.net>
References: <50FEC3B5.1040100@adocean-global.com>
 <20130122195154.GB14246@lenny.home.zabbo.net>
 <50FFC9B8.1020605@adocean-global.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <50FFC9B8.1020605@adocean-global.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> We will try to give it a shot. But it might be hard to reproduce.
> This problem occurred only once, after one week of very heavy
> (over)stress tests.

Yeah, understood.

> Is it at least possible to confirm, that this is definitely the BTRFS
> problem?

*Definitely*?  No, sadly, the kernel is simply not robust enough to
isolate problems to the subsytem that caused them :).

It's likely that this is a bug in btrfs, yes.

But it's always technically possible that some other part of the kernel
corrupted memory and the btrfs spinlock was the innocent victim.

- z
