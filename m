Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:51238 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754539Ab3HWG3B (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 23 Aug 2013 02:29:01 -0400
Received: from m2.gw.fujitsu.co.jp (unknown [10.0.50.72])
	by fgwmail5.fujitsu.co.jp (Postfix) with ESMTP id A2E8D3EE1D9
	for <linux-btrfs@vger.kernel.org>; Fri, 23 Aug 2013 15:28:59 +0900 (JST)
Received: from smail (m2 [127.0.0.1])
	by outgoing.m2.gw.fujitsu.co.jp (Postfix) with ESMTP id 9449845DE4E
	for <linux-btrfs@vger.kernel.org>; Fri, 23 Aug 2013 15:28:59 +0900 (JST)
Received: from s2.gw.fujitsu.co.jp (s2.gw.fujitsu.co.jp [10.0.50.92])
	by m2.gw.fujitsu.co.jp (Postfix) with ESMTP id 7BE6545DE4D
	for <linux-btrfs@vger.kernel.org>; Fri, 23 Aug 2013 15:28:59 +0900 (JST)
Received: from s2.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s2.gw.fujitsu.co.jp (Postfix) with ESMTP id 6E3EE1DB803A
	for <linux-btrfs@vger.kernel.org>; Fri, 23 Aug 2013 15:28:59 +0900 (JST)
Received: from m1000.s.css.fujitsu.com (m1000.s.css.fujitsu.com [10.240.81.136])
	by s2.gw.fujitsu.co.jp (Postfix) with ESMTP id 256D81DB8038
	for <linux-btrfs@vger.kernel.org>; Fri, 23 Aug 2013 15:28:59 +0900 (JST)
Message-ID: <52170114.7060604@jp.fujitsu.com>
Date: Fri, 23 Aug 2013 15:28:36 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
CC: chris.mason@fusionio.com
Subject: [PATCH 0/2] btrfs-progs: prevent mkfs from aborting with small volume
Content-Type: text/plain; charset=ISO-2022-JP
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I found that mkfs.btrfs aborts when one of assigned volume is too small.
Here are 2 patches to fix 2 independent problems.
Both are based on top of Chris's btrfs-progs.git:

  git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-progs.git

Thanks,
H.Seto


Hidetoshi Seto (2):
      btrfs-progs: treat reserved 1MB for superblock properly
      btrfs-progs: exit if there is not enough free space for mkfs

 ctree.h   |    3 +++
 mkfs.c    |    4 ++++
 volumes.c |    7 ++++++-
 3 files changed, 13 insertions(+), 1 deletions(-)


