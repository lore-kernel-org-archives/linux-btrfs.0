Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60496 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965079AbeBMPQE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 13 Feb 2018 10:16:04 -0500
Date: Tue, 13 Feb 2018 16:13:47 +0100
From: David Sterba <dsterba@suse.cz>
To: Dan Robertson <danlrobertson89@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: btrfs-progs: compile with musl libc
Message-ID: <20180213151347.GT3003@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180213132509.GA16525@drobertson-crashbox.lab.tripwire.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180213132509.GA16525@drobertson-crashbox.lab.tripwire.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Feb 13, 2018 at 01:25:10PM +0000, Dan Robertson wrote:
> Ensure that limits.h is included in mkfs/main.c as PATH_MAX is used. The lack
> of this currently causes btrfs-progs to fail to compile when the systems libc
> is musl.

> From 7859e0d01778e844ae0fcbefe55581277ce7cab3 Mon Sep 17 00:00:00 2001
> From: Dan Robertson <danlrobertson89@gmail.com>
> Date: Tue, 13 Feb 2018 13:04:29 +0000
> Subject: [PATCH] btrfs-progs: compile with musl libc
> 
> Ensure that limits.h is included in mkfs/main.c as PATH_MAX is used.
> 
> Signed-off-by: Dan Robertson <danlrobertson89@gmail.com>

Thanks, this has been fixed in
https://github.com/kdave/btrfs-progs/commit/3aa1bbdd89ee9c9c48d260a6192fae08328f1b2f

and the musl build check is now in place so the breakage should not
happen anymore. I'll do a release this week with the fix included.
