Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.forwiss.uni-passau.de ([132.231.20.39]:49832 "EHLO
	mail.forwiss.uni-passau.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752010AbaHSQ3x (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 19 Aug 2014 12:29:53 -0400
Date: Tue, 19 Aug 2014 18:21:52 +0200
From: M G Berberich <btrfs@oss.m-berberich.de>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Questions on using BtrFS for fileserver
Message-ID: <20140819162151.GA15166@forwiss.uni-passau.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

we are thinking about using BtrFS on standard hardware for a
fileserver with about 50T (100T raw) of storage (25×4TByte).

This is what I understood so far. Is this right?

· incremental send/receive works.

· There is no support for hotspares (spare disks that automatically
  replaces faulty disk).

· BtrFS with RAID1 is fairly stable.

· RAID 5/6 spreads all data over all devices, leading to performance
  problems on large diskarrays, and there is no option to limit the
  numbers of disk per stripe so far.

Some questions:

· There where reports, that bcache with btrfs leads to corruption. Is
  this still so?

· If a disk failes, does BtrFS rebalance automatically? (This would
  give a a kind o hotspare behavior)

· Besides using bcache, are there any possibilities to boost
  performance by adding (dedicated) cache-SSDs to a BtrFS?

· Are there any reports/papers/web-pages about BtrFS-systems this size
  in use? Praises, complains, performance-reviews, whatever…

	MfG
	bmg

-- 
„Des is völlig wurscht, was heut beschlos- | M G Berberich
 sen wird: I bin sowieso dagegn!“          | berberic@fmi.uni-passau.de
(SPD-Stadtrat Kurt Schindler; Regensburg)  | www.fmi.uni-passau.de/~berberic
