Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f52.google.com ([74.125.82.52]:37627 "EHLO
	mail-wm0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755035AbcEQPpg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 May 2016 11:45:36 -0400
Received: by mail-wm0-f52.google.com with SMTP id a17so38372156wme.0
        for <linux-btrfs@vger.kernel.org>; Tue, 17 May 2016 08:45:35 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 17 May 2016 17:45:34 +0200
Message-ID: <CABt16=EDFKFj4duaWJ0qCS_SO9TE2jn8UMCx5e_u+X+M328yeA@mail.gmail.com>
Subject: Corrupted system due to imbalanced metadata chunks
From: Peter Kese <peter.kese@viidea.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I've been using btrfs on my main system for a few months. I know btrfs
is a little bit beta, but I thought not using any fancy features like
quotas, snapshotting, raid, etc. would keep me on the safe side.

Then I tried a software upgrade (Ubuntu 15.10 -> 16.04) and it turned
out that while there was more than 100 GB (45%) of free disk space,
the upgrade process broke down somewhere in the middle reporting IO
errors and lack of free disk space.

As I have learned later on, my problem was lack of available metadata
blocks and a couple of tries at btrfs-balance remedied the space
problem, but I nevertheless ended up with a broken Ubuntu distribution
(there were broken packages and apt-get/dpkg hacking failed to fix the
problem).

So there wasn't any major data loss (apart from some .deb packages
missing some files, my personal data is intact). But I'd still
consider this a major loss, because I'll end up having to reinstall
the whole system.

Now here's what I think:
 1) I may have been a bit unfortunate to experience this particular
issue but there's a large audience of people who might get bitten as
well,
 2) I find it hard to blame it on Ubuntu's upgrade process, as it does
check for free space availability before starting the upgrade,
 3) A file system should not refuse to store files (during system
upgrade or any other time), when there is 100 GB of free disk space
available,
 4) Not anywhere in any btrfs documentation (not even in btrfs
Gotchas) did I read any bold text saying *If installing btrfs, you
should always keep an eye on free space for metadata and perform
regular balances or otherwise you may corrupt your system.*

And finally my question:

 Is there a plan to detect such situation and perform an automatic
inline rebalance rather than reporting out-of-disk-space when there's
actually lots of free disk space available?

Thanks,

Peter
