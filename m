Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from xp-ob.rzone.de ([81.169.146.138]:39987 "EHLO xp-ob.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934500Ab3E1Prg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 28 May 2013 11:47:36 -0400
Received: from pizpot.store ([192.168.43.236])
	by jored.store (jored xp4) (RZmta 31.27 OK)
	with ESMTP id 60406bp4S4bhoe for <linux-btrfs@vger.kernel.org>;
	Tue, 28 May 2013 17:47:32 +0200 (CEST)
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 0/3] Btrfs: qgroup rescan fixes for next rc
Date: Tue, 28 May 2013 17:47:21 +0200
Message-Id: <1369756044-17194-1-git-send-email-list.btrfs@jan-o-sch.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Here are three fixes for the new qgroup rescan feature. The first two
are quite small, the third one is a little bigger. I thought about
splitting that one up, but in the end I didn't find a good point to
break that up. It achieves more than one goal, I agree, but its more or
less a compact code change that need not be split artifically in my
opinion.

Jan Schmidt (3):
  Btrfs: fix memory patcher through fs_info->qgroup_ulist
  Btrfs: avoid double free of fs_info->qgroup_ulist
  Btrfs: fix qgroup rescan resume on mount

 fs/btrfs/ctree.h   |    2 +
 fs/btrfs/disk-io.c |    2 +
 fs/btrfs/qgroup.c  |  198 +++++++++++++++++++++++++++++++++-------------------
 3 files changed, 131 insertions(+), 71 deletions(-)

