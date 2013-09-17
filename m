Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:60151 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752888Ab3IQPVa (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 Sep 2013 11:21:30 -0400
Received: from relay1.suse.de (unknown [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 592E0A5511
	for <linux-btrfs@vger.kernel.org>; Tue, 17 Sep 2013 17:21:29 +0200 (CEST)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH 0/3] btrfs-progs: Add command group for rescue operations
Date: Tue, 17 Sep 2013 17:21:19 +0200
Message-Id: <cover.1379430631.git.dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

David Sterba (3):
  btrfs-progs: introduce rescue command group
  btrfs-progs: move chunk-recover to rescue group
  btrfs-progs: separate command ant implementation of chunk-recover code

 Makefile        |    3 +-
 btrfs.c         |    2 +-
 chunk-recover.c | 1745 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 cmds-chunk.c    |    2 +-
 cmds-rescue.c   |  100 ++++
 commands.h      |    3 +
 man/btrfs.8.in  |    4 +-
 7 files changed, 1854 insertions(+), 5 deletions(-)
 create mode 100644 chunk-recover.c
 create mode 100644 cmds-rescue.c

-- 
1.8.3.1

