Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:59292 "EHLO
        mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751991AbeF2E1M (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 29 Jun 2018 00:27:12 -0400
Date: Thu, 28 Jun 2018 21:27:07 -0700
From: Marc MERLIN <marc@merlins.org>
To: linux-btrfs@vger.kernel.org
Message-ID: <20180629042707.vrjwbytg6bxmrgjg@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Subject: So, does btrfs check lowmem take days? weeks?
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Regular btrfs check --repair has a nice progress option. It wasn't
perfect, but it showed something.

But then it also takes all your memory quicker than the linux kernel can
defend itself and reliably completely kills my 32GB server quicker than
it can OOM anything.

lowmem repair seems to be going still, but it's been days and -p seems
to do absolutely nothing.

My filesystem is "only" 10TB or so, albeit with a lot of files.

2 things that come to mind
1) can lowmem have some progress working so that I know if I'm looking
at days, weeks, or even months before it will be done?

2) non lowmem is more efficient obviously when it doesn't completely
crash your machine, but could lowmem be given an amount of memory to use
for caching, or maybe use some heuristics based on RAM free so that it's
not so excrutiatingly slow?

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                       | PGP 7F55D5F27AAF9D08
