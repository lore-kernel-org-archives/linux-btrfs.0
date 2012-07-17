Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from xp-ob.rzone.de ([81.169.146.138]:28548 "EHLO xp-ob.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753811Ab2GQPCN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 Jul 2012 11:02:13 -0400
Received: from pizpot.store ([192.168.43.236])
	by jored.store (jored xp1) (RZmta 29.19 OK)
	with ESMTP id X02240o6HENfiI for <linux-btrfs@vger.kernel.org>;
	Tue, 17 Jul 2012 17:02:11 +0200 (CEST)
From: Stefan Behrens <sbehrens@giantdisaster.de>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 0/2] Btrfs: remove unwanted kernel log output
Date: Tue, 17 Jul 2012 17:02:09 +0200
Message-Id: <cover.1342534465.git.sbehrens@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

People complained about unwanted kernel log output at mount time,
related to btrfs device I/O statistics. With these two commits, the
two messages are removed or filtered, respectively.

Stefan Behrens (2):
  Btrfs: remove unwanted printk() for btrfs device I/O stats
  Btrfs: suppress printk() if all device I/O stats are zero

 fs/btrfs/volumes.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

-- 
1.7.11.2

