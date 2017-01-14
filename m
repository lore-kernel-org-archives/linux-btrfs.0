Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pg0-f54.google.com ([74.125.83.54]:33699 "EHLO
        mail-pg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750823AbdANEZG (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 13 Jan 2017 23:25:06 -0500
Received: by mail-pg0-f54.google.com with SMTP id 204so552756pge.0
        for <linux-btrfs@vger.kernel.org>; Fri, 13 Jan 2017 20:25:05 -0800 (PST)
Date: Fri, 13 Jan 2017 20:24:42 -0800
From: Omar Sandoval <osandov@osandov.com>
To: lsf-pc@lists.linux-foundation.org
Cc: linux-block@vger.kernel.org, linux-btrfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: [LSF/MM ATTEND] blk-mq I/O scheduling, Btrfs, VFS topics
Message-ID: <20170114042442.GA4463@vader>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I'd like to attend LSF/MM again this year to discuss topics in blk-mq,
Btrfs, and the VFS.

I've been working on the blk-mq I/O scheduling framework [1] with Jens.
Once that is finalized, the next step is a proper multiqueue scheduler.
I've put together a prototype with a few basic ideas [2], but there's
still work to be done. It's hard to say where exactly we'll be in time
for LSF/MM since things are moving pretty fast, but I'm sure there will
be something to discuss.

I'd also like to meet with the other Btrfs developers to talk about
what's on the roadmap.

Finally, I'm interested in VFS topics including statx and the mount(2)
API. I'd also love to work out the issues with my linkat() AT_REPLACE
patches.

Thanks!

1: http://git.kernel.dk/cgit/linux-block/log/?h=blk-mq-sched
2: https://github.com/osandov/linux/tree/mq-token-iosched
