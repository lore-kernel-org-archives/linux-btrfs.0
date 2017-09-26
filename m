Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:38451 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S935892AbdIZQuY (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 26 Sep 2017 12:50:24 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1dwt3h-0003mf-3T
        for linux-btrfs@vger.kernel.org; Tue, 26 Sep 2017 18:50:09 +0200
To: linux-btrfs@vger.kernel.org
From: Ferry Toth <ftoth@telfort.nl>
Subject: Give up on bcache?
Date: Tue, 26 Sep 2017 16:50:00 +0000 (UTC)
Message-ID: <oqe0fo$keo$1@blaine.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Looking at the Phoronix benchmark here:

https://www.phoronix.com/scan.php?page=article&item=linux414-bcache-
raid&num=2

I think it might be idle hopes to think bcache can be used as a ssd cache 
for btrfs to significantly improve performance.. True, the benchmark is 
using ext.

But the most important one (where btrfs always shows to be a little slow) 
would be the SQLLite test. And with ext at least performance _degrades_ 
except for the Writeback mode, and even there is nowhere near what the 
SSD is capable of.

I think with btrfs it will be even worse and that it is a fundamental 
problem: caching is complex and the cache can not how how the data on the 
fs is used.

I think the original idea of hot data tracking has a much better chance 
to significantly improve performance. This of course as the SSD's and 
HDD's then will be equal citizens and btrfs itself gets to decide on 
which drive the data is best stored.

With this implemented right, it would also finally silence the never 
ending discussion why not btrfs and why zfs, ext, xfs etc. Which would be 
a plus by its own right.

