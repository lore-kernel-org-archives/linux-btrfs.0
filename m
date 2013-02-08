Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.vapor.com ([83.220.149.2]:39468 "EHLO nitrogen.vapor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754928Ab3BHAk7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 7 Feb 2013 19:40:59 -0500
Received: from twilight.demius.net (c-297271d5.013-195-6c756e10.cust.bredbandsbolaget.se [213.113.114.41])
	by nitrogen.vapor.com (Postfix) with ESMTPSA id 443FC40C028
	for <linux-btrfs@vger.kernel.org>; Fri,  8 Feb 2013 01:40:50 +0100 (CET)
Received: from lori.pomac.com (lori.local [10.0.0.13])
	by twilight.demius.net (Postfix) with ESMTP id 310A68E04E5
	for <linux-btrfs@vger.kernel.org>; Fri,  8 Feb 2013 01:40:45 +0100 (CET)
From: Ian Kumlien <pomac@demius.net>
To: linux-btrfs@vger.kernel.org
Subject: Btrfs-progs: Merge btrfs-restore, btrfsck, btrfs-select-super, btrfs-dump-super and btrfs-debug-tree in to btrfs
Date: Fri,  8 Feb 2013 01:36:56 +0100
Message-Id: <1360283822-23452-1-git-send-email-pomac@demius.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

This patch series moves some of the commands around to reflect that
they are now subcommands of btrfs.

As a stage in this we also add support for btrfs being called as 
btrfsck which yeilds the, now(?), starnard "btrfs check" or 
fsck.btrfs which is a noop to avoid complications with distributions.

We also merge Josef Baciks btrfs-dump-super in patch number 4.

This patchset has been rebased on top of David Sterbas latest WIP changes.

Comments? Ideas? Suggestions?

Please help me with all the help text and verify that it's correct enough ;)

